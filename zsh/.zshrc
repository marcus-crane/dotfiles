##################
# initialisation #
##################

# base path
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/usr/local/sbin:/sbin:/opt/X11/bin:/usr/local/opt/:$PATH"

# set $OPSYS to be a lowercased os name (mainly for checking if inside wsl)
if [[ "*Microsft*" == $(uname -a) ]]; then
  export OPSYS="windows"
else
  export OPSYS=${(L)$(uname -s)}
fi

# set workspace based on current operating system
if [[ $OPSYS == "windows" ]]; then
  export WORKSPACE="/mnt/c/dev"
else
  export WORKSPACE="$HOME/Code"
fi

# constants
export CONFIG_FILE="$HOME/.zshrc"
export EDITOR=$(command -v nvim)
export LC_ALL=en_NZ.UTF-8
export PROMPT='%B%F{green}>%f%b '

################
# applications #
################

# asdf
if [[ $OPSYS == "darwin" ]]; then
  export ASDF_DIR=/usr/local/opt/asdf
else
  export ASDF_DIR=$HOME/.asdf
fi
. $ASDF_DIR/asdf.sh

# erlang
export KERL_CONFIGURE_OPTIONS="--disable-debug --without-javac"
export KERL_BUILD_DOCS="yes"

# git
git config --global user.email "marcus@utf9k.net"
git config --global user.name "Marcus Crane"

# go
export GOPATH="$WORKSPACE/go"
export GOROOT="$(asdf where golang)/go"
export PATH=$GOPATH/bin:$GOROOT:$PATH

# homebrew (mainly fixes rsync)
if [[ $OPSYS == "darwin" ]]; then
  export PATH="/usr/bin/local:$PATH"
fi

# python
export PATH=$(asdf where python)/bin:$PATH

# trash
if [[ $OPSYS == "darwin" ]]; then
  alias rm="trash"
fi

# work related aliases
if [[ -a "$HOME/.work_aliases" ]]; then
  . "$HOME/.work_aliases"
fi


#############
# shortcuts #
#############

alias ae="deactivate &> /dev/null; source ./venv/bin/activate"
alias de="deactivate &> /dev/null"
alias edit="nvim $CONFIG_FILE"
alias gb="git branch -v"
alias gcm="git commit -Si"
alias gitskip="git update-index --no-skip-worktree" # (1)
alias gpom="git pull origin master"
alias gpum="git pull upstream master"
alias gr="git remote -v"
alias gst="git status"
alias lcrash="docker logs $(docker ps -alq)"
alias ls="exa"
alias pap="git pull upstream master && git push origin master"
alias powershell="/usr/local/bin/pwsh"
alias refresh=". $CONFIG_FILE"
alias venv="python3 -m virtualenv venv && ae"
alias vi="nvim"
alias view="less $CONFIG_FILE"
alias vim="nvim"
alias ws="cd $WORKSPACE"

##############
# references #
##############

# (1) https://stackoverflow.com/questions/3319479/can-i-git-commit-a-file-and-ignore-its-content-changes
# (2) https://blog.jayway.com/2017/04/19/running-docker-on-bash-on-windows/
