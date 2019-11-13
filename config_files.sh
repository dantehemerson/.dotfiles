echo "CREATING .gitconfig FILE ---------------------------"
cp ./user/.gitconfig ~/

echo "SETUP zsh config files -----------------------------"
cp ./zsh/.zshrc ~/
cp -rf ./zsh/.zsh ~/

# echo "SETUP .vimrc ---------------------------------------"
# cp ./user/.vimrc ~/