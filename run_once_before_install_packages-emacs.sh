#!/bin/bash

if ! [ -d "$HOME/.emacs.d" ]; then
	git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
fi