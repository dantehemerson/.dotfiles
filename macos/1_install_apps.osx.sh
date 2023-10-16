#!/bin/bash

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
brew doctor

# Update Homebrew
echo "🍺 Updating Homebrew..."
brew update



## =========== UTILITIES ============

# cat with highlight
brew install bat

# Render markdown on the CLI, with pizzazz!
brew install glow

# Display directories as trees (with optional color/HTML output)
brew install tree

# JSON parser and more
brew install jq

# (not used) Adaptive brightness for external displays
# brew install --cask lunar

# Mouse fix
brew install --cask mouse-fix

# Clipboard manager with advanced features
brew install --cask copyq

# Keyboard customizer
brew install --cask karabiner-elements



## =========== AUDIO INPUT/OUTPUT ============

# A command-line utility to switch the audio source on Mac OS X
brew install switchaudio-osx



## =========== GIT ============

# Git: Update to latest version
brew install git

# Delta is a viewer for git and diff output
brew install git-delta

# Github CLI
brew install gh



## ============ TERMINAL ============

# Tmux
brew install tmux

# Tmux plugin manager
rm -rf ~/.tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm


## ============ CLI APPS ==============

# A simple and extensible shell script for managing your todo.txt file.
brew install todo-txt

# Magnificent app which corrects your previous console command.
brew install thefuck

# A better way to navigate directories
brew install broot


## =========== NODE ============

# Node Version Manager
brew install fnm



## =========== DOCKER ============

# Docker and docker-compose
brew install docker
brew install docker-compose

# Colima helps me to manage docker easly
brew install colima



## ============ BASH =============

# Update to latest version
brew install bash

# Bash completion
brew install bash-completion

# To show git branch on terminal
brew install vcprompt



## =========== C++ ============

# Ninja is a small build system with a focus on speed
brew install ninja



## =========== VSCODE ============

# --- Install tools required by clangd Extension for C/C++ ---
# See: https://clangd.llvm.org/installation

# Install language server
brew install llvm

# To generate compile_commands.json
brew install bear
