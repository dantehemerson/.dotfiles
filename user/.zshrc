# If you come from bash you might have to change your $PATH.

# Load hombrew bin
if [[ $(uname -m) == "arm64" ]]; then # Apple Silicon
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
else
  export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
fi

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="robbyrussell"
ZSH_THEME="apple"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# Not do anything
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Message
# == User configuration ==
# load custom aliases and functions
for file in aliases.sh functions.sh zsh/functions.sh; do
    [ -r ~/.dotfiles/shell/$file ] && source ~/.dotfiles/shell/$file >/dev/null 2>&1
done

# # Add date to the right
# RPROMPT="%*"

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Link scripts folder
export SCRIPTS=~/.local/bin/scripts
mkdir -p "$SCRIPTS" &>/dev/null
export PATH="$SCRIPTS:$PATH"

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Move files to trashcurl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.1/install.sh | bash

# Sign commits
# export GPG_TTY=$(tty)

# NVM(Deprecated): Migrated to fnm
# # This loads nvm
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Custom Configuration Shell
# Load .shellrc_custom if exists
[ -f ~/.shellrc_custom ] && source ~/.shellrc_custom

# FNM
eval "$(fnm env --use-on-cd --shell zsh)"

## Rust
# Load cargo
# export PATH=/home/dantehemerson/.cargo/bin:$PATH


# PROMPT="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"
# PROMPT+='%{$fg[cyan]%}%~%{$reset_color%} $(git_prompt_info)'

zstyle ':completion:*' ignored-patterns 'RANDOM'

# Created by `pipx` on 2025-08-12 01:48:23
export PATH="$PATH:/Users/d/.local/bin"

export BLUEUTIL_USE_SYSTEM_PROFILER=1

function re_pair() {
  id=`blueutil --paired | grep "trackpad" | grep -Eo '[a-z0-9]{2}(-[a-z0-9]{2}){5}'`
  name=`blueutil --paired | grep "trackpad" | grep -Eo 'name: "\S+"'`
  echo "unpairing with BT device $id, $name"
  blueutil --unpair "$id"
  echo "unpaired, waiting a few seconds for trackpad to go to pairable state"
  sleep 3
  echo "pairing with BT device $id, $name"
  blueutil --pair "$id" "0000"
  echo "paired"
  blueutil --connect "$id"
  echo "connected"
}
