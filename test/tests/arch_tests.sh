#!/bin/bash

# Arch Linux-Specific Tests for Dotfiles Post-Installation
# This file contains tests that apply only to Arch Linux

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source test helpers
source "$SCRIPT_DIR/../lib/test_helpers.sh"
source "$SCRIPT_DIR/../lib/platform_detection.sh"

# Load test state
load_test_state

# Run Arch Linux command tests
run_arch_command_tests() {
    print_section "Arch Linux Command Tests"
    
    # Arch Linux-specific commands
    assert_command_exists "pacman"
    assert_command_exists "fd"
    
    # Check for yay (AUR helper)
    if command -v yay >/dev/null 2>&1; then
        print_result "yay AUR Helper" "PASS" "Found at: $(which yay)"
    else
        print_result "yay AUR Helper" "FAIL" "yay not found"
    fi
}

# Run Arch Linux package manager tests
run_arch_package_manager_tests() {
    print_section "Arch Linux Package Manager Tests"
    
    # Check if pacman is working
    if pacman -Sy >/dev/null 2>&1; then
        print_result "pacman Update" "PASS" "Can update package database"
    else
        print_result "pacman Update" "FAIL" "Cannot update package database"
    fi
    
    # Check if pacman can query packages
    if pacman -Q pacman >/dev/null 2>&1; then
        print_result "pacman Query" "PASS" "Can query installed packages"
    else
        print_result "pacman Query" "FAIL" "Cannot query installed packages"
    fi
    
    # Check if yay is installed and working
    if command -v yay >/dev/null 2>&1; then
        if yay -Sy >/dev/null 2>&1; then
            print_result "yay Update" "PASS" "Can update package database"
        else
            print_result "yay Update" "FAIL" "Cannot update package database"
        fi
    fi
}

# Run Arch Linux directory tests
run_arch_directory_tests() {
    print_section "Arch Linux Directory Tests"
    
    # Check for Arch Linux-specific directories
    assert_directory_exists "/etc/pacman.d"
    assert_directory_exists "/var/cache/pacman"
}

# Run all Arch Linux tests
run_all_arch_tests() {
    run_arch_command_tests
    run_arch_package_manager_tests
    run_arch_directory_tests
}

# Run tests when called directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Initialize test state
    init_test_state
    
    # Run tests
    run_all_arch_tests
    
    # Print summary only when not part of main test suite
    if [ -z "$DOTFILES_TEST_SUITE" ]; then
        print_summary
        cleanup_test_state
    fi
fi