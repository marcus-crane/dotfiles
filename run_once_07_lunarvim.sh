#!/bin/bash

LV_BRANCH=rolling bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh) --no-install-dependencies --overwrite  >/dev/null 2>&1 || true && echo "~ lunarvim has been installed"
