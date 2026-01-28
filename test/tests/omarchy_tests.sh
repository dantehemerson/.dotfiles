#!/bin/bash

# Omarchy-Specific Tests for Dotfiles Post-Installation
# This file contains tests that apply only to Omarchy setup (Hyprland)

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source test helpers
source "$SCRIPT_DIR/../lib/test_helpers.sh"
source "$SCRIPT_DIR/../lib/platform_detection.sh"

# Load test state
load_test_state

# Run Omarchy command tests
run_omarchy_command_tests() {
    print_section "Omarchy Command Tests"
    
    # Check for Hyprland
    if command -v hyprland >/dev/null 2>&1; then
        print_result "Hyprland" "PASS" "Found at: $(which hyprland)"
    else
        print_result "Hyprland" "FAIL" "Hyprland not found"
    fi
    
    # Check for Hyprctl (Hyprland control utility)
    if command -v hyprctl >/dev/null 2>&1; then
        print_result "Hyprctl" "PASS" "Found at: $(which hyprctl)"
    else
        print_result "Hyprctl" "FAIL" "Hyprctl not found"
    fi
}

# Run Omarchy symlink tests
run_omarchy_symlink_tests() {
    print_section "Omarchy Symlink Tests"
    
    # Omarchy-specific symlinks
    assert_file_is_symlink "$HOME/.config/hypr/input.conf"
    assert_file_is_symlink "$HOME/.config/hypr/bindings.conf"
    
    # Check if the omarchy .bashrc is linked (overwrites the common one)
    if [ -L "$HOME/.bashrc" ]; then
        local bashrc_target=$(readlink "$HOME/.bashrc")
        if [[ "$bashrc_target" == *"omarchy"* ]]; then
            print_result "Omarchy .bashrc" "PASS" "Symlink points to omarchy .bashrc"
        else
            print_result "Omarchy .bashrc" "FAIL" "Symlink does not point to omarchy .bashrc"
        fi
    else
        print_result "Omarchy .bashrc" "FAIL" ".bashrc is not a symlink"
    fi
}

# Run Omarchy directory tests
run_omarchy_directory_tests() {
    print_section "Omarchy Directory Tests"
    
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
    # Initialize test state
    init_test_state
    
    # Run tests
    run_all_omarchy_tests
    
    # Print summary only when not part of main test suite
    if [ -z "$DOTFILES_TEST_SUITE" ]; then
        print_summary
        cleanup_test_state
    fi
fi