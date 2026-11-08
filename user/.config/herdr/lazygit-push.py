"""Keep a popup's git push alive independently of LazyGit's lifetime."""

import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import time


def state_dir():
    base = Path(os.environ.get("XDG_STATE_HOME", Path.home() / ".local/state"))
    directory = base / "herdr/lazygit-pushes"
    directory.mkdir(mode=0o700, parents=True, exist_ok=True)
    return directory


def report():
    failed = False
    for status in sorted(state_dir().glob("push-*/status.json")):
        result = json.loads(status.read_text())
        reported = status.parent / "reported"
        if result["returncode"] != 0 and not reported.exists():
            print(f"Previous push failed in {result['cwd']}")
            print(f"Output: {status.parent / 'output.log'}\n")
            reported.touch()
            failed = True
    return int(failed)


def run_worker(job, args):
    # This process has its own session, no controlling terminal, and no output
    # pipe back to LazyGit. Killing the caller cannot kill or block the push.
    try:
        result = subprocess.run([os.environ["HERDR_LAZYGIT_REAL_GIT"], *args])
        code = result.returncode
    except OSError as error:
        print(error, file=sys.stderr, flush=True)
        code = 127

    status = {"returncode": code, "cwd": os.getcwd()}
    temporary = job / "status.tmp"
    temporary.write_text(json.dumps(status))
    temporary.replace(job / "status.json")

    # Report failures even when the UI that initiated the push is gone.
    herdr = os.environ.get("HERDR_BIN_PATH") or shutil.which("herdr")
    if code != 0 and herdr:
        try:
            subprocess.run(
                [herdr, "notification", "show", "Git push failed",
                 "--body", f"{os.getcwd()} — output: {job / 'output.log'}"],
                stdin=subprocess.DEVNULL, stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL, timeout=5,
            )
        except (OSError, subprocess.TimeoutExpired):
            pass  # The durable status/log remains available on next open.
    return 0


def push(args):
    job = Path(tempfile.mkdtemp(prefix="push-", dir=state_dir()))
    output = job / "output.log"
    with output.open("wb") as log:
        worker = subprocess.Popen(
            [sys.executable, str(Path(__file__).resolve()), "--worker", str(job), *args],
            stdin=subprocess.DEVNULL, stdout=log, stderr=subprocess.STDOUT,
            start_new_session=True, close_fds=True,
        )
    (job / "worker.pid").write_text(str(worker.pid))

    # While LazyGit is alive it still sees live output and the real exit code.
    # If it quits, only this relay is canceled; the worker writes to a file.
    with output.open("rb") as log:
        while True:
            data = log.read()
            if data:
                try:
                    sys.stdout.buffer.write(data)
                    sys.stdout.buffer.flush()
                except BrokenPipeError:
                    os._exit(0)
            if (job / "status.json").exists():
                remaining = log.read()
                if remaining:
                    try:
                        sys.stdout.buffer.write(remaining)
                        sys.stdout.buffer.flush()
                    except BrokenPipeError:
                        os._exit(0)
                code = json.loads((job / "status.json").read_text())["returncode"]
                (job / "reported").touch()
                return code if code >= 0 else 128 - code
            if worker.poll() is not None:
                # A worker startup failure must not leave LazyGit waiting forever.
                if not (job / "status.json").exists():
                    print(f"Push worker stopped unexpectedly. Output: {output}", file=sys.stderr)
                    return 1
            time.sleep(0.1)


if __name__ == "__main__":
    if sys.argv[1:2] == ["--report"]:
        sys.exit(report())
    if sys.argv[1:2] == ["--worker"]:
        sys.exit(run_worker(Path(sys.argv[2]), sys.argv[3:]))
    sys.exit(push(sys.argv[1:]))
