source ~/.dotfiles/utils/utils.sh

sudo apt-get update

common_packages=()
distro_packages=()

load_packages "$HOME/.dotfiles/common/common.packages" common_packages
printf "=> Installing common packages:\n"
for pkg_cmd in "${common_packages[@]}"; do
    printf "\t- %s\n" "$pkg_cmd"
    sudo apt-get install -y $pkg_cmd
done

if [ -f "$HOME/.dotfiles/setup/packages/debian.packages" ]; then
    load_packages "$HOME/.dotfiles/setup/packages/debian.packages" distro_packages
    printf "=> Installing debian packages:\n"
    for pkg_cmd in "${distro_packages[@]}"; do
        printf "\t- %s\n" "$pkg_cmd"
        sudo apt-get install -y $pkg_cmd
    done
fi

if [ -f "$HOME/.dotfiles/setup/packages/ubuntu.packages" ]; then
    load_packages "$HOME/.dotfiles/setup/packages/ubuntu.packages" distro_packages
    printf "=> Installing ubuntu packages:\n"
    for pkg_cmd in "${distro_packages[@]}"; do
        printf "\t- %s\n" "$pkg_cmd"
        sudo apt-get install -y $pkg_cmd
    done
fi
