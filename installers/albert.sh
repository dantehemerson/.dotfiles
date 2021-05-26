#!/bin/bash

UBUNTU_VERSION=$(lsb_release -r | awk '{ print $2 }')

echo "deb http://download.opensuse.org/repositories/home:/manuelschneid3r/xUbuntu_${UBUNTU_VERSION}/ /" | sudo tee /etc/apt/sources.list.d/home:manuelschneid3r.list
curl -fsSL https://download.opensuse.org/repositories/home:manuelschneid3r/xUbuntu_${UBUNTU_VERSION}/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_manuelschneid3r.gpg > /dev/null
sudo apt update
sudo apt install albert


## Deprecated: 
# sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/manuelschneid3r/xUbuntu_19.10/ /' > /etc/apt/sources.list.d/home:manuelschneid3r.list"
# wget -nv https://download.opensuse.org/repositories/home:manuelschneid3r/xUbuntu_19.10/Release.key -O Release.key
# sudo apt-key add - < Release.key
# sudo apt-get update
# sudo apt-get install albert
