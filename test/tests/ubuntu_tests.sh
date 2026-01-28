#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../lib/test_helpers.sh"
source "$SCRIPT_DIR/../lib/platform_detection.sh"

assert_command_exists "apt"
assert_command_exists "rust-fd-find"
assert_command_exists "superfile"

apt update >/dev/null 2>&1
apt list --installed >/dev/null 2>&1

assert_directory_exists "/etc/apt"
assert_directory_exists "/var/cache/apt"