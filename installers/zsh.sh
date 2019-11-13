#!/bin/bash

echo "SETUP zshrc ------------------------------------------"

echo "Installing zsh..."
sudo apt-get install zsh -y

install_zsh() {
  if [[ ! "$SHELL" == "$(command -v zsh)" ]]; then
    chsh -s "$(command -v zsh)"
  fi

  if [[ ! -d $HOME/.oh-my-zsh/ ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  fi
}

install_zsh