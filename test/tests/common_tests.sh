#!/bin/bash

# Common Tests for Dotfiles Post-Installation
# This file contains tests that apply to all platforms

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source test helpers
source "$SCRIPT_DIR/../lib/test_helpers.sh"
source "$SCRIPT_DIR/../lib/platform_detection.sh"

# Run common command tests
run_common_command_tests() {
    # Core commands
    assert_command_exists "git"
    assert_command_exists "wget"
    assert_command_exists "curl"
    assert_command_exists "bash"
    assert_command_exists "zsh"
    
    # System monitoring tools
    assert_command_exists "btop"
    assert_command_exists "htop"
    
    # File and data tools
    assert_command_exists "tree"
    assert_command_exists "jq"
    assert_command_exists "yq"
    
    # Editors and development tools
    assert_command_exists "neovim"
    assert_command_exists "ripgrep"
    assert_command_exists "bat"
    assert_command_exists "lazygit"
}

# Run common symlink tests
run_common_symlink_tests() {
    # Shell configuration files
    assert_file_is_symlink "$HOME/.zshrc"
    assert_file_is_symlink "$HOME/.zimrc"
    assert_file_is_symlink "$HOME/.bashrc"
    assert_file_is_symlink "$HOME/.bash_profile"
    
    # Application configuration files
    assert_file_is_symlink "$HOME/.config/starship.toml"
    assert_file_is_symlink "$HOME/.gitconfig"
    assert_file_is_symlink "$HOME/.vimrc"
    assert_file_is_symlink "$HOME/.tmux.conf"
    
    # Editor configurations
    assert_file_is_symlink "$HOME/.config/zed/settings.json"
    
    # Neovim configuration
    assert_file_is_symlink "$HOME/.config/nvim/init.lua"
    
    # Check if Neovim plugin directories exist
    assert_directory_exists "$HOME/.config/nvim/lua/plugins"
    assert_directory_exists "$HOME/.config/nvim/lua/config"
}

# Run common directory tests
run_common_directory_tests() {
    # Check if important directories exist
    assert_directory_exists "$HOME/.config"
    assert_directory_exists "$HOME/.config/nvim"
    assert_directory_exists "$HOME/.config/zed"
}

# Run all common tests
run_all_common_tests() {
    run_common_command_tests
    run_common_symlink_tests
    run_common_directory_tests
}

# Run tests when called directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Run tests
    run_all_common_tests
fi