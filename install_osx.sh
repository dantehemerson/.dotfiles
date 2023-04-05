# == Link shell config
# ZSH
ln -sf "$PWD/.shell" "$HOME"

mv -f "$HOME/.zshrc" "$HOME/.zshrc.backup"

ln -sf "$PWD/.shell/.zshrc" "$HOME/.zshrc"

