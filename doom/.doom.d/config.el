;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Marcus Crane"
      user-mail-address "marcus@utf9k.net")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "monospace" :size 14))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(after! org (setq org-directory "~/Dropbox/org/"))
(after! org (setq org-agenda-files '("~/Dropbox/org/gtd/inbox.org"
                                     "~/Dropbox/org/gtd/gtd.org"
                                     "~/Dropbox/org/gtd/tickler.org")))

;; src 1: https://blog.jethro.dev/posts/capturing_inbox/
;; src 2: https://emacs.cafe/emacs/orgmode/gtd/2017/06/30/orgmode-gtd.html
;; note : https://emacs.stackexchange.com/questions/7481/how-to-evaluate-the-variables-before-adding-them-to-a-list
;; the backtick (`) here has symantic meaning!
(setq marcus/org-agenda-directory "~/Dropbox/org/gtd/")
(after! org
  (setq org-capture-templates
      `(("i" "inbox" entry
         (file ,(concat marcus/org-agenda-directory "inbox.org"))
         "* TODO %i%?")
        ("l" "link" entry
         (file ,(concat marcus/org-agenda-directory "inbox.org"))
         "* TODO %(org-cliplink-capture)"
         :immediate-finish t)
        ("c" "org-protocol-capture" entry
         (file ,(concat marcus/org-agenda-directory "inbox.org"))
         "* TODO [[%:link][%:description]]\n\n %i"
         :immediate-finish t)
        ("t" "tickler" entry
         (file ,(concat marcus/org-agenda-directory "tickler.org"))
         "* %i%? \n %U"
        ))))

;; Refile targets to move a task from one gtd file to another
(after! org (setq org-refile-targets
      `((,(concat marcus/org-agenda-directory "gtd.org") :maxlevel . 3)
        (,(concat marcus/org-agenda-directory "someday.org") :level . 1)
        (,(concat marcus/org-agenda-directory "tickler.org") :maxlevel . 2))))

;; Set some default keywords to use as org task statuses
(after! org (setq org-todo-keywords '((sequence "TODO(t)" "WAITING(w)" "PROJ(p)" "|" "DONE(d)" "CANCELLED(c)"))))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.
(use-package! org-roam
  :commands (org-roam-insert org-roam-find-file org-roam-switch-to-buffer org-roam)
  :hook
  (after-init . org-roam-mode)
  :custom-face
  (org-roam-link ((t (:inherit org-link :foreground "#005200"))))
  :init
  (map! :leader
        :prefix "n"
        :desc "org-roam" "l" #'org-roam
        :desc "org-roam-insert" "i" #'org-roam-insert
        :desc "org-roam-switch-to-buffer" "b" #'org-roam-switch-to-buffer
        :desc "org-roam-find-file" "f" #'org-roam-find-file
        :desc "org-roam-graph" "g" #'org-roam-graph
        :desc "org-roam-insert" "i" #'org-roam-insert
        :desc "org-roam-capture" "c" #'org-roam-capture)
  (setq org-roam-directory "~/Dropbox/org/notes/"
        org-roam-db-location "~/org-roam.db"
        org-roam-graph-exclude-matcher "private")
  :config
  (require 'org-roam-protocol)
  (setq org-roam-capture-templates
      '(("d" "default" plain (function org-roam--capture-get-point)
         "%?"
         :file-name "${slug}"
         :head "#+TITLE: ${title}\n"
         :unnarrowed t)
        ("p" "private" plain (function org-roam-capture--get-point)
         "%?"
         :file-name "private-${slug}"
         :head "#+TITLE: ${title}\n"
         :unnarrowed t)))
  (setq org-roam-ref-capture-templates
        '(("r" "ref" plain (function org-roam-capture--get-point)
           "%?"
           :file-name "websites/${slug}"
           :head "#+ROAM_KEY: ${ref}\n#+TITLE: ${title}\n\n- source :: ${ref}"
           :unnarrowed t))))

(use-package deft
  :after org
  :bind
  ("C-c n d" . deft)
  :custom
  (deft-recursive t)
  (deft-use-filter-string-for-filename t)
  (deft-default-extension "org")
  (deft-directory "~/Dropbox/org/"))

(use-package! org-journal
  :bind
  ("C-c n j" . org-journal-new-entry)
  :config
  (setq org-journal-date-prefix "#+TITLE: "
        org-journal-file-format "private-%Y-%m-%d.org"
        org-journal-dir "~/Dropbox/org/notes/"
        org-journal-carryover-items nil
        org-journal-date-format "%Y-%m-%d"))
