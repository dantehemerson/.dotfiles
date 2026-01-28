#!/bin/bash

# Arch Linux-Specific Tests for Dotfiles Post-Installation
# This file contains tests that apply only to Arch Linux

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source test helpers
source "$SCRIPT_DIR/../lib/test_helpers.sh"
source "$SCRIPT_DIR/../lib/platform_detection.sh"

# Run Arch Linux command tests
run_arch_command_tests() {
    # Arch Linux-specific commands
    assert_command_exists "pacman"
    assert_command_exists "fd"
    
    # Check for yay (AUR helper)
    assert_command_exists "yay"
}

# Run Arch Linux package manager tests
run_arch_package_manager_tests() {
    # Check if pacman is working
    pacman -Sy >/dev/null 2>&1
    
    # Check if pacman can query packages
    pacman -Q pacman >/dev/null 2>&1
    
    # Check if yay is installed and working
    if command -v yay >/dev/null 2>&1; then
        yay -Sy >/dev/null 2>&1
    fi
}

# Run Arch Linux directory tests
run_arch_directory_tests() {
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
    # Run tests
    run_all_arch_tests
fi