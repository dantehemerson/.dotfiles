#!/bin/bash

function info() {
  echo "\n$1"
}

info "Adding .gitconfig file..."
cp ./user/.gitconfig ~/

info "Creating config for albert"
cp -rf ./config/albert/albert.conf ~/.config/albert/

info "Creating config terminator"
cp -rf ./config/terminator/config ~/.config/terminator/


info "🔤 Adding fonts..."
# Create fonts folder if not exists
mkdir -p ~/.fonts
# Add fonts
mv ./fonts/* ~/.fonts


info "🖼️ Adding wallpapers..."
# Create fonts folder if not exists
mkdir -p ~/Pictures/wallpapers
# Add wallpapers
mv ./wallpapers/* ~/Pictures/wallpapers


info "⌨️ Adding zsh files..."
cp ./zsh/.zshrc ~/
cp -rf ./zsh/.zsh ~/


info "✏️ Adding .vimrc file..."
cp -rf ./user/.vimrc ~/

#info "MOUSE SCRIPT -------------------------"
#cp -rf ./setup/mouse.sh ~/
