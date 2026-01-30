source ~/.dotfiles/utils/utils.sh

echo "=> Linking common files"

## =========== LINK CROSS-PLATFORM FILES ===========

# ZSH
link "$DOTFILES_DIR/user/.zshrc" "$HOME/.zshrc"

# Zim
link "$DOTFILES_DIR/user/.zimrc" "$HOME/.zimrc"

# Bash
link "$DOTFILES_DIR/user/.bashrc" "$HOME/.bashrc"
link "$DOTFILES_DIR/user/.bash_profile" "$HOME/.bash_profile"

# Starship: Shell Prompt
link "$DOTFILES_DIR/user/.config/starship.toml" "$HOME/.config/starship.toml"

# Ghostty
link "$DOTFILES_DIR/user/.ghostty_config" "$HOME/.config/ghostty/config"

# Git
link "$DOTFILES_DIR/user/.gitconfig" "$HOME/.gitconfig" $__DOT_GIT__LINKING_MODE

# Vim
link "$DOTFILES_DIR/user/.vimrc" "$HOME/.vimrc"

# Tmux
link "$DOTFILES_DIR/user/.tmux.conf" "$HOME/.tmux.conf"

# Zed
link "$DOTFILES_DIR/user/zed/settings.json" "$HOME/.config/zed/settings.json"

# Neovim
link "$DOTFILES_DIR/user/.config/nvim" "$HOME/.config/nvim"

## ============ CUSTOM OPTIONS ============
custom_options=(
  "V_$__DOT_GIT__USER__EMAIL"
  "git config --global user.email \"$__DOT_GIT__USER__EMAIL\""

  "V_$__DOT_GIT__USER__NAME"
  "git config --global user.name \"$__DOT_GIT__USER__NAME\""

  "V_$__DOT_GIT__COMMIT__GPG_SIGN"
  "git config --global commit.gpgsign \"$__DOT_GIT__COMMIT__GPG_SIGN\""
)

# Apply custom options
for ((i = 0; i < ${#custom_options[@]}; i += 2)); do
  key=${custom_options[i]}
  value=${custom_options[i + 1]}

  # check if key is not empty(different of "V_")
  if [ "$key" != "V_" ]; then
    echo "Executing $ $value"
    eval $value
  fi
done

echo "=> Linked common files."
