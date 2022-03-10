#!/bin/bash

# fzf shell completion
"$(brew --prefix)"/opt/fzf/install --all  >/dev/null 2>&1 || true && echo "~ fzf shell completion has been installed"
