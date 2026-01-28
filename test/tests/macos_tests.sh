#!/bin/bash

# macOS-Specific Tests for Dotfiles Post-Installation
# This file contains tests that apply only to macOS

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source test helpers
source "$SCRIPT_DIR/../lib/test_helpers.sh"
source "$SCRIPT_DIR/../lib/platform_detection.sh"

# Load test state
load_test_state

# Run macOS command tests
run_macos_command_tests() {
    print_section "macOS Command Tests"
    
    # macOS-specific commands
    assert_command_exists "starship"
    assert_command_exists "unzip"
    assert_command_exists "brew"
    assert_command_exists "mas"
    assert_command_exists "gh"
    assert_command_exists "ghostty"
    assert_command_exists "fnm"
    
    # Check for Xcode Command Line Tools
    if xcode-select -p >/dev/null 2>&1; then
        print_result "Xcode Command Line Tools" "PASS" "Found at: $(xcode-select -p)"
    else
        print_result "Xcode Command Line Tools" "FAIL" "Not installed"
    fi
}

# Run macOS symlink tests
run_macos_symlink_tests() {
    print_section "macOS Symlink Tests"
    
    # macOS-specific symlinks
    assert_file_is_symlink "$HOME/.inputrc"
    assert_file_is_symlink "$HOME/.config/ghostty/config"
}

# Run macOS Homebrew tests
run_macos_homebrew_tests() {
    print_section "macOS Homebrew Tests"
    
    # Check if Homebrew is properly installed
    if command -v brew >/dev/null 2>&1; then
        print_result "Homebrew Installation" "PASS" "Found at: $(which brew)"
        
        # Check if Homebrew is healthy
        if brew doctor >/dev/null 2>&1; then
            print_result "Homebrew Health" "PASS" "No issues found"
        else
            print_result "Homebrew Health" "FAIL" "Issues found, run 'brew doctor'"
        fi
        
        # Check if Homebrew can update
        if brew update >/dev/null 2>&1; then
            print_result "Homebrew Update" "PASS" "Can update successfully"
        else
            print_result "Homebrew Update" "FAIL" "Cannot update"
        fi
    else
        print_result "Homebrew Installation" "FAIL" "Homebrew not found"
    fi
}

# Run macOS shell tests
run_macos_shell_tests() {
    print_section "macOS Shell Tests"
    
    # Check if Homebrew bash is in /etc/shells
    local bash_path=""
    if [ "$(uname -m)" = "arm64" ]; then
        bash_path="/opt/homebrew/bin/bash"
    else
        bash_path="/usr/local/bin/bash"
    fi
    
    if grep -Fxq "$bash_path" /etc/shells; then
        print_result "Homebrew Bash in /etc/shells" "PASS" "Found at: $bash_path"
    else
        print_result "Homebrew Bash in /etc/shells" "FAIL" "Not found in /etc/shells"
    fi
    
    # Check if the bash path exists
    if [ -x "$bash_path" ]; then
        print_result "Homebrew Bash Executable" "PASS" "Found at: $bash_path"
    else
        print_result "Homebrew Bash Executable" "FAIL" "Not found at: $bash_path"
    fi
}

# Run macOS directory tests
run_macos_directory_tests() {
    print_section "macOS Directory Tests"
    
    # Check for macOS-specific directories
    assert_directory_exists "$HOME/Pictures/Screenshots"
    assert_directory_exists "$HOME/.config/ghostty"
}

# Run all macOS tests
run_all_macos_tests() {
    run_macos_command_tests
    run_macos_symlink_tests
    run_macos_homebrew_tests
    run_macos_shell_tests
    run_macos_directory_tests
}

# Run tests when called directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Initialize test state
    init_test_state
    
    # Run tests
    run_all_macos_tests
    
    # Print summary only when not part of main test suite
    if [ -z "$DOTFILES_TEST_SUITE" ]; then
        print_summary
        cleanup_test_state
    fi
fi