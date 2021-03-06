;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Marcus Crane"
      user-mail-address "marcus@utf9k.net")

(setq storage "~/Dropbox")

(display-time-mode 1)

(defun doom-modeline-conditional-buffer-encoding ()
  "We expect the encoding to be LF UTF-8, so only show the modeline when this is not the case"
  (setq-local doom-modeline-buffer-encoding
              (unless (or (eq buffer-file-coding-system 'utf-8-unix)
                          (eq buffer-file-coding-system 'utf-8)))))

(add-hook 'after-change-major-mode-hook #'doom-modeline-conditional-buffer-encoding)

(after! org
  (setq org-directory (concat storage "/org/")))

(setq org-agenda-files (directory-files-recursively org-directory "\\.org$"))

(use-package deft
  :after org
  :custom
  (deft-recursive t)
  (deft-extensions '("org" "md" "markdown"))
  (deft-use-filter-string-for-filename t)
  (deft-default-extension "org")
  (deft-directory org-directory))

(beacon-mode 1)

(add-hook 'beancount-mode-hook #'outline-minor-mode)

(add-hook 'fish-mode-hook (lambda () (add-hook 'before-save-hook 'fish-indent=before-save)))
