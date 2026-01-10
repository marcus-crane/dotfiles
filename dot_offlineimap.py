#!/usr/bin/env python3
from subprocess import check_output

def get_pass():
    return check_output(
        ["op", "read", "op://dotfiles/offlineimap3 Homeostasis Fastmail/password"]
    ).decode().strip()
