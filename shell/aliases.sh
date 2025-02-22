source ~/.dotfiles/utils/utils.sh


alias v="vi"

# ========= Fast switching directories ===========
alias dotfiles="cd ~/.dotfiles"
alias repos="cd ~/coding/repos"
alias coding="cd ~/coding"
alias oss="cd ~/coding/oss"
alias downloads="cd ~/Downloads"
alias Downloads="cd ~/Downloads"

alias numbers='open -a "Numbers" '


# Bat

# if linux set alias bat="batcat"
if [[ "$IS_LINUX" == "true" ]]; then
  alias bat="batcat"
fi

# Files
alias zshrc="vi ~/.zshrc"
alias bashrc="vi ~/.bashrc"
alias vimrc="vi ~/.vimrc"
alias gitconfig="vi ~/.gitconfig"
alias tmuxconf="vi ~/.tmux.conf"
alias inputrc="vi ~/.inputrc"
alias aliases="vi ~/.dotfiles/shell/aliases.sh"
alias functions="vi ~/.dotfiles/shell/functions.sh"
alias readme="bat README.md"

# Interactive git branch switcher. Order by last commit date(most recent branches).
alias branch="git branch -v --sort=-refname --sort=-committerdate | fzf --height=20% --reverse | sed 's/^..//' | awk '{ print \$1 }' | xargs git checkout"

alias dotfiles_backup="~/.dotfiles/utils/dotfiles_backup.sh"
alias dotfiles_import="~/.dotfiles/utils/dotfiles_import.sh"


# =========== SSH ================
alias ssh1="ssh xserver@192.168.3.4 -v"


# =========== Git ===========
alias gaa="git add --all"
alias gc="git commit -m "
alias gs="git status"

# Pull current branch
alias glb="git pull origin \$(git rev-parse --abbrev-ref HEAD)"

# Push current branch
alias gpb="git push origin \$(git rev-parse --abbrev-ref HEAD)"

# Start mongo service
alias mongoplay="sudo service mongod start"

# Move files to trash
alias srm='safe-rm'


# ============ DISKS ===============
alias mountmsi="sudo mkdir -p /mnt/msi_storage && sudo mount /dev/sdb1 /mnt/msi_storage"


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

# =========== NETWORK ======================
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep '^192' | awk 'BEGIN {ORS=\" | \"} {print}' | sed 's/ | $//'"

# Which apps are running on which ports
alias ports="sudo lsof -iTCP -sTCP:LISTEN -n -P | grep -vE 'rapportd|ControlCe|LogiMgrDa'"


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



## ============ GITHUB CLI ============
alias gha="cat ~/.dotfiles/shell/aliases.sh | grep -E 'gh|promote|pr|repo' | bat $1 -l=sh --style=plain,grid --wrap=never"

# Promote
alias promote2stage="gh workflow run promote.yml --ref develop  -f env='develop to stage'"
alias promote2preprod="gh workflow run promote.yml --ref stage  -f env='stage to preprod'"
alias promote2prod="gh workflow run promote.yml --ref preprod  -f env='preprod to prod'"

# PRs
alias prview="gh pr view --web"
alias prcreate="gh pr create --web"
alias prapprove="gh pr review --approve "

# Actions(Workflows)
alias actions="gh workflow view --web"

# Repo
alias repo="gh repo view --web"

# termbin
alias tb="nc termbin.com 9999"


## =============== DOCKER ===================
# alias docker="docker"

alias lzd="lazydocker"

alias "docker-compose"="docker compose"


## ======= CLI APPS =======
alias nvm="fnm"
alias ncu2="npm-check -u"

