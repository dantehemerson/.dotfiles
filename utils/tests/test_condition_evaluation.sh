#!/bin/sh

# Test condition evaluation functions
# Source the test framework and utils

. "$(dirname "$0")/test_framework.sh"
. "$(dirname "$0")/../utils.sh"

echo "Testing condition evaluation functions..."

# Backup current system values
backup_os="$CURRENT_OS"
backup_arch="$CURRENT_ARCH"
backup_pm="$CURRENT_PM"
backup_distro="$CURRENT_DISTRO"

# Set known test values
CURRENT_OS="linux"
CURRENT_ARCH="x86_64"
CURRENT_PM="apt"
CURRENT_DISTRO="debian"

# Test should_install_package function
echo "Testing should_install_package function:"

# Test empty conditions (should always install)
should_install_package ""
result=$?
assert_true "$result" "Empty conditions should always install"

# Test inclusive OS conditions
should_install_package "os.linux"
result=$?
assert_true "$result" "Inclusive OS condition should match"

should_install_package "os.macos"
result=$?
assert_false "$result" "Inclusive OS condition should not match"

# Test inclusive architecture conditions
should_install_package "arch.x86_64"
result=$?
assert_true "$result" "Inclusive architecture condition should match"

should_install_package "arch.arm64"
result=$?
assert_false "$result" "Inclusive architecture condition should not match"

# Test inclusive package manager conditions
should_install_package "pm.apt"
result=$?
assert_true "$result" "Inclusive package manager condition should match"

should_install_package "pm.brew"
result=$?
assert_false "$result" "Inclusive package manager condition should not match"

# Test inclusive distribution conditions
should_install_package "distro.debian"
result=$?
assert_true "$result" "Inclusive distribution condition should match"

should_install_package "distro.arch"
result=$?
assert_false "$result" "Inclusive distribution condition should not match"

# Test exclusive OS conditions
should_install_package "~os.macos"
result=$?
assert_true "$result" "Exclusive OS condition should match (not macOS)"

should_install_package "~os.linux"
result=$?
assert_false "$result" "Exclusive OS condition should not match (is Linux)"

# Test exclusive architecture conditions
should_install_package "~arch.arm64"
result=$?
assert_true "$result" "Exclusive architecture condition should match (not ARM64)"

should_install_package "~arch.x86_64"
result=$?
assert_false "$result" "Exclusive architecture condition should not match (is x86_64)"

# Test exclusive package manager conditions
should_install_package "~pm.brew"
result=$?
assert_true "$result" "Exclusive package manager condition should match (not brew)"

should_install_package "~pm.apt"
result=$?
assert_false "$result" "Exclusive package manager condition should not match (is apt)"

# Test exclusive distribution conditions
should_install_package "~distro.arch"
result=$?
assert_true "$result" "Exclusive distribution condition should match (not arch)"

should_install_package "~distro.debian"
result=$?
assert_false "$result" "Exclusive distribution condition should not match (is debian)"

# Test edge cases
should_install_package "os.unknown"
result=$?
assert_false "$result" "Unknown OS condition should not match"

should_install_package "~os.unknown"
result=$?
assert_true "$result" "Unknown OS exclusion should match"

# Restore original system values
CURRENT_OS="$backup_os"
CURRENT_ARCH="$backup_arch"
CURRENT_PM="$backup_pm"
CURRENT_DISTRO="$backup_distro"

print_summary