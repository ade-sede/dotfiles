(print "Hello, world")
(print (getenv "HOME"))

(org-babel-load-file "~/.emacs.d/emacs.org")
										;*******************************************************************************;
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ccls-sem-highlight-method 'overlay)
 '(ccls-sem-variable-colors nil)
 '(comment-style 'extra-line)
 '(custom-safe-themes
   '("a44e2d1636a0114c5e407a748841f6723ed442dc3a0ed086542dc71b92a87aee" "4fda8201465755b403a33e385cf0f75eeec31ca8893199266a6aeccb4adedfa4" "5f128efd37c6a87cd4ad8e8b7f2afaba425425524a68133ac0efd87291d05874" "0c83e0b50946e39e237769ad368a08f2cd1c854ccbcd1a01d39fdce4d6f86478" "34be6a46f3026dbc0eed3ac8ccf60cba5d2a6ad71aa37ccf21fbd6859f9b4d25" "dea4b7d43d646aa06a4f705a58f874ec706f896c25993fcf73de406e27dc65ba" "267cf309b02f463cd50df6a9ca67034e32698510995fefaa3c1bfee2c0d30f0e" "60ada0ff6b91687f1a04cc17ad04119e59a7542644c7c59fc135909499400ab8" "08765d801b06462a3ce7e414cdb747436ccaf0c073350be201d8f87bd0481435" "05626f77b0c8c197c7e4a31d9783c4ec6e351d9624aa28bc15e7f6d6a6ebd926" "1a1ac598737d0fcdc4dfab3af3d6f46ab2d5048b8e72bc22f50271fd6d393a00" "1436985fac77baf06193993d88fa7d6b358ad7d600c1e52d12e64a2f07f07176" "88deeaaab5a631834e6f83e8359b571cfcbf5a18b04990288c8569cc16ee0798" "9b4ae6aa7581d529e20e5e503208316c5ef4c7005be49fdb06e5d07160b67adc" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "fa2b58bb98b62c3b8cf3b6f02f058ef7827a8e497125de0254f56e373abee088" "e6ff132edb1bfa0645e2ba032c44ce94a3bd3c15e3929cdf6c049802cf059a2a" "54cf3f8314ce89c4d7e20ae52f7ff0739efb458f4326a2ca075bf34bc0b4f499" "76bfa9318742342233d8b0b42e824130b3a50dcc732866ff8e47366aed69de11" "c4bdbbd52c8e07112d1bfd00fee22bf0f25e727e95623ecb20c4fa098b74c1bd" "4bca89c1004e24981c840d3a32755bf859a6910c65b829d9441814000cf6c3d0" "3df5335c36b40e417fec0392532c1b82b79114a05d5ade62cfe3de63a59bc5c6" "e6df46d5085fde0ad56a46ef69ebb388193080cc9819e2d6024c9c6e27388ba9" "2642a1b7f53b9bb34c7f1e032d2098c852811ec2881eec2dc8cc07be004e45a0" "82358261c32ebedfee2ca0f87299f74008a2e5ba5c502bde7aaa15db20ee3731" "d7383f47263f7969baf3856ab8b3df649eb77eafdff0c5731bee2ad18e0faed2" "ae3a3bed17b28585ce84266893fa3a4ef0d7d721451c887df5ef3e24a9efef8c" "bf390ecb203806cbe351b966a88fc3036f3ff68cd2547db6ee3676e87327b311" "87a431903d22fa1cbb2becd88572e7d985e28c2253935448d0d754c13e85a980" "9a155066ec746201156bb39f7518c1828a73d67742e11271e4f24b7b178c4710" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "e9460a84d876da407d9e6accf9ceba453e2f86f8b86076f37c08ad155de8223c" "d494af9adbd2c04bec4b5c414983fefe665cd5dadc5e5c79fd658a17165e435a" "c4bd8fa17f1f1fc088a1153ca676b1e6abc55005e72809ad3aeffb74bd121d23" "b85fc9f122202c71b9884c5aff428eb81b99d25d619ee6fde7f3016e08515f07" "b34636117b62837b3c0c149260dfebe12c5dad3d1177a758bb41c4b15259ed7e" "c158c2a9f1c5fcf27598d313eec9f9dceadf131ccd10abc6448004b14984767c" default))
 '(global-company-mode t)
 '(gud-gdb-command-name "gdb --annotate=1")
 '(highlight-indent-guides-method 'column)
 '(large-file-warning-threshold nil)
 '(lsp-enable-text-document-color nil)
 '(lsp-ui-doc-border "black")
 '(lsp-ui-doc-header t)
 '(lsp-ui-doc-include-signature t)
 '(lsp-ui-doc-use-childframe t)
 '(lsp-ui-flycheck-enable nil)
 '(lsp-ui-flycheck-list-position 'right)
 '(lsp-ui-peek-always-show t)
 '(lsp-ui-sideline-ignore-duplicate t)
 '(lsp-ui-sideline-show-code-actions t)
 '(lsp-ui-sideline-show-hover nil)
 '(lsp-ui-sideline-update-mode 'line)
 '(menu-bar-mode nil)
 '(package-selected-packages
   '(yasnippet-snippets dracula-theme company-quickhelp jest vue-mode counsel uuidgen uuid evil-org moe-theme emojify bug-hunter green-phosphor-theme subatomic256-theme subatomic-theme async-await seoul256-theme auto-complete ac-helm babel racer ggtags vagrant atom-dark-theme company-irony-c-headers auto-dim-other-buffers ac-rtags auto-complete-clang zenburn-theme yaml-mode web-mode use-package ts-comint toml-mode tide spacemacs-theme spaceline-all-the-icons slime rjsx-mode ripgrep rfc-mode pylint py-autopep8 pretty-symbols platformio-mode plantuml-mode page-break-lines ox-slack org-roam org-pomodoro org-plus-contrib org-gcal org-bullets npm-mode nordless-theme magit lua-mode lsp-ui load-theme-buffer-local license-templates license-snippets leetcode kotlin-mode js-format js-doc ibuffer-projectile hl-todo highlight-indent-guides helm-rg helm-projectile gruvbox-theme git-gutter-fringe focus flyspell-correct-popup flyspell-correct-helm flycheck-rust flycheck-pycheckers flycheck-google-cpplint fish-mode exwm evil-surround evil-snipe evil-exchange evil-anzu eslint-fix ergoemacs-status ein editorconfig doom-themes dockerfile-mode docker default-text-scale dashboard dap-mode csv-mode company-irony clang-format+ ccls cargo-mode cargo auto-compile all-the-icons-gnus aggressive-indent 0xc))
 '(python-indent-guess-indent-offset-verbose nil)
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil)
 '(warning-suppress-types '((comp) (comp))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cursor ((t nil)))
 '(lsp-face-highlight-read ((t (:foreground "green"))))
 '(lsp-face-highlight-textual ((t (:foreground "turquoise3"))))
 '(lsp-face-highlight-write ((t (:foreground "orchid"))))
 '(lsp-ui-peek-line-number ((t nil)))
 '(lsp-ui-sideline-code-action ((t (:foreground "red" :underline (:color foreground-color :style wave)))))
 '(lsp-ui-sideline-current-symbol ((t (:foreground "orchid" :box nil :underline t :weight bold :height 0.99))))
 '(lsp-ui-sideline-symbol ((t (:foreground "lime green" :box nil :height 0.99))))
 '(org-block ((t (:inherit fixed-pitch))))
 '(org-code ((t (:inherit (shadow fixed-pitch)))))
 '(org-document-title ((t (:inherit default :weight bold :foreground "unspecified-fg" :font "JetBrains Mono Bold" :height 2.0 :underline nil))))
 '(org-hide ((t (:foreground "#FFFFFF"))))
 '(org-level-1 ((t (:font "JetBrains Mono Bold" :height 1.2))))
 '(org-level-2 ((t (:font "JetBrains Mono Bold" :height 1.12))))
 '(org-level-3 ((t (:font "JetBrains Mono Bold" :height 1.08))))
 '(org-level-4 ((t (:font "JetBrains Mono Bold" :height 1.03))))
 '(org-level-5 ((t (:font "JetBrains Mono Bold"))))
 '(org-level-6 ((t (:font "JetBrains Mono Bold"))))
 '(org-level-7 ((t (:font "JetBrains Mono Bold"))))
 '(org-level-8 ((t (:font "JetBrains Mono Bold"))))
 '(whitespace-tab ((t (:foreground "#636363")))))
(put 'narrow-to-region 'disabled nil)
