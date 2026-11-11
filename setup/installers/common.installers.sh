#!/bin/bash

source ~/.dotfiles/utils/utils.sh

# Downloads a remote installer to a temporary file and runs it.
#
# Piping straight into a shell (`curl ... | bash`) hides download failures: the
# shell happily executes an empty script, reports success and the dependency is
# never installed. Downloading first lets us check both exit statuses and fail
# loudly instead of producing a broken environment.
#
# Usage: run_remote_installer <url> <interpreter> [args...]
run_remote_installer() {
  local url="$1"
  local interpreter="$2"
  shift 2

  local script status
  script="$(mktemp)"

  if ! curl --proto '=https' --tlsv1.2 -fsSL \
    --connect-timeout 30 --max-time 300 \
    --retry 5 --retry-delay 3 --retry-all-errors \
    -o "$script" "$url"; then
    rm -f "$script"
    echo "❌ Failed to download $url" >&2
    return 1
  fi

  "$interpreter" "$script" "$@"
  status=$?
  rm -f "$script"

  if [[ $status -ne 0 ]]; then
    echo "❌ Installer from $url failed (exit $status)" >&2
    return "$status"
  fi
}

# Atuin
echo "==> Installing atuin..."
if ! run_remote_installer https://setup.atuin.sh bash --non-interactive; then
  # setup.atuin.sh is a small redirector that has returned transient 5xx
  # errors. The release installer below is the same binary install it uses,
  # minus the shell hook setup (the dotfiles already wire atuin into the shell).
  echo "==> setup.atuin.sh failed, trying the atuin release installer..."
  if ! run_remote_installer \
    https://github.com/atuinsh/atuin/releases/latest/download/atuin-installer.sh sh; then
    echo "❌ Failed to install atuin" >&2
    exit 1
  fi
fi
if ! command -v atuin >/dev/null 2>&1 && [[ ! -x "$HOME/.atuin/bin/atuin" ]]; then
  echo "❌ atuin is not installed after running the installer" >&2
  exit 1
fi
echo "==> Atuin Installed correctly!"

# Tmux Plugin Manager
~/.dotfiles/setup/installers/tpm.sh

if [[ "$CURRENT_DISTRO" == "ubuntu" ]]; then
  # superfile only for ubuntu. (macos and arch are intalled as common packages)
  run_remote_installer https://superfile.dev/install.sh bash

  # zed only for ubuntu. (macos and arch are intalled as common packages)
  run_remote_installer https://zed.dev/install.sh sh

  # mise only for ubuntu. (macos and arch are intalled as common packages)
  sudo apt install -y extrepo
  sudo extrepo enable mise
  sudo apt update
  sudo apt install -y mise

  # opencode (--no-modify-path: shell PATH is managed by the dotfiles)
  run_remote_installer https://opencode.ai/install bash --no-modify-path

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
  sudo apt install -y ca-certificates curl
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

  sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

fi
