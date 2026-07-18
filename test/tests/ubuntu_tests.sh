#!/bin/bash

set -euxo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../lib/test_helpers.sh"

assert_command_exists "apt-get"
# On Ubuntu/Debian, the `fd-find` package installs the binary as `fdfind`
# (name clash with another package). Some installs also expose it as `fd`.
if command -v fd >/dev/null 2>&1; then
  :
elif command -v fdfind >/dev/null 2>&1; then
  :
else
  echo "❌ Neither 'fd' nor 'fdfind' is installed"
  exit 1
fi
# superfile ships its binary as `superfile` on most platforms, but the
# Homebrew formula on macOS installs it as `spf` (the upstream Go binary name).
if command -v superfile >/dev/null 2>&1; then
  :
elif command -v spf >/dev/null 2>&1; then
  :
else
  echo "❌ Neither 'superfile' nor 'spf' is installed"
  exit 1
fi

# apt DB sanity check
dpkg -l apt >/dev/null 2>&1 || fail "apt package database unavailable"
