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


alias gaa="git add"

## Pull
alias gl="git pull"
alias glb="git pull origin \$(git rev-parse --abbrev-ref HEAD)"

# Push current branch
alias gp="git push"
alias gpb="git push origin \$(git rev-parse --abbrev-ref HEAD)"

# Copy default ssh
alias cpssh="xclip -sel clip < ~/.ssh/id_rsa.pub"

# Start mongo service
alias mongoplay="sudo service mongod start"

# Move files to trash
alias srm='safe-rm'

alias chrome='google-chrome'

# NodeJS
alias scripts="jq '.scripts' package.json"
alias deps="jq '.dependencies' package.json"                                                                                          
alias devs="jq '.devDependencies' package.json"

# Common npm & yarn aliases
alias ns="npm start"
alias nb="npm run build"
alias nrs="npm run serve"
alias nrd="npm run dev"
alias nbs="npm run build && npm run serve"
alias nt="npm t"
alias y="yarn"
alias ya="yarn add"
alias yad="yarn add -D"
alias yr="yarn remove"
alias yag"yarn global add"
alias ys="yarn start"
alias yd="yarn dev"
alias yb="yarn build"
alias yi="yarn install"
alias ts="ts-node"

alias files="nautilus"

alias zshrc="vim ~/.zshrc"
alias vimrc="vim ~/.vimrc"

# List folders
alias t="tree -I 'node_modules|.database|.db|.cache|cache'"


# OS
alias free="free -h"

# bat
alias bat="batcat"

# Execute velocity configuration 
alias mouse="~/mouse.sh"
alias code.="code ."

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
