(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(add-hook 'emacs-startup-hook 'org-agenda-list)

(use-package modus-themes
  :ensure t
  :config
  (load-theme 'modus-vivendi-tinted :no-confirm-loading))

(setq user-full-name "William J. O'Brien"
      user-mail-address "william.obrien@va.gov")

(let ((mono-spaced-font "Fira Code Medium")
      (proportionately-spaced-font "CMU Serif"))
  (set-face-attribute 'default nil :family mono-spaced-font :height 100)
  (set-face-attribute 'fixed-pitch nil :family mono-spaced-font :height 1.0)
  (set-face-attribute 'variable-pitch nil :family proportionately-spaced-font :height 1.0))

(use-package ess
  :ensure t
  :init (require 'ess-site)
  :config
  (setq inferior-ess-r-program "C:/Users/VHASLCObrieW1/AppData/Local/Programs/R/R-4.4.1/bin/x64/Rterm.exe")
  (setq ess-help-own-frame nil)
  (setq ess-style 'RStudio)
  (setq inferior-ess-r-help-command "help(\"%s\", help_type = \"text\")\n"))

(use-package company
  :ensure t 
  :config
  (global-company-mode)
  (setq company-idle-delay 0.1) 
  (setq company-minimum-prefix-length 2))

(use-package display-line-numbers
  :ensure nil
  :config
  (setq display-line-numbers-type 'relative)
  (global-display-line-numbers-mode))

(use-package org
  :ensure t
  :init
  (setq org-directory (expand-file-name "~/org/"))
  (setq org-imenu-depth 7)
  (setq org-duration-format 'h:mm)
  (add-to-list 'safe-local-variable-values '(org-hide-leading-stars . t))
  (add-to-list 'safe-local-variable-values '(org-hide-macro-markers . t))
  :bind
  ( :map global-map
    ("C-c a" . org-agenda)
    ("C-c l" . org-store-link)
    ("C-c o" . org-open-at-point-global)
    :map org-mode-map
    ;; I don't like that Org binds one zillion keys, so if I want one
    ;; for something more important, I disable it from here.
    ("C-'" . org-cycle-agenda-files)
    ("C-," . nil)
    ("M-;" . nil)
    ("<C-return>" . nil)
    ("<C-S-return>" . nil)
    ("C-M-S-<right>" . nil)
    ("C-M-S-<left>" . nil)
    ("C-c ;" . nil)
    ("C-c M-l" . org-insert-last-stored-link)
    ("C-c C-M-l" . org-toggle-link-display)
    ("M-." . org-edit-special) ; alias for C-c ' (mnenomic is global M-. that goes to source)
    :map org-src-mode-map
    ("M-," . org-edit-src-exit) ; see M-. above
    :map narrow-map
    ("b" . org-narrow-to-block)
    ("e" . org-narrow-to-element)
    ("s" . org-narrow-to-subtree)
    :map ctl-x-x-map
    ("i" . prot-org-id-headlines)
    ("h" . prot-org-ox-html))
  :config
  (require 'org-ref)
  (require 'ob-clojure)
  (setq org-babel-clojure-backend 'cider)
  (require 'cider)
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
  (setq org-startup-indented t) 
  (add-hook 'org-mode-hook #'visual-line-mode)
  (require 'org-tempo))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((R . t)
   (emacs-lisp . t)
   (clojure . t)
   (haskell . t)))

(use-package org-ref
  :ensure t
  :init
  (require 'bibtex)
  (setq bibtex-autokey-year-length 4
	bibtex-autokey-name-year-separator "-"
	bibtex-autokey-year-title-separator "-"
	bibtex-autokey-titleword-separator "-"
	bibtex-autokey-titlewords 2
	bibtex-autokey-titlewords-stretch 1
	bibtex-autokey-titleword-length 5)
  (define-key bibtex-mode-map (kbd "H-b") 'org-ref-bibtex-hydra/body)
  (define-key org-mode-map (kbd "C-c ]") 'org-ref-insert-link)
  (define-key org-mode-map (kbd "s-[") 'org-ref-insert-link-hydra/body)
  (require 'org-ref-ivy)
  (require 'org-ref-arxiv)
  (require 'org-ref-scopus)
  (require 'org-ref-wos))

(setq find-program "C:\\cygwin64\\bin\\find.exe")

(use-package nerd-icons-completion
  :ensure t
  :after marginalia
  :config
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

(use-package nerd-icons-corfu
  :ensure t
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package nerd-icons-dired
  :ensure t
  :hook
  (dired-mode . nerd-icons-dired-mode))

(use-package vertico
  :ensure t
  :hook (after-init . vertico-mode))

(use-package marginalia
  :ensure t
  :hook (after-init . marginalia-mode))

(use-package orderless
  :ensure t
  :config
  (setq completion-styles '(orderless basic))
  (setq completion-category-defaults nil)
  (setq completion-category-overrrides nil))

(use-package savehist
  :ensure nil ; it is built-in
  :hook (after-init . savehist-mode))

(use-package corfu
  :ensure t
  :hook (after-init . global-corfu-mode)
  :bind (:map corfu-map ("<tab>" . corfu-complete))
  :config
  (setq tab-always-indent 'complete)
  (setq corfu-preview-current nil)
  (setq corfu-min-width 20)

  (setq corfu-popupinfo-delay '(1.25 . 0.5))
  (corfu-popupinfo-mode 1) ; shows documentation after `corfu-popupinfo-delay'

  ;; Sort by input history (no need to modify `corfu-sort-function').
  (with-eval-after-load 'savehist
    (corfu-history-mode 1)
    (add-to-list 'savehist-additional-variables 'corfu-history)))

;;; The file manager (Dired)

(use-package dired
  :ensure nil
  :commands (dired)
  :hook
  ((dired-mode . dired-hide-details-mode)
   (dired-mode . hl-line-mode))
  :config
  (setq dired-recursive-copies 'always)
  (setq dired-recursive-deletes 'always)
  (setq delete-by-moving-to-trash t)
  (setq dired-dwim-target t))

(use-package dired-subtree
  :ensure t
  :after dired
  :bind
  ( :map dired-mode-map
    ("<tab>" . dired-subtree-toggle)
    ("TAB" . dired-subtree-toggle)
    ("<backtab>" . dired-subtree-remove)
    ("S-TAB" . dired-subtree-remove))
  :config
  (setq dired-subtree-use-backgrounds nil))

(use-package trashed
  :ensure t
  :commands (trashed)
  :config
  (setq trashed-action-confirmer 'y-or-n-p)
  (setq trashed-use-header-line t)
  (setq trashed-sort-key '("Date deleted" . t))
  (setq trashed-date-format "%Y-%m-%d %H:%M:%S"))

(use-package multiple-cursors
  :ensure t
  :bind (:map global-map
	      ("C-S-c C-S-c" . mc/edit-lines)
	      ("C->" . mc/mark-next-like-this)
	      ("C-<" . mc/mark-previous-like-this)
	      ("C-c C-<" . 'mc/mark-all-like-this)))
