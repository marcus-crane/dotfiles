> Bits of my zshrc that are unused but useful to keep for future reference

## Explainer

Over the years, I've accumulated a lot of cruft in my [zshrc](https://github.com/marcus-crane/dotfiles/blob/main/zshrc.md).

Rather than fully delete some aspects of it, they might be handy in future so this file keeps tracks of snippets that have been useful in the future, particularly when trying to keep my config working seamlessly across multiple operating systems.

At the time of writing, I only use macOS systems but I've previously used my config across Windows (WSL), macOS and Linux systems all at the same time.

## Determining the current operating system

The main purpose of this is to create a single variable that can be used to determine whether I'm running on Windows, macOS or Linux.

The only real interesting bit here is [Windows Subsystem for Linux (WSL)](https://docs.microsoft.com/en-us/windows/wsl/about) and nowadays, it can mostly be treated the same.

Historically though, I would set the `DISPLAY` environment variable for use with Emacs whereas nowadays there is proper GUI/X server support.

I haven't tried it out however.


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

## Setting some Windows / WSL specific constants

As mentioned above, it can be handy to set the DISPLAY variable as Windows proper treats WSL as an entirely different networked computer.

In the event you would want to use an external X server (which is now redundant I believe), you would want to make use of this DISPLAY variable to connect to the host via its "remote" IP address.

As far as the BROWSER variable, this trick can be used with URLs to open the browser in your host (ie Windows 10/11) if I recall.

```bash
if [[ $OPSYS == "windows" ]]; then
  export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0
  export BROWSER="/mnt/c/Windows/explorer.exe"
fi
```

1. If I'm running on a Windows machine, I run Emacs by starting a daemon inside my terminal and connecting with `emacsclient`. Doing so spawns a new frame using the X display server running on the Windows host itself

2. While I don't believe this actually works, I attempt to override the `BROWSER` environment variable to open links on the Windows host from within Emacs

## Functions

Some of these are handy but mostly I forget to use them or don't have a use so might as well remove them to keep my config tidy.

### Quick shortcuts to push and pull the current branch

While I can just do `git pull`, setting tracking branches is annoying because I always call them the same as their upstream branch.

These commands just push to and pull from the current branch explicitly.

```bash
function gpl { git branch | grep '*' | cut -c3- | xargs -I{} git pull origin {} }
function gps { git branch | grep '*' | cut -c3- | xargs -I{} git push origin {} }
function pap { git branch | grep '*' | cut -c3- | xargs -I{} git pull upstream {} && git push origin {} }
```

### I'd like to see all resources in any given Kubernetes namespace

Annoyingly, the `kubectl get all` command doesn't actually do what it says on the tin.

Specifically, "all" in this case only includes a couple of different resources like `pods` and `services`.

As a workaround, it's a bit slow but we can just enumerate through all of the supported resources and see what we get back.

```bash
function get-all-resources() {
    kubectl api-resources --verbs=list --namespaced -o name | xargs -n 1 kubectl get --show-kind --ignore-not-found -n $@
}
```

### Extract emails from a webpage

I recently discovered `html-xml-utils` which has some handy functionality so this is a basic script to try and extract mailto links from a webpage

While I never got aroudn to using this much, I would try out [scrape](https://github.com/lawzava/scrape) instead.

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

### View all ingress domain names found in a cluster

```bash
function ingresses() {
  kubectl get ingresses --all-namespaces -o json |
    jq -r '.items[].spec.rules[].host' | 
    fzf --preview="curl -I -L https://{}"
}
```

### Create a new blog post for my site

Hugo archetypes are the way to do this but I'm not sure if I have my folders configured properly.

I never remember to use this and like manually curating my files anyway.

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
      Yes ) $EDITOR ~/utf9k/content/blog/20xx--$SLUG/index.md; echo "Nice work!"; break;;
      No ) break;;
      Delete ) rm -rf ~/utf9k/content/blog/20xx--$SLUG; echo "Deleted"; break;;
    esac
  done
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
