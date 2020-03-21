#!/bin/bash

###########################################
# A bootstrapping script to get my system #
# up and running just enough to run some  #
# more in-depth setup scripts             #
###########################################

CHECKMARK="✔"
CROSS="✖"

echo "Welcome! Let's get started"

if [[ $(uname -r) =~ 'microsoft' ]]; then
  export OPSYS="wsl"
else
  export OPSYS="${(L)$(uname 0s)}"
fi

case $OPSYS in
  "wsl"    ) PACMNGR="sudo apt-get" ;;
  "linux"  ) PACMNGR="sudo apt-get" ;;
  "darwin" ) PACMNGR="brew"         ;;
esac

echo "Looks like we're running on a $OPSYS system"

echo "First we'll check that we've got the latest system packages"

$PACMNGR update -y >> /dev/null
$PACMNGR upgrade -y >> /dev/null

echo "Let's see what we're missing"

[[ $(command -v git ) != '' ]] && GIT_INSTALLED=true  || GIT_INSTALLED=false
[[ $(command -v nvim) != '' ]] && NVIM_INSTALLED=true || NVIM_INSTALLED=false
[[ $(command -v stow) != '' ]] && STOW_INSTALLED=true || STOW_INSTALLED=false
[[ $(command -v zsh ) != '' ]] && ZSH_INSTALLED=true  || ZSH_INSTALLED=false

function get_display_status () {
  if [ "$1" = true ]; then
  	echo $CHECKMARK
  else
  	echo $CROSS
  fi
}

echo -e '\nPrograms\n---'
echo "Git    [$(get_display_status $GIT_INSTALLED)]"
echo "Neovim [$(get_display_status $NVIM_INSTALLED)]"
echo "Stow   [$(get_display_status $STOW_INSTALLED)]"
echo "ZSH    [$(get_display_status $ZSH_INSTALLED)]"
echo -e '\n'

read -p 'Press [Enter] to continue setup'

# ---

if [[ GIT_INSTALLED == false || NEOVIM_INSTALLED == false || STOW_INSTALLED == false || ZSH_INSTALLED == false ]]; then

	if [ GIT_INSTALLED != true ]; then
		echo "Installing Git..."


		$PACMNGR install -y git
	fi

	if [ NVIM_INSTALLED != true ]; then
		echo "Installing Neovim..."


		$PACMNGR install -y neovim
	fi

	if [ GIT_INSTALLED != true ]; then
		echo "Installing Stow..."


		$PACMNGR install -y stow
	fi

	if [ ZSH_INSTALLED != true ]; then
		echo "Installing ZSH..."

		$PACMNGR install -y zsh
	fi
fi

# ---

[[ $(command -v git ) != '' ]] && GIT_INSTALLED=true  || GIT_INSTALLED=false
[[ $(command -v nvim) != '' ]] && NVIM_INSTALLED=true || NVIM_INSTALLED=false
[[ $(command -v stow) != '' ]] && STOW_INSTALLED=true || STOW_INSTALLED=false
[[ $(command -v zsh ) != '' ]] && ZSH_INSTALLED=true  || ZSH_INSTALLED=false

function get_display_status () {
  if [ "$1" = true ]; then
  	echo $CHECKMARK
  else
  	echo $CROSS
  fi
}

echo -e '\nPrograms\n---'
echo "Git    [$(get_display_status $GIT_INSTALLED)]"
echo "Neovim [$(get_display_status $NVIM_INSTALLED)]"
echo "Stow   [$(get_display_status $STOW_INSTALLED)]"
echo "ZSH    [$(get_display_status $ZSH_INSTALLED)]"
echo -e '\n'

# ---

echo 'Cloning dotfiles'

cd ~
git clone https://github.com/marcus-crane/dotfiles

echo 'Setting up various aliases'
stow nvim

echo 'Setting up zsh'

cd dotfiles
stow zsh
chsh -s $(which zsh)

echo 'You should be good to go! Start a new terminal session to move in to ZSH land'
echo 'I recommend moving straight onto the other setup scripts since some zsh aliases will still be broken'