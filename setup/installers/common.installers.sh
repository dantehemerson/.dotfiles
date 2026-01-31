#!/bin/bash

# Atuint
echo -e "==> Installing atuin..."
bash <(curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh)
echo -e "==> Atuin Installed correctly!"

# Tmux Plugin Manager
~/.dotfiles/setup/installers/tpm.sh
