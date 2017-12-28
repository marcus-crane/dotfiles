[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
feh --bg-max --randomize ~/Wallpapers/* &
autocutsel -f
exec i3
