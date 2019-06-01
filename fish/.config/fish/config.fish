##################
# initialisation #
##################

# NOTE: I've ported my Windows bits and pieces over but I haven't used them yet
# Consider this my best guess at what they would look like in fish but don't
# expect them to actually work

# base path
set -xg PATH /usr/local/bin /usr/bin /bin /usr/sbin /sbin /usr/local/MagGPG2/bin /usr/local/sbin /opt/X11/bin $PATH

# set $os to contain operating system name (mainly checking for wsl)
if string match -q "*Microsoft*" -- (uname -a)
  set os "windows"
else
  set os (string lower (uname))
end

# set workspace based on operating system
if test $os = "windows"
  set WORKSPACE "/mnt/c/dev"
else
  set WORKSPACE $HOME/Code
end

# constants
set CONFIG_FILE $HOME/.config/fish/config.fish
set FUNCTION_FOLDER $HOME/.config/fish/functions
set EDITOR nvim
set WORKSPACE $HOME/Code

# general
alias scut="abbr -a -g"

################
# applications #
################

# asdf
if test $os = "darwin"
  set -x ASDF_DIR (brew --prefix asdf) # gets around a macos mojave bug as mentioned in (3)
else
  set -x ASDF_DIR $HOME/.asdf
end
source $ASDF_DIR/asdf.fish

# docker
if type docker -q; and test $os = "windows"
  set -x DOCKER_HOST "tcp://0.0.0.0:2375" # (2)
end
if type docker -q; and test $os = "linux"; and dmesg | grep "Hypervisor" > /dev/null; and test $status = 0
  set -x DOCKER_HOST "unix:///var/run/docker.sock" # fixes docker not resolving requests to the outside world ie; pulling base images from docker hub
end

# erlang
set -xg KERL_CONFIGURE_OPTIONS "--disable-debug --without-javac"
set -xg KERL_BUILD_DOCS yes

# git
git config --global user.email "marcus@utf9k.net"
git config --global user.name "Marcus Crane"

# go
set -xg GOPATH "$WORKSPACE/go"
set -xg GOROOT (asdf where golang)/go   # set whatever asdf decides except which go points to a binary instead of entire directory
set -xg PATH $GOPATH/bin $GOROOT $PATH

# homebrew (mainly fixes rsync)
if test $os = "darwin"
  set PATH /usr/bin/local $PATH
end

# python
set -xg PATH (asdf where python)/bin $PATH
eval (python -m virtualfish)

# work related aliases
if test -f $HOME/.work_aliases.fish
  . $HOME/.work_aliases.fish
end

#############
# shortcuts #
#############

scut ae          "vf activate (basename $PWD)"
scut bp          "bpython3"
scut de          "vf deactivate"
scut edit        "vi $CONFIG_FILE"
scut gcm         "git commit -Si"
scut gitskip     "git update-index --no-skip-worktree" # (1)
scut gpom        "git pull origin master"
scut gpum        "git pull upstream master"
scut gst         "git status"
scut ls          "exa"
scut powershell  "/usr/local/bin/pwsh"
scut refresh     ". $CONFIG_FILE"
scut venv        "vf new (basename $PWD)"
scut vi          "nvim"
scut view        "less $CONFIG_FILE"
scut vim         "nvim"
scut ws          "cd $WORKSPACE"

##############
# references #
##############

# (1) https://stackoverflow.com/questions/3319479/can-i-git-commit-a-file-and-ignore-its-content-changes
# (2) https://blog.jayway.com/2017/04/19/running-docker-on-bash-on-windows/
# (3) https://github.com/asdf-vm/asdf/issues/425#issuecomment-459751694
