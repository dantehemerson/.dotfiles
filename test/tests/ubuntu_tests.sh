#!/bin/bash

set -euxo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../lib/test_helpers.sh"

assert_command_exists "apt-get"
assert_command_exists "rust-fd-find"
assert_command_exists "superfile"

# apt DB sanity check
dpkg -l apt >/dev/null 2>&1 || fail "apt package database unavailable"
