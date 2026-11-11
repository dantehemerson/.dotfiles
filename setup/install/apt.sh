#!/bin/bash

set -euo pipefail

source ~/.dotfiles/utils/utils.sh

sudo apt-get update -y
sudo apt-get upgrade -y

common_packages=()

load_packages "$HOME/.dotfiles/common/common.packages" common_packages
printf "=> Installing common packages:\n"
printf "\t- %s\n" "${common_packages[@]}"

# Install in a single transaction: apt resolution is expensive and doing it
# once per package made this step take tens of minutes on slower runners.
# Fall back to one-by-one installs so a broken package name is still reported.
if ! sudo apt-get install -y "${common_packages[@]}"; then
  echo "⚠️  Batch install failed, retrying packages one by one..." >&2
  for pkg_cmd in "${common_packages[@]}"; do
    if ! sudo apt-get install -y "$pkg_cmd"; then
      echo "❌ Failed to install apt package: $pkg_cmd" >&2
      exit 1
    fi
  done
fi
