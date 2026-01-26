source ~/.dotfiles/utils/utils.sh

alias code="cursor"

alias vi="vim"
# alias vim="nvim"

# ========= Fast switching directories ===========
alias dotfiles="cd ~/.dotfiles"
alias repos="cd ~/coding/repos"
alias coding="cd ~/coding"
alias oss="cd ~/coding/oss"
alias downloads="cd ~/Downloads"
alias Downloads="cd ~/Downloads"

alias numbers='open -a "Numbers" '

# ===== Alias to download music with shira ====
alias mdl='shiradl -c "./music.youtube.com_cookies.txt" -i 141'
alias mdln='shiradl -c "./music.youtube.com_cookies.txt"'

# ====== Counters ==============
alias count_deep_files='find . -type f \( -iname "*.mp3" -o -iname "*.wav" -o -iname "*.m4a" -o -iname "*.flac" \) | wc -l'



# Bat

# if linux set alias bat="batcat"
if [[ "$IS_LINUX" == "true" ]]; then
  alias bat="batcat"
fi

# Config files aliases
alias zshrc="vi ~/.zshrc"
alias bashrc="vi ~/.bashrc"
alias vimrc="vi ~/.vimrc"
alias gitconfig="vi ~/.gitconfig"
alias tmuxconf="vi ~/.tmux.conf"
alias inputrc="vi ~/.inputrc"
alias aliases="vi ~/.dotfiles/shell/aliases.sh"
alias functions="vi ~/.dotfiles/shell/functions.sh"
alias ghostty_config="vi ~/.config/ghostty/config"
alias zimrc="vi ~/.zimrc"
alias nvimvonfig="vim ~/.config/nvim/init.lua"


alias readme="bat README.md"

# Interactive git branch switcher. Order by last commit date(most recent branches).
alias branch="git branch -v --sort=-refname --sort=-committerdate | fzf --height=20% --reverse | sed 's/^..//' | awk '{ print \$1 }' | xargs git checkout"

alias dotfiles_backup="~/.dotfiles/utils/dotfiles_backup.sh"
alias dotfiles_import="~/.dotfiles/utils/dotfiles_import.sh"


# =========== SSH ================
alias ssh1="ssh x@192.168.3.4 -v"


# =========== Git ===========
alias lg="lazygit"
alias gaa="git add --all"
alias gc="git commit -m "
alias gs="git status"
alias gd="git diff"

alias gl="git log"
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
alias tma="tmux attach"
alias tmat="tmux attach -t"
alias tml="tmux ls"
alias tmls="tmux ls"
alias tmks="tmux kill-session -t "

# =========== Node.js ===========
alias scripts="jq '.scripts' package.json"
alias deps="jq '.dependencies' package.json"
alias engines="jq '.engines' package.json"
alias devs="jq '.devDependencies' package.json"
alias version="jq '.version' package.json"
alias node_modules_sizes="du -sm node_modules/* | sort -nr | awk '{printf \"%-10s %s\n\", $1 \"MB\", $2}'"

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
# alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip='ip -4 addr show scope global \
  | awk '\''{print $2}'\'' \
  | cut -d/ -f1 \
  | grep '\''^192\.168\.'\'' \
  | paste -sd " | " -'

# Which apps are running on which ports
alias ports="sudo lsof -iTCP -sTCP:LISTEN -n -P | grep -vE 'rapportd|ControlCe|LogiMgrDa'"


alias reload="exec ${SHELL} -l"
# alias reload="exec zsh"

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

alias "compose"="docker compose"


## ======= CLI APPS =======
alias nvm="fnm"
alias ncu2="npm-check -u"

