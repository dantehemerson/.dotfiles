#!/bin/bash

set -euxo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../lib/test_helpers.sh"

assert_command_exists "pacman"
assert_command_exists "yay"
assert_command_exists "vicinae"

assert_file_exists "$HOME/.local/bin/zed"

pacman -Q pacman >/dev/null 2>&1 || fail "pacman DB broken"
