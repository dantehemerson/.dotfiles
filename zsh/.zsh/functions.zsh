# Kill port, eg. kp 8000 kills port 8000
function kp() {
  fuser -k "$1"/tcp
}

# Determine size of a file or total size of a directory
function fs() {
	if du -b /dev/null > /dev/null 2>&1; then
		local arg=-sbh;
	else
		local arg=-sh;
	fi
	if [[ -n "$@" ]]; then
		du $arg -- "$@";
	else
		du $arg .[^.]* ./*;
	fi;
}

# Copy to clipboard, use: clip file.txt
function clip() {
  xclip -selection clipboard < $1
}


function runsshagent() {
	eval $(ssh-agent -s)
}

function _reverse_search() {
  local selected_command=$(fc -rl 1 | awk '{$1="";print substr($0,2)}' | fzf)
  LBUFFER=$selected_command
}

zle -N _reverse_search
bindkey '^r' _reverse_search
