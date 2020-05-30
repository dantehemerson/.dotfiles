echo "CREATING .gitconfig FILE ---------------------------"
cp ./user/.gitconfig ~/

echo "Creating config for albert"
cp -rf ./.config/albert/albert.conf ~/.config/albert/

echo "Creating config terminator"
cp -rf ./.config/terminator/config ~/.config/terminator/

echo "SETUP zsh config files -----------------------------"
cp ./zsh/.zshrc ~/
cp -rf ./zsh/.zsh ~/

echo "SETUP .vimrc ---------------------------------------"
cp -rf ./user/.vimrc ~/

echo "MOUSE SCRIPT -------------------------"
cp -rf ./setup/mouse.sh ~/