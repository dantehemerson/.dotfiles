#!/bin/sh

# Test load_packages function with various scenarios
# Source the test framework and utils

. "$(dirname "$0")/test_framework.sh"
. "$(dirname "$0")/../utils.sh"

echo "Testing load_packages function..."

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

# Test 1: Basic packages without conditions
echo "Test 1: Basic packages without conditions"
test_file1="/tmp/test_packages1.txt"
create_test_file "$test_file1" "git
wget
curl
# This is a comment
btop

"

packages=()
load_packages "$test_file1" packages
expected_packages="git wget curl btop"
actual_packages="${packages[*]}"
assert_equals "$expected_packages" "$actual_packages" "Load basic packages without conditions"
cleanup_test_file "$test_file1"

# Test 2: Packages with OS conditions
echo "Test 2: Packages with OS conditions"
test_file2="/tmp/test_packages2.txt"
create_test_file "$test_file2" "git
curl[os.linux]
wget[os.macos]
docker[os.windows]
"

packages=()
load_packages "$test_file2" packages
expected_packages="git curl"
actual_packages="${packages[*]}"
assert_equals "$expected_packages" "$actual_packages" "Load packages with OS conditions (Linux only)"
cleanup_test_file "$test_file2"

# Test 3: Packages with exclusion conditions
echo "Test 3: Packages with exclusion conditions"
test_file3="/tmp/test_packages3.txt"
create_test_file "$test_file3" "git
curl[~pm.brew]
wget[~pm.apt]
docker[~pm.pacman]
"

packages=()
load_packages "$test_file3" packages
expected_packages="git curl docker"
actual_packages="${packages[*]}"
assert_equals "$expected_packages" "$actual_packages" "Load packages with exclusion conditions"
cleanup_test_file "$test_file3"

# Test 4: Packages with architecture conditions
echo "Test 4: Packages with architecture conditions"
test_file4="/tmp/test_packages4.txt"
create_test_file "$test_file4" "git
package1[arch.x86_64]
package2[arch.arm64]
package3[arch.all]
"

packages=()
load_packages "$test_file4" packages
expected_packages="git package1"
actual_packages="${packages[*]}"
assert_equals "$expected_packages" "$actual_packages" "Load packages with architecture conditions"
cleanup_test_file "$test_file4"

# Test 5: Packages with package manager conditions
echo "Test 5: Packages with package manager conditions"
test_file5="/tmp/test_packages5.txt"
create_test_file "$test_file5" "git
apt-package[pm.apt]
brew-package[pm.brew]
pacman-package[pm.pacman]
"

packages=()
load_packages "$test_file5" packages
expected_packages="git apt-package"
actual_packages="${packages[*]}"
assert_equals "$expected_packages" "$actual_packages" "Load packages with package manager conditions"
cleanup_test_file "$test_file5"

# Test 6: Packages with distribution conditions
echo "Test 6: Packages with distribution conditions"
test_file6="/tmp/test_packages6.txt"
create_test_file "$test_file6" "git
debian-package[distro.debian]
arch-package[distro.arch]
ubuntu-package[distro.ubuntu]
"

packages=()
load_packages "$test_file6" packages
expected_packages="git debian-package"
actual_packages="${packages[*]}"
assert_equals "$expected_packages" "$actual_packages" "Load packages with distribution conditions"
cleanup_test_file "$test_file6"

# Test 7: Empty file
echo "Test 7: Empty file"
test_file7="/tmp/test_packages7.txt"
create_test_file "$test_file7" ""

packages=()
load_packages "$test_file7" packages
expected_packages=""
actual_packages="${packages[*]}"
assert_equals "$expected_packages" "$actual_packages" "Load packages from empty file"
cleanup_test_file "$test_file7"

# Test 8: File with only comments
echo "Test 8: File with only comments"
test_file8="/tmp/test_packages8.txt"
create_test_file "$test_file8" "# Comment 1
# Comment 2

# Comment 3"

packages=()
load_packages "$test_file8" packages
expected_packages=""
actual_packages="${packages[*]}"
assert_equals "$expected_packages" "$actual_packages" "Load packages from file with only comments"
cleanup_test_file "$test_file8"

# Test 9: Complex scenario with multiple condition types
echo "Test 9: Complex scenario with multiple condition types"
test_file9="/tmp/test_packages9.txt"
create_test_file "$test_file9" "git
linux-specific[os.linux,pm.apt]
macos-specific[os.macos,pm.brew]
exclude-brew[~pm.brew]
arm64-only[arch.arm64]
"

packages=()
load_packages "$test_file9" packages
expected_packages="git linux-specific exclude-brew"
actual_packages="${packages[*]}"
assert_equals "$expected_packages" "$actual_packages" "Load packages with complex conditions"
cleanup_test_file "$test_file9"

# Test 10: Different system configuration
echo "Test 10: Different system configuration (macOS + brew)"
CURRENT_OS="macos"
CURRENT_ARCH="arm64"
CURRENT_PM="brew"
CURRENT_DISTRO="unknown"

test_file10="/tmp/test_packages10.txt"
create_test_file "$test_file10" "git
linux-only[os.linux]
macos-only[os.macos]
brew-only[pm.brew]
exclude-apt[~pm.apt]
"

packages=()
load_packages "$test_file10" packages
expected_packages="git macos-only brew-only exclude-apt"
actual_packages="${packages[*]}"
assert_equals "$expected_packages" "$actual_packages" "Load packages for macOS + brew system"
cleanup_test_file "$test_file10"

# Test 11: Packages with installation flags
echo "Test 11: Packages with installation flags (e.g., --cask)"
CURRENT_OS="macos"
CURRENT_ARCH="x86_64"
CURRENT_PM="brew"
CURRENT_DISTRO="unknown"

test_file11="/tmp/test_packages11.txt"
create_test_file "$test_file11" "git
orbstack
--cask ghostty[os.macos]
--cask obsidian[os.macos]
--formula some-tool[pm.brew]
"

packages=()
load_packages "$test_file11" packages
expected_packages="git orbstack --cask ghostty --cask obsidian --formula some-tool"
actual_packages="${packages[*]}"
assert_equals "$expected_packages" "$actual_packages" "Load packages with installation flags preserved"
cleanup_test_file "$test_file11"

# Test 12: Mixed packages with flags and different conditions
echo "Test 12: Mixed packages with flags and multiple condition types"
CURRENT_OS="linux"
CURRENT_ARCH="x86_64"
CURRENT_PM="apt"
CURRENT_DISTRO="ubuntu"

test_file12="/tmp/test_packages12.txt"
create_test_file "$test_file12" "git
wget
--cask macos-app[os.macos]
linux-tool[os.linux]
--cask another-app[os.macos,pm.brew]
"

packages=()
load_packages "$test_file12" packages
expected_packages="git wget linux-tool"
actual_packages="${packages[*]}"
assert_equals "$expected_packages" "$actual_packages" "Load mixed packages with flags and conditions"
cleanup_test_file "$test_file12"

# Restore original system values
CURRENT_OS="$backup_os"
CURRENT_ARCH="$backup_arch"
CURRENT_PM="$backup_pm"
CURRENT_DISTRO="$backup_distro"

print_summary