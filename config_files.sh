#!/bin/bash

function info() {
  echo "\n$1"
}

info "CREATING .gitconfig FILE ---------------------------"
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


info "SETUP zsh config files -----------------------------"
cp ./zsh/.zshrc ~/
cp -rf ./zsh/.zsh ~/

info "SETUP .vimrc ---------------------------------------"
cp -rf ./user/.vimrc ~/

#info "MOUSE SCRIPT -------------------------"
#cp -rf ./setup/mouse.sh ~/
