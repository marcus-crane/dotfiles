# My zsh configuration

## Setting up PATHs

### Universal system folders

These paths generally exist on most every system so we'll set them seperately from other PATH additions.

```bash
export PATH="/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/opt/X11/bin:$PATH"
```

## Initialisation

This section consists of helpers functions and global variables used by various applications.

A few of the helper functions are intended to make sure my configuration acts mostly identical across all machines and OSes without any extra configuration.

Whether that statement holds true is... debatable :)

### Determining the current OS

In order to save having to remember how to use `uname` and all that, I just have my own little configuration within my shell that I can reference

```bash
if [[ $(uname -r) =~ 'microsoft' ]]; then
  export OPSYS="windows"
else
  export OPSYS=${(L)$(uname -s)}
fi
```

Windows is a bit of a misnomer here because what I'm really checking for is whether the shell is running inside of [Windows Subsystem for Linux (WSL)](https://docs.microsoft.com/en-us/windows/wsl/about)

Functionally, I can treat WSL and Linux the same (and I do) but there are some minor alterations I make use of, such as pointing the `DISPLAY` environment variable at an X display server on my host system

It's worth noting that the value of `$OPSYS` on `macOS` is `darwin`. I could change it to be clearer but [Darwin](https://en.wikipedia.org/wiki/Darwin_(operating_system)) is technically the correct name for the base operating system

### Setting my workspace

All of my development occurs in `$HOME/Code` regardless of what machine I'm on. One day I might change it though hence the variable.

```bash
export WORKSPACE="$HOME/Code"
```

### Setting various global constants

```bash
export CONFIG_FILE="~/.zshrc"
export CONFIG_SRC="~/dotfiles/zsh/zshrc.md"
export EDITOR="$(command -v nvim)"
export GPG_TTY=$(tty)
export LANGUAGE="en_NZ:en"
export LAST_MODIFIED="$(date)"
export PROMPT='%B%F{green}>%f%b '
```

In some cases, when I compile Emacs, I'm not able to find the `emacsclient` executiable within my path.

This doesn't really make much sense given `emacs` and `emacsclient` tend to live side by side and I don't actually remember the specific details from last time I ran into that problem.

In the event that happens anyway, this quick hack (find `emacs` and append "client" on the end) works in the meantime

### Setting some Windows / WSL specific constants

```bash
if [[ $OPSYS == "windows" ]]; then
  export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0
  export BROWSER="/mnt/c/Windows/explorer.exe"
fi
```

1. If I'm running on a Windows machine, I run Emacs by starting a daemon inside my terminal and connecting with `emacsclient`. Doing so spawns a new frame using the X display server running on the Windows host itself

2. While I don't believe this actually works, I attempt to override the `BROWSER` environment variable to open links on the Windows host from within Emacs

### Setting up my work-related aliases

I've got some work related [dotfiles](https://github.com/marcus-crane/dotfiles) that live in a folder called "work"

In reality, it's added as a git submodule but I never commit it as one.

Anyway, I have a single `entrypoint.sh` script that does nothing but source any other scripts I might use, so that there is a fairly clean separation between my personal and work configuration

```bash
if [[ -f "$HOME/dotfiles/work/entrypoint.sh" ]]; then
  . "$HOME/dotfiles/work/entrypoint.sh"
fi
```

## Applications

### asdf

The version manager to rule them all

It wraps a number of existing language version managers into plugins that can be managed through one unified CLI tool

```bash
export ASDF_DIR=$HOME/.asdf
. $ASDF_DIR/asdf.sh
```

### Dropbox

Depending on which computer I'm using, I'll often have my Dropbox in different places

Historically, it would only be in a different place when using Emacs in WSL (I store my org stuff in Dropbox)

I'm currently in the process of moving to Dropbox within WSL though, which will mean that all version of Dropbox will live in `$HOME/Dropbox`

The reason for that is because file operations across WSL boundaries (ie anything on the C:\ Drive) is super slow compared to staying within the boundaries

```bash
export DROPBOX_DIR=~/Dropbox
```

### Emacs

I'll probably configure this a fair bit more but for now, I just shorten the name of `emacsclient`

```bash
alias ec=$EDITOR
export PATH="$HOME/.emacs.d/bin:$PATH"
```

### git

To save me having to set up each machine, I just set my Git identifiers each time

```bash
git config --global user.name "Marcus Crane"
git config --global user.email "marcus@utf9k.net"
```

### Homebrew

Sometimes I have trouble with rsync which is about the only thing that this snippet fixes

```bash
if [[ $OPSYS == "darwin" ]]; then
  export PATH="/usr/bin/local:$PATH"
fi
```

### nix

```bash
if [[ -a "$HOME/.nix-profile" ]]; then
  . "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi
```

## Languages

### Erlang

Whenever I compile `erlang` (using `asdf`), I always use the same flags so it's easier to just set them within my shell

```bash
export KERL_CONFIGURE_OPTIONS="--disable-debug --without-javac"
export KERL_BUILD_DOCS="yes"
```

### go

While I'm slowly getting better at writing Go these days, I think `GOROOT`, to a certain extent, is redundant due to the introduction of `GOMODULES` which you can see I have enabled by default

Don't quote me on that and not all project support `GOMODULES` of course

```bash
export GOPATH="$WORKSPACE/go"
if [[ -a "$ASDF_DIR/plugins/golang" ]]; then
  export GOROOT="$(asdf where golang)/go"
fi
export PATH="$GOPATH/bin:$GOROOT:$PATH"
export GO111MODULE="on"
```

### Node

```bash
if [[ -a "$ASDF_DIR/plugins/nodejs" ]]; then
  export PATH="$(asdf where nodejs)/.npm/bin:$PATH"
fi
```

