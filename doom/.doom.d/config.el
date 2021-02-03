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

(after! org
  (setq org-agenda-directory org-directory
        org-agenda-files '("~/netocean/org")))

(setq org-agenda-include-diary t)

(use-package deft
  :after org
  :custom
  (deft-recursive t)
  (deft-use-filter-string-for-filename t)
  (deft-default-extension "org")
  (deft-directory org-directory))

(use-package! org-super-agenda
  :commands (org-super-agenda-mode))
(after! org-agenda
  (org-super-agenda-mode))

(setq org-agenda-skip-scheduled-if-done t
      org-agenda-skip-deadline-if-done t
      org-agenda-include-deadlines t
      org-agenda-block-separator nil
      org-agenda-compact-blocks t
      org-agenda-start-day nil
      org-agenda-span 1
      org-agenda-start-on-weekday nil)

(setq org-agenda-custom-commands
      '(("c" "Super view"
         ((agenda "" ((org-agenda-overriding-header "")
                      (org-super-agenda-groups
                       '((:name "Today"
                          :time-grid t
                          :date today
                          :order 1)))))
          (alltodo "" ((org-agenda-overriding-header "")
                       (org-super-agenda-groups
                        '((:log t)
                          (:name "To refile"
                           :file-path "refile\\.org")
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

(setq org-roam-directory (concat netocean "/brain/"))
(use-package! org-mac-iCal)
