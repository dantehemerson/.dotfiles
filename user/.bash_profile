source ~/.dotfiles/user/.bashrc

# Added by OrbStack: command-line tools and integration
source ~/.orbstack/shell/init.bash 2>/dev/null || :


[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"
[ -f "$HOME/.atuin/bin/env" ] && . "$HOME/.atuin/bin/env"
