#!/bin/sh

# Test condition parsing functions
# Source the test framework and utils

. "$(dirname "$0")/test_framework.sh"
. "$(dirname "$0")/../utils.sh"

echo "Testing condition parsing functions..."

# Test parse_package_line function
echo "Testing parse_package_line function:"

# Test package without conditions
result=$(parse_package_line "git")
expected="git|"
assert_equals "$expected" "$result" "Parse package without conditions"

# Test package with single condition
result=$(parse_package_line "curl[os.linux]")
expected="curl|os.linux"
assert_equals "$expected" "$result" "Parse package with single condition"

# Test package with multiple conditions
result=$(parse_package_line "docker[os.linux,pm.apt]")
expected="docker|os.linux,pm.apt"
assert_equals "$expected" "$result" "Parse package with multiple conditions"

# Test package with exclusion condition
result=$(parse_package_line "wget[~pm.brew]")
expected="wget|~pm.brew"
assert_equals "$expected" "$result" "Parse package with exclusion condition"

# Test package with complex conditions
result=$(parse_package_line "neovim[os.macos,arch.arm64]")
expected="neovim|os.macos,arch.arm64"
assert_equals "$expected" "$result" "Parse package with complex conditions"

# Test package name with numbers and hyphens
result=$(parse_package_line "package123-test[os.linux]")
expected="package123-test|os.linux"
assert_equals "$expected" "$result" "Parse package name with numbers and hyphens"

# Test empty package name (edge case)
result=$(parse_package_line "[os.linux]")
expected="|os.linux"
assert_equals "$expected" "$result" "Parse empty package name with conditions"

# Test package with empty conditions (edge case)
result=$(parse_package_line "git[]")
expected="git|"
assert_equals "$expected" "$result" "Parse package with empty conditions"

# Test package with nested brackets (should handle first pair only)
result=$(parse_package_line "test[os.linux,pm.apt[extra]]")
expected="test|os.linux,pm.apt"
assert_equals "$expected" "$result" "Parse package with nested brackets (first pair only)"

print_summary