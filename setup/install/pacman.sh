source ~/.dotfiles/utils/utils.sh

packages=""
load_packages "$HOME/.dotfiles/common/common.packages" packages
printf "=> Installing common packages:\n"
printf "\t- %s\n" $packages
sudo pacman -S --noconfirm --needed $packages

packages=""
load_packages "$HOME/.dotfiles/setup/packages/arch.packages" packages
printf "=> Installing arch packages:\n"
printf "\t- %s\n" $packages
sudo pacman -S --noconfirm --needed $packages
