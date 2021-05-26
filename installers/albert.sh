#!/bin/bash

echo "🔷 Albert Launcher"

echo "🔹 Installing Albert Laucher..."

UBUNTU_VERSION=$(lsb_release -r | awk '{ print $2 }')

echo "deb http://download.opensuse.org/repositories/home:/manuelschneid3r/xUbuntu_${UBUNTU_VERSION}/ /" | sudo tee /etc/apt/sources.list.d/home:manuelschneid3r.list
curl -fsSL https://download.opensuse.org/repositories/home:manuelschneid3r/xUbuntu_${UBUNTU_VERSION}/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_manuelschneid3r.gpg > /dev/null
sudo apt update
sudo apt install albert