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
  # `enable --now` is a no-op if already enabled, but `--now` requires a
  # running systemd (e.g. CI containers without systemd will fail it).
  # Split the two so we can ignore the start failure in that case.
  sudo systemctl enable docker.service || true
  sudo systemctl start docker.service 2>/dev/null || true

  # Make the current user able to run docker without sudo (group + socket).
  # The script always exits 0, so no `|| true` needed here.
  ~/.dotfiles/setup/scripts/create-user-docker.sh
fi
