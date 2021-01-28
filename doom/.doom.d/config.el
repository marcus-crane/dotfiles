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
          ,(concat org-agenda-directory "cal-errands.org")
          ,(concat org-agenda-directory "habits.org")
          ,(concat org-agenda-directory "inbox.org")
          ,(concat org-agenda-directory "projects.org")
          ,(concat org-agenda-directory "cal-notices.org")
          ,(concat org-agenda-directory "cal-pagerduty.org")
          ,(concat org-agenda-directory "someday.org")
          ,(concat org-agenda-directory "tickler.org")
          ,(concat org-agenda-directory "cal-work.org")
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

(after! org
  (setq org-cal-cache (concat org-agenda-directory "caches/")
        org-cal-list `(
                       (:calendar-id "12a4af42-ca44-455a-a935-d10eb99b93aa"
                        :sync 'cal->org
                        :inbox ,(concat org-agenda-directory "cal-adventures.org"))
                       (:calendar-id "D43720AE-4BFE-4026-92E3-514FABD36D31"
                        :sync 'cal->org
                        :inbox ,(concat org-agenda-directory "cal-errands.org"))
                       (:calendar-id "571F4C73-A096-4293-B961-75391E213A87"
                        :sync 'cal->org
                        :inbox ,(concat org-agenda-directory "cal-notices.org"))
                       (:calendar-id "367e7e37-1def-4f23-aac7-3af7a6e87f76"
                        :sync 'cal->org
                        :inbox ,(concat org-agenda-directory "cal-pagerduty.org"))
                       (:calendar-id "95f79eb1-f737-48c2-9c14-0958a75d73a1"
                        :sync 'cal->org
                        :inbox ,(concat org-agenda-directory "cal-work.org"))
                       )))

(use-package org-caldav
  :defer 3
  :after org
  :config
  (setq org-caldav-url "https://caldav.fastmail.com/dav/calendars/user/marcus@utf9k.net"
        org-caldav-calendars org-cal-list
        org-caldav-delete-org-entries 'never
        org-caldav-resume-aborted 'never
        org-caldav-save-directory org-cal-cache))
