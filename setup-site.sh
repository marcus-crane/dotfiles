#!/usr/bin/env bash

# Intro
cp README.md site/docs/intro.md

# Root Home Directory ($HOME)
mkdir -p site/docs/home

cp sqliterc.md site/docs/home/
cp zshrc.md site/docs/home/

# SSH (~/.ssh)
mkdir -p site/docs/home/ssh

cp dot_ssh/authorized_keys.md site/docs/home/ssh/authorized_keys.md

# Extras
mkdir -p site/docs/extras

cp playground.md site/docs/extras
cp zshrc-graveyard.md site/docs/extras