##################
# initialisation #
##################

# base path
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/usr/local/sbin:/sbin:/opt/X11/bin:/usr/local/opt/:$PATH"

# set $OPSYS to be a lowercased os name (mainly for checking if inside wsl)
if [[ $(uname -a) =~ 'Microsoft' ]]; then
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
export GPG_TTY=$(tty) # (3)
export LANGUAGE="en_NZ:en"
export LC_ALL="en_NZ.UTF-8"
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

# docker
if [[ $OPSYS == "windows" ]]; then
  export DOCKER_HOST='tcp://0.0.0.0:2375' # (4)
fi

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
  export PATH="/usr/local/opt/openssl/bin:$PATH" # (6)
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

# yarn
export PATH=$(yarn global bin):$PATH


#############
# shortcuts #
#############

alias ae="deactivate &> /dev/null; source ./venv/bin/activate"
alias de="deactivate &> /dev/null"
alias dsync="cd ~/dotfiles && git add -i && gcm && git push && cd - && refresh"
alias edit="nvim $CONFIG_FILE"
alias gb="git branch -v"
alias gbd="git branch -D"
alias gbm="git checkout master"
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

#############
# functions #
#############

if [[ $OPSYS == "windows" ]]; then # (5)
  function oclip() { pass otp $1 | clip.exe }
  function pclip() { pass show $1 | head -n 1 | clip.exe }
fi

function whomport() { lsof -nP -i4TCP:$1 | grep LISTEN }

##################
## colour scheme #
##################

