source ~/.dotfiles/utils/utils.sh

common_packages=()
load_packages "$HOME/.dotfiles/common/common.packages" common_packages
printf "=> Installing common packages:\n"
for pkg_cmd in "${common_packages[@]}"; do
    printf "\t- %s\n" "$pkg_cmd"
    brew install $pkg_cmd
done

macos_packages=()
load_packages "$HOME/.dotfiles/setup/packages/macos.packages" macos_packages
printf "=> Installing macos packages:\n"
for pkg_cmd in "${macos_packages[@]}"; do
    printf "\t- %s\n" "$pkg_cmd"
    brew install $pkg_cmd
done
