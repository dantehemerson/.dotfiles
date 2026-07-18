#!/usr/bin/env bash
#
# setup-docker-nopasswd.sh
#
# Ensures the current user can run `docker` without sudo.
#
# In a real Linux session, this means: add the user to the `docker` group and
# fix the socket's group ownership so the change takes effect immediately
# (group-membership changes alone don't apply until the user logs in again).
#
# In CI / container contexts, persistent group membership is pointless (the
# user is created fresh per run, won't re-login) AND modifying the docker
# socket ownership breaks GitHub Actions' post-job cleanup (which uses the
# host's docker socket to inspect the container). So in CI we skip the
# socket chmod — group add is still done since it's harmless.
#
# Usage:
#   ./setup-docker-nopasswd.sh            # applies to the user running the script
#   sudo ./setup-docker-nopasswd.sh someuser   # applies to another user

set -uo pipefail

# Determine the target user. Priority: explicit arg > SUDO_USER > USER > logname.
# `logname` can fail in some container/CI contexts, so guard with `2>/dev/null`.
TARGET_USER="${1:-${SUDO_USER:-${USER:-$(logname 2>/dev/null)}}}"

if [[ -z "$TARGET_USER" || "$TARGET_USER" == "root" ]]; then
  echo "ERROR: could not determine target user. Pass it as an argument: $0 <username>" >&2
  exit 1
fi

echo "==> Target user: $TARGET_USER"

# 1. Make sure Docker is actually installed
if ! command -v docker &>/dev/null; then
  echo "ERROR: docker command not found. Install Docker first." >&2
  exit 1
fi

# 2. If the current user can already talk to the daemon, there's nothing to do.
#    This is the common case on local machines where the user is already in
#    the docker group, and in CI where the user is in the docker group from
#    the moment of `useradd -m -G docker ...`.
if docker info >/dev/null 2>&1; then
  echo "==> User '$TARGET_USER' can already access the Docker daemon. Skipping."
  exit 0
fi

# 3. Create the docker group if it doesn't exist
if ! getent group docker &>/dev/null; then
  echo "==> Creating 'docker' group..."
  sudo groupadd docker || true
else
  echo "==> 'docker' group already exists."
fi

# 4. Add the user to the docker group. Idempotent — if they're already in it,
#    this is a no-op. Safe in CI (the container's /etc/group is its own file
#    and doesn't affect the host).
if id -nG "$TARGET_USER" 2>/dev/null | grep -qw docker; then
  echo "==> User '$TARGET_USER' is already in the 'docker' group."
else
  echo "==> Adding '$TARGET_USER' to the 'docker' group..."
  sudo usermod -aG docker "$TARGET_USER" || true
fi

# 5. Fix the socket so the current session can use it. SKIPPED in CI because
#    the host's docker socket is what GitHub Actions uses for post-job
#    cleanup, and chowning it inside the container makes the host lose access.
if [ -S /var/run/docker.sock ] && [[ -z "${CI:-}" ]]; then
  echo "==> Ensuring docker.sock is accessible..."
  sudo chown root:docker /var/run/docker.sock || true
  sudo chmod 660 /var/run/docker.sock || true
fi

# 6. Make sure the Docker service is enabled/running (systemd systems).
#    On non-systemd (CI containers) these will silently fail, which is fine.
if command -v systemctl &>/dev/null; then
  sudo systemctl enable docker.service &>/dev/null || true
  sudo systemctl start docker.service &>/dev/null || true
fi

# 7. Final check — if docker is still not usable, warn but don't fail the
#    install. The user can fix it manually after a fresh login.
if docker info >/dev/null 2>&1; then
  echo "==> ✅ Docker is now accessible without sudo."
else
  echo "==> ⚠️  Docker socket still not accessible to '$TARGET_USER'."
  echo "    If this is a new login session, log out and back in for group"
  echo "    membership to take effect, or run:  newgrp docker"
fi

exit 0
