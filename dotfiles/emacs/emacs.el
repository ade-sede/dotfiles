(defvar bootstrap-version) (let ((bootstrap-file (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory)) (bootstrap-version 6)) (unless (file-exists-p bootstrap-file) (with-current-buffer (url-retrieve-synchronously "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el" 'silent 'inhibit-cookies) (goto-char (point-max)) (eval-print-last-sexp))) (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package) (setq straight-use-package-by-default t)

(setq gc-cons-threshold (* 50 1000 1000)) (setq package-enable-at-startup nil) (setq inhibit-startup-screen t) (setq inhibit-startup-message t) (setq inhibit-startup-echo-area-message t) (setq initial-scratch-message nil) (setq initial-major-mode 'org-mode) (menu-bar-mode -1) (tool-bar-mode -1) (scroll-bar-mode -1) (setq frame-inhibit-implied-resize t)

(use-package gcmh :init (gcmh-mode 1) :config (setq gcmh-idle-delay 5 gcmh-high-cons-threshold (* 16 1024 1024)))

(setq read-process-output-max (* 1024 1024)) (setq inhibit-compacting-font-caches t)

(when (fboundp 'native-comp-available-p) (setq native-comp-async-report-warnings-errors nil) (setq native-comp-deferred-compilation t) (add-to-list 'native-comp-eln-load-path (expand-file-name "eln-cache/" user-emacs-directory)))

(set-face-attribute 'default nil :font "JetBrains Mono" :weight 'medium :height 120) (set-face-attribute 'variable-pitch nil :font "Cantarell" :weight 'regular) (set-face-attribute 'fixed-pitch nil :font "JetBrains Mono" :weight 'medium) (add-to-list 'default-frame-alist '(font . "JetBrains Mono-12"))

(global-font-lock-mode t) (global-hl-line-mode t) (show-paren-mode t)

(setq scroll-margin 3 scroll-conservatively 10000 scroll-preserve-screen-position t scroll-step 1 mouse-wheel-scroll-amount '(1 ((shift) . 1)) mouse-wheel-progressive-speed nil)

(setq ring-bell-function 'ignore) (setq use-dialog-box nil)

(use-package doom-themes :config (setq doom-themes-enable-bold t doom-themes-enable-italic t) (load-theme 'doom-one t) (doom-themes-org-config))

(use-package doom-modeline :hook (after-init . doom-modeline-mode) :config (setq doom-modeline-height 25 doom-modeline-bar-width 3 doom-modeline-icon t doom-modeline-major-mode-icon t doom-modeline-major-mode-color-icon t doom-modeline-buffer-state-icon t doom-modeline-buffer-modification-icon t doom-modeline-persp-name t doom-modeline-display-default-persp-name nil doom-modeline-minor-modes nil doom-modeline-lsp t))

(setq vc-follow-symlinks t)

(use-package magit :bind (("C-x g" . magit-status)) :config (setq magit-process-finish-apply-ansi-colors t) (global-auto-revert-mode t) (setq auto-revert-check-vc-info t) :init (use-package with-editor) (defadvice magit-status (around magit-fullscreen activate) (window-configuration-to-register :magit-fullscreen) ad-do-it (delete-other-windows)) (defadvice magit-quit-window (after magit-restore-screen activate) (jump-to-register :magit-fullscreen)) :config (remove-hook 'magit-status-sections-hook 'magit-insert-tags-header) (remove-hook 'magit-status-sections-hook 'magit-insert-unpushed-to-pushremote) (remove-hook 'magit-status-sections-hook 'magit-insert-unpulled-from-pushremote) (remove-hook 'magit-status-sections-hook 'magit-insert-unpulled-from-upstream) (remove-hook 'magit-status-sections-hook 'magit-insert-unpushed-to-upstream-or-recent))

(use-package git-gutter-fringe :hook (prog-mode . git-gutter-mode))

(defun pretty-symbols ()
  (setq prettify-symbols-alist
        (mapcan (lambda (x) (list x (cons (upcase (car x)) (cdr x))))
                '(("lambda" . "λ")
                  ("TODO" . "")
                  ("WAIT" . "")
                  ("PAUSED" . "")
                  ("ONGOING" . "")
                  ("NOPE" . "")
                  ("CANCELED" . "")
                  ("DONE" . "")
                  ("PLANNED" . "📅")
                  ("[#A]" . "")
                  ("[#B]" . "")
                  ("[#C]" . "")
                  ("[ ]" . "")
                  ("[X]" . "")
                  ("[-]" . "")
                  ("#+begin_src" . ?)
                  ("#+BEGIN_SRC" . ?)
                  ("#+end_src" . ?)
                  ("#+END_SRC" . ?)
                  (":END:" . "―")
                  ("#+begin_example" . ?)
                  ("#+end_example" . ?)
                  ("#+header:" . ?)
                  ("#+name:" . ?﮸)
                  ("#+results:" . ?)
                  ("#+call:" . ?)
                  (":properties:" . "")
                  (":startup:" . "")
                  (":logbook:" . ?))))
  (prettify-symbols-mode 1))

(global-prettify-symbols-mode 1)

(use-package all-the-icons :if (display-graphic-p))

(use-package all-the-icons-dired :if (display-graphic-p) :hook (dired-mode . all-the-icons-dired-mode))

(use-package nerd-icons)

(use-package dashboard :config (setq dashboard-startup-banner 'logo) (setq initial-buffer-choice (lambda () (get-buffer "dashboard"))) (setq dashboard-items '((bookmarks . 4) (recents . 3) (projects . 4))) (setq dashboard-set-heading-icons t) (setq dashboard-set-navigator t) (dashboard-setup-startup-hook))

(use-package company :hook (prog-mode . company-mode) :bind (:map company-active-map ("C-n" . company-select-next) ("C-p" . company-select-previous) ("<tab>" . company-complete-common-or-cycle)) :config (setq company-idle-delay 0.1 company-minimum-prefix-length 1 company-selection-wrap-around t company-tooltip-align-annotations t company-require-match nil))

(use-package company-box :hook (company-mode . company-box-mode))

(use-package helm :bind (("M-x" . helm-M-x) ("C-x b" . helm-mini) ("C-x r b" . helm-bookmarks) ("C-x C-f" . helm-find-files) ("C-x C-b" . helm-buffers-list)) :config (setq helm-mode-fuzzy-match t helm-completion-in-region-fuzzy-match t helm-split-window-inside-p t helm-move-to-line-cycle-in-source t helm-autoresize-max-height 30 helm-autoresize-min-height 20) (helm-autoresize-mode 1) (helm-mode 1))

(use-package helm-projectile :after (helm projectile) :config (helm-projectile-on))

(use-package projectile :bind-keymap ("C-c p" . projectile-command-map) :config (setq projectile-indexing-method 'alien projectile-enable-caching t projectile-completion-system 'helm) (add-to-list 'projectile-project-root-files-top-down-recurring "compile_commands.json") (add-to-list 'projectile-project-root-files-top-down-recurring ".ccls") (setq projectile-globally-ignored-file-suffixes (list ".o")) (projectile-mode +1))

(use-package ibuffer :bind ("C-x C-b" . ibuffer) :init (add-hook 'ibuffer-hook (lambda () (ibuffer-projectile-set-filter-groups) (unless (eq ibuffer-sorting-mode 'alphabetic) (ibuffer-do-sort-by-alphabetic)))))

(use-package ibuffer-projectile)

(use-package tree-sitter :hook ((python-mode js-mode typescript-mode tsx-mode rust-mode c-mode c++-mode go-mode) . tree-sitter-mode) :config (global-tree-sitter-mode) (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

(use-package tree-sitter-langs :after tree-sitter)

(use-package org :hook ((org-mode . pretty-symbols) (org-mode . visual-line-mode) (org-mode . org-indent-mode)) :config (setq org-src-tab-acts-natively t org-src-preserve-indentation nil org-edit-src-content-indentation 0 fill-column 100 org-log-into-drawer 'LOGBOOK org-ellipsis " ▾" org-hide-emphasis-markers t org-hide-leading-stars t org-agenda-start-with-log-mode t org-agenda-files '("~/org/agenda.org")))

(use-package org-bullets :hook (org-mode . org-bullets-mode) :config (setq org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(use-package org-appear :hook (org-mode . org-appear-mode))

(font-lock-add-keywords 'org-mode '(("^ *\([-]\) " (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

(let* ((variable-tuple '(:font "JetBrains Mono")) (header-sizes '(1.2 1.12 1.08 1.03 1.0 1.0 1.0 1.0))) (dolist (i (number-sequence 1 8)) (set-face-attribute (intern (format "org-level-%d" i)) nil :font "JetBrains Mono Bold" :height (nth (1- i) header-sizes))))

(use-package org-roam :custom (org-roam-directory (file-truename "~/org/roam")) :bind (("C-c n l" . org-roam-buffer-toggle) ("C-c n f" . org-roam-node-find) ("C-c n g" . org-roam-graph) ("C-c n i" . org-roam-node-insert) ("C-c n c" . org-roam-capture) ("C-c n j" . org-roam-dailies-capture-today)) :config (org-roam-db-autosync-mode))

(use-package lsp-mode :hook ((c-mode c++-mode python-mode rust-mode go-mode typescript-mode js-mode web-mode css-mode) . lsp-deferred) :commands (lsp lsp-deferred) :init (setq lsp-keymap-prefix "C-c l") :config (setq lsp-ui-doc-show-with-cursor nil lsp-headerline-breadcrumb-enable nil lsp-ui-sideline-update-mode 'line lsp-signature-render-documentation nil lsp-completion-show-detail t lsp-completion-show-kind t lsp-ui-flycheck-list-position 'bottom lsp-ui-sideline-enable t lsp-ui-sideline-show-symbol nil lsp-ui-sideline-show-hover nil lsp-ui-sideline-show-flycheck t lsp-ui-sideline-show-code-actions nil lsp-modeline-code-actions-enable t lsp-enable-on-type-formatting t lsp-ui-sideline-show-diagnostics t lsp-modeline-diagnostics-enable t lsp-enable-indentation t lsp-diagnostic-clean-after-change t lsp-enable-file-watchers t lsp-file-watch-threshold 4000 lsp-ui-doc-enable t lsp-eslint-auto-fix-on-save t) (define-key lsp-mode-map (kbd "C-c l") lsp-command-map) (advice-add 'json-parse-string :around (lambda (orig string &rest rest) (apply orig (s-replace "\u0000" "" string) rest))) (advice-add 'json-parse-buffer :around (lambda (oldfn &rest args) (save-excursion (while (search-forward "\u0000" nil t) (replace-match "" nil t))) (apply oldfn args))))

(use-package lsp-ui :commands lsp-ui-mode)

(use-package lsp-treemacs :commands lsp-treemacs-errors-list)

(use-package dap-mode :after lsp-mode :config (dap-auto-configure-mode))

(use-package copilot :straight (:host github :repo "zerolfx/copilot.el" :files ("dist" "*.el")) :hook (prog-mode . copilot-mode))

(defun my-tab-completion () (interactive) (or (copilot-accept-completion) (company-indent-or-complete-common nil)))

(with-eval-after-load 'copilot (define-key copilot-mode-map (kbd "<tab>") #'my-tab-completion) (define-key copilot-mode-map (kbd "TAB") #'my-tab-completion))

(use-package flycheck :hook (prog-mode . flycheck-mode) :bind-keymap ("C-c f" . flycheck-command-map) :config (add-to-list 'display-buffer-alist `(,(rx bos "Flycheck errors" eos) (display-buffer-reuse-window display-buffer-in-side-window) (side . bottom) (reusable-frames . visible) (window-height . 0.33))))

(use-package yasnippet :hook (prog-mode . yas-minor-mode) :config (yas-global-mode 1))

(use-package yasnippet-snippets)

(use-package helm-c-yasnippet :config (setq helm-yas-space-match-any-greedy t) :bind ("C-c y" . helm-yas-complete))

(use-package editorconfig :config (editorconfig-mode 1))

(add-hook 'prog-mode-hook (lambda () (subword-mode 1))) (add-hook 'prog-mode-hook 'show-paren-mode) (add-hook 'prog-mode-hook 'display-line-numbers-mode)

(use-package typescript-mode :mode ("\.ts\'" "\.tsx\'") :hook (typescript-mode . lsp-deferred))

(use-package web-mode :mode ("\.html\'" "\.tsx\'" "\.jsx\'"))

(use-package vue-mode :mode "\.vue\'" :config (setq js-indent-level 2 css-indent-offset 2) :hook (vue-mode . lsp-deferred))

(use-package emmet-mode :hook ((web-mode html-mode css-mode) . emmet-mode))

(use-package prettier-js :hook ((js-mode js2-mode typescript-mode web-mode css-mode json-mode) . prettier-js-mode))

(use-package jest :hook ((js-mode js2-mode typescript-mode) . jest-minor-mode))

(use-package python :hook (python-mode . lsp-deferred) :config (setq python-indent-guess-indent-offset-verbose nil))

(use-package py-isort :hook (python-mode . py-isort-enable-on-save))

(use-package pyvenv :config (pyvenv-mode 1))

(use-package ccls :hook ((c-mode c++-mode) . (lambda () (require 'ccls) (lsp-deferred))) :config (setq ccls-executable "/usr/bin/ccls"))

(setq-default c-default-style "linux" c-basic-offset 4 c-backspace-function 'backward-delete-char)

(use-package rust-mode :hook (rust-mode . lsp-deferred) :config (setq lsp-rust-server 'rust-analyzer) (setq rust-format-on-save t))

(use-package cargo :hook (rust-mode . cargo-minor-mode))

(use-package go-mode :hook (go-mode . lsp-deferred) :config (setq gofmt-command "goimports") (add-hook 'before-save-hook 'gofmt-before-save))

(use-package kotlin-mode :hook (kotlin-mode . lsp-deferred))

(use-package flyspell :hook ((text-mode org-mode markdown-mode) . flyspell-mode) :hook (prog-mode . flyspell-prog-mode))

(use-package flyspell-correct :after flyspell :bind (:map flyspell-mode-map ("C-;" . flyspell-correct-wrapper)))

(use-package flyspell-correct-popup :after flyspell-correct)

(use-package markdown-mode :mode (("README\.md\'" . gfm-mode) ("\.md\'" . markdown-mode) ("\.markdown\'" . markdown-mode)) :hook (markdown-mode . flyspell-mode) :config (setq markdown-command "multimarkdown"))

(use-package emojify :hook (after-init . global-emojify-mode))

(use-package vterm :commands vterm :config (setq vterm-shell "fish") (setq vterm-max-scrollback 10000))

(use-package fish-mode)

(use-package anzu :config (global-anzu-mode 1))

(use-package leetcode :config (setq leetcode-prefer-language "python3" leetcode-prefer-sql "mysql" leetcode-save-solutions t leetcode-directory "~/projects/leetcode"))

(use-package rfc-mode :config (setq rfc-mode-directory (expand-file-name "~/RFC/")))

(use-package lua-mode)

(use-package toml-mode)

(use-package slime :config (setq inferior-lisp-program "/usr/bin/sbcl --noinformation") (slime-setup))

(use-package which-key :config (which-key-mode))

(use-package helpful :bind ([remap describe-function] . helpful-callable) ([remap describe-variable] . helpful-variable) ([remap describe-key] . helpful-key))

(setq create-lockfiles nil) (setq backup-directory-alist ((".*" . ,(expand-file-name "backup/" user-emacs-directory)))) (setq auto-save-file-name-transforms       ((".*" ,(expand-file-name "auto-save/" user-emacs-directory) t)))

;; Custom variables will be stored in the standard custom-file location
;; This keeps this config file clean
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))
