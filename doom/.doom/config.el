;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Marcus Crane"
      user-mail-address "marcus@utf9k.net")

(setq dropbox       (getenv "DROPBOX_DIR")
      org-directory (concat dropbox "/org/"))

(setq org-agenda-directory (concat org-directory "gtd/"))
(setq org-agenda-files
      `(,(concat org-agenda-directory "inbox.org")
        ,(concat org-agenda-directory "gtd.org")
        ,(concat org-agenda-directory "tickler.org")))

(setq org-archive-location
      (concat org-agenda-directory "archive/archive-"
              (format-time-string "%Y%m" (current-time))
              ".org::"))

(setq org-todo-keywords
      '((sequence
         "TODO(t)"
         "NEXT(n)"
         "|"
         "DONE(d)")
        (sequence
         "WAITING(w@/!)")))

(setq org-tag-alist
      '(("@errand" . ?e)
        ("@home"   . ?h)
        ("@office" . ?o)))

(setq org-refile-targets
      `((,(concat org-agenda-directory "ideas.org") :level . 0)
        (,(concat org-agenda-directory "gtd.org") :maxlevel . 1)
        (,(concat org-agenda-directory "someday.org") :level . 0)
        (,(concat org-agenda-directory "tickler.org") :maxlevel . 1)))

(setq org-agenda-todo-ignore-scheduled 'future)

(setq org-capture-templates
      `(("i" "inbox" entry
         (file ,(concat org-agenda-directory "inbox.org"))
         "* TODO %i%?")
        ))
