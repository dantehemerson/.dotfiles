# :penguin: Dante Calderón dotfiles:rocket:

Work less and be more productive

This dotfiles includes configuration for:

- [Zsh + Oh My Zsh](https://github.com/ohmyzsh/ohmyzsh)
- Vim
- TMUX
- Node
- Solarized Terminal


## Installation


### Arch Linux

```
```
sudo pacman -Sy --noconfirm git curl sudo base-devel \
  && curl -fsSL https://raw.githubusercontent.com/dantehemerson/.dotfiles/master/install.sh | bash
```
```


### Configuring custom options

You can configure custom options for your environment by creating a file called `.env.sh` in the root of the project. This file is ignored by git and will not be commited.



## Change shell Manually

If you want to change your shell to zsh, you can do it manually by running the following command:

```bash
# In Apple Intel
chsh -s /usr/local/bin/zsh

# or in Apple Silicon
chsh -s /opt/homebrew/bin/zsh
``` 
