#!/bin/bash

set -euxo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../lib/test_helpers.sh"
source "$SCRIPT_DIR/../lib/platform_detection.sh"

assert_command_exists "starship"
assert_command_exists "unzip"
assert_command_exists "brew"
assert_command_exists "gh"
assert_command_exists "fnm"

xcode-select -p >/dev/null 2>&1

assert_file_is_symlink "$HOME/.inputrc"

if command -v brew >/dev/null 2>&1; then
  brew doctor >/dev/null 2>&1
  brew update >/dev/null 2>&1
fi

bash_path=""
if [ "$(uname -m)" = "arm64" ]; then
  bash_path="/opt/homebrew/bin/bash"
else
  bash_path="/usr/local/bin/bash"
fi

grep -Fxq "$bash_path" /etc/shells
[ -x "$bash_path" ]
