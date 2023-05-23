echo "🔷 OS"

echo "🔹 Installing beautiful cursor theme..."
sudo apt-get install breeze-cursor-theme -y

# echo "Installing paper icons theme..."
#sudo add-apt-repository -u ppa:snwh/ppa -y
# wget -q "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xd320d0c30b02e64c5b2bb2743766223989993a70" -O- | sudo apt-key add -
# sudo add-apt-repository "deb http://ppa.launchpad.net/snwh/ppa/ubuntu disco main" -y
# sudo apt install paper-icon-theme -y

# echo "Installing Arc Theme..."
# sudo apt-get install arc-theme -y

echo "🔷 GNOME"

echo "🔹 Installing Gnome Tweaks..." # Not Available in Ubuntu 22.04
sudo apt install gnome-tweak-tool -y

echo "🔹 Installing Gnome SHELL..."
sudo apt install gnome-shell-extensions -y

echo "🔹 Install Gnome SHELL Extension for chrome..."
sudo apt install chrome-gnome-shell -y


# echo "Install Flat Remix theme..."
# sudo add-apt-repository ppa:daniruiz/flat-remix -y
# sudo apt-get update -y
# sudo apt-get install flat-remix-gtk -y
