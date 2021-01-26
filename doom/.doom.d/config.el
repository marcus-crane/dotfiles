;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Marcus Crane"
      user-mail-address "marcus@utf9k.net")

(setq dropbox     (getenv "DROPBOX_DIR")
      dropbox-org (concat dropbox "/org/"))

(after! org (setq org-directory dropbox-org))

(after! org
  (setq org-agenda-directory (concat dropbox-org "gtd/")
        org-agenda-files
        `(,(concat org-agenda-directory "inbox.org")
          ,(concat org-agenda-directory "gtd.org")
          ,(concat org-agenda-directory "tickler.org"))))

(after! org
  (setq org-archive-location
        (concat org-agenda-directory "archive/archive-"
                (format-time-string "%Y%m" (current-time))
                ".org::")))

(after! org
  (setq org-todo-keywords
        '((sequence
           "TODO(t)"
           "NEXT(n)"
           "|"
           "DONE(d)")
          (sequence
           "WAITING(w@/!)"))))

(after! org
  (setq org-tag-alist
        '(("@errand" . ?e)
          ("@home"   . ?h)
          ("@office" . ?o))))

(after! org
  (setq org-refile-targets
        `((,(concat org-agenda-directory "ideas.org") :level . 0)
          (,(concat org-agenda-directory "gtd.org") :maxlevel . 2)
          (,(concat org-agenda-directory "someday.org") :level . 0)
          (,(concat org-agenda-directory "tickler.org") :maxlevel . 1))))

(after! org (setq org-agenda-todo-ignore-scheduled 'future))

(after! org
  (setq org-capture-templates
        `(("i" "inbox" entry
           (file ,(concat org-agenda-directory "inbox.org"))
           "* TODO %i%?")
          )))

(after! org
  (require 'org-habit)
  (add-to-list 'org-modules 'org-habit))
