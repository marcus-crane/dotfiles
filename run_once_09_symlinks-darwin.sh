{{- if (eq .chezmoi.os "darwin") -}}
#!/bin/bash

if [[ ! -d ~/org ]]; then
  ln -s /Users/marcus/Library/Mobile\ Documents/iCloud~com~appsonthemove~beorg/Documents/org ~
fi

{{ end -}}
