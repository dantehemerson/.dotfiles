source ~/.dotfiles/utils/utils.sh

## =========== LINK CROSS-PLATFORM FILES ===========
source ~/.dotfiles/common/link_files.sh

## =========== LINK OMARCHY FILES ===========

# Bash
link "$PWD/omarchy/.bashrc" "$HOME/.bashrc"

## Hyprland config

link ~/.dotfiles/omarchy/.config/hypr/input.conf "$HOME/.config/hypr/input.conf"
link ~/.dotfiles/omarchy/.config/hypr/bindings.conf "$HOME/.config/hypr/bindings.conf"
