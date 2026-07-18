#!/bin/bash

source ~/.dotfiles/utils/utils.sh

# Atuint
echo "==> Installing atuin..."
bash <(curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh) --non-interactive
echo "==> Atuin Installed correctly!"

# Tmux Plugin Manager
~/.dotfiles/setup/installers/tpm.sh

# superfile only for ubuntu. (macos and arch are intalled as common packages)
if [[ "$CURRENT_DISTRO" == "ubuntu" ]]; then
  bash -c "$(curl -sLo- https://superfile.dev/install.sh)"
fi
