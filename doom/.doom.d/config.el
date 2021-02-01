;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Marcus Crane"
      user-mail-address "marcus@utf9k.net")

(setq netocean "~/netocean")

(after! org
  (setq org-directory (concat netocean "/org/")))

(after! org
  (setq deft-directory org-directory
        deft-extensions '("md" "org" "txt")))
