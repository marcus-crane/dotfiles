# dotfiles

I recently came across [Brandon Invergo](https://twitter.com/brandoninvergo)'s [blog post](http://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html) about [GNU Stow](https://www.gnu.org/software/stow/) after battling with dotfile configuration for quite some time.

The top level files are simply categories and running `stow {folder name}` on them will symlink the contents to `$HOME`.

For example, let's say you used `stow` on `mopidy/.config/mopidy`. It would ignore the top level directory and starting from
`$HOME` (eg; `/home/marcus`), it would place the folder in `home/marcus/.config/mopidy`.

The nice thing about it is that everything is kept organised in one folder but you don't have to worry about conflicts since you need to explicitly use stow on each folder.

## A note on tangling files

You may notice that some configuration files are seemingly missing with `.md` files in their place.

This is because a few, and in time most of, my config files are kept as "literate configuration".

In short, all of the surrounding commentary is stripped and the correct file is generated off of the source code blocks.

In order to "tangle" them into a proper config, you'll need to have [codedown](https://github.com/earldouglas/codedown) installed.

Assuming it's installed, you can "tangle" the file you're interested in like so:

```bash
cat <file> | codedown <language> > <output>
```

A working example would be:

```bash
cat ~/dotfiles/zsh/zshrc.md | codedown bash > ~/dotfiles/zsh/.zshrc && stow zsh -d ~/dotfiles
```

This emulates the same functionality I had using `org-mode` for literate programming but without the dependency of installing `emacs` which can take a little while

In future, I look to replace `codedown` with something more lightweight as not only does it require `node/npm` installed but there's still a catch 22 aspect where you need your config installed to source codedown in the first place

## Installing languages with asdf

I used [asdf](https://asdf-vm.com) to manage language installs, with versioning stored in `asdf/.tool-versions`

They are installed by running `stow asdf` followed by `asdf install` in the location that `.tool-versions` is symlinked to. By default, that's `$HOME/.tool-versions`

A few prerequisite utilities are needed for a seamless install 

| Name      | Required for | Needed         |
| autoconf  | Erlang       | Yes            |
| coreutils | Node         | Yes            |
| gpg       | Node         | Install script |
| jq        | Terraform    | Install script |
| wxmac     | Erlang       | Optional       |
