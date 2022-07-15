#!/bin/bash

function info() {
  echo "\n$1"
}

info "Adding .gitconfig file..."
cp -n ./user/.gitconfig ~/

info "Config for Albert"
mkdir -p ~/.config/albert
ln -sf "$PWD/config/albert/albert.conf" "$HOME/.config/albert/albert.conf"

info "Terminator"
mkdir -p ~/.config/terminator
ln -sf "$PWD/config/terminator/config" "$HOME/.config/terminator/config"

info "🔤 Adding fonts..."
# Create fonts folder if not exists
mkdir -p ~/.local/share/fonts
ln -sf "$PWD/fonts" "$HOME/.local/share/fonts"

info "⌨️ Adding zsh files..."
ln -sf "$PWD/zsh/.zshrc" "$HOME/.zshrc"
ln -sf "$PWD/zsh/.zsh" "$HOME"


info "Adding .vimrc file..."
ln -sf "$PWD/user/.vimrc" "$HOME/.vimrc"
