#!/usr/bin/env bash
#
# setup-docker-nopasswd.sh
#
# Automates the steps needed to run `docker` commands without sudo:
#   1. Ensures the `docker` group exists
#   2. Adds the current (or specified) user to that group
#   3. Fixes ownership/permissions on the Docker socket (temporary, until reboot/relogin)
#   4. Tells you what to do next to make it take effect
#
# Usage:
#   ./setup-docker-nopasswd.sh            # applies to the user running the script
#   sudo ./setup-docker-nopasswd.sh someuser   # applies to another user

set -euo pipefail

TARGET_USER="${1:-$(logname 2>/dev/null || echo "$USER")}"

echo "==> Target user: $TARGET_USER"

# 1. Make sure Docker is actually installed
if ! command -v docker &>/dev/null; then
  echo "ERROR: docker command not found. Install Docker first." >&2
  exit 1
fi

# 2. Create the docker group if it doesn't exist
if ! getent group docker &>/dev/null; then
  echo "==> Creating 'docker' group..."
  sudo groupadd docker
else
  echo "==> 'docker' group already exists."
fi

# 3. Add the user to the docker group
if id -nG "$TARGET_USER" | grep -qw docker; then
  echo "==> User '$TARGET_USER' is already in the 'docker' group."
else
  echo "==> Adding '$TARGET_USER' to the 'docker' group..."
  sudo usermod -aG docker "$TARGET_USER"
fi

# 4. Fix socket permissions for the CURRENT session (temporary; real fix needs relogin)
if [ -S /var/run/docker.sock ]; then
  echo "==> Ensuring docker.sock is owned by group 'docker'..."
  sudo chown root:docker /var/run/docker.sock
  sudo chmod 660 /var/run/docker.sock
fi

# 5. Make sure the Docker service is enabled/running (systemd systems)
if command -v systemctl &>/dev/null; then
  sudo systemctl enable docker.service &>/dev/null || true
  sudo systemctl start docker.service &>/dev/null || true
fi

echo
echo "✅ Done. Group membership changes only take effect in a NEW login session."
echo "   Choose one of the following to apply it now:"
echo "     - Log out and log back in, OR"
echo "     - Reboot, OR"
echo "     - Run:  newgrp docker   (applies it to your current shell only)"
echo
echo "Then test with:  docker run hello-world   (no sudo)"
