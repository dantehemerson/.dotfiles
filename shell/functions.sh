source ~/.dotfiles/utils/utils.sh

# Kill port, eg. kp 8000 kills port 8000

if [[ "$IS_LINUX" == true ]]; then

  # Kill port on linux
  function kp() {
    fuser -k "$1"/tcp
  }

elif [[ "$IS_OSX" == true ]]; then

  # Kill port on macos
  function kp() {
    local port="$1"
    local pid=$(lsof -i :"$port" -t)

    if [[ -z $pid ]]; then
      echo "No process found running on port $port."
    else
      kill "$pid"
      echo "😵 Port $port killed."
    fi
  }

fi

# List processes listening on PORT $1
function port() {
  lsof "-i:$1"
}

# Print plist in json format
function printPlist() {
  plutil -convert json -o - $1 | jq
}

# Exit keybase
function ekb() {
  keybase ctl app-exit
}

function display_size() {
  echo "Virtual Size: $(system_profiler SPDisplaysDataType | awk '/Resolution/{print $2, $3, $4}')"
}

# Determine size of a file or total size of a directory
function fs() {
  if du -b /dev/null >/dev/null 2>&1; then
    local arg=-sbh
  else
    local arg=-sh
  fi
  if [[ -n "$@" ]]; then
    du $arg -- "$@"
  else
    du $arg .[^.]* ./*
  fi
}

# Copy to clipboard, use: clip file.txt. TODO:Add mac support
function clip() {
  xclip -selection clipboard <$1
}

# Copy file to clipboard, use: cf <path/to/file.text>
function cf() {
  xclip -sel clip <$1
}

# Tells you a joke
function joke() {
  randomNumber=$(((RANDOM % 2) + 1))

  echo -e "------------------------- JOKE OF THE DAY --------------------------\n\n"

  case $randomNumber in
  1)
    curl -s https://v2.jokeapi.dev/joke/Any | jq '{setup, delivery, joke} | del(.[] | nulls)  + {from: "https://v2.joke.api.dev"}'
    ;;
  2)
    curl -s -H "Accept: application/json" https://icanhazdadjoke.com/ | jq '{ joke } | del(.[] | nulls)  + {from: "https://icanhazdadjoke.com/"}'
    ;;
  esac

  echo -e "\033[0m\n\n--------------------------------------------------------------------\n"
}

# random git-commit message
function randcommit() {
  # gitRan=$(curl -L -s http://whatthecommit.com/ |grep -A 1 "\"c" |tail -1 |sed 's/<p>//');
  # commitTemp="$gitRan";
  #  commitLowercase=`echo "$commitTemp" | awk '{ print tolower($0) }'`;
  # git add --all && git commit -m "$commitLowercase";
  git add --all && git commit -m "${DEFAULT_COMMIT_MESSAGE:-feat: [DIGI-0] Update}"
  gpb
}

function colors() {
  for i in {0..255}; do
    printf "\x1b[38;5;%smcolour%s                                 \n                                        | \x1b[7m\n" "${i}" "${i}"
  done
}

# Runs and delete the compiled file
function exec_cpp() {
  file_name=$(date +%s)
  g++ -std=c++17 -lstdc++ -o "$filename" "$1" && "$filename" && rm "$filename"
}

# Generate nest module and service

# === NETWORK ===
function ips() {
  # 'display all ip addresses for this host'

  if _command_exists ifconfig; then
    ifconfig | awk '/inet /{ gsub(/addr:/, ""); print $2 }'
  elif _command_exists ip; then
    ip addr | grep -oP 'inet \K[\d.]+'
  else
    echo "You don't have ifconfig or ip command installed!"
  fi
}

# === DISK ===
function usage() {
  #about 'disk usage per directory, in Mac OS X and Linux'
  #param '1: directory name'
  #group 'base'
  case $OSTYPE in
  *'darwin'*)
    du -hd 1 "$@"
    ;;
  *'linux'*)
    du -h --max-depth=1 "$@"
    ;;
  esac
}

# get a quick overview for your git repo
function giti() {
  #about 'overview for your git repo'
  #group 'git'

  if [ -n "$(git symbolic-ref HEAD 2>/dev/null)" ]; then
    # print informations
    echo "git repo overview"
    echo "-----------------"
    echo

    # print all remotes and thier details
    for remote in $(git remote show); do
      echo "${remote}":
      git remote show "${remote}"
      echo
    done

    # print status of working repo
    echo "status:"
    if [ -n "$(git status -s 2>/dev/null)" ]; then
      git status -s
    else
      echo "working directory is clean"
    fi

    # print at least 5 last log entries
    echo
    echo "log:"
    git log -5 --oneline
    echo

  else
    echo "you're currently not in a git repository"

  fi
}

function git_stats {
  #about 'display stats per author'
  #group 'git'

  # awesome work from https://github.com/esc/git-stats
  # including some modifications

  if [ -n "$(git symbolic-ref HEAD 2>/dev/null)" ]; then
    echo "Number of commits per author:"
    git --no-pager shortlog -sn --all
    AUTHORS=$(git shortlog -sn --all | cut -f2 | cut -f1 -d' ')
    LOGOPTS=""
    if [ "$1" == '-w' ]; then
      LOGOPTS="${LOGOPTS} -w"
      shift
    fi
    if [ "$1" == '-M' ]; then
      LOGOPTS="${LOGOPTS} -M"
      shift
    fi
    if [ "$1" == '-C' ]; then
      LOGOPTS="${LOGOPTS} -C --find-copies-harder"
      shift
    fi
    for a in ${AUTHORS}; do
      echo '-------------------'
      echo "Statistics for: ${a}"
      echo -n "Number of files changed: "
      # shellcheck disable=SC2086
      git log ${LOGOPTS} --all --numstat --format="%n" --author="${a}" | cut -f3 | sort -iu | wc -l
      echo -n "Number of lines added: "
      # shellcheck disable=SC2086
      git log ${LOGOPTS} --all --numstat --format="%n" --author="${a}" | cut -f1 | awk '{s+=$1} END {print s}'
      echo -n "Number of lines deleted: "
      # shellcheck disable=SC2086
      git log ${LOGOPTS} --all --numstat --format="%n" --author="${a}" | cut -f2 | awk '{s+=$1} END {print s}'
      echo -n "Number of merges: "
      # shellcheck disable=SC2086
      git log ${LOGOPTS} --all --merges --author="${a}" | grep -c '^commit'
    done
  else
    echo "you're currently not in a git repository"
  fi
}

# Update karabiner config
function karabinerUpdate() {
  SOURCE="$HOME/.dotfiles/user/karabiner/karabiner-partial.json"
  DESTINATION="$HOME/.config/karabiner/karabiner.json"

  # Create temp file, to avoid issue in Karabiner while writting directly to destination
  TEMP_FILE="$HOME/.config/karabiner/karabiner_temp.json"
  touch "$TEMP_FILE"

  jq --slurpfile source "$SOURCE" '
	.profiles[0].complex_modifications.rules = $source[0].rules |
	.profiles[0].fn_function_keys = $source[0].fn_function_keys |
	.global = $source[0].global

	' "$DESTINATION" >$TEMP_FILE

  move_to_trash "$DESTINATION"
  mv "$TEMP_FILE" "$DESTINATION"
}

function karabinerBackup() {
  SOURCE="$HOME/.config/karabiner/karabiner.json"
  DESTINATION="$HOME/.dotfiles/user/karabiner/karabiner-partial.json"

  jq --slurpfile source "$SOURCE" '
		.rules = $source[0].profiles[0].complex_modifications.rules |
		.fn_function_keys = $source[0].profiles[0].fn_function_keys |
		.global = $source[0].global
	' "$DESTINATION" >$DESTINATION
}

localip() {
  if command -v ip >/dev/null 2>&1; then
    # Linux
    ip -4 addr show scope global |
      awk '{print $2}' |
      cut -d/ -f1 |
      awk '/^(10\.|192\.168\.|172\.(1[6-9]|2[0-9]|3[0-1])\.)/ {
          ips = ips $0 " | "
        }
        END {
          sub(/ \| $/, "", ips)
          print ips
        }'
  else
    # macOS / BSD
    ifconfig |
      awk '/inet / && $2 != "127.0.0.1" {print $2}' |
      awk '/^(10\.|192\.168\.|172\.(1[6-9]|2[0-9]|3[0-1])\.)/ {
          ips = ips $0 " | "
        }
        END {
          sub(/ \| $/, "", ips)
          print ips
        }'
  fi
}

function gitignore-reload() {
  # 'Empties the git cache, and readds all files not blacklisted by .gitignore'

  # The .gitignore file should not be reloaded if there are uncommited changes.
  # Firstly, require a clean work tree. The function require_clean_work_tree()
  # was stolen with love from https://www.spinics.net/lists/git/msg142043.html

  # Begin require_clean_work_tree()

  # Update the index
  git update-index -q --ignore-submodules --refresh
  err=0

  # Disallow unstaged changes in the working tree
  if ! git diff-files --quiet --ignore-submodules --; then
    echo >&2 "ERROR: Cannot reload .gitignore: Your index contains unstaged changes."
    git diff-index --cached --name-status -r --ignore-submodules HEAD -- >&2
    err=1
  fi

  # Disallow uncommited changes in the index
  if ! git diff-index --cached --quiet HEAD --ignore-submodules; then
    echo >&2 "ERROR: Cannot reload .gitignore: Your index contains uncommited changes."
    git diff-index --cached --name-status -r --ignore-submodules HEAD -- >&2
    err=1
  fi

  # Prompt user to commit or stash changes and exit
  if [[ "${err}" == 1 ]]; then
    echo >&2 "Please commit or stash them."
  fi

  # End require_clean_work_tree()

  # If we're here, then there are no uncommited or unstaged changes dangling around.
  # Proceed to reload .gitignore
  if [[ "${err}" == 0 ]]; then
    # Remove all cached files
    git rm -r --cached .

    # Re-add everything. The changed .gitignore will be picked up here and will exclude the files
    # now blacklisted by .gitignore
    echo >&2 "Running git add ."
    git add .
    echo >&2 "Files readded. Commit your new changes now."
  fi
}

nvim-fix() {
  echo "⚠️  This will delete Neovim runtime data:"
  echo "   ~/.local/share/nvim"
  echo "   ~/.cache/nvim"
  echo "   ~/.local/state/nvim"
  echo
  read -p "Continue? [y/N] " confirm
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    rm -rf ~/.local/share/nvim ~/.cache/nvim ~/.local/state/nvim
    echo "✅ Neovim cache cleared. Restart nvim."
  else
    echo "❌ Aborted."
  fi
}

# Compression
compress() { tar -czf "${1%/}.tar.gz" "${1%/}"; }
alias decompress="tar -xzf"

# === add-repo ===
# Add a Git worktree to a Herdr workspace in ~/workspaces, with env-file copy.
# Usage: add-repo [workspace] [repo] [branch]
#   All args optional — anything omitted is prompted via fzf/read.
add-repo() {
  local CODING_DIR="$HOME/coding"
  local WORKSPACES_DIR="$HOME/workspaces"

  if ! command -v fzf >/dev/null 2>&1; then
    echo "❌ fzf is required (https://github.com/junegunn/fzf)" >&2
    return 1
  fi

  # ---------- Workspace ----------
  # No prompt: the workspace is derived from the current directory so the
  # worktree lands in the workspace you're already in.
  # e.g. cwd ~/workspaces/sort-student-error/... -> workspace "sort-student-error"
  local workspace="$1"
  if [[ -z "$workspace" ]]; then
    local cur="$PWD"
    if [[ "$cur" == "$WORKSPACES_DIR"/* ]]; then
      # Relative path under ~/workspaces: first segment is the workspace name.
      local rel="${cur#"$WORKSPACES_DIR"/}"
      workspace="${rel%%/*}"
    else
      # Fallback: find which workspace dir contains the cwd (symlinked setups etc.)
      local d
      while IFS= read -r d; do
        if [[ "$cur" == "$d"/* || "$cur" == "$d" ]]; then
          workspace="$(basename "$d")"
          break
        fi
      done < <(command find "$WORKSPACES_DIR" -mindepth 1 -maxdepth 1 -type d 2>/dev/null)
    fi
  fi
  [[ -z "$workspace" ]] && { echo "❌ Not inside a workspace. cd into ~/workspaces/<name> first (or pass it as arg 1)." >&2; return 1; }
  mkdir -p "$WORKSPACES_DIR/$workspace"

  # ---------- Repo ----------
  local repo="$2"
  if [[ -z "$repo" ]]; then
    local repos=()
    while IFS= read -r d; do
      [[ -d "$d/.git" ]] && repos+=("$(basename "$d")")
    done < <(command find "$CODING_DIR" -mindepth 1 -maxdepth 1 -type d 2>/dev/null)
    if [[ ${#repos[@]} -eq 0 ]]; then
      echo "❌ No git repositories found in $CODING_DIR" >&2
      return 1
    fi
    repo=$(printf '%s\n' "${repos[@]}" | fzf --prompt="Repository › " --height=20 --reverse) || return 1
  fi
  if [[ ! -d "$CODING_DIR/$repo/.git" ]]; then
    echo "❌ $CODING_DIR/$repo is not a git repository." >&2
    return 1
  fi
  local main_repo="$CODING_DIR/$repo"

  # ---------- Fetch ----------
  echo "⟳ Fetching origin for $repo…"
  if ! git -C "$main_repo" fetch origin --prune --quiet 2>/dev/null; then
    echo "⚠️  Fetch failed (offline?). Continuing with local branches." >&2
  fi

  # ---------- Branch ----------
  local branch="$3"
  if [[ -z "$branch" ]]; then
    # Local + remote branches, deduped, origin/HEAD marker removed
    local branches
    branches=$( {
      git -C "$main_repo" for-each-ref --format='%(refname:short)' refs/heads/
      git -C "$main_repo" for-each-ref --format='%(refname:short)' refs/remotes/origin/ | grep -v 'origin/HEAD'
    } | sort -u )

    local picked
    local fzf_rc
    # --print-query + Enter on a non-matching query: fzf prints the query but exits 1
    # (same code as ESC). So: accept rc=0 or rc=1-with-query; only bail if nothing typed.
    picked=$(printf '%s\n' "$branches" | fzf --print-query --prompt="Branch (type to create new) › " --height=20 --reverse) && fzf_rc=0 || fzf_rc=$?
    picked="${picked%%$'\n'*}"   # first line = query
    if [[ $fzf_rc -ne 0 && -z "${picked//[[:space:]]/}" ]]; then
      return 1   # genuine cancel (ESC / empty query)
    fi
    branch="${picked//$'\n'/}"
  fi
  [[ -z "$branch" ]] && { echo "❌ No branch given." >&2; return 1; }

  # ---------- Branch resolution ----------
  local base_ref=""
  local create=0

  if git -C "$main_repo" show-ref --verify --quiet "refs/heads/$branch"; then
    echo "ℹ️  Branch '$branch' exists locally — reusing."
  elif git -C "$main_repo" show-ref --verify --quiet "refs/remotes/origin/$branch"; then
    echo "ℹ️  Branch '$branch' exists on origin — reusing."
  else
    create=1
    # Pick a base ref for the new branch
    local origin_head
    origin_head=$(git -C "$main_repo" symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's|^refs/remotes/||')
    local bases=()
    [[ -n "$origin_head" ]] && bases+=("$origin_head (origin/HEAD)")
    git -C "$main_repo" show-ref --verify --quiet refs/heads/main && bases+=("main")
    git -C "$main_repo" show-ref --verify --quiet refs/heads/master && bases+=("master")

    echo "✨ Branch '$branch' doesn't exist — will create it."
    local base_pick
    base_pick=$(printf '%s\n' "${bases[@]}" | fzf --print-query --prompt="Base branch › " --height=10 --reverse --header="Enter=accept, Esc=cancel") || return 1
    base_ref="${base_pick%%$'\n'*}"
    # Strip the "(origin/HEAD)" annotation if chosen
    base_ref="${base_ref%% *}"
    if [[ -z "$base_ref" ]]; then
      # User typed nothing / accepted empty → default
      base_ref="${origin_head:-main}"
    fi
    if ! git -C "$main_repo" rev-parse --verify --quiet "$base_ref" >/dev/null; then
      echo "❌ Base ref '$base_ref' not found in $repo." >&2
      return 1
    fi
  fi

  # ---------- Worktree path ----------
  local wt_path="$WORKSPACES_DIR/$workspace/$repo"

  if [[ -e "$wt_path" ]]; then
    if [[ -d "$wt_path/.git" || -f "$wt_path/.git" ]]; then
      local existing_branch
      existing_branch=$(git -C "$wt_path" symbolic-ref --short HEAD 2>/dev/null)
      if [[ -n "$existing_branch" && "$existing_branch" != "$branch" ]]; then
        echo "❌ $wt_path already holds branch '$existing_branch', not '$branch'." >&2
        echo "   A workspace holds one worktree per repo. Remove it or use another branch." >&2
        return 1
      fi
      echo "ℹ️  Worktree already exists at $wt_path — skipping git setup."
      [[ -n "$existing_branch" ]] && branch="$existing_branch"
    else
      echo "❌ $wt_path exists but is not a git worktree. Remove it manually first." >&2
      return 1
    fi
  else
    # Check if branch is already checked out elsewhere
    local taken_path
    taken_path=$(git -C "$main_repo" worktree list --porcelain | awk -v b="refs/heads/$branch" '
      /^worktree /{p=$2} /^branch /{if ($2==b) print p}')
    if [[ -n "$taken_path" ]]; then
      echo "⚠️  Branch '$branch' is checked out at: $taken_path"
      local open_existing
      open_existing=$( { echo "Yes — attach that path"; echo "No — abort"; } | fzf --prompt="Open existing worktree instead? › " --height=6 --reverse) || return 1
      if [[ "$open_existing" == Yes* ]]; then
        wt_path="$taken_path"
      else
        return 1
      fi
    elif [[ $create -eq 1 ]]; then
      echo "🌿 Creating worktree: $wt_path (branch '$branch' from '$base_ref')"
      git -C "$main_repo" worktree add -b "$branch" "$wt_path" "$base_ref" || return 1
    else
      echo "🌿 Creating worktree: $wt_path (branch '$branch')"
      git -C "$main_repo" worktree add "$wt_path" "$branch" || return 1
    fi
  fi

  # ---------- Env/config file copy (never overwrite) ----------
  echo "📋 Copying env files (no overwrites)…"
  rsync -av --ignore-existing \
    --include='.env' \
    --include='.env.*' \
    --include='.envrc' \
    --exclude='*' \
    "$main_repo/" "$wt_path/"

  # ---------- Summary ----------
  # Note: nothing is created in Herdr — no pane, no tab, no workspace.
  # The worktree directory is simply available at ~/workspaces/<ws>/<repo>;
  # open it in Herdr yourself when you want an agent on it.
  echo
  echo "✅ Done"
  echo "   Workspace : $workspace"
  echo "   Repo      : $repo"
  echo "   Path      : $wt_path"
  echo "   Branch    : $branch"
  [[ $create -eq 1 && "$wt_path" == "$WORKSPACES_DIR/$workspace/$repo" ]] && echo "   Base      : $base_ref"
  echo "   Env files : copied (existing files untouched)"
}
