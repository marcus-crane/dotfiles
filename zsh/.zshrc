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
plugins=(brew cask command-not-found docker encode64 git httpie npm osx sublime sudo urltools vscode)

# --- user ---

# aliasing
alias edit="vi ~/.zshrc"
alias files="ranger ~"
alias refresh="source ~/.zshrc"
alias ws="~/Code"

# aliasing overrides (different platforms)
if [[ $(uname -r) == *'Microsoft' ]]; then
  alias ws="/mnt/c/dev/"
fi

# docker (see https://blog.jayway.com/2017/04/19/running-docker-on-bash-on-windows/)
if [[ $(which docker) && $(uname -r) == *'Microsoft' ]]; then
  export DOCKER_HOST='tcp://0.0.0.0:2375'
fi

# git
alias gcm="git commit -S -m"
alias gpom="git pull origin master"
alias gpum="git pull upstream master"
alias gst="git status"
## https://stackoverflow.com/questions/3319479/can-i-git-commit-a-file-and-ignore-its-content-changes
alias gitskip="git update-index --no-skip-worktree"

# go
if [[ $(uname -r) == *'Microsoft' ]]; then
  export GOROOT=/usr/local/go
  export GOPATH=/mnt/c/dev/go
else
  export GOROOT=/usr/local/Cellar/go/1.10.1/libexec 
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
alias vi="nvim"

# powershell
alias powershell="/usr/local/bin/pwsh"

# pyenv
eval "$(pyenv init -)"

# python
alias ae="deactivate &> /dev/null; source ./venv/bin/activate"
alias de="deactivate &> /dev/null"
alias venv="python3 -m virtualenv venv && ae"

# rbenv
eval "$(rbenv init -)"

# serverless
[[ -f /Users/marcus.crane/n/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh ]] && . /Users/marcus.crane/n/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh
[[ -f /Users/marcus.crane/n/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh ]] && . /Users/marcus.crane/n/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh

# ssh
alias kaze="ssh sentry@kaze"
alias magus="ssh marcus@magus"
alias magus-remote="ssh marcus@magus-remote"
alias makenshi="ssh sentry@makenshi"
alias site='eval "$(docker-machine env site)"'

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
  if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
    exec startx
  fi
fi

# yarn
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
