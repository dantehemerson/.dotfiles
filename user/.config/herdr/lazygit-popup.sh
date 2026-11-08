#!/bin/sh

# Keep LazyGit alive when its Herdr popup is detached or closed.
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

if ! command -v tmux >/dev/null 2>&1; then
  echo "Persistent LazyGit requires tmux." >&2
  exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "Persistent LazyGit pushes require python3." >&2
  exit 1
fi

real_git=$(command -v git)
python=$(command -v python3)

if ! "$python" "$script_dir/lazygit-push.py" --report; then
  printf 'Press Enter to open LazyGit... '
  IFS= read -r answer
fi

cd "${HERDR_ACTIVE_PANE_CWD:-.}"
repo=$(git rev-parse --show-toplevel)
repo=$(CDPATH= cd -- "$repo" && pwd -P)

# Hash the worktree root, not the shared Git directory: linked worktrees
# need independent sessions, but subdirectories should reuse the same one.
session="lazygit-$(printf '%s' "$repo" | git hash-object --stdin)"

# Use an isolated server/config, leaving normal tmux sessions untouched.
unset TMUX TMUX_PANE
exec tmux -L herdr-lazygit -f "$script_dir/lazygit-tmux.conf" \
  new-session -A -s "$session" -c "$repo" \
  -e "PATH=$script_dir/lazygit-bin:$PATH" \
  -e "HERDR_LAZYGIT_REAL_GIT=$real_git" \
  -e "HERDR_LAZYGIT_PYTHON=$python" \
  lazygit
