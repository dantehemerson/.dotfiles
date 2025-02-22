#!/bin/sh

# VERSION="0.1"

# parser_definition() {
#   setup   REST help:usage -- "Usage: example.sh [options]... [arguments]..." ''
#   msg -- 'Options:'
#   flag    FLAG    -f --flag                 -- "takes no arguments"
#   flag    SKIP_GITCONFIG_LINKIG   --skip-gitconfig-linking  -- "skip linking .gitconfig"
#   param   PARAM   -p --param                -- "takes one argument"
#   option  OPTION  -o --option on:"default"  -- "takes one optional argument"
#   disp    :usage  -h --help
#   disp    VERSION    --version
#   disp    SOLUTION -s  --solution
# }

# eval "$(./deps/getoptions parser_definition) exit 1" # argument parsing

# echo "FLAG: $FLAG, PARAM: $PARAM, OPTION: $OPTION"
# printf '%s\n' "$@" # output rest argument


if [[ "$(uname)" == "Linux" ]]; then
  export IS_LINUX=true
elif [[ "$(uname)" == "Darwin" ]]; then
  export IS_OSX=true
fi

# Move a file or folder to trash.
# Used to moved files that already exists before create the symlink,
# just in case you need to restore them.
function move_to_trash() {
  if [ -e "$1" ]; then
    filename=$(basename "$1")
    new_filename="$filename-$(date +%s)"

    if [[ "$IS_OSX" == true ]]; then
      # On OSX, use the `trash` command
      mv -f "$1" ~/.Trash/"$new_filename"
      echo "$filename moved to trash, you can restore it from there if needed"
    else if [[ "$IS_LINUX" == true ]]; then
      # On Linux, move to temp folder
      mv -f "$1" /tmp/"$new_filename"

      echo "$filename moved to trash, you can restore it from there if needed"
    fi
  fi
 fi
}

# Link/Copy a file to another location.
# It has 3 modes:
# - symbolic link(default): create a symbolic link to the file. It's usefult to keep file synced with git.
# - copy: created a copy of the file to the specified location.
# - skip: skip the file (do nothing)
function link() {
  if [ "$3" = "copy" ]; then # COPY
    move_to_trash "$2"
    cp -r "$1" "$2"
    echo "🔗 File $2 copied from $1"
    return
  elif [ "$3" = "skip" ]; then # SKIP
    # noop
    return
  else # symbolic link by default
    # Only link if file is not already linked
    if [ ! -L "$2" ] && [ ! -d "$2" ]; then
      move_to_trash "$2"
      ln -sf "$1" "$2"
      echo "🔗 File $2 linked to $1"
    else
      echo "ℹ️  File $2 is already linked"
    fi
    return
  fi
}

function _command_exists() {
	#_about 'checks for existence of a command'
	#_param '1: command to check'
	#_param '2: (optional) log message to include when command not found'
	#_example '$ _command_exists ls && echo exists'
	#_group 'lib'
	local msg="${2:-Command '$1' does not exist}"
	if type -t "$1" > /dev/null; then
		return 0
	else
		_log_debug "$msg"
		return 1
	fi
}
