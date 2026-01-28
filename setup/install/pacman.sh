source ~/.dotfiles/utils/utils.sh

packages=()
load_packages "$HOME/.dotfiles/common/common.packages" packages
printf "=> Installing common packages:\n"
for pkg_cmd in "${packages[@]}"; do
    printf "\t- %s\n" "$pkg_cmd"
    sudo pacman -S --noconfirm --needed $pkg_cmd
done

if [ -f "$HOME/.dotfiles/setup/packages/arch.packages" ]; then
    arch_packages=()
    load_packages "$HOME/.dotfiles/setup/packages/arch.packages" arch_packages
    printf "=> Installing arch packages:\n"
    for pkg_cmd in "${arch_packages[@]}"; do
        printf "\t- %s\n" "$pkg_cmd"
        sudo pacman -S --noconfirm --needed $pkg_cmd
    done
fi
