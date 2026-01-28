source ~/.dotfiles/utils/utils.sh

packages=()
load_packages "$HOME/.dotfiles/setup/packages/arch.yay.packages" packages
printf "=> Installing common yay packages:\n"
printf "\t- %s\n" "${packages[@]}"
for pkg_cmd in "${packages[@]}"; do
  yay -S --noconfirm $pkg_cmd
done
