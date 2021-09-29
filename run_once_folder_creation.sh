#!/bin/bash

directories=(
  "$HOME/.ssh-sockets"
  "$HOME/Code"
  "$HOME/tmp"
  "$HOME/.tmux/plugins"
)

for i in "${directories[@]}"; do
  if ! [ -d "$i" ]; then
    mkdir -p "$i"
    echo "Creating $i"
  fi
done
