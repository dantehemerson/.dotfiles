# Zsh aliases missing in bash

# List directory contents
alias lsa='ls -lah --color'
alias l='ls -lah --color'
alias ll='ls -lh --color'
alias la='ls -lAh --color'
alias ls='ls -G --color'

alias md='mkdir -p'
alias rd=rmdir


# Fix issue with homebrew bash

# Check if Apple Silicon or Intel Mac
if [[ "$(uname)" == "Darwin" ]]; then
  if [[ $(uname -m) == "arm64" ]]; then # Apple Silicon
    alias bash=/opt/homebrew/bin/bash
  else # Intel
    alias bash=/usr/local/bin/bash
  fi
fi


