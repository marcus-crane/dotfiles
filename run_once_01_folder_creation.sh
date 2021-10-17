#!/bin/bash

directories=(
  "$HOME/.ssh-sockets"
  "$HOME/Code"
  "$HOME/Pictures/Screenshots"
  "$HOME/tmp"
  "$HOME/.tmux/plugins/tpm"
)

for i in "${directories[@]}"; do
  if ! [ -d "$i" ]; then
    mkdir -p "$i"
    echo "Creating $i"
  fi
done
