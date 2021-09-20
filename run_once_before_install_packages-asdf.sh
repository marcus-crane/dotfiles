#!/bin/bash

if ! [ -d "$HOME/.asdf" ]; then
	git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.1
fi