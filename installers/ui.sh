echo "UI ------------------------------------"

echo "Installing beautiful cursor theme..."
sudo apt-get install breeze-cursor-theme -y

echo "Installing paper icons theme..."
sudo add-apt-repository -u ppa:snwh/ppa -y
sudo apt install paper-icon-theme -y

echo "Installing Arc Theme..."
sudo apt-get install arc-theme -y

echo "Installing Gnome SHELL..."
sudo apt install gnome-shell-extensions -y

echo "Install extension for chrome..."
sudo apt install chrome-gnome-shell -y

echo "Install Flat Remix theme..."
sudo add-apt-repository ppa:daniruiz/flat-remix -y
sudo apt-get update -y
sudo apt-get install flat-remix-gtk -y
