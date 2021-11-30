#!/bin/bash

mkdir -p "$HOME/.zsh-plugins" && \
cd "$HOME/.zsh-plugins" && \
wget -qN https://raw.githubusercontent.com/larkery/zsh-histdb/master/sqlite-history.zsh
