#!/bin/bash

tools=(
  "gohugo"
  "golang"
  "helm"
  "kubectl"
  "lua"
  "neovim"
  "python"
  "shellcheck"
  "sqlite"
  "terraform"
  "tmux"
)

if [ -d "$HOME/.asdf" ]; then
	for i in "${tools[@]}"; do
		asdf plugin-add "$i"
	done
fi