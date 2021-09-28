# dotfiles

Currently, I use [chezmoi](https://github.com/twpayne/chezmoi) as a dotfile manager which runs a bunch of preinstallation scripts and then applies all dotfiles in this repo to `$HOME`.

This differs quite a bit from my previous setup which used [GNU Stow](https://www.gnu.org/software/stow/) to symlink files to `$HOME` but so far, I like it a lot and it makes the setup process mostly automatic between machines.

All I really tend to do is run `chezmoi update` and changes are applied to various machines without much trouble.

## Installation

The nice thing about chezmoi is that it's fairly one shot meaning you can go from a fresh machine with no tools to a set up config with one command. If you're interested in installing my dotfiles for whatever reason, you can do so with this one liner:

```bash
sh -c "$(curl -fsLS git.io/chezmoi)" -- init --apply marcus-crane
```

That should do pretty much everything including tangling my zsh config and running all the pre-install scripts that use `Brew` to add system dependencies and so on.

## A note on tangling files

You may notice that some configuration files are seemingly missing with `.md` files in their place.

This is because a few, and in time most of, my config files are kept as "literate configuration".

In short, all of the surrounding commentary is stripped and the correct file is generated off of the source code blocks.

In order to "tangle" them into a proper config, I use [lugh](https://github.com/marcus-crane/lugh), a hacky custom made tool for tangling markdown.

I have used Emacs `org-tangle` for this job and it's nice but it's also quite a bit of overhead to get it running I think. Generally on a new machine, compiling Emacs can take quite some time.

Anyway, `lugh` should be installed automatically as part of the initial `chezmoi apply` so with that, you can "tangle" the file you're interested in like so:

```bash
lugh -f <file>
```

A working example would be:

```bash
lugh -f zshrc.md
# Wrote /Users/marcus/.local/share/chezmoi/dot_zshrc.tmpl
```

Instead of anything fancy, I just "tangle" the contents into a file that chezmoi expects and since it's a `.tmpl` file, it can also make use of chezmoi's built in variables.

## Installing languages with asdf

I used [asdf](https://asdf-vm.com) to manage language installs, with versioning stored in `asdf/.tool-versions`

They are installed by running `asdf install` in the location that `.tool-versions` is symlinked to. By default, that's `$HOME/.tool-versions`

A few prerequisite utilities are needed for a seamless install 

| Name      | Required for | Needed         |
| --------- | ------------ | -------------- |
| autoconf  | Erlang       | Yes            |
| coreutils | Node         | Yes            |
| gpg       | Node         | Install script |
| jq        | Terraform    | Install script |
| wxmac     | Erlang       | Optional       |

In future, I intend to make this all automated via chezmoi