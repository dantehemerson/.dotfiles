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
  git add --all && git commit -m "feat: [DIGI-0] Update"
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
