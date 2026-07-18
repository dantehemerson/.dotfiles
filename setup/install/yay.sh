#!/bin/bash

source ~/.dotfiles/utils/utils.sh

packages=()
load_packages "$HOME/.dotfiles/setup/packages/arch.yay.packages" packages
printf "=> Installing common yay packages:\n"
printf "\t- %s\n" "${packages[@]}"

# If opencode-bin is in the list, remove the source `opencode` package first
# (they conflict; yay's non-interactive mode won't auto-resolve the prompt).
if [[ " ${packages[*]} " == *" opencode-bin "* ]]; then
  if pacman -Q opencode &>/dev/null; then
    echo "==> Removing conflicting 'opencode' package before installing opencode-bin..."
    sudo pacman -Rns --noconfirm opencode || true
  fi
fi

for pkg_cmd in "${packages[@]}"; do
  yay -Syu --noconfirm --needed --cleanafter $pkg_cmd
done
