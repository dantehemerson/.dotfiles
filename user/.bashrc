export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"

# autocd - automatically cd into directories when they are the only argument to a command
shopt -s autocd

# Append to the history file, don't overwrite it
shopt -s histappend

# Increase history size
export HISTSIZE=5000
export HISTFILESIZE=10000


export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# Load custom aliases and functions
for file in aliases.sh functions.sh bash/aliases.sh bash/functions.sh; do
    [ -r ~/.dotfiles/shell/$file ] && source ~/.dotfiles/shell/$file >/dev/null 2>&1
done


# Bash completion
[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"


# Supports history search using up and down arrows
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\eOA": history-search-backward'
bind '"\eOB": history-search-forward'

# Colors for prompt
txtred='\e[0;31m' # Red
txtgrn='\e[0;32m' # Green

bldred='\e[1;31m' # Bold Red
bldgrn='\e[1;32m' # Bold Green
bldpur='\e[1;35m' # Bold Purple
bldcya='\e[1;36m' # Bold Cyan
bldblue='\e[1;34m' # Bold Blue
bldsky='\e[1;38;5;117m' # Bold Sky Blue
blddblue='\e[1;38;5;33m' # Bold Dark Blue
blddsky='\e[1;38;5;45m' # Bold Dark Sky Blue

txtrst='\e[0m'    # Text Reset
bld='\e[1m'       # Bold

# GIT


# Save history without affecting the exist status
# to be captured in the prompt
function save_history {
  local exit_status=$?
  history -a; history -c; history -r
  return $exit_status
}

# # Show git branch in prompt(only when a git repo is present)
function prompt () {
  local exit_code=$?

  dir=$PWD
  home=$HOME
  dir=${dir/"$HOME"/"~"}

  if [ $exit_code -ne 0 ]; then
    status_color=$bldred
  else
    status_color=$blddblue
  fi
  
  # Avoid displaying exit status in VSCode terminal, since it as it's own status indicator.
  # Variable IS_VSCODE passed in the terminal profile configuration of VSCode.
  if [ "$IS_VSCODE" = "1" ]; then
    PS1="${bldgrn}${dir} ${bldpur}$(vcprompt -f '[%b]')${txtrst}$ "
  else
    PS1="${status_color}• ${bldgrn}${dir} ${bldpur}$(vcprompt -f '[%b]')${txtrst}$ "
  fi 
}

PROMPT_COMMAND="save_history; prompt;"
