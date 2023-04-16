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

# JSON parser and more
brew install jq



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



## =========== NODE ============

# Node Version Manager
brew install fnm

 

## =========== DOCKER ============

# Docker and docker-compose
brew install docker
brew install docker-compose

# Colima helps me to manage docker easly
brew install colima



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
