#!/bin/sh

# Load .env to customize the installation
if [ -f .env.sh ]; then
  source .env.sh
fi

if [[ "$(uname)" == "Linux" ]]; then
  IS_LINUX=true
elif [[ "$(uname)" == "Darwin" ]]; then
  IS_OSX=true
fi

echo "==============================================="
echo "=============== D's DOTFILES =================="
echo "==============================================="

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


if [[ "$IS_LINUX" == true ]]; then
  echo "- Info -"
  echo "SO: Linux"
  echo "Shell: $SHELL"
  ./linux/1_install_apps.linux.sh
  ./linux/2_link_user_files.linux.sh

elif [[ "$IS_OSX" == true ]]; then
  echo "- Info -"
  echo "SO: OSX"
  echo "Shell: $SHELL"

  if [[ $(uname -m) == "arm64" ]]; then
    echo "Processor: Apple Silicon"
  else
    echo "Processor: Intel"
  fi

  ./macos/1_install_apps.osx.sh
  ./macos/2_configure.osx.sh

fi
