#!/bin/bash

set -euxo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../lib/test_helpers.sh"
source "$SCRIPT_DIR/../lib/platform_detection.sh"

assert_command_exists "git"
assert_command_exists "wget"
assert_command_exists "btop"
assert_command_exists "htop"
assert_command_exists "curl"
assert_command_exists "duf"
assert_command_exists "fastfetch"
assert_command_exists "jq"
assert_command_exists "yq"
assert_command_exists "nvim"
assert_command_exists "tree"
assert_command_exists "bat"
assert_command_exists "lazygit"
assert_command_exists "rg" # ripgrep
assert_command_exists "bash"
assert_command_exists "zsh"
assert_command_exists "fd"
assert_command_exists "unzip"

zsh -ic 'command -v zimfw >/dev/null' 2>/dev/null

assert_directory_exists "$HOME/.tmux/plugins/tpm"

assert_file_is_symlink "$HOME/.zshrc"
assert_file_is_symlink "$HOME/.zimrc"
assert_file_is_symlink "$HOME/.bashrc"
assert_file_is_symlink "$HOME/.bash_profile"
assert_file_is_symlink "$HOME/.config/starship.toml"
assert_file_is_symlink "$HOME/.gitconfig"
assert_file_is_symlink "$HOME/.vimrc"
assert_file_is_symlink "$HOME/.tmux.conf"
assert_file_is_symlink "$HOME/.config/zed/settings.json"
assert_file_is_symlink "$HOME/.config/nvim/init.lua"
assert_file_is_symlink "$HOME/.config/ghostty/config"

assert_directory_exists "$HOME/.config/nvim/lua/plugins"
assert_directory_exists "$HOME/.config/nvim/lua/config"
assert_directory_exists "$HOME/.config/nvim"
assert_file_exists "$HOME/.config/nvim/lua/config/lazy.lua"
assert_directory_exists "$HOME/.config/zed"
