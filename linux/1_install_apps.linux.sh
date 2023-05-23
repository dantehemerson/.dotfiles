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


## ============= GIT ====================
sudo apt-get install git -y



## ================ UTILITIES =======================
echo "🔹 Installing screenfetch..."
sudo apt-get install screenfetch -y

echo "Installing dnsutils..."
sudo apt-get install dnsutils

echo "Installing dconf-editor"
sudo apt install dconf-editor

echo "Installing xclip ..."
sudo apt-get install xclip -y


echo "Installing zip and unzip ..."
sudo apt-get install zip -y
sudo apt-get install unzip -y

sudo apt-get install tree -y

sudo apt-get install jq -y

echo "Installing teminator..."
sudo apt-get install terminator -y


# Disk Usage/Free Utility
sudo apt install duf


## =============== TMUX ================================

echo "Installing tmux..."
sudo apt-get install tmux -y

# Install tmux plugin manager
if [ -f ~/.tmux/plugins/tpm ]; then
    echo "tmux plugin manager already installed"
else
    echo "Installing tmux plugin manager"
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi



sudo apt-get install fzf -y

## Improvement
sudo apt install bat -y

## Monitoring
sudo snap install bashtop
sudo apt-get install htop -y

# VIM

echo "Installing vi and vim"
sudo apt-get install vim -y

# Install vim-plug
if [ -f ~/.vim/autoload/plug.vim ]; then
    echo "vim-plug already installed"
else
    echo "Installing vim-plug"
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi


## ============ PYTHON 2( for utils/bin/vcprompt ) ===================

sudo apt-get install python2 -y



## ============= SSH ===============

# ssh server
sudo apt-get install openssh-server -y



## ============== NODE VERSION MANAGER ===============

# Check if fnm is installed ~/.local/share/fnm/fnm
if [ -f ~/.local/share/fnm/fnm ]; then
    echo "fnm already installed"
else
    echo "Installing fnm"
    curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell
fi
