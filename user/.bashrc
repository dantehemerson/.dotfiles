# Omarchy environment (OMARCHY_PATH + PATH), needed even for non-interactive shells
[[ -r /usr/share/omarchy/default/bash/env-bootstrap ]] && source /usr/share/omarchy/default/bash/env-bootstrap

# If not running interactively, don't do anything else (leave this above the rc source)
[[ $- != *i* ]] && return

# All the default Omarchy aliases, functions and shell init (mise, starship,
# zoxide, fzf, completions). Loaded before the dotfiles modules below so that
# anything defined here can be intentionally overridden there.
[[ -n "${OMARCHY_PATH:-}" && -r "$OMARCHY_PATH/default/bash/rc" ]] && source "$OMARCHY_PATH/default/bash/rc"

# Load homebrew bin (macOS only)
if [[ "$(uname)" == "Darwin" ]]; then
  if [[ $(uname -m) == "arm64" ]]; then # Apple Silicon
    export PATH="/opt/homebrew/bin:$PATH"
    export PATH="/opt/homebrew/sbin:$PATH"
  else
    export PATH="/usr/local/bin:$PATH"
    export PATH="/usr/local/sbin:$PATH"
  fi
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

[ -f "$HOME/.dotfiles/.env.sh" ] && . "$HOME/.dotfiles/.env.sh"

# Load custom aliases and functions
for file in init.sh aliases.sh functions.sh bash/aliases.sh bash/functions.sh; do
  [ -r ~/.dotfiles/shell/$file ] && source ~/.dotfiles/shell/$file
done

# Execute commands only available if line editing is on. https://superuser.com/a/1361068/983887
if [[ "$(set -o | grep 'emacs\|\bvi\b' | cut -f2 | tr '\n' ':')" != 'off:off:' ]]; then
  # Load .inputrc if it exists
  [ -f ~/.inputrc ] && bind -f ~/.inputrc
fi

# Bash completion (macOS only)
if [[ "$(uname)" == "Darwin" ]]; then
  if [[ $(uname -m) == "arm64" ]]; then # Apple Silicon
    [[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"
  else # Intel
    [[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
  fi
fi

#  ============= PROMPT ===========
# Omarchy ships starship and initializes it from its own rc; don't override it.
if [[ -z "${OMARCHY_PATH:-}" ]]; then
  prompt_git_info() {
    local branch state code marker
    branch=$(git symbolic-ref --quiet --short HEAD 2>/dev/null) || \
      branch=$(git rev-parse --short HEAD 2>/dev/null) || return
    state=$(git status --porcelain --untracked-files=normal 2>/dev/null)
    marker=''
    if [[ -n "$state" ]]; then
      code=${state:0:2}
      if [[ "$code" == '??' ]]; then
        marker=' ?'
      elif [[ "$code" != '  ' ]]; then
        marker=' '
      fi
    fi
    # Use readline's non-printing markers here (rather than PS1's \[ / \]),
    # since this text is emitted from a command substitution inside PS1.
    printf '\001\e[3;36m\002%s\001\e[0m\002%s' "$branch" "$marker"
  }

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

    # Omarchy-like native Bash prompt: shortened path, branch/status, and arrow.
    if [[ $exit_status -ne 0 ]]; then
      PS1='\[\e[36m\]\w\[\e[0m\] $(prompt_git_info) \[\e[36m\]✗ ❯\[\e[0m\] '
    else
      PS1='\[\e[36m\]\w\[\e[0m\] $(prompt_git_info) \[\e[36m\]❯\[\e[0m\] '
    fi

    return $exit_status
  }

  PROMPT_DIRTRIM=2
  PROMPT_COMMAND="prompt_hook"
fi

export PATH=$PATH:$HOME/.local/bin

# pnpm (macOS only)
if [[ "$(uname)" == "Darwin" ]]; then
  export PNPM_HOME="$HOME/Library/pnpm"
  case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
  esac
fi

[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

[ -f "$HOME/.atuin/bin/env" ] && . "$HOME/.atuin/bin/env"

# opencode
export PATH="$HOME/.opencode/bin:$PATH"

if command -v atuin >/dev/null 2>&1; then
  [[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh
  eval "$(atuin init bash)"
fi

# Antigravity CLI (macOS only)
if [[ "$(uname)" == "Darwin" && -d "$HOME/.antigravity/antigravity/bin" ]]; then
  export PATH="$HOME/.antigravity/antigravity/bin:$PATH"
fi
