source ~/.dotfiles/utils/utils.sh

## =========== LINK CROSS-PLATFORM FILES ===========
source ~/.dotfiles/common/link_files.sh

## =========== LINK OMARCHY FILES ===========

# Bash
link "$PWD/omarchy/.bashrc" "$HOME/.bashrc"
