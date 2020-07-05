set -xg PATH /usr/local/bin /usr/bin /usr/sbin /sbin /bin /usr/local/sbin /opt/X11/bin $PATH

set -xg PATH /usr/local/opt /Applications/Emacs.app/Contents/MacOS/bin /Applications/Emacs.app/Contents/MacOS $PATH

if string match -q '*microsoft*' -- (uname -r)
    set OPSYS "windows"
else
    set OPSYS (string lower (uname))
end

set -x WORKSPACE ~/Code

set -x CONFIG_FILE ~/.config/fish/config.fish
set -x CONFIG_SRC  ~/.config/fish/config.org
set -x EDITOR      (command -v emacs)client -c # (1)
set -x GPG_TTY     (tty)
set -x LANGUAGE    "en_NZ:en"
set -x LC_ALL      "en_NZ.UTF-8"

if test $OPSYS = "windows"
    set -x DISPLAY (cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0 # (1)
    set -x BROWSER "/mnt/c/Windows/explorer.exe" # (2)
end

alias scut="abbr -a -g"

if test $OPSYS = "darwin"
    set -x ASDF_DIR (brew --prefix asdf) # (1)
else
    set -x ASDF_DIR ~/.asdf
end
if test -e $ASDF_DIR
    source $ASDF/asdf.fish
    if ! test -e ~/.config/fish/completions
        mkdir -p ~/.config/fish/completions; and cp ~/.asdf/completions/asdf.fish ~/.config/fish/completions # (2)
    end
end

if test $OPSYS = "windows"; and test $NAME != "epitaph"
    set -x DROPBOX_DIR /mnt/c/Users/marcus.crane/Dropbox
else
    set -x DROPBOX_DIR ~/Dropbox
end

scut ec $EDITOR

set -x KERL_CONFIGURE_OPTIONS "--disable-debug --without-javac"
set -x KERL_BUILD_DOCS "yes"

git config --global user.name "Marcus Crane"
git config --global user.email "marcus@utf9k.net"

set -x GOPATH $WORKSPACE/go
if test -e $ASDF_DIR
    set -x GOROOT (asdf where golang)/go
end
set -xg PATH $GOPATH/bin $GOROOT $PATH

if test $OPSYS = "darwin"
    set -xg PATH /usr/bin/local $PATH
end

if test -e $ASDF_DIR
    set -xg PATH (asdf where python)/bin $PATH
end

if test -e $ASDF_DIR
    set -xg PATH (asdf where rust)/bin $PATH
end

scut ae      "deactivate &> /dev/null; source ./venv/bin/activate"
scut de      "deactivate &> /dev/null"
scut edit    "$EDITOR $CONFIG_SRC"
scut gb      "git branch -v"
scut gcm     "git commit -Si"
scut gr      "git remote -v"
scut gst     "git status"
scut pap     "git pull upstream master && git push origin master"
scut refresh "tangle-file $CONFIG_SRC && source $CONFIG_FILE"
scut venv    "python3 -m virtualenv venv && ae"
scut vi      "nvim"
scut view    "less $CONFIG_FILE"
scut vim     "nvim"
scut ws      "cd $WORKSPACE"
