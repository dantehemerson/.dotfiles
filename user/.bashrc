# Load hombrew bin
if [[ $(uname -m) == "arm64" ]]; then # Apple Silicon
  export PATH="/opt/homebrew/bin:$PATH"
  export PATH="/opt/homebrew/sbin:$PATH"
else
  export PATH="/usr/local/bin:$PATH"
  export PATH="/usr/local/sbin:$PATH"
fi

# Load variables script
source ~/.dotfiles/shell/variables.sh

# Load .shellrc_custom if exists
[ -f ~/.shellrc_custom ] && source ~/.shellrc_custom


# autocd - automatically cd into directories when they are the only argument to a command
shopt -s autocd

# Append to the history file, don't overwrite it
shopt -s histappend


# show potential good files when trying to cd in a non existant dir
shopt -s cdspell

# Increase history to 100x the default (500)
export HISTSIZE=50000
export HISTFILESIZE=10000
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
# export HISTCONTROL=ignoreboth

# 'ignorespace': don't save command lines which begin with a space to history
# 'erasedups' (alternative 'ignoredups'): don't save duplicates to history
# 'autoshare': automatically share history between multiple running shells
export HISTCONTROL=ignorespace:erasedups:autoshare


export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# Load custom aliases and functions
for file in aliases.sh functions.sh bash/aliases.sh bash/functions.sh; do
    [ -r ~/.dotfiles/shell/$file ] && source ~/.dotfiles/shell/$file >/dev/null 2>&1
done



# Execute commands only available if line editing is on. https://superuser.com/a/1361068/983887
if [[ "$(set -o | grep 'emacs\|\bvi\b' | cut -f2 | tr '\n' ':')" != 'off:off:' ]]; then
  # Load .inputrc if it exists
  [ -f ~/.inputrc ] && bind -f ~/.inputrc

  export MY_LOCAL_IP="$(localip)"
fi


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

# ============ NODE VERSION MANAGER ===========
if  [[ -f ~/.local/share/fnm/fnm ]]; then
  export PATH="$HOME/.local/share/fnm:$PATH"
fi

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



# =============== SAVE GIT DIRECTORY =========

REPO_PATH=""
function __save_repo_path_if_found() {
	REPO_PATH=$(git rev-parse --show-toplevel 2>/dev/null) || true
}

function __save_repo_path_on_cd() {
	\cd "$@" || return $?
	__save_repo_path_if_found
}

alias cd="__save_repo_path_on_cd"

__save_repo_path_if_found



# Show git branch in prompt(only when a git repo is present)
function prompt () {
  local exit_code=$?

	# Get status color
  if [ $exit_code -ne 0 ]; then
    status_color=$bldred
  else
    status_color=$blddblue
  fi


	# --------- Get branch --------
  if [[ $(uname) == "Linux" ]]; then
    branch=$(~/.dotfiles/utils/bin/vcprompt -f ' [%b]')
    if [[ "$branch" == ' [(unknown)]' ]]; then
      # Show revision if not on a branch
      branch=$(~/.dotfiles/utils/bin/vcprompt -f ' [%r]')
    fi
  else
    branch=$(vcprompt -f ' [%b]')
    if [[ "$branch" == ' [(unknown)]' ]]; then
      # Show revision if not on a branch
      branch=$(vcprompt -f ' [%r]')
    fi
  fi


	workdir=$PWD

	# Get dir
  if [ -n "$branch" ]; then
		parent_dir="$(dirname "$REPO_PATH")/"

		# Only get path from workdir
		dir=${workdir/"$parent_dir"/""}
	else
		dir=${workdir/"$HOME"/"~"}
  fi


  # Updates current dir and proxy icon in Terminal title ——
  if [ -n "$TMUX" ]; then
    tmux set-option set-titles-string "#{s|$HOME|~|:pane_current_path}  ◄  #{window_index} #{window_name}  —  Terminal"
  fi

  PS1="\[${bldgrn}\]${dir}\[${bldpur}\]\$branch\[${txtrst}\]\$ "

  # Variable IS_VSCODE passed in the terminal profile configuration of VSCode.
  if ! [ "$IS_VSCODE" = "1" ]; then
    PS1="\[${status_color}\]⏺ $PS1"
  fi

  return $exit_code
}

#PROMPT_COMMAND="save_history; prompt;"
PROMPT_COMMAND="prompt;"

# Optional export if go/bin exists
if [ -d "$HOME/go/bin" ] ; then
  export PATH=$PATH:$HOME/go/bin
fi

if [ -d "$HOME/.local/bin" ] ; then
  export PATH=$PATH:$HOME/.local/bin
fi


if [ -d "$HOME/.gvm/scripts" ]; then
	source /Users/d/.gvm/scripts/gvm
fi


if [ -d "$HOME/.goenv" ]; then
	export GOENV_ROOT="$HOME/.goenv"
	export PATH="$GOENV_ROOT/bin:$PATH"

	eval "$(goenv init -)"

	export PATH="$GOROOT/bin:$PATH"
	export PATH="$PATH:$GOPATH/bin"
fi


# Only eval if thefuck command exist:
if command -v thefuck >/dev/null 2>&1; then
  eval "$(thefuck --alias)"
fi
