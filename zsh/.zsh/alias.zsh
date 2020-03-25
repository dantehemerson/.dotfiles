alias v="vim"

alias g="git"
alias ga="git add"
alias gc="git commit -m"
alias gs="git status"
alias gd="git diff"
alias gf="git fetch"
alias gm="git merge"
alias gr="git rebase"
alias gu="git unstage"

## Migrate to
alias gl="git pull"
alias glb="git pull origin \$(git rev-parse --abbrev-ref HEAD)"

# Push current branch
alias gp="git push"
alias gpb="git push origin \$(git rev-parse --abbrev-ref HEAD)"

alias disks='echo "╓───── m o u n t . p o i n t s"; echo "╙────────────────────────────────────── ─ ─ "; lsblk -a; echo ""; echo "╓───── d i s k . u s a g e"; echo "╙────────────────────────────────────── ─ ─ "; df -h;'

# Copy default ssh
alias cpssh="xclip -sel clip < ~/.ssh/id_rsa.pub"

# Start mongo service
alias mongoplay="sudo service mongod start"

# Move files to trash
alias srm='safe-rm'

alias chrome='google-chrome'

# NodeJS
alias scripts="jq '.scripts' package.json"

# Common npm & yarn aliases
alias ns="npm start"
alias nb="npm run build"
alias nrs="npm run serve"
alias nrd="npm run dev"
alias nbs="npm run build && npm run serve"
alias nt="npm t"
alias ys="yarn start"
alias yb="yarn build"
alias yi="yarn install"

alias files="nautilus"

alias zshrc="vim ~/.zshrc"
alias vimrc="vim ~/.vimrc"

# Execute velocity configuration 
alias mouse="~/mouse.sh"
alias code.="code ."

alias reload="exec ${SHELL} -l"

# cd shorcuts
alias cd..="cd .."
alias cd...="cd ..."
alias cd....="cd ...."
alias cd.....="cd ....."
alias cd......="cd ......"
alias cd.......="cd ......."
