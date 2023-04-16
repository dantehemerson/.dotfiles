function _reverse_search() {
  local selected_command=$(history | awk '{$1="";print substr($0,2)}' | fzf)
  READLINE_LINE=$selected_command
  READLINE_POINT=${#READLINE_LINE}
}

bind -x '"\C-e":_reverse_search'