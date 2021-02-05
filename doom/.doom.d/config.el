;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Marcus Crane"
      user-mail-address "marcus@utf9k.net")

(setq netocean "~/netocean")

(setq-default
 delete-by-moving-to-trash t)

(setq evil-want-fine-undo t
      auto-save-default t
      truncate-string-ellipsis "…")

(display-time-mode 1)

(if (equal "Battery status not available"
           (battery))
    (display-battery-mode 1)
  (setq password-cache-expiry nil))

(defun doom-modeline-conditional-buffer-encoding ()
  "We expect the encoding to be LF UTF-8, so only show the modeline when this is not the case"
  (setq-local doom-modeline-buffer-encoding
              (unless (or (eq buffer-file-coding-system 'utf-8-unix)
                          (eq buffer-file-coding-system 'utf-8)))))

(add-hook 'after-change-major-mode-hook #'doom-modeline-conditional-buffer-encoding)

(after! org
  (setq org-directory (concat netocean "/org/")))

(setq org-agenda-files '("~/netocean/org"))

(setq org-archive-location
      (concat org-directory "archive/archive-"
              (format-time-string "%Y%m" (current-time))
              ".org::"))

(setq org-agenda-include-diary t)

(setq org-agenda-dim-blocked-tasks t)

(setq org-todo-keywords
      '((sequence
         "TODO(t!)"
         "NEXT(n)"
         "SOMD(s)"
         "WAIT(w@/!)"
         "|"
         "DONE(d!)"
         "CANC(c!)")))

(setq org-tag-alist
      '(("@errand" . ?e)
        ("@home"   . ?h)
        ("@office" . ?o)))

(setq org-refile-targets
      `((,(concat org-directory "projects.org"))
        (,(concat org-directory "bugs.org"))
        (,(concat org-directory "tickler.org"))
        (,(concat org-directory "ideas.org"))
        (,(concat org-directory "work.org"))))

(setq org-treat-insert-todo-heading-as-state-change t
      org-log-into-drawer t)

(setq org-inbox (concat org-directory "inbox.org")
      org-capture-templates
      `(("i" "inbox" entry
         (file org-inbox)
         "* TODO %i%?")
        ))

(use-package! org-super-agenda
  :commands (org-super-agenda-mode)
  :init
  (map! "C-c a" #'switch-to-agenda)
  (defun switch-to-agenda ()
    (interactive)
    (org-agenda nil "c")))
(after! org-agenda
  (org-super-agenda-mode))

(setq org-agenda-skip-scheduled-if-done t
      org-agenda-skip-deadline-if-done t
      org-agenda-include-deadlines t
      org-agenda-block-separator nil
      org-agenda-compact-blocks t
      org-agenda-start-day nil
      org-agenda-span 1
      org-agenda-time-grid
      (quote
       ((daily today remove-match)
        (900 1100 1300 1500 1700)
        "......" "----------------"))
      org-agenda-start-on-weekday nil)

(setq org-agenda-custom-commands
      '(("c" "Super view"
         ((agenda "" ((org-agenda-overriding-header "")
                      (org-super-agenda-groups
                       '((:name "Today"
                          :time-grid t
                          :date today
                          :scheduled today
                          :order 1)))))
          (alltodo "" ((org-agenda-overriding-header "")
                       (org-super-agenda-groups
                        '((:log t)
                          (:name "To refile"
                           :file-path "inbox\\.org")
                          (:name "Next Up"
                           :todo "NEXT"
                           :order 1)
                          (:name "Coming Up"
                           :scheduled future
                           :order 8)
                          (:name "Overdue"
                           :deadline past
                           :order 7)
                          (:discard (:not (:todo "TODO")))))))))))

(use-package deft
  :after org
  :custom
  (deft-recursive t)
  (deft-use-filter-string-for-filename t)
  (deft-default-extension "org")
  (deft-directory org-directory))

(setq org-roam-directory (concat netocean "/brain/"))
(use-package! org-mac-iCal)

(after! org
  (require 'org-habit)
  (add-to-list 'org-modules 'org-habit))

(add-hook! 'elfeed-search-mode-hook 'elfeed-update)
(setq elfeed-db-directory "~/netocean/org/.caches/elfeed")
