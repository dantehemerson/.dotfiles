# Load hombrew bin
if [[ $(uname -m) == "arm64" ]]; then # Apple Silicon
  export PATH="/opt/homebrew/bin:$PATH"
  export PATH="/opt/homebrew/sbin:$PATH"
else
  export PATH="/usr/local/bin:$PATH"
  export PATH="/usr/local/sbin:$PATH"
fi

# Load .inputrc if it exists
[ -f ~/.inputrc ] && bind -f ~/.inputrc

# autocd - automatically cd into directories when they are the only argument to a command
shopt -s autocd

# Append to the history file, don't overwrite it
shopt -s histappend


# show potential good files when trying to cd in a non existant dir
shopt -s cdspell

# Increase history size
export HISTSIZE=5000
export HISTFILESIZE=10000
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
export HISTCONTROL=ignoreboth


export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# Load custom aliases and functions
for file in aliases.sh functions.sh bash/aliases.sh bash/functions.sh; do
    [ -r ~/.dotfiles/shell/$file ] && source ~/.dotfiles/shell/$file >/dev/null 2>&1
done


# Bash completion

if [[ $(uname -m) == "arm64" ]]; then # Apple Silicon
  [[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"
else # Intel
  [[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
fi



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


# FNM: Node version manager
eval "$(fnm env --use-on-cd)"

# This fixes issue installing Postman Bridge interceptor since node not found
if [ -z "$FNM_MULTISHELL_PATH" ]; then
  export PATH="$FNM_MULTISHELL_PATH/bin:$PATH"
fi

#  ============= PROMPT ===========

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

  branch=$(vcprompt -f ' [%b]')
  if [[ "$branch" == ' [(unknown)]' ]]; then
    # Show revision if not on a branch
    branch=$(vcprompt -f ' [%r]')
  fi

  if [ -n "$branch" ]; then
    dir=$(basename "$dir")
  fi


  # Updates current dir and proxy icon in Terminal title ——
  if [ -n "$TMUX" ]; then
    tmux set-option set-titles-string "#{s|$HOME|~|:pane_current_path}  ◄  #{window_index} #{window_name}  —  Terminal"
  fi

  # Variable IS_VSCODE passed in the terminal profile configuration of VSCode.
  if [ "$IS_VSCODE" = "1" ]; then
    PS1="\[${bldgrn}\]${dir}\[${bldpur}\]\$branch\[${txtrst}\]\$ "
  else
    PS1="\[${status_color}\]⏺ \[${bldgrn}\]${dir}\[${bldpur}\]\$branch\[${txtrst}\]\$ "
  fi 
}

#PROMPT_COMMAND="save_history; prompt;"
PROMPT_COMMAND="prompt;"


# Show current directory in Terminal title(no tmux)
# Disabled(makes conflict in tmux)
# if [ -z "$TMUX" ]; then
#   echo 'Putting right'
#   update_terminal_cwd() {
#     local exit_code=$?

#     if [ -n "$TMUX" ]; then
#       echo "tmux"
#       return $exit_code
#     fi
#     echo "sin tmux"

#     # Identify the directory using a "file:" scheme URL, including
#     # the host name to disambiguate local vs. remote paths.

#     # Percent-encode the pathname.
#     local url_path=''

#     {
#         # Use LC_CTYPE=C to process text byte-by-byte and
#         # LC_COLLATE=C to compare byte-for-byte. Ensure that
#         # LC_ALL and LANG are not set so they don't interfere.
#         local i ch hexch LC_CTYPE=C LC_COLLATE=C LC_ALL= LANG=
#         for ((i = 0; i < ${#PWD}; ++i)); do
#       ch="${PWD:i:1}"
#       if [[ "$ch" =~ [/._~A-Za-z0-9-] ]]; then
#           url_path+="$ch"
#       else
#           printf -v hexch "%02X" "'$ch"
#           # printf treats values greater than 127 as
#           # negative and pads with "FF", so truncate.
#           url_path+="%${hexch: -2:2}"
#       fi
#         done
#     }

#     printf '\e]7;%s\a' "file://$HOSTNAME$url_path"

#     return $exit_code
#   }

#   PROMPT_COMMAND="update_terminal_cwd${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
# fi



_cd_completion() {
    mapfile -t COMPREPLY < <(ls -d * | grep "${COMP_WORDS[COMP_CWORD]}")
}
# complete -F _cd_completion cd
