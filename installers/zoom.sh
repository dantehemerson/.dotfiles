#!/bin/bash

echo "🔷 Installing Zoom"

sudo apt remove zoom -y

wget https://zoom.us/client/latest/zoom_amd64.deb

sudo dpkg -i zoom_amd64.deb

echo "🔹 Zoom installed correctly"


