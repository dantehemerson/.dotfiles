#!/bin/bash

# macOS-Specific Tests for Dotfiles Post-Installation
# This file contains tests that apply only to macOS

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source test helpers
source "$SCRIPT_DIR/../lib/test_helpers.sh"
source "$SCRIPT_DIR/../lib/platform_detection.sh"

# Run macOS command tests
run_macos_command_tests() {
    # macOS-specific commands
    assert_command_exists "starship"
    assert_command_exists "unzip"
    assert_command_exists "brew"
    assert_command_exists "mas"
    assert_command_exists "gh"
    assert_command_exists "ghostty"
    assert_command_exists "fnm"
    
    # Check for Xcode Command Line Tools
    xcode-select -p >/dev/null 2>&1
}

# Run macOS symlink tests
run_macos_symlink_tests() {
    # macOS-specific symlinks
    assert_file_is_symlink "$HOME/.inputrc"
    assert_file_is_symlink "$HOME/.config/ghostty/config"
}

# Run macOS Homebrew tests
run_macos_homebrew_tests() {
    # Check if Homebrew is properly installed
    if command -v brew >/dev/null 2>&1; then
        # Check if Homebrew is healthy
        brew doctor >/dev/null 2>&1
        
        # Check if Homebrew can update
        brew update >/dev/null 2>&1
    fi
}

# Run macOS shell tests
run_macos_shell_tests() {
    # Check if Homebrew bash is in /etc/shells
    local bash_path=""
    if [ "$(uname -m)" = "arm64" ]; then
        bash_path="/opt/homebrew/bin/bash"
    else
        bash_path="/usr/local/bin/bash"
    fi
    
    grep -Fxq "$bash_path" /etc/shells
    
    # Check if the bash path exists
    [ -x "$bash_path" ]
}

# Run macOS directory tests
run_macos_directory_tests() {
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

# Run tests when called called directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Run tests
    run_all_macos_tests
fi