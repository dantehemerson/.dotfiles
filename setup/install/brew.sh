#!/usr/bin/env bash

source ~/.dotfiles/utils/utils.sh

macos_packages=()
load_packages "$HOME/.dotfiles/setup/packages/macos.packages" macos_packages
printf "=> Installing macos packages:\n"
printf "\t- %s\n" "${macos_packages[@]}"
for pkg_cmd in "${macos_packages[@]}"; do
  brew install $pkg_cmd
done

common_packages=()
load_packages "$HOME/.dotfiles/common/common.packages" common_packages
printf "=> Installing common packages:\n"
printf "\t- %s\n" "${common_packages[@]}"
for pkg_cmd in "${common_packages[@]}"; do
  brew install $pkg_cmd
done
