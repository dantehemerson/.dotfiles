alias v="vi"

# ========= Fast switching directories ===========
alias dotfiles="cd ~/.dotfiles"
alias repos="cd ~/coding/repos"
alias coding="cd ~/coding"
alias oss="cd ~/coding/oss"
alias downloads="cd ~/Downloads"
alias Downloads="cd ~/Downloads"

# Files
alias zshrc="vi ~/.zshrc"
alias bashrc="vi ~/.bashrc"
alias vimrc="vi ~/.vimrc"
alias gitconfig="vi ~/.gitconfig"
alias tmuxconf="vi ~/.tmux.conf"
alias aliases="vi ~/.dotfiles/shell/aliases.sh"
alias functions="vi ~/.dotfiles/shell/functions.sh"


# ========== Notes ===========
alias vnotes="vi ~/.notes.md" 
alias notes='glow ~/.notes.md'  # Show notes

# =========== Git ===========
alias gaa="git add ."
alias gc="git commit -m "
alias gs="git status"
alias gd="git diff | delta"


# Pull current branch
alias glb="git pull origin \$(git rev-parse --abbrev-ref HEAD)"

# Push current branch
alias gpb="git push origin \$(git rev-parse --abbrev-ref HEAD)"

# Start mongo service
alias mongoplay="sudo service mongod start"

# Move files to trash
alias srm='safe-rm'



# =========== Tmux ==============
alias tma="tmux a"
alias tmat="tmux a -t "
alias tml="tmux ls"
alias tmls="tmux ls"
alias tmks="tmux kill-session -t "

# =========== Node.js ===========
alias scripts="jq '.scripts' package.json"
alias deps="jq '.dependencies' package.json" 
alias engines="jq '.engines' package.json"
alias devs="jq '.devDependencies' package.json"
alias version="jq '.version' package.json"

# Common npm & yarn aliases
alias ns="npm start"
alias nb="npm run build"
alias nrs="npm run serve"
alias nrd="npm run dev"
alias nbs="npm run build && npm run serve"
alias ts="ts-node"

if [[ $(uname) == "Darwin" ]]; then # OS X only aliases
  alias files="open ."
elif [[ $(uname) == "Linux" ]]; then # Linux only aliases
  alias files="nautilus &>/dev/null &"
  alias chrome='google-chrome'
fi

# List files an folders in tree format
alias t="tree -I 'node_modules|.database|.db|.cache|cache'"

# IP
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"

alias reload="exec ${SHELL} -l"

# cd shorcuts
alias cd..="cd .."
alias cd...="cd ..."
alias cd....="cd ...."
alias cd.....="cd ....."
alias cd......="cd ......"
alias cd.......="cd ......."

# Enter to directory and list
function cdl() {
  cd $1 && l
}


# Typos
alias code.="code ."
