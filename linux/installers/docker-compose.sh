#!/bin/bash

echo "🔷 Installing Docker-Compose"

echo "🔹 Downloading latest release..."
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

echo "🔹 Docker-Compose installed correctly"