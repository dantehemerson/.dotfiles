source ~/.dotfiles/utils/utils.sh

## =========== LINK FILES ===========

# ZSH
link "$PWD/user/.zshrc" "$HOME/.zshrc"

# Bash
link "$PWD/user/.bashrc" "$HOME/.bashrc"
link "$PWD/user/.bash_profile" "$HOME/.bash_profile"

# Inputrc
link "$PWD/user/.inputrc" "$HOME/.inputrc"

# Git
link "$PWD/user/.gitconfig" "$HOME/.gitconfig" $__DOT_GIT__LINKING_MODE

# Vim
link "$PWD/user/.vimrc" "$HOME/.vimrc"

# Tmux
link "$PWD/user/.tmux.conf" "$HOME/.tmux.conf"


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
for ((i=0; i<${#custom_options[@]}; i+=2)); do
  key=${custom_options[i]}
  value=${custom_options[i+1]}

  # check if key is not empty(different of "V_")
  if [ "$key" != "V_" ]; then
    echo "Executing $ $value"
    eval $value
  fi
done