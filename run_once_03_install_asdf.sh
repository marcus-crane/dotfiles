#!/bin/bash

if [[ ! $(command -v asdf) ]]; then
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.1
fi
