alias v="vim"
alias g="git"
alias ga="git add"
alias gc="git commit -m"
alias gs="git status"
alias gd="git diff"
alias gf="git fetch"
alias gm="git merge"
alias gr="git rebase"
alias gp="git push"
alias gu="git unstage"
alias disks='echo "╓───── m o u n t . p o i n t s"; echo "╙────────────────────────────────────── ─ ─ "; lsblk -a; echo ""; echo "╓───── d i s k . u s a g e"; echo "╙────────────────────────────────────── ─ ─ "; df -h;'

# Copy default ssh
alias cpssh="xclip -sel clip < ~/.ssh/id_rsa.pub"

# Start mongo service
alias mongoplay="sudo service mongod start"

# Move files to trash
alias srm='safe-rm'

alias chrome='google-chrome'

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

alias srm='safe-rm'

alias zshrc="vim ~/.zshrc"
alias vimrc="vim ~/.vimrc"
