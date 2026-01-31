#!/bin/bash

# Atuint
echo "==> Installing atuin..."
bash <(curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh)
echo "==> Atuin Installed correctly!"

# Tmux Plugin Manager
~/.dotfiles/setup/installers/tpm.sh
