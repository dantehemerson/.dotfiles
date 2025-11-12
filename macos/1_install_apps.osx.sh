#!/bin/bash

source ~/.dotfiles/utils/utils.sh

## -------------------------------------------
echo "📦 Installing apps..."
## -------------------------------------------


## ============ XCODE ============

# Install Xcode Command Line Tools
xcode-select --install


## =========== BREW ============

# Install Homebrew if not installed

echo "🍺 Checking Homebrew installation..."

if [[ ! -x "$(command -v brew)" ]]; then
  echo "🍺 Homebrew not installed, installing..."

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [[ $? -eq 0 ]]; then
    echo "✅ 🍺 Homebrew installed successfully"
  else
    echo "🍺 Homebrew installation failed, exiting bootstrap"
    exit 1
  fi

else
  echo "✅ 🍺 Homebrew already installed, skipping..."
fi

# Brew: Check your system for potential problems
echo "Checking brew status..."
brew doctor

# Update Homebrew
echo "🍺 Updating Homebrew..."
brew update


## ======== Mac App Store  CLI =========

# A simple command line interface for the Mac App Store. Designed for scripting and automation.
brew install mas



## =========== UTILITIES ============

# cat with highlight
brew install bat

# Display directories as trees (with optional color/HTML output)
brew install tree

# JSON parser and more
brew install jq

# An interactive process viewer
brew install htop

# A smarter cd command.
brew install zoxide

# (not used) Adaptive brightness for external displays
# brew install --cask lunar

# Mouse fix
brew install --cask mac-mouse-fix

# Keyboard customizer
brew install --cask karabiner-elements

# LogiOptions+ for Mx Ergo trackball settings
brew install --cask logi-options+

# BetterDisplay to control brigtness of external monitors
brew install --cask betterdisplay

# DBeaver Community Edition - Universal Database Manager
brew install --cask dbeaver-community

## =========== GIT ============

# Git: Update to latest version
brew install git

# Github CLI
brew install gh



## ============ TERMINAL ============

# Tmux
brew install tmux

# Tmux plugin manager
rm -rf ~/.tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Shell

# BASH:
# Update to latest version
brew install bash

# Bash completion
brew install bash-completion

# To show git branch on terminal
brew install vcprompt

# ZSH:
# zsh is installed by default on MacOS(in /bin/zsh), but it's normally an older version.
# Install zsh by brew to get the latest version. (in /opt/homebrew/bin/zsh (silicon))
brew install zsh

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc

## ============ CLI APPS ==============

# Magnificent app which corrects your previous console command.
brew install thefuck

# A better way to navigate directories
brew install broot


## =========== NODE ============

# Node Version Manager
brew install fnm



## =========== DOCKER ============

# Fast, light, powerful way to run containers.
# ! No need to install docker, compose.
brew install orbstack


## === C++ Development (Optional by flag defined in .env.sh) ===
if [[ "$__DOT__INSTALL_CPP" == true ]]; then
  # Ninja is a small build system with a focus on speed
  brew install ninja

  # Install tools required by clangd Extension for C/C++
  # See: https://clangd.llvm.org/installation

  # Install language server
  brew install llvm

  # To generate compile_commands.json
  brew install bear
else
  echo "🚫 Skipping C++ Development tools installation..."
fi # __DOT__INSTALL_CPP


# Done. Final message
echo "🎉 All apps installed successfully!"