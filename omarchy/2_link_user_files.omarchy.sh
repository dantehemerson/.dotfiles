source ~/.dotfiles/utils/utils.sh

## =========== LINK CROSS-PLATFORM FILES ===========
source ~/.dotfiles/common/link_files.sh

## =========== LINK OMARCHY FILES ===========

# Bash
link "$PWD/omarchy/.bashrc" "$HOME/.bashrc"

## Hypr

link ~/.dotfiles/omarchy/.config/hypr/input.conf "$HOME/.config/hypr/input.conf"
link ~/.dotfiles/omarchy/.config/hypr/bindings.conf "$HOME/.config/hypr/bindings.conf"
link ~/.dotfiles/user/zed/settings.json "$HOME/.config/zed/settings.json"
