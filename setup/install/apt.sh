source ~/.dotfiles/utils/utils.sh

sudo apt-get update

common_packages=""
load_packages "$HOME/.dotfiles/common/common.packages" common_packages
printf "=> Installing common packages:\n"
printf "\t- %s\n" $common_packages
sudo apt-get install -y $common_packages
