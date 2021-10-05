---
title: My zsh config
output: dot_zshrc.tmpl
---

<div align="center">
<img src="assets/zsh.gif" />
<h1>Welcome to my zsh config</h1>
</div>

<details>
<summary>Table of contents</summary>

- [Setting up PATHs](#setting-up-paths)
	- [Universal system folders](#universal-system-folders)
- [Initialisation](#initialisation)
	- [Determining the current OS](#determining-the-current-os)
	- [Setting my workspace](#setting-my-workspace)
	- [Setting various global constants](#setting-various-global-constants)
	- [Setting some Windows / WSL specific constants](#setting-some-windows--wsl-specific-constants)
	- [Adding custom items to PATH](#adding-custom-items-to-path)
	- [Module autoloading](#module-autoloading)
- [Applications](#applications)
  - [asdf](#asdf)
  - [fzf](#fzf)
  - [git](#git)
  - [kubectl](#kubectl)
  - [less](#less)
  - [nix](#nix)
  - [Postgres](#postgres)
  - [Sublime Text](#sublime-text)
- [Languages](#languages)
  - [Erlang](#erlang)
  - [go](#go)
- [Global packages](#global-packages)
- [Shortcuts](#shortcuts)
- [Functions](#functions)
  - [Quick shortcuts to push and pull the current branch](#quick-shortcuts-to-push-and-pull-the-current-branch)
  - [What application is listening on any given port?](#what-application-is-listening-on-any-given-port)
  - [I'd like to tangle a markdown file please](#id-like-to-tangle-a-markdown-file-please)
  - [I'd like to tangle an org file please](#id-like-to-tangle-an-org-file-please)
  - [What's inside that JWT?](#whats-inside-that-jwt)
  - [I'd like to see all resources in any given namespace](#id-like-to-see-all-resources-in-any-given-namespace)
  - [What functions have I defined?](#what-functions-have-i-defined)
- [iTerm 2 integration](#iterm-2-integration)

</details>

## Setting up PATHs

### Universal system folders

These paths generally exist on most every system so we'll set them seperately from other PATH additions.

```bash
path=(/bin
      /sbin
      /usr/local/bin
      /usr/bin
      /usr/sbin
      /usr/local/sbin
      /opt/X11/bin
      $(brew --prefix)/bin
      $HOME/bin
      $HOME/.nix-profile/bin
      $HOME/.emacs.d/bin
      $HOME/.local/bin
      /usr/local/MacGPG2/bin
      /Applications/Postgres.app/Contents/Versions/13/bin
    )
export PATH
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
export CONFIG_FILE="$HOME/.zshrc"
export CONFIG_SRC="$(chezmoi source-path)/zshrc.md"
export EDITOR="lvim"
export GPG_TTY=$(tty)
export LANGUAGE="en_NZ:en"
export LAST_MODIFIED="$(date)"
REPORTTIME=5

if [[ $TERM_PROGRAM == "iTerm.app" ]]; then
  export PROMPT=' ' # Installing iTerm helpers adds an arrow prompt
else
  export PROMPT='%B%F{green}>%f%b ' # I'd like a prompt in every other terminal
fi
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

### Adding custom items to PATH

I've got some scripts that are handy to have so let's add those to the PATH

```bash
export PATH=$HOME/scripts:$PATH
```

### Module autoloading

Currently, this is just used for kubectl shell completion

```bash
autoload -Uz compinit
compinit
```

## Applications

### asdf

The version manager to rule them all

It wraps a number of existing language version managers into plugins that can be managed through one unified CLI tool

```bash
export ASDF_DIR=$HOME/.asdf
if [[ -f $ASDF_DIR/asdf.sh ]]; then
  . $ASDF_DIR/asdf.sh
fi
export PATH=$(asdf where nodejs)/.npm/bin:$PATH
export PATH=$(asdf where python)/bin:$PATH
```

### fzf

A fuzzy finder which comes with some autocompletions

```bash
if [[ $(command -v fzf) ]]; then
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
fi
```

### git

To save me having to set up each machine, I just set my Git identifiers each time

```bash
git config --global user.name "{{ .name }}"
git config --global user.email "{{ .email }}"
```

### kubectl

Kubectl comes with some shell completions for zsh

```bash
source <(kubectl completion zsh)
```

### less

Less is great by default but it'd be even nicer with syntax highlighting!

```bash
if [[ $(which src-hilite-lesspipe.sh) ]]; then
  LESSPIPE=`which src-hilite-lesspipe.sh`
  export LESSOPEN="| ${LESSPIPE} %s"
  export LESS=' -R -X -F '
fi
```

### nix

I don't use it yet but Home Manager is promising

Setup is:

  - `sh <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume`
  - `nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager`
  - `nix-channel --update`
  - `nix-shell '<home-manager>' -A install`

```bash
export NIX_SSL_CERT_FILE=/etc/ssl/cert.pem
if [[ $(command -v nix) ]]; then
  export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
fi
```

### Postgres
```bash
export PATH="/usr/local/opt/postgresql@10/bin:$PATH"
```

### Sublime Text

Sublime ships with a helper tool called `subl` which, on macOS lives within the application bundle. It isn't registered by default so let's add it to the `PATH`.

```bash
export PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin/:$PATH"
```

## Languages

### Erlang

Whenever I compile `erlang` (using `asdf`), I always use the same flags so it's easier to just set them within my shell

```bash
export KERL_CONFIGURE_OPTIONS="--disable-debug --without-javac"
export KERL_BUILD_DOCS="yes"
```

### go

I don't explicitly set `GOROOT` as it is defined by `asdf` generally.

```bash
export GOPATH="$WORKSPACE/go"
export PATH="$GOPATH/bin:$PATH"
export GO111MODULE="on"
```
## Global packages

There's no native functionality for keeping globally installed packages in sync, to my knowledge, so this is going to be a hack for that!

This installs a range of language servers in a very hacky way

```bash
function gsync() {
  global_npm_packages=(
    neovim
    pkgparse
  )
  global_ruby_packages=(
    neovim
  )
  yarn global add $global_npm_packages
  gem install $global_ruby_packages
}
```

## Shortcuts

Admittedly most of the git related stuff could live inside of a `.gitconfig` file but I never get around to moving it

That and I figure this will all eventually be superseded by `nix` anyway

You know... when I get around to doing that...

```bash
alias ae="deactivate &> /dev/null; source ./venv/bin/activate"
alias crush="pngcrush -ow"
alias de="deactivate &> /dev/null"
alias edit="$EDITOR $CONFIG_SRC"
alias gb="git branch -v"
alias gbm="git checkout master"
alias gcm="git commit -Si"
alias gr="git remote -v"
alias gs="git status"
alias gst="git status"
alias ipv4="dig @resolver4.opendns.com myip.opendns.com +short -4"
alias ipv6="dig @resolver1.ipv6-sandbox.opendns.com AAAA myip.opendns.com +short -6"
alias neovim="$EDITOR"
alias rebrew="brew bundle --file=$(chezmoi source-path)/Brewfile"
alias refresh="chezmoi apply && source $CONFIG_FILE"
alias tabcheck="/bin/cat -e -t -v"
alias utd="cd ~/utf9k && yarn start"
alias venv="python3 -m venv venv && ae"
alias vi="$EDITOR"
alias view="less $CONFIG_FILE"
alias vim="$EDITOR"
alias ws="cd $WORKSPACE"
```

## Functions

These are some handy functions I use from time to time

### Quick shortcuts to push and pull the current branch

While I can just do `git pull`, setting tracking branches is annoying because I always call them the same as their upstream branch.

These commands just push to and pull from the current branch explicitly.

```bash
function gpl { git branch | grep '*' | cut -c3- | xargs -I{} git pull origin {} }
function gps { git branch | grep '*' | cut -c3- | xargs -I{} git push origin {} }
function pap { git branch | grep '*' | cut -c3- | xargs -I{} git pull upstream {} && git push origin {} }
```

### What application is listening on any given port?

```bash
function whomport() { lsof -nP -i4TCP:$1 | grep LISTEN }
```

### I'd like to tangle a markdown file please

I have my own little Markdown tangling tool which you can read about [here](https://github.com/marcus-crane/dotfiles#a-note-on-tangling-files)

```bash
function tangle-md() {
  if [[ $(command -v lugh) ]]; then
    lugh -f "$1"
  else
    echo "lugh isn't installed. You can find it at https://github.com/marcus-crane/lugh"
  fi
}
```

### I'd like to tangle an org file please

```bash
function tangle-file() {
  emacs --batch -l org $@ -f org-babel-tangle
}
```

### What's inside that JWT?

This function is used to display both encrypted and regular JWT tokens, as opposed to using an online service like https://jwt.io

It's taken almost verbatim from [this post](https://www.jvt.me/posts/2019/06/13/pretty-printing-jwt-openssl/) except the original `exit 0` would cause my terminal session to exit so I swapped it for a `break` instead.

To pretty print a JWT line, just use it like so: `jwt <token>`

If you'd like to use a JWT stored as a file, you can do that pretty easily too: `jwt $(cat a_saved_jwt)`

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

### Quick convert screen recording to a more suitable format

Often times, I find myself making screen recording with Quicktime but they export as `.mov` files. I much prefer having an `mp4` file as it's more universally accepted so this is a quick function to perform that convertion with ffmpeg.

```bash
function demov() {
  if [[ $(command -v "ffmpeg") ]]; then
      ffmpeg -i $1 -vcodec libx264 -acodec aac $(echo "$1" | rev | cut -f 2- -d '.' | rev).mp4
  else
      print "It doesn't look like you have ffmpeg installed."
  fi
}
```

### Quick convert h265 to 8 bit 264

```bash
function de265() {
  if [[ $(command -v "ffmpeg") ]]; then
      ffmpeg -i $1 -map 0 -c:v libx264 -crf 18 -vf format=yuv420p -c:a copy $(echo "$1" | rev | cut -f 2- -d '.' | rev).mp4
  else
      print "It doesn't look like you have ffmpeg installed."
  fi
}
```

### Pin Kubernetes namespace

I often end up repeating the same namespace which gets annoying so this is a way to "pin" a namespace

```bash
function tack() {
  alias kubectl="kubectl -n $1"
  print "Tacked $1"
}
```

```bash
function untack() {
  unalias kubectl
}
```

### Extract emails from a webpage

I recently discovered `html-xml-utils` which has some handy functionality so this is a basic script to try and extract mailto links from a webpage

```bash
function emails() {
  wget --spider --recursive --level=2 --execute robots=off --user-agent="Mozilla/5.0 Firefox/4.0.1" $1 2>&1 |
    egrep -o 'https?://[^ ]+' |
    sed -e 's/^.*"\([^"]\+\)".*$/\1/g' |
    uniq |
    xargs curl -s |
    grep -s "mailto" |
    hxpipe |
    grep "mailto:" |
    cut -d ":" -f2 |
    sort |
    uniq
}
```

### Change Kubernetes context quickly

This is a small script I [found on Hacker News](https://news.ycombinator.com/item?id=26636675) which uses fzf to quick switch contexts

```bash
function kc () {
  if [[ $(command -v "fzf") ]]; then
    kubectl config get-contexts | tail -n +2 | fzf | cut -c 2- | awk '{print $1}' | xargs kubectl config use-context
  else
    print "It doesn't look like you have fzf installed."
  fi
}
```

### Calculating nines

Often times, it can be useful to put service uptime into minutes and hours. Thankfully [uptime.is](https://uptime.is) is a handy tool for this plus it reserves JSON too!

```bash
function nines() {
  curl -s https://uptime.is/$1 | jq
}
```

### Delete Git branches interactively with fzf

This function was quite shamelessly taken from [this very good post](https://seb.jambor.dev/posts/improving-shell-workflows-with-fzf/) by Sebastian Jambor.

It opens an interactive fzf window which shows a list of git branches, with their relevant history on the side as a preview pane.

You can press TAB to select multiple branches and ENTER to delete them.

If you decide to back out, you can press ESC to cancel.

```bash
function gbd() {
  git branch |
    grep --invert-match --extended-regexp 'master|main' |
    cut -c 3- |
    fzf --multi --preview="git log {} --" |
    xargs git branch --delete --force
}
```

### View and delete pods interactively with fzf

Inspired by the git branches function, I decided to apply the same idea to viewing and deleting pods.

It takes a little bit longer as it relies on network API calls of course but it's fairly handy.

```bash
function pods() {
  kubectl get pods -o=custom-columns=NAME:.metadata.name |
    tail -n +2 |
    fzf --multi --preview-window down --preview="kubectl describe pod {} --" |
    xargs kubectl delete pod
}
```

### View Kubernetes container logs interactively with fzf

This one took me a little while to throw together since fzf is designed to only work with one input for the preview.

It seems if you attempt to use `xargs -I {}`, the value of `{}` will always refer to the single preview input, rather than whatever value you have piped into `xargs`. As long as you don't use the `-I` flag, you can split the original `{}` value into multiple lines and using xarg, create a multi-line command.

The only catch of course is that you can't use `xargs -I` to format those. In this case, `kubectl logs $1 $2` happens to be a valid way to specify container name and pod name but if a `-c` was enforced, this command wouldn't work.

Also clearly breaking the model of what fzf expects and arguably introducing some unnecessary complexity.

```bash
function logs() {
  kubectl get pods -o json |
    jq -r '.items[] as $item | $item.spec.containers[] | [$item.metadata.name, .name] | join(" ~ ")' |
    fzf --preview-window down:follow --preview="echo {} | tr ' ~ ' '\n' | xargs kubectl logs --tail 20 --follow"
}
```

### Create an internet bookmark file

```bash
function bookmark() {
  local bookmarkName
  local bookmarkURL
  vared -p "Bookmark name: " bookmarkName
  vared -p "Bookmark URL: " bookmarkURL
  echo "[InternetShortcut]\nURL=$bookmarkURL\nIconIndex=0\n" > $HOME/Bookmarks/$bookmarkName.url
}
```

### View and open internet bookmarks

```bash
function site() {
  fd . ~/Bookmarks |
    fzf --multi --preview="cat {} | grep URL | cut -c 5- | xargs curl --head --location --max-time 10" |
    sed 's/ /\\ /g' |
    xargs open
}
```

### View unread Pinboard items

```bash
function pinboard() {
  if [[ ! $OP_SESSION_my ]]; then
    echo "Please log in using the op cli | eval (op signin my)"
  else
    export pinboardToken=$(op get item Pinboard --fields "API Token")
    curl "https://api.pinboard.in/v1/posts/all?auth_token=$pinboardToken&format=json" |
      jq 'map(select(.toread == "yes")) | .[].href' |
      tr -d '"' |
      fzf --multi --preview="curl -L -I {}" |
      xargs open
  fi
}
```

### View homebrew casks

I find that the Homebrew cask search doesn't provide enough information to make an informed decision so I'm using fzf instead to help

```bash
function casks() {
  curl "https://formulae.brew.sh/api/cask.json" |
    jq '.[].token' |
    tr -d '"' |
    fzf --multi --preview="curl https://formulae.brew.sh/api/cask/{}.json | jq '.'" |
    xargs brew install --cask
}
```

### View all ingress domain names found in a cluster

```bash
function ingresses() {
  kubectl get ingresses --all-namespaces -o json |
    jq -r '.items[].spec.rules[].host' | 
    fzf --preview="curl -I -L https://{}"
}
```

### Regenerate a secret key that has the same length as the input

Something I commonly do is regenerate secret keys between environments when deploying software. These keys aren't necessarily secret in themselves so much as they are just used to provide extra entropy.

I can never remember which keys require a specific length so this is a short function to take a key and regenerate a key that is the exact same length.

```bash
function secretregen() {
  local SECRET_LENGTH=$(echo -n $1 | wc -m | awk '{$1=$1};1')
  LC_ALL=C tr -dc A-Za-z0-9 </dev/urandom | head -c $SECRET_LENGTH ; echo ''
}
```

### Decode URLs with percentage decoded values

Often times, it can be more useful to inspect the API calls made by a web application, than using the API documentation supplies but this can get a little annoying when you need to decode HTML entities.

As a result, this little function will decode a URL parameter like `team_ids%5B%5D=ABC123` into `team_ids[]=ABC123`.

There are other types of HTML encoding of course but I only ever seem to run into percentage decoding on a day to day basis.

Remember to quote your input so that `&` symbols and the like aren't interpreted as shell commands.

```bash
function percentdecode() {
  echo $1 | python3 -c 'import sys,urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()),end="")'
}
```

### Create a new blog post for my site

Hugo archetypes are the way to do this but I'm not sure if I have my folders configured properly.

```bash
function newpost() {
  local SLUG=$(echo $1 | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
  mkdir -p ~/utf9k/content/blog/20xx--$SLUG
  cp ~/utf9k/archetypes/blog.md ~/utf9k/content/blog/20xx--$SLUG/index.md
  sed -i '' -e "s/<TITLE>/$1/g" ~/utf9k/content/blog/20xx--$SLUG/index.md
  sed -i '' -e "s/<SLUG>/$SLUG/g" ~/utf9k/content/blog/20xx--$SLUG/index.md
  echo "Created a new post at ~/utf9k/content/blog/20xx--$SLUG/index.md"
  echo "Would you like to start writing?"
  select ynd in "Yes" "No" "Delete"; do
    case $ynd in
      Yes ) nvim ~/utf9k/content/blog/20xx--$SLUG/index.md; echo "Nice work!"; break;;
      No ) break;;
      Delete ) rm -rf ~/utf9k/content/blog/20xx--$SLUG; echo "Deleted"; break;;
    esac
  done
}
```

### Envy

A small helper function for sourcing the contents of `.env` files into my shell

```bash
envy() {
  if [ -f ".env" ]; then
    set -o allexport
    source .env
    set +o allexport
  else
    echo "No env file located"
    return 1
  fi
}
```

### fly.io logs

I find myself checking fly logs (and sshing into them) a lot since some of my personal projects live there.

We can use fzf to make this easier, and faster without too much hassle.

There's some data munging due to the CLI output being a little non-standard but nothing impossible

```bash
flogs() {
  fly apps list |
    tail -r |
    tail -n +2 |
    tail -r |
    tail -n +2 |
    awk '{ print $1 }' |
    fzf --preview="fly logs -a {}" --preview-window=80%,follow |
    xargs fly ssh console -a
}
```

### Pretty print PATH

```bash
path() {
  echo -e "${PATH//:/\\n}"
}
```

### Kumamon on demand

I like [Kumamon](https://en.wikipedia.org/wiki/Kumamon) but I don't watch Kumamon videos enough so this is a small function that opens a random Kumamon YouTube video using mpv

```bash
kumamon() {
  channels=(
    https://www.youtube.com/c/KumamonTV/videos
    https://www.youtube.com/channel/UCHZQHTjxwQ5fa9Fiosp6orw/videos
    https://www.youtube.com/channel/UCZ4jjYAi4BI1-aU7Tg4HliQ/videos
  )
  channel=${channels[$(( $RANDOM % ${#channels[@]} +1 ))]}
  mpv $channel --shuffle --geometry=100%:0% --autofit=20% --ytdl-format="bestvideo[height<=480]+bestaudio/best[height<=480]" --ontop
}
```

### defaults plist viewer

This is probably my weightiest command to date

```bash
viewdefaults() {
  defaults domains |
    sed 's/$/, NSGlobalDomain/' |
    tr -d ',' |
    tr ' ' '\n' |
    fzf --preview="defaults export {} - | python3 -c \"import sys,plistlib,pprint; pprint.pprint(plistlib.loads(sys.stdin.read().encode('utf-8')))\"" |
    xargs -n1 -I{} sh -c 'defaults export $1 - > $1.plist' -- {}
}
```

### params

Using the previously defined `percentdecode` function, this makes it easy to visualise request params in a URL

```bash
params() {
  percentdecode $1 |
    tr "?" "\n" |
    tr "&" "\n"
}
```

## iTerm 2 integration

I used iTerm 2 on my various devices as a terminal and so, there are some shell integrations that are handy to use

```bash
if [[ -f "$HOME/.iterm2_shell_integration.zsh" ]]; then
  . $HOME/.iterm2_shell_integration.zsh
fi
```

