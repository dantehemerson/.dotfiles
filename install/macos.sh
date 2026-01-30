#!/bin/bash

xcode-select --install

~/.dotfiles/setup/installers/brew.sh

if [[ "$(uname -m)" == "arm64" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  eval "$(/usr/local/bin/brew shellenv)"
fi

brew update

~/.dotfiles/setup/install/brew.sh
~/.dotfiles/setup/installers/tpm.sh
~/.dotfiles/common/link_files.sh
~/.dotfiles/setup/linkers/macos.link.sh
~/.dotfiles/setup/installers/ssh-key-generator/ssh-key-generator.sh
~/.dotfiles/setup/scripts/configure_macos.sh
