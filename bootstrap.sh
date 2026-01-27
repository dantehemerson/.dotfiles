#!/bin/bash

source ~/.dotfiles/utils/utils.sh

# Load .env to customize the installation
if [ -f .env.sh ]; then
  source .env.sh
fi

echo "==============================================="
echo "=============== D's DOTFILES =================="
echo "==============================================="

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

echo "OS: $CURRENT_OS"
echo "ARCH: $CURRENT_ARCH"
echo "PM: $CURRENT_PM"
echo "DISTRO: $CURRENT_DISTRO"

if [[ "$OS" == "linux" ]]; then
  echo "- Info -"
  echo "SO: Linux"
  echo "Shell: $SHELL"
  ./linux/1_install_apps.linux.sh
  ./linux/2_link_user_files.linux.sh

elif [[ "$OS" == "macos" ]]; then
  ./macos/1_install_apps.osx.sh
  ./macos/2_configure.osx.sh
fi
