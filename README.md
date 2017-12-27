# dotfiles

I recently came across [Brandon Invergo](https://twitter.com/brandoninvergo)'s [blog post](http://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html) about [GNU Stow](https://www.gnu.org/software/stow/) after battling with dotfile configuration for quite some time.

The top level files are simply categories and running `stow {folder name}` on them will symlink the contents to `$HOME`.

For example, let's say you used `stow` on `mopidy/.config/mopidy`. It would ignore the top level directory and starting from `$HOME` (eg; /home/marcus), it would place the folder in `home/marcus/.config/mopidy`.

The nice thing about it is that everything is kept organised in one folder but you don't have to worry about conflicts since you need to explicitly use stow on each folder.
