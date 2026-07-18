#!/bin/bash

source ~/.dotfiles/utils/utils.sh

# Atuint
echo "==> Installing atuin..."
bash <(curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh) --non-interactive
echo "==> Atuin Installed correctly!"

# Tmux Plugin Manager
~/.dotfiles/setup/installers/tpm.sh

if [[ "$CURRENT_DISTRO" == "ubuntu" ]]; then
  # superfile only for ubuntu. (macos and arch are intalled as common packages)
  bash -c "$(curl -sLo- https://superfile.dev/install.sh)"

  # zed only for ubuntu. (macos and arch are intalled as common packages)
  curl -f https://zed.dev/install.sh | sh

  # mise only for ubuntu. (macos and arch are intalled as common packages)
  sudo apt install -y extrepo
  sudo extrepo enable mise
  sudo apt update
  sudo apt install -y mise

  # opencode
  curl -fsSL https://opencode.ai/install | bash
fi
