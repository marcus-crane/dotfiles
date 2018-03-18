#--- init ---

# base path
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/usr/local/sbin:/sbin:/opt/X11/bin:/Library/Frameworks/Mono.framework/Versions/Current/Commands:$HOME/.local/bin:$PATH"

# oh-my-zsh install path
export ZSH=$HOME/.oh-my-zsh

# theme
ZSH_THEME="robbyrussell"

# defaults
source $ZSH/oh-my-zsh.sh

# set editor
export EDITOR=$(which nvim)

# --- user ---

# aliases
alias cp="sudo rsync -av --info=progress2"
alias edit="vi ~/.zshrc"
alias files="ranger ~"
alias refresh="source ~/.zshrc"

if [[ $(uname -r) == *'Microsoft' ]]; then
  alias ws="/mnt/c/dev/"
else
  alias ws="~/Code"
fi

# docker (see https://blog.jayway.com/2017/04/19/running-docker-on-bash-on-windows/)
if [[ $(which docker) && $(uname -r) == *'Microsoft' ]]; then
  export DOCKER_HOST='tcp://0.0.0.0:2375'
fi

# daemons
if [[ `uname` == 'Linux' ]]; then
  alias restart="sudo systemctl restart"
fi

# django
alias run="ae && python manage.py runserver"

# git
alias gcm="git commit -S -m"
alias gst="git status"

# go
if [[ $(uname -r) == *'Microsoft' ]]; then
  export GOROOT=/usr/local/go
  export GOPATH=/mnt/c/dev/go
else
  export GOPATH=~/Code/Go
fi
export PATH=$GOROOT/bin:$GOPATH:$PATH

# homebrew (mainly fixes rsync)
if [[ `uname` == 'Darwin' ]]; then
  export PATH="/usr/bin/local:$PATH"
fi

# n (node version manager)
export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"

# neovim
alias vi="NVIM_TUI_ENABLE_TRUE_COLOR=1 nvim"

# python
alias ae="deactivate &> /dev/null; source ./env/bin/activate"
alias de="deactivate &> /dev/null"
alias python="$(which python3)"
alias pip="$(which pip3)"
alias venv="python -m virtualenv env && ae"

# ssh
alias ai="ssh sentry@ai"
alias kaze="ssh sentry@kaze"
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

# xorg
if [[ `uname` == 'Linux' ]]; then
  if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
    exec startx
  fi
fi
