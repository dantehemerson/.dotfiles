#!/bin/bash

set -euo pipefail

source ~/.dotfiles/utils/utils.sh

sudo apt-get update -y
sudo apt-get upgrade -y

common_packages=()

load_packages "$HOME/.dotfiles/common/common.packages" common_packages
printf "=> Installing common packages:\n"
printf "\t- %s\n" "${common_packages[@]}"
for pkg_cmd in "${common_packages[@]}"; do
  if ! sudo apt-get install -y "$pkg_cmd"; then
    echo "❌ Failed to install apt package: $pkg_cmd" >&2
    exit 1
  fi
done
