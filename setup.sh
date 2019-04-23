################################################
# My personal setup script for macOS and Linux #
################################################

# Order of operations
# 1) Install Homebrew (mmm)
# 2) Install languages / interpreters such as Python, Node/JS, Elixir etc
# 3) Install my current shell of choice
# 4) Install dotfiles (overwriting defaults from above)
# 5) Install helper utilities, GNU tools and other bits

if [[ $(command -v brew) == "" ]]; then
    echo "Installing some delicious Homebrew"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    echo "Nice, you've got Homebrew already. Let's make sure it's up to date!"
    brew update
fi
echo "Done"