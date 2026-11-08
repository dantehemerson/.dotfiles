"""Test push persistence against temporary local Git repositories only."""

import json
import os
from pathlib import Path
import pty
import select
import shutil
import signal
import subprocess
import sys
import tempfile
import termios
import time
import unittest


CONFIG = Path(__file__).resolve().parents[1] / "user/.config/herdr"
SHIM = CONFIG / "lazygit-bin/git"
WORKER = CONFIG / "lazygit-push.py"


class PersistentPushTest(unittest.TestCase):
    def setUp(self):
        self.temporary = tempfile.TemporaryDirectory(prefix="herdr-push-")
        self.addCleanup(self.temporary.cleanup)
        self.root = Path(self.temporary.name)
        self.repo = self.root / "repo with spaces"
        self.remote = self.root / "local bare remote"
        self.hooks = self.root / "hooks"
        self.hooks.mkdir()
        hook = self.hooks / "pre-push"
        hook.write_text(
            "#!/bin/sh\n"
            "touch .push-started\n"
            "count=0\n"
            "while [ ! -f .allow-push ]; do\n"
            "  sleep 0.05\n"
            "  count=$((count + 1))\n"
            "  [ \"$count\" -lt 200 ] || exit 1\n"
            "done\n"
            "if [ -f .reject-push ]; then\n"
            "  echo 'intentional test rejection' >&2\n"
            "  exit 1\n"
            "fi\n"
        )
        hook.chmod(0o755)
        self.git("init", "-qb", "main", str(self.repo))
        self.git("init", "-q", "--bare", str(self.remote))
        self.git(
            "-C", str(self.repo), "-c", "user.name=Test",
            "-c", "user.email=test@example.invalid", "-c", "commit.gpgsign=false",
            "-c", "core.hooksPath=/dev/null", "commit", "-qm", "Fixture", "--allow-empty",
        )
        self.env = dict(
            os.environ,
            XDG_STATE_HOME=str(self.root / "state"),
            HERDR_LAZYGIT_REAL_GIT=shutil.which("git"),
            HERDR_LAZYGIT_PYTHON=sys.executable,
            HERDR_BIN_PATH="/usr/bin/false",  # Never send real notifications in tests.
        )
        self.command = [
            str(SHIM), "--no-pager", "-C", str(self.repo),
            "-c", f"core.hooksPath={self.hooks}",
            "push", str(self.remote), "HEAD:refs/heads/main",
        ]
        self.terminal_fd = None
        self.screen = bytearray()

    def git(self, *args):
        return subprocess.check_output(["git", *args], text=True).strip()

    def wait_for(self, predicate):
        deadline = time.monotonic() + 15
        while time.monotonic() < deadline:
            if self.terminal_fd is not None and select.select([self.terminal_fd], [], [], 0)[0]:
                try:
                    self.screen.extend(os.read(self.terminal_fd, 65536))
                except OSError:
                    pass
            if predicate():
                return
            time.sleep(0.05)
        self.fail("Timed out waiting for the local push\n" + self.screen[-4000:].decode(errors="replace"))

    def job(self):
        jobs = list((self.root / "state/herdr/lazygit-pushes").glob("push-*"))
        self.assertEqual(len(jobs), 1)
        return jobs[0]

    def test_non_push_is_unchanged(self):
        result = subprocess.run(
            [str(SHIM), "-C", str(self.repo), "rev-parse", "--show-toplevel"],
            env=self.env, capture_output=True, text=True, check=True,
        )
        self.assertEqual(Path(result.stdout.strip()).resolve(), self.repo.resolve())
        self.assertFalse((self.root / "state").exists())

    def test_real_push_finishes_after_caller_process_group_is_killed(self):
        caller = subprocess.Popen(
            self.command, env=self.env, start_new_session=True,
            stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
        )
        try:
            self.wait_for(lambda: (self.repo / ".push-started").exists())
            worker_pid = int((self.job() / "worker.pid").read_text())
            self.assertNotEqual(os.getsid(caller.pid), os.getsid(worker_pid))
            os.killpg(caller.pid, signal.SIGTERM)
            caller.communicate(timeout=5)
        finally:
            (self.repo / ".allow-push").touch()
            if caller.poll() is None:
                caller.kill()
                caller.communicate(timeout=5)
        self.wait_for(lambda: (self.job() / "status.json").exists())
        self.assertEqual(json.loads((self.job() / "status.json").read_text())["returncode"], 0)
        self.assertEqual(
            self.git("-C", str(self.repo), "rev-parse", "HEAD"),
            self.git("--git-dir", str(self.remote), "rev-parse", "refs/heads/main"),
        )

    def test_foreground_success_returns_output_and_exit_status(self):
        (self.repo / ".allow-push").touch()
        result = subprocess.run(
            self.command, env=self.env, capture_output=True, text=True, timeout=15,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertIn("main", result.stdout)

    @unittest.skipUnless(shutil.which("lazygit"), "lazygit is required")
    def test_actual_lazygit_q_exits_without_canceling_push(self):
        self.git("-C", str(self.repo), "remote", "add", "origin", str(self.remote))
        for key, value in [
            ("branch.main.remote", "origin"),
            ("branch.main.merge", "refs/heads/main"),
            ("core.hooksPath", str(self.hooks)),
        ]:
            self.git("-C", str(self.repo), "config", key, value)
        config = self.root / "lazygit-config"
        config.mkdir()
        (config / "config.yml").write_text(
            "disableStartupPopups: true\nconfirmOnQuit: false\n"
            "git:\n  autoFetch: false\nupdate:\n  method: never\n"
        )
        env = dict(
            self.env, TERM="xterm-256color",
            PATH=f"{SHIM.parent}{os.pathsep}{os.environ['PATH']}",
        )
        pid, fd = pty.fork()
        if pid == 0:
            os.chdir(self.repo)
            os.execvpe("lazygit", ["lazygit", "--use-config-dir", str(config)], env)
        self.terminal_fd = fd
        termios.tcsetwinsize(fd, (40, 120))
        exited = False

        def has_exited():
            nonlocal exited
            exited = os.waitpid(pid, os.WNOHANG)[0] == pid
            return exited

        try:
            self.wait_for(lambda: b"Fixture" in self.screen)
            os.write(fd, b"P")
            self.wait_for(lambda: (self.repo / ".push-started").exists())
            os.write(fd, b"q")
            self.wait_for(has_exited)
        finally:
            (self.repo / ".allow-push").touch()
            os.close(fd)
            self.terminal_fd = None
            if not exited:
                os.kill(pid, signal.SIGKILL)
                os.waitpid(pid, 0)

        self.wait_for(lambda: (self.job() / "status.json").exists())
        self.assertEqual(json.loads((self.job() / "status.json").read_text())["returncode"], 0)
        self.assertEqual(
            self.git("-C", str(self.repo), "rev-parse", "HEAD"),
            self.git("--git-dir", str(self.remote), "rev-parse", "refs/heads/main"),
        )

    def test_failure_returns_error_and_reports_unseen_background_failure(self):
        (self.repo / ".allow-push").touch()
        (self.repo / ".reject-push").touch()
        result = subprocess.run(
            self.command, env=self.env, capture_output=True, text=True, timeout=15,
        )
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("intentional test rejection", result.stdout)
        # Model a failure that was not seen because LazyGit already closed.
        (self.job() / "reported").unlink()
        report = subprocess.run(
            [sys.executable, str(WORKER), "--report"], env=self.env,
            capture_output=True, text=True, timeout=5,
        )
        self.assertEqual(report.returncode, 1)
        self.assertIn("Previous push failed", report.stdout)
        self.assertIn("output.log", report.stdout)
        report = subprocess.run(
            [sys.executable, str(WORKER), "--report"], env=self.env,
            capture_output=True, text=True, timeout=5,
        )
        self.assertEqual(report.returncode, 0)


if __name__ == "__main__":
    unittest.main()
