#--- init ---

# base path
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/usr/local/sbin:/sbin:/opt/X11/bin:/Library/Frameworks/Mono.framework/Versions/Current/Commands:$HOME/.local/bin:$PATH"

# oh-my-zsh install path
export ZSH=$HOME/.oh-my-zsh

# theme
ZSH_THEME="af-magic"

# defaults
source $ZSH/oh-my-zsh.sh

# set editor
export EDITOR=$(which nvim)

# locale
export LC_ALL=en_NZ.UTF-8

# plugins
plugins=()

# --- user ---

# constants
if [[ $(uname -r) == *'Microsoft' ]]; then
  export DEV_FOLDER="/mnt/c/dev"
else
  export DEV_FOLDER="~/Code"
fi

# general
alias edit="vi ~/.zshrc"
alias refresh="source ~/.zshrc"
alias vol="alsamixer -c 1"
alias ws="cd $DEV_FOLDER"

# docker (see https://blog.jayway.com/2017/04/19/running-docker-on-bash-on-windows/)
if [[ $(which docker) && $(uname -r) == *'Microsoft' ]]; then
  export DOCKER_HOST='tcp://0.0.0.0:2375'
fi

# git
alias gcm="git commit -S -m"
alias gpom="git pull origin master"
alias gpum="git pull upstream master"
alias gst="git status"
alias gitskip="git update-index --no-skip-worktree" ## https://stackoverflow.com/questions/3319479/can-i-git-commit-a-file-and-ignore-its-content-changes

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

# n (node version manager)
export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"

# neovim
alias vi="nvim"
alias vim="nvim"

# powershell
alias powershell="/usr/local/bin/pwsh"

# pyenv
export PATH="$HOME/.pyenv/bin:$PATH"
if command -v pyenv 1> /dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# python
alias ae="deactivate &> /dev/null; source ./venv/bin/activate"
alias de="deactivate &> /dev/null"
alias venv="python3 -m virtualenv venv && ae"

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
if command -v rbenv 1> /dev/null 2>&1; then
  eval "$(rbenv init -)"
fi

# serverless
[[ -f /Users/marcus.crane/n/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh ]] && . /Users/marcus.crane/n/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh
[[ -f /Users/marcus.crane/n/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh ]] && . /Users/marcus.crane/n/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh

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

# work related aliases
if [[ -a ~/.work_aliases ]]; then
  source ~/.work_aliases
fi

# xorg
if [[ `uname` == 'Linux' ]]; then
  if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
    exec startx
  fi
fi

# yarn
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