export LS_COLORS="or=0;38;2;0;0;0;48;2;255;92;87:ln=0;38;2;255;106;193:fi=0:pi=0;38;2;0;0;0;48;2;87;199;255:*~=0;38;2;102;102;102:no=0:mi=0;38;2;0;0;0;48;2;255;92;87:so=0;38;2;0;0;0;48;2;255;106;193:ex=1;38;2;255;92;87:di=0;38;2;87;199;255:*.z=4;38;2;154;237;254:*.p=0;38;2;90;247;142:*.o=0;38;2;102;102;102:*.a=1;38;2;255;92;87:*.t=0;38;2;90;247;142:*.h=0;38;2;90;247;142:*.m=0;38;2;90;247;142:*.c=0;38;2;90;247;142:*.d=0;38;2;90;247;142:*.r=0;38;2;90;247;142:*.fs=0;38;2;90;247;142:*.cc=0;38;2;90;247;142:*.go=0;38;2;90;247;142:*.js=0;38;2;90;247;142:*.hi=0;38;2;102;102;102:*.bz=4;38;2;154;237;254:*.cs=0;38;2;90;247;142:*.cr=0;38;2;90;247;142:*.di=0;38;2;90;247;142:*.7z=4;38;2;154;237;254:*.vb=0;38;2;90;247;142:*.md=0;38;2;243;249;157:*.hs=0;38;2;90;247;142:*.pl=0;38;2;90;247;142:*.ui=0;38;2;243;249;157:*.la=0;38;2;102;102;102:*.rm=0;38;2;255;180;223:*.pp=0;38;2;90;247;142:*.mn=0;38;2;90;247;142:*.as=0;38;2;90;247;142:*.so=1;38;2;255;92;87:*.rb=0;38;2;90;247;142:*.pm=0;38;2;90;247;142:*.rs=0;38;2;90;247;142:*.el=0;38;2;90;247;142:*.sh=0;38;2;90;247;142:*.ts=0;38;2;90;247;142:*.cp=0;38;2;90;247;142:*css=0;38;2;90;247;142:*.ex=0;38;2;90;247;142:*.lo=0;38;2;102;102;102:*.ps=0;38;2;255;92;87:*.py=0;38;2;90;247;142:*.ml=0;38;2;90;247;142:*.gv=0;38;2;90;247;142:*.kt=0;38;2;90;247;142:*.ko=1;38;2;255;92;87:*.jl=0;38;2;90;247;142:*.gz=4;38;2;154;237;254:*.xz=4;38;2;154;237;254:*.hh=0;38;2;90;247;142:*.nb=0;38;2;90;247;142:*.toc=0;38;2;102;102;102:*.wma=0;38;2;255;180;223:*.jar=4;38;2;154;237;254:*.com=1;38;2;255;92;87:*.cgi=0;38;2;90;247;142:*.xlr=0;38;2;255;92;87:*.hpp=0;38;2;90;247;142:*.php=0;38;2;90;247;142:*.xmp=0;38;2;243;249;157:*.bat=1;38;2;255;92;87:*.pod=0;38;2;90;247;142:*.exs=0;38;2;90;247;142:*.apk=4;38;2;154;237;254:*.aux=0;38;2;102;102;102:*.ltx=0;38;2;90;247;142:*.png=0;38;2;255;180;223:*.cpp=0;38;2;90;247;142:*.mkv=0;38;2;255;180;223:*.bst=0;38;2;243;249;157:*.arj=4;38;2;154;237;254:*.wmv=0;38;2;255;180;223:*.rtf=0;38;2;255;92;87:*.pps=0;38;2;255;92;87:*.sxi=0;38;2;255;92;87:*.yml=0;38;2;243;249;157:*.ilg=0;38;2;102;102;102:*.fsi=0;38;2;90;247;142:*.bsh=0;38;2;90;247;142:*.bbl=0;38;2;102;102;102:*.pid=0;38;2;102;102;102:*.mli=0;38;2;90;247;142:*.tsx=0;38;2;90;247;142:*.htc=0;38;2;90;247;142:*.csv=0;38;2;243;249;157:*.pkg=4;38;2;154;237;254:*.bib=0;38;2;243;249;157:*.mid=0;38;2;255;180;223:*.tgz=4;38;2;154;237;254:*.tar=4;38;2;154;237;254:*.asa=0;38;2;90;247;142:*.ini=0;38;2;243;249;157:*.ics=0;38;2;255;92;87:*.txt=0;38;2;243;249;157:*.awk=0;38;2;90;247;142:*.htm=0;38;2;243;249;157:*.mov=0;38;2;255;180;223:*.csx=0;38;2;90;247;142:*.out=0;38;2;102;102;102:*.ind=0;38;2;102;102;102:*.rst=0;38;2;243;249;157:*.ogg=0;38;2;255;180;223:*.exe=1;38;2;255;92;87:*.tmp=0;38;2;102;102;102:*.ps1=0;38;2;90;247;142:*.inl=0;38;2;90;247;142:*.zip=4;38;2;154;237;254:*.sxw=0;38;2;255;92;87:*.bcf=0;38;2;102;102;102:*.rpm=4;38;2;154;237;254:*.wav=0;38;2;255;180;223:*.pyc=0;38;2;102;102;102:*.ico=0;38;2;255;180;223:*.ppm=0;38;2;255;180;223:*.pas=0;38;2;90;247;142:*.jpg=0;38;2;255;180;223:*.cfg=0;38;2;243;249;157:*.rar=4;38;2;154;237;254:*.log=0;38;2;102;102;102:*.ttf=0;38;2;255;180;223:*.m4v=0;38;2;255;180;223:*.c++=0;38;2;90;247;142:*.fnt=0;38;2;255;180;223:*.flv=0;38;2;255;180;223:*.ipp=0;38;2;90;247;142:*.blg=0;38;2;102;102;102:*.kex=0;38;2;255;92;87:*.pro=0;38;2;165;255;195:*.dpr=0;38;2;90;247;142:*.odp=0;38;2;255;92;87:*.mp4=0;38;2;255;180;223:*.fls=0;38;2;102;102;102:*.pdf=0;38;2;255;92;87:*.vob=0;38;2;255;180;223:*.bmp=0;38;2;255;180;223:*.clj=0;38;2;90;247;142:*.bz2=4;38;2;154;237;254:*.sty=0;38;2;102;102;102:*.h++=0;38;2;90;247;142:*.cxx=0;38;2;90;247;142:*.xcf=0;38;2;255;180;223:*.pgm=0;38;2;255;180;223:*.doc=0;38;2;255;92;87:*.dox=0;38;2;165;255;195:*.sbt=0;38;2;90;247;142:*.erl=0;38;2;90;247;142:*.xls=0;38;2;255;92;87:*.otf=0;38;2;255;180;223:*.tex=0;38;2;90;247;142:*.zsh=0;38;2;90;247;142:*.tbz=4;38;2;154;237;254:*.vim=0;38;2;90;247;142:*.bak=0;38;2;102;102;102:*.bag=4;38;2;154;237;254:*.iso=4;38;2;154;237;254:*.gif=0;38;2;255;180;223:*.pbm=0;38;2;255;180;223:*.git=0;38;2;102;102;102:*.fon=0;38;2;255;180;223:*.gvy=0;38;2;90;247;142:*.fsx=0;38;2;90;247;142:*.lua=0;38;2;90;247;142:*.ppt=0;38;2;255;92;87:*.hxx=0;38;2;90;247;142:*.bin=4;38;2;154;237;254:*TODO=1:*.elm=0;38;2;90;247;142:*.mpg=0;38;2;255;180;223:*.idx=0;38;2;102;102;102:*.deb=4;38;2;154;237;254:*.epp=0;38;2;90;247;142:*.xml=0;38;2;243;249;157:*.swp=0;38;2;102;102;102:*.kts=0;38;2;90;247;142:*.svg=0;38;2;255;180;223:*.aif=0;38;2;255;180;223:*.odt=0;38;2;255;92;87:*hgrc=0;38;2;165;255;195:*.mp3=0;38;2;255;180;223:*.vcd=4;38;2;154;237;254:*.swf=0;38;2;255;180;223:*.tcl=0;38;2;90;247;142:*.tif=0;38;2;255;180;223:*.ods=0;38;2;255;92;87:*.dmg=4;38;2;154;237;254:*.tml=0;38;2;243;249;157:*.nix=0;38;2;243;249;157:*.img=4;38;2;154;237;254:*.dot=0;38;2;90;247;142:*.sql=0;38;2;90;247;142:*.dll=1;38;2;255;92;87:*.avi=0;38;2;255;180;223:*.make=0;38;2;165;255;195:*.dart=0;38;2;90;247;142:*.purs=0;38;2;90;247;142:*.rlib=0;38;2;102;102;102:*.tbz2=4;38;2;154;237;254:*.hgrc=0;38;2;165;255;195:*.fish=0;38;2;90;247;142:*.xlsx=0;38;2;255;92;87:*.psd1=0;38;2;90;247;142:*.java=0;38;2;90;247;142:*.h264=0;38;2;255;180;223:*.jpeg=0;38;2;255;180;223:*.mpeg=0;38;2;255;180;223:*.docx=0;38;2;255;92;87:*.less=0;38;2;90;247;142:*.conf=0;38;2;243;249;157:*.html=0;38;2;243;249;157:*.flac=0;38;2;255;180;223:*.json=0;38;2;243;249;157:*.epub=0;38;2;255;92;87:*.lock=0;38;2;102;102;102:*.psm1=0;38;2;90;247;142:*.diff=0;38;2;90;247;142:*.pptx=0;38;2;255;92;87:*.toml=0;38;2;243;249;157:*.yaml=0;38;2;243;249;157:*.lisp=0;38;2;90;247;142:*.orig=0;38;2;102;102;102:*.bash=0;38;2;90;247;142:*.patch=0;38;2;90;247;142:*.cabal=0;38;2;90;247;142:*.ipynb=0;38;2;90;247;142:*.class=0;38;2;102;102;102:*.scala=0;38;2;90;247;142:*.swift=0;38;2;90;247;142:*README=0;38;2;40;42;54;48;2;243;249;157:*.mdown=0;38;2;243;249;157:*.xhtml=0;38;2;243;249;157:*.shtml=0;38;2;243;249;157:*.dyn_o=0;38;2;102;102;102:*.cache=0;38;2;102;102;102:*.cmake=0;38;2;165;255;195:*.toast=4;38;2;154;237;254:*passwd=0;38;2;243;249;157:*shadow=0;38;2;243;249;157:*.flake8=0;38;2;165;255;195:*INSTALL=0;38;2;40;42;54;48;2;243;249;157:*TODO.md=1:*LICENSE=0;38;2;153;153;153:*.config=0;38;2;243;249;157:*.gradle=0;38;2;90;247;142:*.matlab=0;38;2;90;247;142:*.ignore=0;38;2;165;255;195:*COPYING=0;38;2;153;153;153:*.groovy=0;38;2;90;247;142:*.dyn_hi=0;38;2;102;102;102:*.desktop=0;38;2;243;249;157:*.gemspec=0;38;2;165;255;195:*Doxyfile=0;38;2;165;255;195:*TODO.txt=1:*Makefile=0;38;2;165;255;195:*setup.py=0;38;2;165;255;195:*.kdevelop=0;38;2;165;255;195:*.rgignore=0;38;2;165;255;195:*configure=0;38;2;165;255;195:*.cmake.in=0;38;2;165;255;195:*.fdignore=0;38;2;165;255;195:*.markdown=0;38;2;243;249;157:*README.md=0;38;2;40;42;54;48;2;243;249;157:*COPYRIGHT=0;38;2;153;153;153:*SConstruct=0;38;2;165;255;195:*README.txt=0;38;2;40;42;54;48;2;243;249;157:*.scons_opt=0;38;2;102;102;102:*SConscript=0;38;2;165;255;195:*.gitconfig=0;38;2;165;255;195:*INSTALL.md=0;38;2;40;42;54;48;2;243;249;157:*Dockerfile=0;38;2;243;249;157:*.gitignore=0;38;2;165;255;195:*CODEOWNERS=0;38;2;165;255;195:*Makefile.am=0;38;2;165;255;195:*Makefile.in=0;38;2;102;102;102:*LICENSE-MIT=0;38;2;153;153;153:*.gitmodules=0;38;2;165;255;195:*.travis.yml=0;38;2;90;247;142:*.synctex.gz=0;38;2;102;102;102:*MANIFEST.in=0;38;2;165;255;195:*CONTRIBUTORS=0;38;2;40;42;54;48;2;243;249;157:*.fdb_latexmk=0;38;2;102;102;102:*configure.ac=0;38;2;165;255;195:*appveyor.yml=0;38;2;90;247;142:*.applescript=0;38;2;90;247;142:*.clang-format=0;38;2;165;255;195:*CMakeLists.txt=0;38;2;165;255;195:*INSTALL.md.txt=0;38;2;40;42;54;48;2;243;249;157:*.gitattributes=0;38;2;165;255;195:*CMakeCache.txt=0;38;2;102;102;102:*LICENSE-APACHE=0;38;2;153;153;153:*CONTRIBUTORS.md=0;38;2;40;42;54;48;2;243;249;157:*requirements.txt=0;38;2;165;255;195:*.sconsign.dblite=0;38;2;102;102;102:*CONTRIBUTORS.txt=0;38;2;40;42;54;48;2;243;249;157:*package-lock.json=0;38;2;102;102;102"

##############
# references #
##############

# (1) https://stackoverflow.com/questions/3319479/can-i-git-commit-a-file-and-ignore-its-content-changes
# (2) https://blog.jayway.com/2017/04/19/running-docker-on-bash-on-windows/
# (3) This allows the GPG prompt to appear when using WSL.
#     Without it, a "gpg: signing failed: Inappropriate ioctl for device" error is thrown.
#       - https://github.com/microsoft/WSL/issues/4029
#       - https://www.gnupg.org/(it)/documentation/manuals/gnupg/Common-Problems.html
# (4) Setting TLS insecure on Docker for Windows, alongside this exported DOCKER_HOST means that the Docker daemon
#     inside WSL is able to use the actual Docker for Windows service. Windows without windows! :)
# (5) I run pass inside of WSL which means that, for now, I can't use the Firefox browser extension. As a workaround,
#     these functions pipe output to clip.exe, placing them on the Windows clipboard. Works pretty well.# (6) Fixes compilation issues with Erlang on macOS
#       - https://github.com/kerl/kerl/issues/226
