source ~/.dotfiles/utils/utils.sh

## =========== LINK CROSS-PLATFORM FILES ===========
source ~/.dotfiles/common/link_files.sh

## =========== LINK MACOS FILES ===========

# Inputrc
link "$DOTFILES_DIR/user/.inputrc" "$HOME/.inputrc"
