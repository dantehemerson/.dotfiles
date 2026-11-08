"""Exercise the popup launcher with real tmux/PTYs, but never push to a remote."""

import os
from pathlib import Path
import pty
import select
import shutil
import signal
import subprocess
import tempfile
import time
import unittest


LAUNCHER = (
    Path(__file__).resolve().parents[1]
    / "user/.config/herdr/lazygit-popup.sh"
)


@unittest.skipUnless(shutil.which("tmux"), "tmux is required")
class PersistentLazygitTest(unittest.TestCase):
    def test_detach_reopen_worktree_isolation_and_client_disconnect(self):
        with tempfile.TemporaryDirectory(prefix="herdr-lazygit-") as directory:
            root = Path(directory)
            server = f"herdr-lazygit-test-{os.getpid()}"
            real_tmux = shutil.which("tmux")
            clients = []

            def tmux(*args):
                return subprocess.check_output(
                    [real_tmux, "-L", server, *args], text=True, timeout=5
                ).strip()

            def wait_for(predicate):
                deadline = time.monotonic() + 10
                while time.monotonic() < deadline:
                    for fd in fds:
                        if select.select([fd], [], [], 0)[0]:
                            try:
                                os.read(fd, 65536)
                            except OSError:
                                pass  # A disconnected PTY may return EIO.
                    if predicate():
                        return
                    time.sleep(0.05)
                self.fail("Timed out waiting for the tmux test")

            def reap(pid):
                wait_for(lambda: os.waitpid(pid, os.WNOHANG)[0] == pid)
                clients.remove(pid)

            bin_dir = root / "bin"
            bin_dir.mkdir()
            # Redirect only this launcher's dedicated server to our test socket.
            (bin_dir / "tmux").write_text(
                '#!/bin/sh\nshift 2\nexec "$REAL_TMUX" -L "$TEST_SERVER" "$@"\n'
            )
            # A delayed fake push proves work finishes after the view detaches.
            (bin_dir / "lazygit").write_text(
                "#!/bin/sh\n"
                "printf '%s\\n' \"$$\" >> .lazygit-starts\n"
                "while IFS= read -r command; do\n"
                "  case \"$command\" in\n"
                "    push) touch .push-started; sleep 1; touch .push-completed ;;\n"
                "    quit) exit 0 ;;\n"
                "  esac\n"
                "done\n"
            )
            for script in bin_dir.iterdir():
                script.chmod(0o755)

            repo = root / "repo with spaces"
            repo.mkdir()
            subprocess.run(["git", "init", "-q", str(repo)], check=True)
            subprocess.run(
                [
                    "git", "-C", str(repo), "-c", "user.name=Test",
                    "-c", "user.email=test@example.invalid",
                    "-c", "commit.gpgsign=false", "-c", "core.hooksPath=/dev/null",
                    "commit", "-qm", "Test fixture", "--allow-empty",
                ],
                check=True,
            )
            worktree = root / "linked worktree"
            subprocess.run(
                ["git", "-C", str(repo), "worktree", "add", "-qb", "test", str(worktree)],
                check=True,
            )
            subdir = repo / "subdirectory"
            subdir.mkdir()

            def launch(cwd):
                env = dict(
                    os.environ,
                    PATH=f"{bin_dir}{os.pathsep}{os.environ['PATH']}",
                    REAL_TMUX=real_tmux,
                    TEST_SERVER=server,
                    TERM="xterm-256color",
                    HERDR_ACTIVE_PANE_CWD=str(cwd),
                    # The launcher must ignore a parent tmux session.
                    TMUX="/nonexistent/parent,123,0",
                )
                pid, fd = pty.fork()
                if pid == 0:
                    os.chdir(root)
                    os.execve("/bin/sh", ["sh", str(LAUNCHER)], env)
                clients.append(pid)
                return pid, fd

            fds = []
            try:
                pid, fd = launch(repo)
                fds.append(fd)
                wait_for(lambda: (repo / ".lazygit-starts").exists())
                first_pid = (repo / ".lazygit-starts").read_text()
                session = tmux("list-sessions", "-F", "#{session_name}")
                self.assertEqual(tmux("show-options", "-gv", "prefix"), "None")
                self.assertNotIn("C-g", tmux("list-keys", "-T", "root"))

                tmux("send-keys", "-t", session, "push", "Enter")
                wait_for(lambda: (repo / ".push-started").exists())
                tmux("detach-client", "-s", session)
                reap(pid)
                self.assertEqual(tmux("display-message", "-pt", session, "#{session_attached}"), "0")
                wait_for(lambda: (repo / ".push-completed").exists())

                pid, fd = launch(subdir)
                fds.append(fd)
                wait_for(lambda: tmux("display-message", "-pt", session, "#{session_attached}") == "1")
                self.assertEqual((repo / ".lazygit-starts").read_text(), first_pid)
                os.kill(pid, signal.SIGHUP)  # Abrupt popup/client closure.
                reap(pid)
                self.assertEqual(tmux("display-message", "-pt", session, "#{pane_dead}"), "0")

                pid, fd = launch(worktree)
                fds.append(fd)
                wait_for(lambda: (worktree / ".lazygit-starts").exists())
                sessions = tmux("list-sessions", "-F", "#{session_name}").splitlines()
                self.assertEqual(len(sessions), 2)
                other_session = next(name for name in sessions if name != session)
                tmux("detach-client", "-s", other_session)
                reap(pid)
            finally:
                # Close PTYs before waiting: macOS can block child exit while
                # terminal output is still buffered in an unread master.
                for fd in fds:
                    os.close(fd)
                fds.clear()
                subprocess.run(
                    [real_tmux, "-L", server, "kill-server"],
                    stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
                )
                for pid in clients:
                    try:
                        os.kill(pid, signal.SIGKILL)
                    except ProcessLookupError:
                        pass
                    reap(pid)


if __name__ == "__main__":
    unittest.main()
