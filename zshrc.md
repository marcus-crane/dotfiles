---
title: .zshrc
category: zsh
tags:
- shell
output: dot_zshrc.tmpl
---

# ~/.zshrc

> My personal zsh configuration, now available in literate form.

## Zim setup

At the time of writing, I'm using [zim](https://github.com/zimfw/zimfw) as my zsh framework of choice.

Here is some general setup of it before doing wider zsh fiddling.

```bash
# Set editor default keymap to vi (`-v`) rather than emacs (`-e`)
bindkey -v

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}
```

### zsh-autosuggestions

```bash
# Disable automatic widget re-binding on each precmd. This can be set when
# zsh-users/zsh-autosuggestions is the last module in your ~/.zimrc.
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
```

### zsh-syntax-highlighting

```bash
# Set what highlighters will be used.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
```

## Module setup + zimfw install

If we don't have zimfw already installed, let's automatically install it before attempting setup.

```bash
ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  if (( ${+commands[curl]} )); then
    curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi
# Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi
# Initialize modules.
source ${ZIM_HOME}/init.zsh
```

## Post-setup configuration

### zsh-history-substring-search

```bash
zmodload -F zsh/terminfo +p:terminfo
# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
for key ('^[[A' '^P' ${terminfo[kcuu1]}) bindkey ${key} history-substring-search-up
for key ('^[[B' '^N' ${terminfo[kcud1]}) bindkey ${key} history-substring-search-down
for key ('k') bindkey -M vicmd ${key} history-substring-search-up
for key ('j') bindkey -M vicmd ${key} history-substring-search-down
unset key
```

## Initialisation

This section consists of helpers functions and global variables used by various applications.

A few of the helper functions are intended to make sure my configuration acts mostly identical across all machines and OSes without any extra configuration.

Whether that statement holds true is... debatable :)

### Setting up PATH

These paths generally exist on most every system so we'll set them seperately from other PATH additions.

```bash
path=(
  $HOME/.local/share/mise/shims
  /opt/homebrew/opt/emacs-mac/bin
  /opt/homebrew/opt/openjdk/bin
  /opt/homebrew/opt/mtr/sbin
  /nix/var/nix/profiles/default/bin
  /home/linuxbrew/.linuxbrew/bin
  $HOME/.bin
  /opt/homebrew/bin
  /bin
  /sbin
  /usr/local/bin
  /usr/bin
  /usr/sbin
  /usr/local/sbin
  /usr/libexec
  /opt/X11/bin
  $HOME/.nix-profile/bin
  $HOME/.config/emacs/bin
  $HOME/.local/bin
  $HOME/.opam/default/bin
  $HOME/scripts
  /usr/local/MacGPG2/bin
  /usr/local/opt/postgresql@10/bin
  /Applications/Postgres.app/Contents/Versions/latest/bin
  "/Applications/Sublime Text.app/Contents/SharedSupport/bin"
)
export PATH
```

1. If we're using Nix, we want Nix installed binaries to always resolve first no matter what
2. While this could cause trouble, this path should only ever resolve on Linux so it'll do for now
3. We want to make sure that our Homebrew binaries are picked up earlier than system binaries that tend to be older
4. Enables quickly opening Sublime Text via terminal by using the `subl` command

TODO: Why is Homebrew on Linux installed as its own user

### Homebrew

Some homebrew setup that is needed on Linux

```bash
{{ if eq .chezmoi.os "darwin" -}}
eval "$(brew shellenv)"
{{ end -}}
```

### fzf setup

This is requested by the fzf plugin so we need to do it before we load things

```bash
{{- if eq .chezmoi.os "darwin" -}}
export FZF_BASE=$(brew --prefix)/opt/fzf
{{ end -}}
```

1. Updates are handled by chezmoi so we disable automatic zsh updating

### Handy credentials

```bash
export GITHUB_TOKEN={{ onepasswordRead "op://Personal/Chezmoi Github Token/password" "my" }} # (1)!
```

1. I use this with the Github CLI among other places so it's useful to just have it always set in my shell

### History

