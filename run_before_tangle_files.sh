#!/usr/bin/env bash

LUGH_BIN="${HOME}/.bin/lugh"

if [ ! -x "$LUGH_BIN" ]; then
  echo "Skipping tangling as lugh not found at expected location of $LUGH_BIN"
  exit 0
fi

SOURCE_PATH="$(chezmoi source-path)"

while IFS= read -r -d '' file; do
  if head -n 10 "$file" | grep -q "^output:"; then
    "$LUGH_BIN" -f "$file" && echo "~ $file has been tangled"
  fi
done < <(find "$SOURCE_PATH" -type f -name '*.md' -print0)
