#!/bin/bash

echo "SETUP zshrc ------------------------------------------"

echo "Installing zsh..."
sudo apt-get install zsh -y

<<<<<<< HEAD
install_zsh() {
  if [[ ! "$SHELL" == "$(command -v zsh)" ]]; then
    chsh -s "$(command -v zsh)"
  fi

  if [[ ! -d $HOME/.oh-my-zsh/ ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  fi
}
=======
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
>>>>>>> Update configs for Ubuntu20

install_zsh