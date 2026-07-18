# :penguin: Dante's dotfiles:rocket:

## Installation

###  MacOS

```sh
curl -fsSL https://raw.githubusercontent.com/dantehemerson/.dotfiles/master/install.sh | bash
```

If you didn't have the `xcode-select` installed, it will prompt ask you to install.
It will skip dotfiles installation process as it is required.

After installed, you will need to run the script again:

```sh
curl -fsSL https://raw.githubusercontent.com/dantehemerson/.dotfiles/master/install.sh | bash
```

> [!IMPORTANT]
> You will need to be prompted by password twice, before running installer and before intalling `karabiner-elements`.
> This is because they require su privileges to install.
> After that you can relax and let the script run.


### Arch Linux

**Flavours Tested**:
* CachyOS

```
sudo pacman -Sy --noconfirm git curl sudo base-devel && curl -fsSL https://raw.githubusercontent.com/dantehemerson/.dotfiles/master/install.sh | bash
```

## Configuring custom options

You can configure custom options for your environment by creating a file called `.env.sh` in the root of the project. This file is ignored by git and will not be commited.

## Change shell Manually

If you want to change your shell to zsh, you can do it manually by running the following command:

```bash
# In Apple Intel
chsh -s /usr/local/bin/zsh

# or in Apple Silicon
chsh -s /opt/homebrew/bin/zsh
```

## Post-install steps

A few things aren't done automatically and need to be run manually after the install completes.

### Docker: run `docker` without sudo

After the install, only `root` can talk to the Docker daemon by default. To run `docker` as your normal user, run the helper once:

```sh
~/.dotfiles/setup/scripts/create-user-docker.sh
```

Then **log out and log back in** (or run `newgrp docker` in your current shell) for the group change to take effect. Verify with:

```sh
docker run hello-world
```

> [!NOTE]
> This isn't run automatically because in CI (where the docker socket is bind-mounted from the host) modifying the socket's ownership breaks GitHub Actions' post-job cleanup. Running it manually keeps the install flow predictable across environments.
