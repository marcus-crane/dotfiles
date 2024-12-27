#!/usr/bin/env bash

while IFS= read -r -d '' file
do
  ~/.bin/lugh -f "$file" && echo "~ $file has been tangled"
done <   <(find "$(chezmoi source-path)" -type f -name '*.md' ! -path './docs/index.md' ! -name 'playground.md' ! -name 'README.md' ! -name 'zshrc-graveyard.md' ! -name 'todo.md' ! -name 'index.md' -print0)
