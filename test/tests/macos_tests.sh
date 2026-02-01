#!/bin/bash

set -euxo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../lib/test_helpers.sh"

assert_command_exists "starship"

xcode-select -p >/dev/null 2>&1

assert_file_is_symlink "$HOME/.inputrc"
