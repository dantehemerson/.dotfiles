# Move a file or folder to trash.
# Used to moved files that already exists before create the symlink,
# just in case we need to restore them.
function move_to_trash() {
  if [ -e "$1" ]; then
    filename=$(basename "$1")
    new_filename="$filename-$(date +%s)"

    mv -f "$1" ~/.Trash/"$new_filename"
    echo "$filename moved to trash, you can restore it from there if needed"
  fi
}

function link() {
  if [ "$3" = "copy" ]; then # COPY
    move_to_trash "$2"
    cp -r "$1" "$2"
    echo "🔗 File $2 copied from $1"
    return
  elif [ "$3" = "skip" ]; then # SKIP
    # noop
    return
  else # LINK by default
    # Only link if file is not already linked
    if [ ! -L "$2" ] && [ ! -d "$2" ]; then
      move_to_trash "$2"
      ln -sf "$1" "$2"
      echo "🔗 File $2 linked to $1"
    else
      echo "ℹ️  File $2 is already linked"
    fi
    return
  fi
}



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