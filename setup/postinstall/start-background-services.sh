#!/bin/bash

source ~/.dotfiles/utils/utils.sh

# Background services only apply to Linux. Skip on macOS.
if [[ "$CURRENT_OS" != "linux" ]]; then
  exit 0
fi

# `systemctl enable --now` enables the unit at boot and starts it now, in a
# single idempotent command. Both `enable` and `start` are no-ops if the unit
# is already enabled/active, so this is safe to re-run.
# Both Ubuntu and Arch use systemd with the same docker.service unit.
if _command_exists docker; then
  sudo systemctl enable --now docker.service
fi
