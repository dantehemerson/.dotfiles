#!/bin/bash

source ~/.dotfiles/utils/utils.sh

# Background services only apply to Linux. Skip on macOS.
if [[ "$CURRENT_OS" != "linux" ]]; then
  exit 0
fi

# Enable and start Docker if it's installed. Both `enable` and `start` are
# no-ops if already enabled/active, so this is safe to re-run.
# `start` may fail in CI containers without systemd; that's fine and ignored.
if _command_exists docker; then
  sudo systemctl enable docker.service 2>/dev/null || true
  sudo systemctl start docker.service 2>/dev/null || true
fi

# NOTE: `~/.dotfiles/setup/scripts/create-user-docker.sh` is intentionally
# NOT called here. That script modifies the docker socket's ownership/
# permissions, which in CI (where the socket is bind-mounted from the host)
# breaks GitHub Actions' post-job cleanup. Run it manually instead — see
# setup/postinstall/README.md for details.
