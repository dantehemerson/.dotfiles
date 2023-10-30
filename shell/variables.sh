if [ -f ~/.dotfiles/variables.private.sh ]; then
  source ~/.dotfiles/variables.private.sh
fi


# -------- todo.sh dir ---------
case $OSTYPE in
  *'darwin'*)
    export TODO_SH_DIR="$HOME/Library/Mobile Documents/com~apple~CloudDocs/Apps Data/todo.sh"
    ;;

  *'linux'*)
    export TODO_SH_DIR="$HOME/todo.sh"
    ;;
esac

if [ ! -d "$TODO_SH_DIR" ]; then
  mkdir -p "$TODO_SH_DIR"
fi