source ~/.dotfiles/utils/utils.sh

common_packages=""
load_packages "$HOME/.dotfiles/common/common.packages" common_packages
printf "=> Installing common packages:\n"
printf "\t- %s\n" $common_packages
brew install $common_packages

macos_packages=""
load_packages "$HOME/.dotfiles/setup/packages/macos.packages" macos_packages
printf "=> Installing macos packages:\n"
printf "\t- %s\n" $macos_packages
brew install $macos_packages
