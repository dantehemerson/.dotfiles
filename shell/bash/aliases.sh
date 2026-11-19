# Bash-only aliases

# List directory contents.
# Omarchy owns `ls`, `lsa`, `lt` and `lta` (all eza). Add the shorter spellings
# it doesn't define, using eza when available so output matches the rest.
if command -v eza >/dev/null 2>&1; then
  alias l='eza -lah --group-directories-first --icons=auto'
  alias ll='eza -lh --group-directories-first --icons=auto'
  alias la='eza -lah --group-directories-first --icons=auto'
else
  alias l='ls -lah --color'
  alias ll='ls -lh --color'
  alias la='ls -lAh --color'
fi

# macOS only: BSD ls uses -G for color; on Linux/Omarchy leave ls/lsa to eza.
if [[ "$(uname)" == "Darwin" ]]; then
  alias lsa='ls -lah --color'
  alias ls='ls -G --color'
fi

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
