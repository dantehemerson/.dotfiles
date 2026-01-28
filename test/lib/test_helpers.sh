#!/bin/bash

# Test Helpers for Dotfiles Post-Installation Tests
# This file contains helper functions and assertions for testing

# Source the main utils for platform detection
source ~/.dotfiles/utils/utils.sh

# Test state file
TEST_STATE_FILE="/tmp/dotfiles_test_state"

# Initialize test state
init_test_state() {
    # Only initialize if the state files don't exist
    if [ ! -f "$TEST_STATE_FILE.total" ]; then
        echo "0" > "$TEST_STATE_FILE.total"
    fi
    if [ ! -f "$TEST_STATE_FILE.passed" ]; then
        echo "0" > "$TEST_STATE_FILE.passed"
    fi
    if [ ! -f "$TEST_STATE_FILE.failed" ]; then
        echo "0" > "$TEST_STATE_FILE.failed"
    fi
}

# Load test state
load_test_state() {
    if [ -f "$TEST_STATE_FILE.total" ]; then
        TESTS_TOTAL=$(cat "$TEST_STATE_FILE.total")
    else
        TESTS_TOTAL=0
    fi
    
    if [ -f "$TEST_STATE_FILE.passed" ]; then
        TESTS_PASSED=$(cat "$TEST_STATE_FILE.passed")
    else
        TESTS_PASSED=0
    fi
    
    if [ -f "$TEST_STATE_FILE.failed" ]; then
        TESTS_FAILED=$(cat "$TEST_STATE_FILE.failed")
    else
        TESTS_FAILED=0
    fi
}

# Save test state
save_test_state() {
    echo "$TESTS_TOTAL" > "$TEST_STATE_FILE.total"
    echo "$TESTS_PASSED" > "$TEST_STATE_FILE.passed"
    echo "$TESTS_FAILED" > "$TEST_STATE_FILE.failed"
}

# Clean up test state
cleanup_test_state() {
    rm -f "$TEST_STATE_FILE.total" "$TEST_STATE_FILE.passed" "$TEST_STATE_FILE.failed"
}

# Force clean up test state (for main script)
force_cleanup_test_state() {
    cleanup_test_state
}

# Test variables
TESTS_TOTAL=0
TESTS_PASSED=0
TESTS_FAILED=0

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Print test section header
print_section() {
    echo -e "\n${YELLOW}========== $1 ==========${NC}"
}

# Print test result
print_result() {
    local test_name="$1"
    local result="$2"
    local message="$3"
    
    TESTS_TOTAL=$((TESTS_TOTAL + 1))
    
    if [ "$result" = "PASS" ]; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo -e "${GREEN}✓ PASS${NC} $test_name"
        if [ -n "$message" ]; then
            echo -e "  ${GREEN}$message${NC}"
        fi
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo -e "${RED}✗ FAIL${NC} $test_name"
        if [ -n "$message" ]; then
            echo -e "  ${RED}$message${NC}"
        fi
    fi
    
    # Save state after each test
    save_test_state
}

# Assert that a command exists
assert_command_exists() {
    local cmd="$1"
    local test_name="Command '$cmd' is available"
    
    if command -v "$cmd" >/dev/null 2>&1; then
        print_result "$test_name" "PASS" "Found at: $(command -v "$cmd")"
        return 0
    else
        print_result "$test_name" "FAIL" "Command '$cmd' not found in PATH"
        return 1
    fi
}

# Assert that a file exists and is a symlink
assert_file_is_symlink() {
    local file_path="$1"
    local test_name="File '$file_path' is a symlink"
    
    if [ -L "$file_path" ]; then
        print_result "$test_name" "PASS" "Symlink points to: $(readlink "$file_path")"
        return 0
    elif [ -e "$file_path" ]; then
        print_result "$test_name" "FAIL" "File exists but is not a symlink"
        return 1
    else
        print_result "$test_name" "FAIL" "File does not exist"
        return 1
    fi
}

# Assert that a symlink points to a specific target
assert_symlink_points_to() {
    local symlink_path="$1"
    local expected_target="$2"
    local test_name="Symlink '$symlink_path' points to '$expected_target'"
    
    if [ ! -L "$symlink_path" ]; then
        print_result "$test_name" "FAIL" "File is not a symlink or does not exist"
        return 1
    fi
    
    local actual_target=$(readlink "$symlink_path")
    if [ "$actual_target" = "$expected_target" ]; then
        print_result "$test_name" "PASS" "Symlink correctly points to expected target"
        return 0
    else
        print_result "$test_name" "FAIL" "Symlink points to '$actual_target' instead of '$expected_target'"
        return 1
    fi
}

# Assert that a file exists (not necessarily a symlink)
assert_file_exists() {
    local file_path="$1"
    local test_name="File '$file_path' exists"
    
    if [ -e "$file_path" ]; then
        print_result "$test_name" "PASS" "File exists"
        return 0
    else
        print_result "$test_name" "FAIL" "File does not exist"
        return 1
    fi
}

# Assert that a directory exists
assert_directory_exists() {
    local dir_path="$1"
    local test_name="Directory '$dir_path' exists"
    
    if [ -d "$dir_path" ]; then
        print_result "$test_name" "PASS" "Directory exists"
        return 0
    else
        print_result "$test_name" "FAIL" "Directory does not exist"
        return 1
    fi
}

# Run a command as a specific user (for CI)
run_as_user() {
    local user="$1"
    local command="$2"
    
    if [ -n "$user" ]; then
        su - "$user" -c "bash -lc \"$command\""
    else
        bash -lc "$command"
    fi
}

# Check if a command exists as a specific user
command_exists_as_user() {
    local user="$1"
    local cmd="$2"
    
    if [ -n "$user" ]; then
        su - "$user" -c "bash -lc \"command -v $cmd\"" >/dev/null 2>&1
    else
        bash -lc "command -v $cmd" >/dev/null 2>&1
    fi
}

# Print test summary
print_summary() {
    # Load the latest state
    load_test_state
    
    echo -e "\n${YELLOW}========== TEST SUMMARY ==========${NC}"
    echo -e "Total Tests: $TESTS_TOTAL"
    echo -e "${GREEN}Passed: $TESTS_PASSED${NC}"
    echo -e "${RED}Failed: $TESTS_FAILED${NC}"
    
    if [ $TESTS_FAILED -eq 0 ]; then
        echo -e "\n${GREEN}✓ All tests passed!${NC}"
        return 0
    else
        echo -e "\n${RED}✗ Some tests failed!${NC}"
        return 1
    fi
}

# Reset test counters (if needed)
reset_test_counters() {
    TESTS_TOTAL=0
    TESTS_PASSED=0
    TESTS_FAILED=0
}

