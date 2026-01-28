#!/bin/bash

# Ubuntu-Specific Tests for Dotfiles Post-Installation
# This file contains tests that apply only to Ubuntu

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source test helpers
source "$SCRIPT_DIR/../lib/test_helpers.sh"
source "$SCRIPT_DIR/../lib/platform_detection.sh"

# Run Ubuntu command tests
run_ubuntu_command_tests() {
    # Ubuntu-specific commands
    assert_command_exists "apt"
    assert_command_exists "rust-fd-find"
    assert_command_exists "superfile"
}

# Run Ubuntu package manager tests
run_ubuntu_package_manager_tests() {
    # Check if apt is working
    apt update >/dev/null 2>&1
    
    # Check if apt can query packages
    apt list --installed >/dev/null 2>&1
}

# Run Ubuntu directory tests
run_ubuntu_directory_tests() {
    # Check for Ubuntu-specific directories
    assert_directory_exists "/etc/apt"
    assert_directory_exists "/var/cache/apt"
}

# Run all Ubuntu tests
run_all_ubuntu_tests() {
    run_ubuntu_command_tests
    run_ubuntu_package_manager_tests
    run_ubuntu_directory_tests
}

# Run tests when called directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Run tests
    run_all_ubuntu_tests
fi