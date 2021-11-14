#!/bin/bash

while IFS= read -r -d '' file
do
  lugh -f "$file"
done <   <(find "$(chezmoi source-path)" -type f -name '*.md' ! -name 'README.md' ! -name 'zshrc-graveyard.md' -print0)
