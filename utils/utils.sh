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
# printf '%s\n' "$@" # output rest arguments


if [[ "$(uname)" == "Linux" ]]; then
  export IS_LINUX=true
elif [[ "$(uname)" == "Darwin" ]]; then
  export IS_OSX=true
fi

# Move a file or folder to trash.
# Used to moved files that already exists before create the symlink,
# just in case we need to restore them.
function move_to_trash() {
  if [ -e "$1" ]; then
    filename=$(basename "$1")
    new_filename="$filename-$(date +%s)"

    mv -f "$1" ~/.Trash/"$new_filename"
    echo "$filename moved to trash, you can restore it from there if needed"
  fi
}

function link() {
  if [ "$3" = "copy" ]; then # COPY
    move_to_trash "$2"
    cp -r "$1" "$2"
    echo "🔗 File $2 copied from $1"
    return
  elif [ "$3" = "skip" ]; then # SKIP
    # noop
    return
  else # LINK by default
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