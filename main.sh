#!/bin/bash

# Load .env to customize the installation
if [ -f .env.sh ]; then
  source .env.sh
fi

source ~/.dotfiles/utils/utils.sh

echo "==============================================="
echo "=============== D's DOTFILES =================="
echo "==============================================="

# Ask for the administrator password upfront
sudo -v

echo "OS: $CURRENT_OS"
echo "ARCH: $CURRENT_ARCH"
echo "PM: $CURRENT_PM"
echo "DISTRO: $CURRENT_DISTRO"

if [[ "$CURRENT_DISTRO" == "arch" ]]; then
  ~/.dotfiles/install/arch.sh
elif [[ "$CURRENT_DISTRO" == "ubuntu" ]]; then
  ~/.dotfiles/install/ubuntu.sh
elif [[ "$CURRENT_OS" == "macos" ]]; then
  ~/.dotfiles/install/macos.sh
else
  echo "❌ Unsupported distro: '$CURRENT_DISTRO'" >&2
  exit 1
fi

# Run common post-install tasks
~/.dotfiles/setup/scripts/post_install_tasks.sh
