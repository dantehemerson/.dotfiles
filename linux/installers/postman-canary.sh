#!/bin/bash

echo "🔷 Postman Canary"

echo "🔹 Downloading latest release..."
wget -O postman-canary-latest.tar.gz "https://dl.pstmn.io/download/channel/canary/linux64"

sudo rm -rf /opt/PostmanCanary/
sudo tar xvf postman-canary-latest.tar.gz -C /opt/

sudo ln -sf /opt/PostmanCanary/app/PostmanCanary /usr/bin/postman_canary

touch ~/.local/share/applications/postman_canary.desktop
cat > ~/.local/share/applications/postman_canary.desktop << EOF
[Desktop Entry]
Encoding=UTF-8
Name=PostmanCanary
Exec=/usr/bin/postman_canary
Icon=/opt/PostmanCanary/app/resources/app/assets/icon.png
Terminal=false
Type=Application
Categories=Development;
EOF

rm postman-canary-latest.tar.gz

echo "🔹 Postman Canary updated/installed successfully"
