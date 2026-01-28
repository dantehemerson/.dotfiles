source ~/.dotfiles/utils/utils.sh

packages=()
load_packages "$HOME/.dotfiles/common/common.packages" packages
printf "=> Installing common packages:\n"
printf "\t- %s\n" "${packages[@]}"
for pkg_cmd in "${packages[@]}"; do
    sudo pacman -S --noconfirm --needed $pkg_cmd
done

if [ -f "$HOME/.dotfiles/setup/packages/arch.packages" ]; then
    arch_packages=()
    load_packages "$HOME/.dotfiles/setup/packages/arch.packages" arch_packages
    printf "=> Installing arch packages:\n"
    printf "\t- %s\n" "${arch_packages[@]}"
    for pkg_cmd in "${arch_packages[@]}"; do
        sudo pacman -S --noconfirm --needed $pkg_cmd
    done
fi
