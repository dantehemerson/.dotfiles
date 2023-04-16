#!/bin/bash

echo "🔷 Postman"

echo "🔹 Downloading latest release..."
wget -O postman-latest.tar.gz "https://dl.pstmn.io/download/latest/linux64"

sudo rm -rf /opt/Postman/
sudo tar xvf postman-latest.tar.gz -C /opt/

sudo ln -sf /opt/Postman/app/Postman /usr/bin/postman

touch ~/.local/share/applications/postman.desktop
cat > ~/.local/share/applications/postman.desktop << EOF
[Desktop Entry]
Encoding=UTF-8
Name=Postman
Exec=/usr/bin/postman
Icon=/opt/Postman/app/resources/app/assets/icon.png
Terminal=false
Type=Application
Categories=Development;
EOF

rm postman-latest.tar.gz

echo "🔹 Postman updated/installed successfully"