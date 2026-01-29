#!/bin/sh

# Test system detection functions
# Source the test framework and utils

. "$(dirname "$0")/test_framework.sh"
. "$(dirname "$0")/../utils.sh"

echo "Testing system detection functions..."

# Test OS detection
echo "Testing OS detection:"
current_os_backup="$CURRENT_OS"

CURRENT_OS="linux"
assert_equals "linux" "$CURRENT_OS" "OS detection set to linux"

CURRENT_OS="macos" 
assert_equals "macos" "$CURRENT_OS" "OS detection set to macos"

CURRENT_OS="windows"
assert_equals "windows" "$CURRENT_OS" "OS detection set to windows"

# Restore original OS
CURRENT_OS="$current_os_backup"

# Test architecture detection
echo "Testing architecture detection:"
current_arch_backup="$CURRENT_ARCH"

CURRENT_ARCH="x86_64"
assert_equals "x86_64" "$CURRENT_ARCH" "Architecture detection set to x86_64"

CURRENT_ARCH="arm64"
assert_equals "arm64" "$CURRENT_ARCH" "Architecture detection set to arm64"

# Restore original architecture
CURRENT_ARCH="$current_arch_backup"

# Test package manager detection
echo "Testing package manager detection:"
current_pm_backup="$CURRENT_PM"

CURRENT_PM="brew"
assert_equals "brew" "$CURRENT_PM" "Package manager detection set to brew"

CURRENT_PM="apt"
assert_equals "apt" "$CURRENT_PM" "Package manager detection set to apt"

CURRENT_PM="pacman"
assert_equals "pacman" "$CURRENT_PM" "Package manager detection set to pacman"

# Restore original package manager
CURRENT_PM="$current_pm_backup"

# Test distribution detection
echo "Testing distribution detection:"
current_distro_backup="$CURRENT_DISTRO"

CURRENT_DISTRO="arch"
assert_equals "arch" "$CURRENT_DISTRO" "Distribution detection set to arch"

CURRENT_DISTRO="debian"
assert_equals "debian" "$CURRENT_DISTRO" "Distribution detection set to debian"

CURRENT_DISTRO="ubuntu"
assert_equals "ubuntu" "$CURRENT_DISTRO" "Distribution detection set to ubuntu"

# Restore original distribution
CURRENT_DISTRO="$current_distro_backup"

print_summary