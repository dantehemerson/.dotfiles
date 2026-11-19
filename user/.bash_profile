# Login shells: load the interactive shell config (also brings in Omarchy's
# environment bootstrap, so OMARCHY_PATH and PATH are set for every session).
[ -r "$HOME/.bashrc" ] && source "$HOME/.bashrc"

# macOS-only integrations
if [[ "$(uname)" == "Darwin" ]]; then
  # Added by OrbStack: command-line tools and integration
  [ -r "$HOME/.orbstack/shell/init.bash" ] && source "$HOME/.orbstack/shell/init.bash"

  [ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"
  [ -f "$HOME/.atuin/bin/env" ] && . "$HOME/.atuin/bin/env"

  # opencode
  export PATH="$HOME/.opencode/bin:$PATH"

  # Added by Antigravity CLI installer
  [ -d "$HOME/.antigravity/antigravity/bin" ] && export PATH="$HOME/.antigravity/antigravity/bin:$PATH"
fi