The following options were borrowed from [this HN comment](https://news.ycombinator.com/item?id=33188042)

> SHARE_HISTORY will cause zsh to write to the history file after every command which means that two shells running in parallel won't override changes of each other and it will write a timestamp to the file too in order to have the history in chronological order even in light of multiple instances.
> 
> HIST_IGNORE_DUPS (or HIST_IGNORE_ALL_DUPS) will cause duplicated commands to not be written to the history file which helps with `Ctrl-R`ing

```bash
setopt SHARE_HISTORY HIST_IGNORE_ALL_DUPS
```

Also, just for my sanity across platforms, here are the macOS history defaults explicitly defined

```bash
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
HISTSIZE=2000
SAVEHIST=1000
```

### Setting up build flags

Compiling some things can end in failure on macOS when using a version of OpenSSL installed using Homebrew.

This ensures that the right folders are scanned for development libraries.

Pretty boring stuff.

Crystal on macOS Silicon fails with an architecture error for me without this `PKG_CONFIG_PATH` as an example

```bash
{{ if eq .chezmoi.os "darwin" -}}
export LDFLAGS="-L$(brew --prefix)/opt/openssl/lib"
export CPPFLAGS="-I$(brew --prefix)/opt/openssl/include"
export PKG_CONFIG_PATH="$(brew --prefix)/opt/openssl/lib/pkgconfig"
{{ end -}}
```

### Setting up WSL Shims

In order to support WSL, there are a bunch of scripts that live in `dot_wslshims` containing wrapper scripts.

These are just dumb files that translate eg; `op` into `op.exe` which is the equivalent executable in Windows land

```bash
{{ if .wsl }}
export PATH="~/.wslshims:$PATH"
{{ end }}
```

### Setting my workspace

All of my development occurs in `$HOME/Code` regardless of what machine I'm on. One day I might change it though hence the variable.

```bash
export WORKSPACE="$HOME/Code"
```

### Setting various global constants

```bash
export CONFIG_FILE="$HOME/.zshrc"
export CONFIG_SRC="$(chezmoi source-path)/zshrc.md"
export EDITOR="nvim"
export GPG_TTY=$(tty)
export LANGUAGE="en_NZ:en"
export LAST_MODIFIED="$(date)"
export SHELL="$(which zsh)"
REPORTTIME=5
```

## Applications

### Atuin

```bash
if [[ $(command -v atuin) ]]; then
  eval "$(atuin init zsh)"
fi
```

### Emacs

Given that I use chezmoi, I can't have Doom Emacs editing the default config in `$HOME` so we need to overwrite that.

```bash
export DOOMDIR=$(chezmoi source-path)/dot_doom.d # (1)!
```

1. If I make updates to my Emacs config, I want to make sure that I'm editing the source and not the version in `$HOME` which will get overwritten on the next `chezmoi apply`

### fzf

A fuzzy finder which comes with some autocompletions

```bash
if [[ $(command -v fzf) ]]; then
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
fi
```

### Homebrew

It can take quite some time if Homebrew decides to automatically update everything so let's turn that off

```bash
export HOMEBREW_NO_AUTO_UPDATE=1
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

### mise

```bash
eval "$(mise activate zsh)"
```

### nix

I don't use it yet but Home Manager is promising

Setup is:

  - `sh <(curl -L https://nixos.org/nix/install) --darwin-use-unencrypted-nix-store-volume`
  - `nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager`
  - `nix-channel --update`
  - `nix-shell '<home-manager>' -A install`

```bash
export NIX_SSL_CERT_FILE=/nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt
if [[ $(command -v nix) ]]; then
  export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
fi
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
    . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
```

### opam

The package manager for OCaml

```bash
[[ ! -r /Users/marcus/.opam/opam-init/init.zsh ]] || source /Users/marcus/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null
```

### pnpm

```bash
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
```

## Languages

### Erlang

Whenever I compile `erlang`, I always use the same flags so it's easier to just set them within my shell

```bash
export ERL_AFLAGS="-kernel shell_history enabled"
export KERL_CONFIGURE_OPTIONS="--disable-debug --without-javac"
export KERL_BUILD_DOCS="yes"
```

### go

I don't explicitly set `GOROOT` as it is defined by `mise` generally.

```bash
export GOPATH="$WORKSPACE/go"
export PATH="$PATH:$GOPATH/bin"
```

### Rust

For certain applications and utilities that require compilation from source, Cargo tends to fall over when running up against 1Password's built-in SSH agent so we [tell Cargo](https://doc.rust-lang.org/cargo/reference/config.html#netgit-fetch-with-cli) to use the `git` CLI directly.

```bash
export CARGO_NET_GIT_FETCH_WITH_CLI=true
```

## Shortcuts

Admittedly most of the git related stuff could live inside of a `.gitconfig` file but I never get around to moving it

That and I figure this will all eventually be superseded by `nix` anyway

You know... when I get around to doing that...

```bash
alias ae="deactivate &> /dev/null; source ./venv/bin/activate"
alias alphaenv="env -0 | sort -z | tr '\0' '\n'"
alias assume="source assume"
alias ccd="chezmoi cd"
alias cce="chezmoi edit"
alias crush="pngcrush -ow"
alias de="deactivate &> /dev/null"
alias ec="emacsclient -na $(which code)"
alias edit="$EDITOR $CONFIG_SRC"
alias gb="git branch -v"
alias gbm="git checkout master"
alias gcm="git commit -Ssi"
alias gr="git remote -v"
# Taken from https://twitter.com/flakpaket/status/1445751410331586568
alias grip='grep -oE "([0-9]{1,3}[.]){3}[0-9]{1,3}"'
alias gs="git status"
alias gst="git status"
alias ipv4="dig @resolver4.opendns.com myip.opendns.com +short -4"
alias ipv6="dig @resolver1.ipv6-sandbox.opendns.com AAAA myip.opendns.com +short -6"
alias lidclosed="ioreg -r -k AppleClamshellState -d 4 | grep AppleClamshellState | awk '{ print $4 }'"
alias lvim="nvim"
alias rebrew="brew bundle --file=$(chezmoi source-path)/Brewfile"
alias refresh="chezmoi git pull && chezmoi apply && exec zsh && echo '~ refreshed shell config'"
alias rmuntracked="git status -su --no-ahead-behind | awk '{ print $2 }' | xargs rm"
alias rtx="echo 'Reminder that rtx is now called mise!'"
alias tabcheck="/bin/cat -e -t -v"
alias tsc="transmission-remote netocean"
alias utd="cd ~/utf9k && yarn start"
alias venv="python3 -m venv venv && ae"
alias vi="$EDITOR"
alias view="less $CONFIG_FILE"
alias vim="$EDITOR"
alias ws="cd $WORKSPACE"
alias wsd="chezmoi cd"
alias youtube-dl="yt-dlp --add-metadata --dateafter 20081004 -i -o '%(uploader)s [%(channel_id)s]/%(title)s [%(id)s].%(ext)s' -ci --format 'bestvideo[height<=?1080]+bestaudio[ext=m4a]/bestvideo+bestaudio/best' --merge-output-format mp4"
```

## Functions

These are some handy functions I use from time to time

### What application is listening on any given port?

```bash
function whomport() { lsof -nP -i4TCP:$1 | grep LISTEN }
```

<details><summary>Example</summary>

<code>
> lsof -nP -i4TCP:1313 | grep LISTEN
hugo    64740 marcus  466u  IPv4 0x76ace186a77b90b9      0t0  TCP 127.0.0.1:1313 (LISTEN)
</code>

</details>

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

<details><summary>Example</summary>

<code>
> jwt eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
{
    "alg": "HS256",
    "typ": "JWT"
}
{
    "sub": "1234567890",
    "name": "John Doe",
    "iat": 1516239022
}
</code>

</details>

### What functions have I defined?

Often I'll forget what little shortcut functions I've made so here's a quick cheatsheet

There is a built-in `functions` but it shows the actual source code rather than a list of names

```bash
function funcs() {
    functions | grep "()" | grep -v '"'
}
```

<details><summary>Example</summary>

<code>
> funcs
kumamon () {
massunset () {
master2main () {
mkd () {
</code>

</details>

How's that for disorientation? Enough "functions" for ya?

The extra `grep` is a bit of a hack because without it, the actual function body will match the search for `grep "()"`

It's quite interesting in a way, that it would recursively search itself so I added in a second grep to remove any lines that feature a double quote.

Technically speaking, the second grep would potentially be filtering itself out recursively which I think is pretty interesting

It also makes my head hurt a little bit for what you'd think would be a pretty basic function!

### What is the definition of a given shell function?

Sometimes I like to take a copy of an existing shell function and poke around the internals to debug/fix it.

I can read through my shell config but I'm lazy so instead here is a function to search other functions.

```bash
function fsearch () {
  functions | sed -n "/$1/,/^}$/p"
}
```

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

### Calculating nines

Often times, it can be useful to put service uptime into minutes and hours. Thankfully [uptime.is](https://uptime.is) is a handy tool for this plus it reserves JSON too!

```bash
function nines() {
  curl -s https://uptime.is/$1 | jq
}
```

<details><summary>Example</summary>

<code>
> nines 99.95
{
  "SLA": 99.95,
  "dailyDown": "43s",
  "dailyDownSecs": 43,
  "weeklyDown": "5m 2s",
  "weeklyDownSecs": 302,
  "monthlyDown": "21m 54s",
  "monthlyDownSecs": 1314,
  "quarterlyDown": "1h 5m 44s",
  "quarterlyDownSecs": 3944,
  "yearlyDown": "4h 22m 58s",
  "yearlyDownSecs": 15778,
  "uptimeURL": "https://uptime.is/99.95",
  "runtimeSecs": 0.001
}
</code>

</details>

### Delete Git branches interactively with fzf

This function was quite shamelessly taken from [this very good post](https://seb.jambor.dev/posts/improving-shell-workflows-with-fzf/) by Sebastian Jambor.

It opens an interactive fzf window which shows a list of git branches, with their relevant history on the side as a preview pane.

You can press TAB to select multiple branches and ENTER to delete them.

If you decide to back out, you can press ESC to cancel.

```bash
function gbd() {
  git branch |
    grep --invert-match $(git branch --show-current) |
    cut -c 3- |
    fzf --multi --preview="git log {} --" |
    xargs git branch --delete --force
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

### Regenerate a secret key that has the same length as the input

Something I commonly do is regenerate secret keys between environments when deploying software. These keys aren't necessarily secret in themselves so much as they are just used to provide extra entropy.

I can never remember which keys require a specific length so this is a short function to take a key and regenerate a key that is the exact same length.

```bash
function secretregen() {
  local SECRET_LENGTH=$(echo -n $1 | wc -m | awk '{$1=$1};1')
  LC_ALL=C tr -dc A-Za-z0-9 </dev/urandom | head -c $SECRET_LENGTH ; echo ''
}
```

<details><summary>Example</summary>

<code>
> secretregen ABC123
0qbTGG
> secretregen 0qbTGG
LUhxAp
> secretregen LUhxAp
S5VkqQ
</code>

</details>

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

<details><summary>Example</summary>

<code>
> percentdecode "https://example.com?repo=marcus%2Dcrane%2Fdotfiles"
https://example.com?repo=marcus-crane/dotfiles
</code>

</details>

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
    https://www.youtube.com/channel/UCrw3-jkioIlt7JtvtrrbPFg/videos
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

### Pretty print URL params

Using the previously defined `percentdecode` function, this makes it easy to visualise request params in a URL

```bash
params() {
  percentdecode $1 |
    tr "?" "\n" |
    tr "&" "\n"
}
```

<details><summary>Example</summary>

<code>
> params "http://localhost:1313?test=hi&nice=cool&wow=great"
http://localhost:1313
test=hi
nice=cool
wow=great
</code>

</details>

### master to main

From time to time, I'll update a repo's branch for consistency and forget the steps to update my local

```bash
master2main() {
  git branch -m master main
  git fetch origin
  git branch -u origin/main main
  git remote set-head origin -a
}
```

### Sign in with 1Password CLI

At this point, my work config is intertwined with my 1Password installation and shortly the same will probably be true of my work config.

It's a hassle manually entering in my password each time so instead, here's a shortcut to automatically log me in to the `op` cli tool

It requires your password being stored in at `$HOME/.op`

Also note that if you have a `printf` formatting symbol such as `%` in your master password, you'll need to escape it so eg; `abc12%` becomes `abc12%%`

Does this mean my master password is stored on my machine? Yes but realistically, it isn't much of a threat.

You still need to a) unlock my laptop and b) have my security key to access my vault on a new machine

You could physically access my machine of course but that's no less of a threat than it is at present so always remember to lock your devices!

```bash
opauth() {
  eval $(op signin --account $1.1password.com)
  echo "~ Signed in to $1 vault"
}
```

### mkd

It's often handy to change into a folder you've just created so this is a handy way to do that.

```bash
mkd() {
  mkdir -p $1 && cd $_
}
```

### Pull an image from ECR and recurse

```bash
ecrrecurse() {
  REPOSITORY_NAME=$1
  IMAGE_TAG=$2

  if [[ $REPOSITORY_NAME == "" || $IMAGE_TAG == "" ]]; then
    echo "Please enter both a repository name and an image tag"
    echo "Usage: ecrrecurse myservice abc1234"
    exit 1
  fi

  MANIFEST=$(aws ecr batch-get-image --repository-name=$REPOSITORY_NAME --image-id imageTag=$IMAGE_TAG --region=us-west-2 --output json | jq -r '.images[].imageManifest')

  if [[ $MANIFEST == "" ]]; then
    echo "No results found for that Docker manifest"
    exit 1
  fi

  MEDIA_TYPE=$(jq '.mediaType' <<< "${MANIFEST}")

  if [[ $MEDIA_TYPE == '"application/vnd.docker.distribution.manifest.list.v2+json"' ]]; then
    INNER_DIGEST=$(jq '.manifests[0].digest' <<< "${MANIFEST}")
    MANIFEST=$(aws ecr batch-get-image --repository-name=$REPOSITORY_NAME --image-id imageDigest=$INNER_DIGEST | jq -r '.images[].imageManifest')
  fi

  CONFIG_DIGEST=$(jq '.config.digest' <<< "${MANIFEST}")
  DOWNLOAD_URL=$(xargs -I{} aws ecr get-download-url-for-layer --repository-name=$REPOSITORY_NAME --layer-digest={} <<< "${CONFIG_DIGEST}" | jq '.downloadUrl')
  CONTENT=$(xargs curl -s <<< "${DOWNLOAD_URL}")

  echo $CONTENT | jq '.config.Labels'
}
```

### Show env with values redacted

Sometimes it's useful to illustrate some env values but you don't actually want to show the content 

```bash
redactenv() {
  sed -E 's/=.*/=•••/g;t' <<< $(env | grep "$1")
}
```

<details><summary>Example</summary>

<code>
> env | grep SHELL
SHELL=/bin/zsh
> redactenv SHELL
SHELL=•••
</code>

</details>

### Mass unset environment items

```bash
massunset() {
  name=$(env | fzf --multi | tr "=" " " | awk '{ print $1 }')
  spacedName=$(echo $name | tr "\n" " ")
  unset $spacedName
}
```

### Remotely remove torrents

Sometimes it's nice to be able to remove Linux distro ISO torrents from across the room

```bash
tsd() {
  tsc -l |
    awk 'NR>2 {print last} {last=$0}' |
    awk '{ $2=$3=$4=$5=$6=$7=$8=$9=""; print $0 }' |
    sed 's/        //g' |
    fzf --multi --preview="awk '{ print $1 }' | transmission-remote netocean -t {} -i" | awk '{ print $1 }' |
    xargs -I{} transmission-remote netocean -t {} -r
}
```

### Format Terraform plans for Github

At work, I occasionally paste Terraform plans into Github pull requests where they aren't otherwise automated.

In order to make use of screen real estate, these are put inside of an HTML `details` block that can be expanded.

```bash
txtplan() {
  gsed '1 i <details><summary>Plan</summary>||```terraform' txt.plan | gsed -E '$ a ```||</details>' | tr '|' '\n' | pbcopy
}
```

### Quick convert unix timestamps to ISO-8601 timestamps

Often times, when using the `jwt` shell function (earlier in this file), the timestamps for expiry will be provided as unix timestamps.

I always end up going to some website to convert these and never remember that `date` exists so this shell function is a quick way to convert these locally.

Note that `gdate` is needed for macOS (`brew install coreutils`) but you can probably just use plain `date` on Linux.

TODO: Update this to use `date` by default but `gdate` if platform is `darwin`

```bash
deunix() {
  gdate --iso-8601=seconds -d '@$1'
}
```

### Recurse through files to find Slack emoji identifiers

In the past, I had some use case where I needed to search for Slack identifiers in order to confirm that emoji referenced still existed in our workspace post-migration.

This command also needed to be able to skip AWS ARNs as well as Ruby classes (which both use `:` characters)

Here's the verbatim explainer I wrote at the time:

> So, the actual regex is `(?<=\s):([a-z0-9_\-\+']+):` and it comes in two parts.
> 
> I'll start with the second portion which is `:([a-z0-9_\-\+']+):` . It's just saying to look for anything that has a bunch of characters between two colons. Specifically, any lowercase characters (TIL you can't use uppercase letters!), numbers and a handful of punctuation characters. Most punctuation isn't allowed but `_`, `-`, `+` and `'` are valid. `-` and `+` also need to be escaped since they're regex operators. Any number of these characters can be used although there is an upper limit to the emoji name that I forget but we've definitely hit.
> 
> The first portion is a little less clear. It's a positive lookbehind meaning it only matches if its content exist behind the snippet that we're checking for. In this case, we're looking for any whitespace character which could be a newline, tab, carriage return and so on.
> 
> The reason we want to do this is because there are other things that will otherwise match a Slack emoji identifier such as AWS ARNs (`aws:arn:ecs::blah`) and Ruby classes (`Something::Blah:Bleh`) which might match so to get around this, we just say that emojis have to either be on a new line or have a space behind them.
> 
> Technically, you can have two emojis back to back (`:3720-rainbow-corgi::3720-rainbow-corgi:`) eg <img src="https://cdn.utf9k.net/emoji/3720-rainbow-corgi.gif" height="30px" /><img src="https://cdn.utf9k.net/emoji/3720-rainbow-corgi.gif" height="30px" />) but that's an edge case so :shrug:
> 
> Now if you'll excuse me, I'm going to go outside and touch some grass

```bash
reslackmoji() {
  rg --pcre2 --no-filename --no-line-number --only-matching "(?<=\s):([a-z0-9_\-\+']+):" . | sort -u
}
```

### 1Password CLI for WSL

When using WSL, it's more ideal to use an instance of the OP CLI installed on the Windows host as that will enable the use of biometric unlock from within WSL

As my dotfiles use both my personal and work accounts for various things, this is basically required due to having to switch accounts partway through the dotfile installation process.

It's also just a lot nicer not having to deal with long passwords.

By default, `op.exe` is installed at `C:/Program Files/1Password CLI`

In order to make this switch transparent to any calling scripts, there is a wrapper script that can be found in the `dot_wslshims` folder

```bash
{{ if .wsl }}
export PATH="/mnt/c/Program Files/1Password CLI:$PATH"
{{- end }}
```

## iTerm 2 integration

I used iTerm 2 on my various devices as a terminal and so, there are some shell integrations that are handy to use

```bash
if [[ -f "$HOME/.iterm2_shell_integration.zsh" ]]; then
  . $HOME/.iterm2_shell_integration.zsh
fi
```

## Work configuration

Usually most people maintain a separate configuration between their personal and work lives.

I've opted to maintain mine in public to show that it's possible to have the best of both worlds without leaking credentials.

In the case of my employer, not only are the referenced tools the usual suspects but you can easily verify on Github that we use them internally in the form of public repos so this can't be considered as leaking metadata in that sense.

```bash
{{ if .workmode }}
source $HOME/.halter_asdf
source $HOME/.halter_backend
source $HOME/.halter_core
source $HOME/.halter_utilities
{{- end }}
```