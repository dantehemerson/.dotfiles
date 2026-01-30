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

### Arch Linux

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
