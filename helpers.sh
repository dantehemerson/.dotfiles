#!/bin/sh

VERSION="0.1"

parser_definition() {
  setup   REST help:usage -- "Usage: example.sh [options]... [arguments]..." ''
  msg -- 'Options:'
  flag    FLAG    -f --flag                 -- "takes no arguments"
  flag    SKIP_GITCONFIG_LINKIG   --skip-gitconfig-linking  -- "skip linking .gitconfig"
  param   PARAM   -p --param                -- "takes one argument"
  option  OPTION  -o --option on:"default"  -- "takes one optional argument"
  disp    :usage  -h --help
  disp    VERSION    --version
}

eval "$(./deps/getoptions parser_definition) exit 1" # argument parsing

echo "FLAG: $FLAG, PARAM: $PARAM, OPTION: $OPTION"
printf '%s\n' "$@" # output rest arguments
