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

echo 'Updating repositories ...'
sudo apt-get update -y
sudo apt-get upgrade -y

# dig
sudo apt-get install dnsutils

echo "Installing git ..."
sudo apt-get install git -y

echo "Installing xclip ..."
sudo apt-get install xclip -y

echo "Installing curl ..."
sudo apt-get install curl -y

echo "Installing zip and unzip ..."
sudo apt-get install zip -y
sudo apt-get install unzip -y


echo "Installing Ruby ..."
sudo apt-get install ruby -y
sudo apt-get install ruby-dev -y

echo "Installing LaTex, This will take a long time ..."
sudo apt-get install texlive-full -y
echo "Installing Texmaker, This will take a long time ..."
sudo apt-get install texmaker -y
