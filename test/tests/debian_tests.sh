#!/bin/bash

# Debian-Specific Tests for Dotfiles Post-Installation
# This file contains tests that apply only to Debian

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source test helpers
source "$SCRIPT_DIR/../lib/test_helpers.sh"
source "$SCRIPT_DIR/../lib/platform_detection.sh"

# Run Debian command tests
run_debian_command_tests() {
    # Debian-specific commands
    assert_command_exists "apt"
    assert_command_exists "rust-fd-find"
    assert_command_exists "superfile"
}

# Run Debian package manager tests
run_debian_package_manager_tests() {
    # Check if apt is working
    apt update >/dev/null 2>&1
    
    # Check if apt can query packages
    apt list --installed >/dev/null 2>&1
}

# Run Debian directory tests
run_debian_directory_tests() {
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
    # Run tests
    run_all_debian_tests
fi