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

(setq org-cal-dir "~/netocean.utf9k.net/org/calendars/"
      org-cal-list `(
                     (:calendar-id "12a4af42-ca44-455a-a935-d10eb99b93aa"
                      :sync 'twoway
                      :inbox ,(concat org-cal-dir "adventures.org"))
                     (:calendar-id "D43720AE-4BFE-4026-92E3-514FABD36D31"
                      :sync 'twoway
                      :inbox ,(concat org-cal-dir "errands.org"))
                     (:calendar-id "571F4C73-A096-4293-B961-75391E213A87"
                      :sync 'twoway
                      :inbox ,(concat org-cal-dir "notices.org"))
                     (:calendar-id "367e7e37-1def-4f23-aac7-3af7a6e87f76"
                      :sync 'cal->org
                      :inbox ,(concat org-cal-dir "pagerduty.org"))
                     (:calendar-id "722b72a9-04ba-488b-93aa-4047f4a83018"
                      :sync 'cal->org
                      :inbox ,(concat org-cal-dir "work.org"))
                     ))

(setq org-cal-cache (concat org-cal-dir "cache/"))
(use-package org-caldav
  :defer 3
  :after org
  :config
  (setq org-caldav-url "https://caldav.fastmail.com/dav/calendars/user/marcus@utf9k.net"
        org-caldav-calendars org-cal-list
        org-caldav-delete-org-entries 'never
        org-caldav-resume-aborted 'never
        org-caldav-save-directory org-cal-cache))
