---
title: Homebrew Packages
category: scripts
tags:
- applications
- shell
output: run_once_01_packages-darwin.sh.tmpl
---

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

## Taps

### Official taps

#### cask-fonts

Nothing particularly interesting to see here.

[homebrew-cask-fonts](https://github.com/Homebrew/homebrew-cask-fonts) contains lots of fonts but it's most commonly used for installing [Nerd Fonts](https://www.nerdfonts.com/).

That is, fonts which are modified to work nicely with icons, great for use in the terminal to represent things like Git branch states and that.

By default, most fonts don't have support for glyphs and things, hence the modifications to the underlying fonts.

```bash
tap "homebrew/cask-fonts"
```

#### cask-versions

As for [homebrew-cask-versions](https://github.com/Homebrew/homebrew-cask-versions), it contains alternative versions of Homebrew casks.

Not just older versions but also beta and canary versions as well.

I don't think I actively use it but in the past, it's been handy to grab [Chrome Canary](https://www.google.com/intl/en_au/chrome/canary/) for testing in a pinch.

```bash
tap "homebrew/cask-versions"
```

## The rest

TBA

```bash
# Community taps
tap "espanso/espanso"
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
brew "docker-credential-helper-ecr"
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
brew "granted"
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
brew "openssl@1.1"
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
cask "charles", args: { force: true }
cask "cleanshot", args: { force: true }
cask "dbngin", args: { force: true }
cask "discord", args: { force: true }
cask "espanso", args: { force: true }
cask "flycut", args: { force: true }
cask "goland", args: { force: true }
cask "gpg-suite-no-mail", args: { force: true }
cask "insomnia", args: { force: true }
cask "iterm2", args: { force: true }
cask "keka", args: { force: true }
cask "kekaexternalhelper", args: { force: true }
cask "obsidian", args: { force: true }
cask "plexamp", args: { force: true }
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
mas "iA Writer", id: 775737590
mas "Book Track", id: 1496543317
mas "Parcel", id: 639968404
mas "Shazam", id: 897118787
mas "Tailscale", id: 1475387142
mas "TestFlight", id: 899247664 # Only available on macOS 12+

EOF

/usr/bin/xattr -r -d com.apple.quarantine ~/Library/QuickLook/*.qlgenerator
qlmanage -r >/dev/null 2>&1 || true && echo "~~ quicklook extensions have been configured"

# Used to fix a PHP compilation issue
# ln -sf /Applications/Postgres.app/Contents/Versions/latest/bin/pg_config  /usr/local/bin/pg_config

{{ end -}}
```
