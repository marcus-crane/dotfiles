[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
feh --bg-max --randomize ~/Wallpapers/* &
autocutsel -f
[ ! -s ~/.config/mpd/pid ] && mpd
exec i3
