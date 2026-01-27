#!/bin/bash

echo "       ______      _    __ _ _                   "
echo "       |  _  \    | |  / _(_) |                  "
echo "       | | | |___ | |_| |_ _| | ___  ___         "
echo "       | | | / _ \| __|  _| | |/ _ \/ __|        "
echo "       | |/ / (_) | |_| | | | |  __/\__ \        "
echo "       |___/ \___/ \__|_| |_|_|\___||___/        "
echo "                                                 "
echo "              ❤ Dante's dotfiles ❤              "
echo "                 @dantehemerson                  "
echo ""

## ============ UPDATE SYSTEM =========================
echo 'Updating repositories ...'

sudo apt-get update -y
sudo apt-get upgrade -y

## ============== ESSENTIALS =========================
sudo apt install build-essential -y

sudo apt install net-tools -y

sudo apt-get install curl -y

## ================ UTILITIES =======================
echo "🔹 Installing screenfetch..."
sudo apt-get install screenfetch -y

echo "Installing xclip ..."
sudo apt-get install xclip -y

# File manager
bash -c "$(curl -sLo- https://superfile.dev/install.sh)"

# Install tmux plugin manager
if [ -f ~/.tmux/plugins/tpm ]; then
  echo "tmux plugin manager already installed"
else
  echo "Installing tmux plugin manager"
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Install vim-plug
if [ -f ~/.vim/autoload/plug.vim ]; then
  echo "vim-plug already installed"
else
  echo "Installing vim-plug"
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# ssh server
sudo apt-get install openssh-server -y

## =========== DOCKER ==============

# docker gui
curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash

## ============== NODE VERSION MANAGER ===============

# Check if fnm is installed ~/.local/share/fnm/fnm
if [ -f ~/.local/share/fnm/fnm ]; then
  echo "fnm already installed"
else
  echo "Installing fnm"
  curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell
fi
