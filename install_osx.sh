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
  # Only link if file is not already linked
  if [ ! -L "$2" ] && [ ! -d "$2" ]; then
    move_to_trash "$2"
    ln -sf "$1" "$2"
    echo "🔗 File $2 linked"
  else
    echo "🔗 File $2 is already linked"
  fi
}

## =========== LINK FILES ===========

# ZSH
link "$PWD/.shell" "$HOME/.shell"
link "$PWD/.shell/.zshrc" "$HOME/.zshrc"

# Git Config
link "$PWD/user/.gitconfig" "$HOME/.gitconfig"

# Vimrc
link "$PWD/user/.vimrc" "$HOME/.vimrc"