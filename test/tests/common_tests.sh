#!/bin/bash

set -euxo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../lib/test_helpers.sh"

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
assert_command_exists "tmux"
assert_command_exists "bash"
assert_command_exists "zsh"
assert_command_exists "fd"
assert_command_exists "unzip"
assert_command_exists "gh"
assert_command_exists "atuin"
assert_command_exists "mise"
assert_command_exists "opencode"

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
assert_file_is_symlink "$HOME/.config/ghostty/config"
assert_file_is_symlink "$HOME/.config/nvim"
assert_file_is_symlink "$HOME/.config/mise/config.toml"

assert_directory_exists "$HOME/.config/zed"

# SSH Key tests (directory existence implied by file checks)
assert_file_exists "$HOME/.ssh/id_ed25519_gh"
assert_file_exists "$HOME/.ssh/id_ed25519_gh.pub"
assert_file_permissions "$HOME/.ssh/id_ed25519_gh" "600"
assert_file_permissions "$HOME/.ssh/id_ed25519_gh.pub" "644"
# SSH config (if it exists, check permissions)
if [ -f "$HOME/.ssh/config" ]; then
  assert_file_permissions "$HOME/.ssh/config" "600"
fi

# Test that dotfiles repo remote is using SSH (not HTTPS)
CURRENT_REMOTE_URL=$(git -C "$HOME/.dotfiles" remote get-url origin 2>/dev/null || true)
if [[ "$CURRENT_REMOTE_URL" == https://* ]]; then
  echo "❌ Dotfiles remote is using HTTPS instead of SSH: $CURRENT_REMOTE_URL"
  exit 1
fi
