# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantlycurl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
# alias p='python'
#
source ~/.dotfiles/user/.bashrc

export PATH="$HOME/.local/bin:$PATH"

# pnpm
export PNPM_HOME="/home/randalph/.local/share/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm endcurl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh

# Load custom aliases and functionscurl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
for file in aliases.sh functions.sh bash/aliases.sh bash/functions.sh; do
  [ -r ~/.dotfiles/shell/$file ] && source ~/.dotfiles/shell/$file >/dev/null 2>&1
done
