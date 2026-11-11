"""Check the desktop launcher's first-frame size using a real PTY, not Git."""
import fcntl
import os
from pathlib import Path
import pty
import select
import struct
import subprocess
import tempfile
import termios
import time
import unittest

LAUNCHER = Path(__file__).resolve().parents[1] / "user/.config/herdr-app/mods/lazygit/start.sh"


class LazygitStartupTest(unittest.TestCase):
    def launch(self, resize):
        with tempfile.TemporaryDirectory(prefix="lazygit startup ") as directory:
            binary = Path(directory) / "lazygit"
            binary.write_text('#!/bin/sh\nstty size\nprintf "arg=%s pid=%s\\n" "$1" "$$"\n')
            binary.chmod(0o755)
            master, slave = pty.openpty()
            process = None
            try:
                fcntl.ioctl(slave, termios.TIOCSWINSZ, struct.pack("HHHH", 120, 200, 0, 0))
                start = time.monotonic()
                process = subprocess.Popen(
                    ["sh", str(LAUNCHER), "argument with spaces"],
                    stdin=slave, stdout=slave, stderr=slave,
                    env={**os.environ, "PATH": directory + os.pathsep + os.environ["PATH"]},
                )
                if resize:
                    # No UI should be drawn at the headless dimensions.
                    self.assertFalse(select.select([master], [], [], 0.08)[0])
                    fcntl.ioctl(slave, termios.TIOCSWINSZ, struct.pack("HHHH", 40, 150, 0, 0))
                process.wait(timeout=3)
                output = os.read(master, 4096).decode()
                self.assertIn("arg=argument with spaces", output)
                self.assertIn(f"pid={process.pid}", output)  # exec, not an orphaned child
                self.assertLess(time.monotonic() - start, 2)
                self.assertEqual(process.returncode, 0)
                return output
            finally:
                if process and process.poll() is None:
                    process.kill()
                    process.wait()
                os.close(master)
                os.close(slave)

    def test_first_frame_uses_viewer_dimensions(self):
        self.assertIn("40 150", self.launch(resize=True))

    def test_unchanged_size_has_bounded_fallback(self):
        self.assertIn("120 200", self.launch(resize=False))


if __name__ == "__main__":
    unittest.main()
