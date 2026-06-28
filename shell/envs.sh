# Editor used by CLI
export SUDO_EDITOR="$EDITOR"
export BAT_THEME=ansi


# Load hombrew bin
if [[ $(uname -m) == "arm64" ]]; then # Apple Silicon
  export PATH="/opt/homebrew/bin:$PATH"
  export PATH="/opt/homebrew/sbin:$PATH"
else
  export PATH="/usr/local/bin:$PATH"
  export PATH="/usr/local/sbin:$PATH"
fi

