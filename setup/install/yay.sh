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
    # -Rdd: remove the package, skip dependency checks, ignore "not installed" deps
    # --nodeps: do not run dependency checks (in case the source build left
    #           dangling deps in a broken state)
    sudo pacman -Rdd --noconfirm opencode 2>&1 || true
  fi
fi

for pkg_cmd in "${packages[@]}"; do
  yay -Syu --noconfirm --needed --cleanafter $pkg_cmd
done
