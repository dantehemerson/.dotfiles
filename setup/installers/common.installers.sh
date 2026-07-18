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

  # opencode (--no-modify-path: shell PATH is managed by the dotfiles)
  curl -fsSL https://opencode.ai/install | bash -s -- --no-modify-path

  # If opencode is also installed via the .deb package, it ships as
  # /usr/bin/opencode-cli with no `opencode` symlink. Create one if missing so
  # `command -v opencode` works regardless of how opencode was installed.
  # https://github.com/anomalyco/opencode/issues — the .deb package has no
  # postinst to create the symlink, so we do it here.
  if [[ -x /usr/bin/opencode-cli ]] && [[ ! -e /usr/bin/opencode ]]; then
    sudo ln -s /usr/bin/opencode-cli /usr/bin/opencode
  fi


  # - - - - - Docker - - - - - -
  # Add Docker's official GPG key:
  sudo apt update
  sudo apt install ca-certificates curl
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

  sudo apt update

  sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

fi
