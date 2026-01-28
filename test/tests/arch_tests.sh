#!/bin/bash

set -euxo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../lib/test_helpers.sh"
source "$SCRIPT_DIR/../lib/platform_detection.sh"

assert_command_exists "pacman"
assert_command_exists "fd"
assert_command_exists "yay"

pacman -Sy
pacman -Q pacman

if command -v yay >/dev/null 2>&1; then
  yay -Sy >/dev/null 2>&1
fi

assert_directory_exists "/etc/pacman.d"
assert_directory_exists "/var/cache/pacman"

