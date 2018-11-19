# constants
if [[ $(uname -r) == *'Microsoft' ]]; then
  export DEV_FOLDER="/mnt/c/dev"
else
  export DEV_FOLDER="~/Code"
fi

# general
alias edit="nvim ~/.bash_aliases"
alias refresh="source ~/.bashrc"
alias ws="cd $DEV_FOLDER"

# docker
if [[ $(which docker) && $(uname -r) == *'Microsoft' ]]; then
  export DOCKER_HOST='tcp://0.0.0.0:2375'
fi

# git
alias gcm="git commit -S -m"
alias gpom="git pull origin master"
alias gpum="git pull upstream master"
alias gst="git status"
alias gitskip="git update-index --no-skip-worktree"

# go
if [[ $(uname -r) == *'Microsoft' ]]; then
  export GOROOT=/usr/local/go
else
  export GOROOT=/usr/local/Cellar/go/1.10.1/libexec
fi
export GOPATH="$DEV_FOLDER/go"
export PATH=$GOROOT/bin:$GOPATH:$PATH

# homebrew (mainly fixes rsync)
if [[ `uname` == 'Darwin' ]]; then
  export PATH="/usr/bin/local:$PATH"
fi

# neovim
alias vi="nvim"
alias vim="nvim"

# powershell
alias powershell="/usr/local/bin/pwsh"

# python
alias ae="deactivate &> /dev/null; source ./venv/bin/activate"
alias de="deactivate &> /dev/null"
alias venv="python3 -m virtualenv venv && ae"

# ssh
alias kaze="ssh sentry@kaze"
alias magus="ssh marcus@magus"
alias magus-remote="ssh marcus@magus-remote"
alias makenshi="ssh sentry@makenshi"

# trash
if [[ `uname` == 'Darwin' ]]; then
  alias rm="trash"
fi

# windows for linux (wsl) subsystem
if [[ $(uname -r) == *'Microsoft' ]]; then
  alias open="wsl-open"
  alias win="/mnt/c/Users/marcus.crane"
fi

# xero
source ~/.work_aliases

# xorg
if [[ `uname` == 'Linux' ]]; then
  if [ -z "DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
    exec startx
  fi
fi
