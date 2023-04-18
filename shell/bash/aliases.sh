# Zsh aliases missing in bash

# List directory contents
alias lsa='ls -lah'
alias l='ls -lah'
alias ll='ls -lh'
alias la='ls -lAh'

alias md='mkdir -p'
alias rd=rmdir


# Fix issue with homebrew bash
if [[ $(uname -m) == "arm64" ]]; then # Apple Silicon
  alias bash=/opt/homebrew/bin/bash
else # Intel
  alias bash=/usr/local/bin/bash
fi
