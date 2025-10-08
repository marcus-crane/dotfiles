---
title: Homebrew Packages
category: scripts
tags:
- applications
- shell
output: run_once_01_packages-darwin.sh.tmpl
---

# Homebrew Packages

This script uses `brew bundle` to install various macOS packages.

The reason that it is done inline instead of using a Brewfile is because Chezmoi basically hashes the script to determine whether it needs to be rerun again or not.

Inlining packages means that adding or removing files causes the script to be rerun as the hash will compute differently.

```bash
{{- if (eq .chezmoi.os "darwin") -}}
#!/usr/bin/env bash

set -euo pipefail

echo "~ homebrew"

brew bundle --quiet --file=/dev/stdin <<EOF && echo "~~ brew packages have been updated"
```

Now that all of our boring boilerplate is out of the way, let's see what we've got to play with!

```bash
# community taps
{{ range .packages.darwin.taps -}}
tap "{{ .ref }}"
{{ end -}}

# cli tools
{{ range .packages.darwin.brews -}}
brew "{{ .ref }}"
{{ end -}}

# cask apps
# force is used here to overwrite any applications
# manually installed outside of brew. without force,
# these commands will fail otherwise
{{ range .packages.darwin.casks -}}
cask "{{ .ref }}", args: { force: true }
{{ end -}}

# mac app store
{{ range .packages.darwin.mas -}}
mas "{{ .name }}", id: {{ .ref }}
{{ end -}}
EOF

/usr/bin/xattr -r -d com.apple.quarantine ~/Library/QuickLook/*.qlgenerator
qlmanage -r >/dev/null 2>&1 || true && echo "~~ quicklook extensions have been configured"

# Used to fix a PHP compilation issue
# ln -sf /Applications/Postgres.app/Contents/Versions/latest/bin/pg_config  /usr/local/bin/pg_config

{{ end -}}
```
