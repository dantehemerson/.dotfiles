# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# Global environment variables
source ~/.dotfiles/shell/envs.sh

# Load hombrew bin
if [[ $(uname -m) == "arm64" ]]; then # Apple Silicon
  export PATH="/opt/homebrew/bin:$PATH"
  export PATH="/opt/homebrew/sbin:$PATH"
else
  export PATH="/usr/local/bin:$PATH"
  export PATH="/usr/local/sbin:$PATH"
fi

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
for file in env.sh init.sh aliases.sh functions.sh bash/aliases.sh bash/functions.sh; do
  [ -r ~/.dotfiles/shell/$file ] && source ~/.dotfiles/shell/$file >/dev/null 2>&1
done

# Execute commands only available if line editing is on. https://superuser.com/a/1361068/983887
if [[ "$(set -o | grep 'emacs\|\bvi\b' | cut -f2 | tr '\n' ':')" != 'off:off:' ]]; then
  # Load .inputrc if it exists
  [ -f ~/.inputrc ] && bind -f ~/.inputrc
fi

# Bash completion
if [[ $(uname -m) == "arm64" ]]; then # Apple Silicon
  [[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"
else # Intel
  [[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
fi

# ============ NODE VERSION MANAGER ===========
if [[ -f ~/.local/share/fnm/fnm ]]; then
  export PATH="$HOME/.local/share/fnm:$PATH"

  # fnm: node version manager
  eval "$(fnm env --use-on-cd)"
fi

# This fixes issue installing Postman Bridge interceptor since node not found
if [ -z "$FNM_MULTISHELL_PATH" ]; then
  export PATH="$FNM_MULTISHELL_PATH/bin:$PATH"
fi

#  ============= PROMPT ===========
prompt_hook() {
  local exit_status=$?

  # tmux window title
  if [[ -n "$TMUX" ]]; then
    tmux set-option -w set-titles-string \
      "#{s|$HOME|~|:pane_current_path} - [ #{window_index} #{window_name} ] - Terminator"
  fi

  # history sync
  history -a
  history -c
  history -r

  return $exit_status
}

if [ -d "$HOME/.local/bin" ]; then
  export PATH=$PATH:$HOME/.local/bin
fi

# pnpm
export PNPM_HOME="/Users/d/Library/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

PROMPT_COMMAND="prompt_hook${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

. "$HOME/.atuin/bin/env"

[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh
eval "$(atuin init bash)"
