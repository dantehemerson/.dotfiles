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

## ================ UTILITIES =======================
echo "🔹 Installing screenfetch..."
sudo apt-get install screenfetch -y

echo "Installing dnsutils..."
sudo apt-get install dnsutils

echo "Installing git ..."
sudo apt-get install git -y

echo "Installing dconf-editor"
sudo apt install dconf-editor

echo "Installing xclip ..."
sudo apt-get install xclip -y

echo "Installing curl ..."
sudo apt-get install curl -y

echo "Installing zip and unzip ..."
sudo apt-get install zip -y
sudo apt-get install unzip -y

sudo apt-get install tree -y

sudo apt-get install jq -y

echo "Installing vi and vim"
sudo apt-get install vim -y

echo "Installing robo3t..."
sudo snap install robo3t-snap

echo "Installing teminator..."
sudo apt-get install terminator -y

echo "Installing tmux..."
sudo apt-get install tmux -y

sudo apt-get install fzf -y

## Improvement
sudo apt install bat -y

## Monitoring
sudo snap install bashtop
sudo apt-get install htop -y


# ./installers/ubuntu.sh
# ./installers/autojump.sh

# ./installers/beauty_tmux.sh
# ./installers/albert.sh

# sudo ./installers/postman.sh

# do ./installers/obs.sh -y

# Download wallpapers
# ./installers/download-wallpapers.sh

# Install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# ./installers/zsh.sh

# ./config_files.sh