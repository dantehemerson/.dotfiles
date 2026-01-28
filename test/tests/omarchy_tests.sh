#!/bin/bash

# Omarchy-Specific Tests for Dotfiles Post-Installation
# This file contains tests that apply only to Omarchy setup (Hyprland)

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source test helpers
source "$SCRIPT_DIR/../lib/test_helpers.sh"
source "$SCRIPT_DIR/../lib/platform_detection.sh"

# Run Omarchy command tests
run_omarchy_command_tests() {
    # Check for Hyprland
    assert_command_exists "hyprland"
    
    # Check for Hyprctl (Hyprland control utility)
    assert_command_exists "hyprctl"
}

# Run Omarchy symlink tests
run_omarchy_symlink_tests() {
    # Omarchy-specific symlinks
    assert_file_is_symlink "$HOME/.config/hypr/input.conf"
    assert_file_is_symlink "$HOME/.config/hypr/bindings.conf"
    
    # Check if the omarchy .bashrc is linked (overwrites the common one)
    if [ -L "$HOME/.bashrc" ]; then
        local bashrc_target=$(readlink "$HOME/.bashrc")
        [[ "$bashrc_target" == *"omarchy"* ]]
    else
        false
    fi
}

# Run Omarchy directory tests
run_omarchy_directory_tests() {
    # Check for Omarchy-specific directories
    assert_directory_exists "$HOME/.config/hypr"
}

# Run all Omarchy tests
run_all_omarchy_tests() {
    run_omarchy_command_tests
    run_omarchy_symlink_tests
    run_omarchy_directory_tests
}

# Run tests when called directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Run tests
    run_all_omarchy_tests
fi