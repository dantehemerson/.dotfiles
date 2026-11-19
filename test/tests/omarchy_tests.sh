#!/bin/bash

set -euxo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../lib/test_helpers.sh"

# Omarchy must be present for these assertions to mean anything.
assert_command_exists "omarchy"

# The shell files must parse cleanly.
for shell_file in \
  "$HOME/.dotfiles/user/.bashrc" \
  "$HOME/.dotfiles/user/.bash_profile" \
  "$HOME/.dotfiles/shell/init.sh" \
  "$HOME/.dotfiles/shell/aliases.sh" \
  "$HOME/.dotfiles/shell/functions.sh" \
  "$HOME/.dotfiles/shell/bash/aliases.sh" \
  "$HOME/.dotfiles/shell/bash/functions.sh"; do
  bash -n "$shell_file"
done

# The dotfiles bashrc owns ~/.bashrc through a symlink.
assert_file_is_symlink "$HOME/.bashrc"
assert_symlink_points_to "$HOME/.bashrc" "$HOME/.dotfiles/user/.bashrc"
assert_file_is_symlink "$HOME/.bash_profile"
assert_symlink_points_to "$HOME/.bash_profile" "$HOME/.dotfiles/user/.bash_profile"

# Omarchy's own rc MUST be sourced, otherwise the migration that preserves
# dotfiles-owned bashrcs and the next `omarchy update` would fight each other.
grep -q 'default/bash/rc' "$HOME/.dotfiles/user/.bashrc"

# Omarchy keeps ownership of its shell (bash) and init.
assert_command_exists "bash"
assert_shell_definition "zd" "function"   # Omarchy zoxide directory jumper
assert_shell_definition "gcm" "alias"     # Omarchy git alias
assert_shell_definition "ls" "alias"      # Omarchy eza alias
assert_shell_definition "l" "alias"       # dotfiles long listing
assert_shell_definition "ll" "alias"      # dotfiles long listing
assert_shell_definition "la" "alias"      # dotfiles long listing

# Dotfiles definitions loaded after Omarchy's, so they win on overlap.
assert_shell_definition "c" "alias"           # dotfiles: opencode (not opencode --auto)
assert_shell_definition "lzd" "alias"         # dotfiles: lazydocker
assert_shell_definition "lg" "alias"          # dotfiles: lazygit
assert_shell_definition "kp" "function"       # dotfiles: kill port
assert_shell_definition "add-repo" "function" # dotfiles: herdr worktree helper

# User-owned configs are symlinked into the dotfiles repo.
for linked in \
  "$HOME/.gitconfig" \
  "$HOME/.vimrc" \
  "$HOME/.inputrc" \
  "$HOME/.config/nvim" \
  "$HOME/.config/starship.toml" \
  "$HOME/.config/lazygit/config.yml" \
  "$HOME/.config/mise/config.toml" \
  "$HOME/.config/opencode/cli.json" \
  "$HOME/.config/herdr/config.toml" \
  "$HOME/.config/herdr-app/settings.json"; do
  assert_file_is_symlink "$linked"
done

# Omarchy keeps ownership of these, so they must NOT be symlinked.
for omarchy_owned in \
  "$HOME/.config/ghostty/config" \
  "$HOME/.tmux.conf" \
  "$HOME/.config/zed/settings.json"; do
  [ ! -L "$omarchy_owned" ]
done

# Git identity comes from the dotfiles .gitconfig.
[ "$(git config user.email)" = "18385321+dantehemerson@users.noreply.github.com" ]

# The linked nvim config starts cleanly (the runtime theme file is optional).
timeout 60 nvim --headless +q >/dev/null 2>&1
