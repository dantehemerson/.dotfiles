#!/bin/bash

# Debian-Specific Tests for Dotfiles Post-Installation
# This file contains tests that apply only to Debian

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source test helpers
source "$SCRIPT_DIR/../lib/test_helpers.sh"
source "$SCRIPT_DIR/../lib/platform_detection.sh"

# Load test state
load_test_state

# Run Debian command tests
run_debian_command_tests() {
    print_section "Debian Command Tests"
    
    # Debian-specific commands
    assert_command_exists "apt"
    assert_command_exists "rust-fd-find"
    assert_command_exists "superfile"
}

# Run Debian package manager tests
run_debian_package_manager_tests() {
    print_section "Debian Package Manager Tests"
    
    # Check if apt is working
    if apt update >/dev/null 2>&1; then
        print_result "apt Update" "PASS" "Can update package list"
    else
        print_result "apt Update" "FAIL" "Cannot update package list"
    fi
    
    # Check if apt can query packages
    if apt list --installed >/dev/null 2>&1; then
        print_result "apt Query" "PASS" "Can query installed packages"
    else
        print_result "apt Query" "FAIL" "Cannot query installed packages"
    fi
}

# Run Debian directory tests
run_debian_directory_tests() {
    print_section "Debian Directory Tests"
    
    # Check for Debian-specific directories
    assert_directory_exists "/etc/apt"
    assert_directory_exists "/var/cache/apt"
}

# Run all Debian tests
run_all_debian_tests() {
    run_debian_command_tests
    run_debian_package_manager_tests
    run_debian_directory_tests
}

# Run tests when called directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Initialize test state
    init_test_state
    
    # Run tests
    run_all_debian_tests
    
    # Print summary only when not part of main test suite
    if [ -z "$DOTFILES_TEST_SUITE" ]; then
        print_summary
        cleanup_test_state
    fi
fi