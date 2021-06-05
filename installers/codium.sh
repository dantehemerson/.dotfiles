#!/bin/bash

echo "🔷 Installing Codium"


wget -O codium.deb https://github.com/VSCodium/vscodium/releases/download/1.56.2/codium_1.56.2-1620951495_amd64.deb

sudo dpkg -i codium.deb

echo "🔹 Codium installed correctly"


