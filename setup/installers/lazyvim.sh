#!/usr/bin/env bash

# Check if LazyVim is already installed
if [ -f "$HOME/.config/nvim/lua/config/lazy.lua" ]; then
    echo "LazyVim is already installed (lazy.lua found)"
    exit 0
fi

# Instructions from:
# https://www.lazyvim.org/installation

# required
mv ~/.config/nvim{,.bak}

# optional but recommended
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}

git clone https://github.com/LazyVim/starter ~/.config/nvim

rm -rf ~/.config/nvim/.git
