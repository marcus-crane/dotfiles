;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Marcus Crane"
      user-mail-address "marcus@utf9k.net")

(setq netocean "~/netocean")

(after! org
  (setq org-directory (concat netocean "/org/")))

(after! org
  (setq org-agenda-directory org-directory
        org-agenda-files
        `(,(concat org-agenda-directory "adventures.org")
          ,(concat org-agenda-directory "errands.org")
          ,(concat org-agenda-directory "habits.org")
          ,(concat org-agenda-directory "inbox.org")
          ,(concat org-agenda-directory "notices.org")
          ,(concat org-agenda-directory "pagerduty.org")
          ,(concat org-agenda-directory "projects.org")
          ,(concat org-agenda-directory "someday.org")
          ,(concat org-agenda-directory "tickler.org")
          ,(concat org-agenda-directory "work.org")
          )))

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
          (,(concat org-agenda-directory "projects.org") :maxlevel . 2)
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

(use-package! org-agenda
  :init
  (map! "C-c a" #'switch-to-agenda)
  (defun switch-to-agenda ()
    (interactive)
    (org-agenda nil " "))
  :config
  (setq org-columns-default-format "%40ITEM(Task) %Effort(EE){:} %CLOCKSUM(Time Spent) %SCHEDULED(Scheduled) %DEADLINE(Deadline)"
        org-agenda-custom-commands `((" " "Agenda"
                                      ((todo "NEXT"
                                             ((org-agenda-overriding-header "Current Focus")
                                              (org-agenda-files '(,(concat org-agenda-directory "projects.org")
                                                                  ,(concat org-agenda-directory "inbox.org")))
                                              ))
                                       (agenda ""
                                               ((org-agenda-span 'week)
                                                (org-deadline-warning-days 365)))
                                       (todo "TODO"
                                             ((org-agenda-overriding-header "Inbox")
                                              (org-agenda-files '(,(concat org-agenda-directory "inbox.org")))
                                              ))
                                       )))))