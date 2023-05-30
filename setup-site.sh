#!/usr/bin/env bash

# Create docs folder
mkdir docs

# Intro
cp README.md docs


# Root Home Directory ($HOME)
cp sqliterc.md docs
cp zshrc.md docs

# SSH (~/.ssh)
mkdir -p docs/home/ssh

cp dot_ssh/authorized_keys.md docs

# Extras
cp playground.md docs
cp zshrc-graveyard.md docs