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


# Tells you a joke
function joke() {
	curl -s https://v2.jokeapi.dev/joke/Any | jq '{setup, delivery, joke} | del(.[] | nulls)'
}


  # random git-commit message
function randcommit(){
  gitRan=$(curl -L -s http://whatthecommit.com/ |grep -A 1 "\"c" |tail -1 |sed 's/<p>//');
  commitTemp="$1:$gitRan";
  commitLowercase=`echo "$commitTemp" | awk '{ print tolower($0) }'`;
  git add . && git commit -m "$commitLowercase";
}