### Python

```bash
if [[ -a $(asdf where python) ]]; then
  export PATH="$(asdf where python)/bin:$PATH"
fi
```

### Rust

```bash
if [[ -a "$ASDF_DIR/plugins/rust" ]]; then
  export PATH="$(asdf where rust)/bin:$PATH"
fi
```

## Shortcuts

Admittedly most of the git related stuff could live inside of a `.gitconfig` file but I never get around to moving it

That and I figure this will all eventually be superseded by `nix` anyway

You know... when I get around to doing that...

```bash
alias ae="deactivate &> /dev/null; source ./venv/bin/activate"
alias de="deactivate &> /dev/null"
alias edit="$EDITOR $CONFIG_SRC"
alias gb="git branch -v"
alias gbd="git branch -D"
alias gbm="git checkout master"
alias gcm="git commit -Si"
alias gpom="git pull origin master"
alias gpum="git pull upstream master"
alias gr="git remote -v"
alias gst="git status"
alias pap="git pull upstream master && git push origin master"
alias refresh="tangle-md $CONFIG_SRC bash $(dirname $CONFIG_SRC)/.zshrc &> /dev/null && stow zsh -d ~/dotfiles && source $CONFIG_FILE && echo 'Refreshed config from $CONFIG_SRC'"
alias venv="python3 -m virtualenv venv && ae"
alias vi="nvim"
alias view="less $CONFIG_FILE"
alias vim="nvim"
alias ws="cd $WORKSPACE"
```

## Functions

These are some handly functions I use from time to time

### What application is listening on any given port?

```bash
function whomport() { lsof -nP -i4TCP:$1 | grep LISTEN }
```

### I'd like to tangle a markdown file please

As an intermediary step to migrate off of `org-mode`, I'm using codedown to extract markdown blocks

The primary motivation is that when setting up a new laptop, between the installation time for `emacs` and general setup, there are quite a few dependencies

My ideal end state is something easy to install (likely a go binary) that does the same job as codedown, perhaps with support for inline attributes like the path to render out

Lastly, `pandoc` should be able to render this very file into an HTML page or render it as a static site using the markdown file

```bash
function tangle-md() {
  if [[ $(command -v codedown) ]]; then
    if [[ ! -n "$1" ]]; then
      echo "Please supply a file to tangle"
    elif [[ ! -n "$2" ]]; then
      echo "Please supply a language"
    elif [[ ! -n "$3" ]]; then
      echo "Please supply an output file"
    elif [[ -n "$1" && -n "$2" && -n "$3" ]]; then
      cat "$1" | codedown "$2" > "$3"
    fi
  else
    echo "Codedown isn't installed. You can find it at https://github.com/earldouglas/codedown"
  fi
}
```

### I'd like to tangle an org file please

```bash
function tangle-file() {
  emacs --batch -l org $@ -f org-babel-tangle
}
```

This function is used to display both encrypted and regular JWT tokens, as opposed to using an online service like https://jwt.io

It's taken almost verbatim from [this post](https://www.jvt.me/posts/2019/06/13/pretty-printing-jwt-openssl/) except the original `exit 0` would cause my terminal session to exit so I swapped it for a `break` instead.

To pretty print a JWT line, just use it like so: `jwt <token>`

If you'd like to use a JWT stored as a file, you can do that pretty easily too: `jwt $(cat a_saved_jwt)`

### What's inside that JWT?

```bash
function jwt() {
  for part in 1 2; do
    b64="$(cut -f$part -d. <<< "$1" | tr '_-' '/+')"
    len=${#b64}
    n=$((len % 4))
    if [[ 2 -eq n ]]; then
      b64="${b64}=="
    elif [[ 3 -eq n ]]; then
      b64="${b64}="
    fi
    d="$(openssl enc -base64 -d -A <<< "$b64")"
    python -mjson.tool <<< "$d"
    # don't decode further if this is an encrypted JWT (JWE)
    if [[ 1 -eq part ]] && grep '"enc":' <<< "$d" >/dev/null ; then
        break
    fi
  done
}
```

### I'd like to see all resources in any given namespace

Annoyingly, the `kubectl get all` command doesn't actually do what it says on the tin.

Specifically, "all" in this case only includes a couple of different resources like `pods` and `services`.

As a workaround, it's a bit slow but we can just enumerate through all of the supported resources and see what we get back.

```bash
function get-all-resources() {
    kubectl api-resources --verbs=list --namespaced -o name | xargs -n 1 kubectl get --show-kind --ignore-not-found -n $@
}
```

### What functions have I defined?

Often I'll forget what little shortcut functions I've made so here's a quick cheatsheet

There is a built-in `functions` but it shows the actual source code rather than a list of names

```bash
function funcs() {
    functions | grep "()" | grep -v '"'
}
```

How's that for disorientation? Enough "functions" for ya?

The extra `grep` is a bit of a hack because without it, the actual function body will match the search for `grep "()"`

It's quite interesting in a way, that it would recursively search itself so I added in a second grep to remove any lines that feature a double quote.

Technically speaking, the second grep would potentially be filtering itself out recursively which I think is pretty interesting

It also makes my head hurt a little bit for what you'd think would be a pretty basic function!

### What's a quick way to archive backups?

In order to save on cloud storage space, while still keeping a home for rarely used backups, I like to store things in [Backblaze B2](https://backblaze.com/b2/cloud-storage)

While I could use the web UI, it's often just as fast to use [rclone](https://rclone.org) which is what this script is a wrapper around

```bash
function archive() {
    rclone copy "$(pwd)/$1" b2:long-term-backups --progress
}
```