---
title: Homebrew Packages
category: scripts
tags:
- applications
- shell
output: run_once_01_packages-darwin.sh.tmpl
---

# Homebrew Packages

This script uses `brew bundle` to install various macOS packages.

The reason that it is done inline instead of using a Brewfile is because Chezmoi basically hashes the script to determine whether it needs to be rerun again or not.

Inlining packages means that adding or removing files causes the script to be rerun as the hash will compute differently.

```bash
{{- if (eq .chezmoi.os "darwin") -}}
#!/usr/bin/env bash

echo "~ homebrew"

brew bundle --quiet --no-lock --file=/dev/stdin <<EOF && echo "~~ brew packages have been updated"
```

Now that all of our boring boilerplate is out of the way, let's see what we've got to play with!

```bash
# Community taps
tap "go-task/tap"
tap "jdx/tap"
tap "railwaycat/emacsmacport"
tap "vectordotdev/brew"
tap "yt-dlp/taps"

# Work taps
{{ if .workmode }}
tap "common-fate/granted"
{{ end }}

# my own projects
tap "marcus-crane/tap"
brew "khinsider"
brew "spanner"
cask "october", args: { force: true } # Hey, that's me!

# cli tools
brew "angle-grinder"
brew "aria2"
brew "autoconf"
brew "automake"
brew "bash"
brew "bison"
brew "cmake"
brew "comby"
brew "coreutils"
brew "create-dmg"
brew "curl"
brew "dbus"
brew "entr"
brew "fd"
brew "ffmpeg"
brew "flyctl"
brew "fzf"
brew "gh"
brew "git"
brew "glow"
brew "go-task"
brew "golangci-lint"
{{ if .workmode }}
brew "granted"
{{ end }}
brew "graphicsmagick"
brew "graphviz"
brew "gron"
brew "gnu-tar"
brew "hexyl"
brew "hey"
brew "hidapi"
brew "html-xml-utils"
brew "htop"
brew "hyperfine"
brew "ical-buddy"
brew "imagemagick"
brew "jansson"
brew "jq"
brew "libiconv"
brew "librdkafka"
brew "libxmlsec1"
brew "mise"
brew "moreutils"
brew "mpv"
brew "mtr"
brew "neomutt"
brew "nmap"
brew "notmuch"
brew "oha"
brew "onefetch"
brew "openssl"
brew "overmind"
brew "pandoc"
brew "pngcrush"
brew "pngpaste"
brew "protobuf"
brew "pwgen"
brew "rclone"
brew "re2c" # php build dependency
brew "ripgrep"
brew "source-highlight"
brew "speedtest-cli"
brew "telnet"
brew "terminal-notifier"
brew "texinfo"
brew "transmission-cli"
brew "tmuxp"
brew "tree"
brew "vdirsyncer"
brew "vector"
brew "vpn-slice"
brew "w3m"
brew "watch"
brew "webp"
brew "wget"
brew "wxwidgets"
brew "xz"
brew "yt-dlp"
brew "z"
brew "zsh"

# quicklook extensions
cask "gltfquicklook", args: { force: true }
cask "provisionql", args: { force: true }
cask "qladdict", args: { force: true }
cask "qlcommonmark", args: { force: true }
cask "qlstephen", args: { force: true }
cask "quickgeojson", args: { force: true }
cask "quicklook-csv", args: { force: true }

# fonts
cask "font-fira-code-nerd-font"
cask "font-hack-nerd-font"

# cask apps
# force is used here to overwrite any applications
# manually installed outside of brew. without force,
# these commands will fail otherwise
cask "calibre", args: { force: true }
cask "cleanshot", args: { force: true }
cask "dbngin", args: { force: true }
cask "discord", args: { force: true }
cask "flycut", args: { force: true }
cask "ghostty", args: { force: true }
cask "goland", args: { force: true }
cask "gpg-suite-no-mail", args: { force: true }
cask "hex-fiend", args: { force: true }
cask "iina", args: { force: true }
cask "insomnia", args: { force: true }
cask "keka", args: { force: true }
cask "kekaexternalhelper", args: { force: true }
cask "obsidian", args: { force: true }
cask "ogdesign-eagle", args: { force: true }
cask "plexamp", args: { force: true }
cask "proxyman", args: { force: true }
cask "pycharm", args: { force: true }
cask "raycast", args: { force: true }
cask "sidequest", args: { force: true }
cask "slack", args: { force: true }
cask "sublime-text", args: { force: true }
cask "tableplus", args: { force: true }
cask "ticktick", args: { force: true }
cask "trackerzapper", args: { force: true }
cask "transmission", args: { force: true }
cask "vlc", args: { force: true }

# mac app store
mas "1Password for Safari", id: 1569813296
mas "Baking Soda", id: 1601151613
mas "Book Tracker", id: 1496543317
mas "Kagi for Safari", id: 1622835804
mas "Parcel", id: 639968404
mas "Shazam", id: 897118787
mas "Tailscale", id: 1475387142
mas "TestFlight", id: 899247664 # Only available on macOS 12+
mas "Vinegar", id: 1591303229

EOF

/usr/bin/xattr -r -d com.apple.quarantine ~/Library/QuickLook/*.qlgenerator
qlmanage -r >/dev/null 2>&1 || true && echo "~~ quicklook extensions have been configured"

# Used to fix a PHP compilation issue
# ln -sf /Applications/Postgres.app/Contents/Versions/latest/bin/pg_config  /usr/local/bin/pg_config

{{ end -}}
```
