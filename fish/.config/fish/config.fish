set -xg PATH /bin /sbin /usr/local/bin /usr/bin /usr/sbin /usr/local/sbin /opt/X11/bin $PATH

if string match -q '*microsoft*' -- (uname -r)
    set OPSYS "windows"
else
    set OPSYS (string lower (uname))
end

set -x WORKSPACE "$HOME/Code"

set -x CONFIG_FILE    "$HOME/.config/fish/config.fish"
set -x CONFIG_SRC     "$HOME/.config/fish/config.org"
set -x EDITOR         (command -v nvim)
set -x GPG_TTY        (tty)
set -x LANGUAGE       "en_NZ:en"
set -x LAST_MODIFIED  "(date)"

if test $OPSYS = "windows"
    set -x DISPLAY (cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0 # (1)
    set -x BROWSER "/mnt/c/Windows/explorer.exe" # (2)
end

alias scut="abbr -a -g"

set -x ASDF_DIR $HOME/.asdf
if test -e $ASDF_DIR
    source $ASDF_DIR/asdf.fish
    if not test -e $HOME/.config/fish/completions
        mkdir -p $HOME/.config/fish/completions; and cp $HOME/.asdf/completions/asdf.fish $HOME/.config/fish/completions # (2)
    end
end

set -x DROPBOX_DIR $HOME/Dropbox

git config --global user.name "Marcus Crane"
git config --global user.email "marcus@utf9k.net"

if test $OPSYS = "darwin"
    set -xg PATH /usr/bin/local $PATH
end

set -x KERL_CONFIGURE_OPTIONS "--disable-debug --without-javac"
set -x KERL_BUILD_DOCS        "yes"

set -x GOPATH      "$WORKSPACE/go"
set -x PATH        $GOPATH/bin $GOROOT $PATH
set -x GO111MODULE on

if test -e $HOME/.work_aliases.fish
    source $HOME/.work_aliases.fish
end

scut ae      "deactivate &> /dev/null; source ./venv/bin/activate"
scut de      "deactivate &> /dev/null"
scut edit    "$EDITOR $CONFIG_SRC"
scut gb      "git branch -v"
scut gcm     "git commit -Si"
scut gr      "git remote -v"
scut gst     "git status"
scut pap     "git pull upstream master && git push origin master"
scut refresh "tangle $CONFIG_SRC && stow fish -d $HOME/dotfiles && source $CONFIG_FILE"
scut venv    "python3 -m virtualenv venv && ae"
scut vi      "nvim"
scut view    "less $CONFIG_FILE"
scut vim     "nvim"
scut ws      "cd $WORKSPACE"
