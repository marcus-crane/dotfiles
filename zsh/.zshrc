##################
# initialisation #
##################

# base path
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/usr/local/sbin:/sbin:/opt/X11/bin:/usr/local/opt/:$HOME/.emacs.d/bin:/Applications/Emacs.app/Contents/MacOS/bin:/Applications/Emacs.app/Contents/MacOS:$PATH"

# set $OPSYS to be a lowercased os name (mainly for checking if inside wsl)
if [[ $(uname -r) =~ 'microsoft' ]]; then
  export OPSYS="windows"
else
  export OPSYS=${(L)$(uname -s)}
fi

# set workspace
export WORKSPACE="$HOME/Code"

# constants
export CONFIG_FILE="$HOME/.zshrc"
export EDITOR="$(command -v emacs)client -c" # (emacsclient)
export GPG_TTY=$(tty) # (gpgwsl)
export LANGUAGE="en_NZ:en"
export LC_ALL="en_NZ.UTF-8"
export PROMPT='%B%F{green}>%f%b '

if [[ $OPSYS == "windows" ]]; then
   export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0 # (disp)
   export BROWSER="/mnt/c/Windows/explorer.exe" # (wslbrowser)
fi

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

# dropbox // changes based on which computer i'm at

if [[ $OPSYS == "windows" && $NAME == "epitaph" ]]; then
  export DROPBOX_DIR=$HOME/Dropbox
fi

if [[ $OPSYS == "windows" && $NAME != "epitaph" ]]; then
  export DROPBOX_DIR=/mnt/c/Users/marcus.crane/Dropbox
fi

if [[ ! $OPSYS == "windows" ]]; then
  export DROPBOX_DIR=$HOME/Dropbox
fi

# emacs
alias ec=$EDITOR

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

# macos
if [[ $OPSYS == "darwin" ]]; then
  export PATH="/usr/local/opt/openssl/bin:$PATH" # (kerlmacos)
fi

# python
export PATH=$(asdf where python)/bin:$PATH

# rust
export PATH=$(asdf where rust)/bin:$PATH

# work related aliases
if [[ -a "$HOME/.work_aliases" ]]; then
  . "$HOME/.work_aliases"
fi

#############
# shortcuts #
#############

alias ae="deactivate &> /dev/null; source ./venv/bin/activate"
alias de="deactivate &> /dev/null"
alias dsync="cd ~/dotfiles && git add -i && gcm && git push && cd - && refresh"
alias edit="$EDITOR $CONFIG_FILE"
alias gb="git branch -v"
alias gbd="git branch -D"
alias gbm="git checkout master"
alias gcm="git commit -Si"
alias gitskip="git update-index --no-skip-worktree" # (emptycommit)
alias gpom="git pull origin master"
alias gpum="git pull upstream master"
alias gr="git remote -v"
alias gst="git status"
alias pap="git pull upstream master && git push origin master"
alias powershell="/usr/local/bin/pwsh"
alias refresh=". $CONFIG_FILE"
alias venv="python3 -m virtualenv venv && ae"
alias vi="nvim"
alias view="less $CONFIG_FILE"
alias vim="nvim"
alias ws="cd $WORKSPACE"

#############
# functions #
#############

function whomport() { lsof -nP -i4TCP:$1 | grep LISTEN }

function tangle-file() {
  emacs --batch -l org $@ -f org-babel-tangle
}

##############
# references #
##############

# (emptycommit) https://stackoverflow.com/questions/3319479/can-i-git-commit-a-file-and-ignore-its-content-changes
# (gpgwsl) This allows the GPG prompt to appear when using WSL.
#     Without it, a "gpg: signing failed: Inappropriate ioctl for device" error is thrown.
#       - https://github.com/microsoft/WSL/issues/4029
#       - https://www.gnupg.org/(it)/documentation/manuals/gnupg/Common-Problems.html
#       - https://www.gnupg.org/documentation/manuals/gnupg/Invoking-GPG_002dAGENT.html#Invoking-GPG_002dAGENT
# (kerlmacos) Fixes compilation issues with Erlang on macOS
#       - https://github.com/kerl/kerl/issues/226
# (disp) This allows X11 supported programs (ie Emacs) to render on my Windows desktop, rather than inside a terminal
#     I use the Windows Terminal currently which doesn't support key passthrough for Ctrl + Shift + <key> for example
#     You can read more about this setup here: https://utf9k.net/blog/emacs-wsl2-install/
# (emacsclient) On some devices, I compile Emacs only to find that the emacs executable exists in my PATH but emacsclient
#               may not. Weirdly enough, that shouldn't be the case. Anyway, generally they live side by side so as a quick
#               hack, I just append "client" to the end of the emacs location in case it's not able to be resolved.
#               I'll definitely need to fix this shortly
# (wslbrowser) In order to open links in my host browser, explorer.exe receives links and forwards them to the default host browser
