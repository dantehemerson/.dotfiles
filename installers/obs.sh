
#!/bin/bash

echo "🔷 Installing OBS..."

# yes | sudo apt install ffmpeg

sudo add-apt-repository ppa:obsproject/obs-studio

sudo apt update -y
sudo apt install obs-studio -y

echo "🔹 OBS installed correctly"

