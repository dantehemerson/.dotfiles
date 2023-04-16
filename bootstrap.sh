#!/usr/bin/env bash

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

if [[ "$IS_LINUX" == true ]]; then
  echo "- Info -"
  echo "SO: Linux"
  echo "Shell: $SHELL"
  echo "Missing"



elif [[ "$IS_OSX" == true ]]; then
  echo "- Info -"
  echo "SO: OSX"
  echo "Shell: $SHELL"

  ./macos/1_install_apps.osx.sh
  ./macos/2_configure.osx.sh
  
fi
