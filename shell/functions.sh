# Kill port, eg. kp 8000 kills port 8000
function kp() {
  fuser -k "$1"/tcp
}

# List processes listening on PORT $1
function port() {
  lsof "-i:$1"
}

# Exit keybase
function ekb() {
  keybase ctl app-exit
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

# Copy to clipboard, use: clip file.txt. TODO:Add mac support
function clip() {
  xclip -selection clipboard < $1
}

# Copy file to clipboard, use: cf <path/to/file.text>
function cf() {
  xclip -sel clip < $1
}
