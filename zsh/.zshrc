# --- init ---

# base path
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/usr/local/sbin:/sbin:/opt/X11/bin:/Library/Frameworks/Mono.framework/Versions/Current/Commands:$PATH"

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
alias files="ranger $HOME"
alias refresh="source $HOME/.zshrc"
alias ws="$HOME/Code"

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
export PATH="/usr/local/go/bin:$PATH"

# homebrew (mainly fixes rsync)
if [[ `uname` == 'Darwin' ]]; then
    export PATH="/usr/bin/local:$PATH"
fi

# neovim
alias vi="NVIM_TUI_ENABLE_TRUE_COLOR=1 nvim"

# nvm
export NVM_DIR="$HOME/.nvm"
#alias loadnvm='[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"'

# python
alias ae="deactivate &> /dev/null; source ./env/bin/activate"
alias de="deactivate &> /dev/null"
alias venv="virtualenv --python=$(which python3) env && ae"

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# rust
export PATH="$HOME/.cargo/bin:$PATH"

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
fi

# xorg
if [[ `uname` == 'Linux' ]]; then
  if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ]; then
    exec startx
  fi
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
