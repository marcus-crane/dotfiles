

if [[ $(command -v brew) == "" ]]; then
    echo "Installing some delicious Homebrew"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    echo "Nice, you've got Homebrew already. Let's make sure it's up to date!"
    brew update
fi
echo "Done"