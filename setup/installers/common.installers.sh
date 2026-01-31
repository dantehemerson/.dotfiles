#!/bin/bash

# Atuin
echo -e "==> Installing atuin..."
curl --proto '=https' --tlsv1.2 -LsSf htts://setup.atuin.sh | sh
echo -e "==> Atuin Installed correctly!"

# Tmux Plugin Manager
~/.dotfiles/setup/installers/tpm.sh
