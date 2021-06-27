(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(Man-notify-method (quote pushy))
 '(ansi-color-names-vector
   ["#073642" "#dc322f" "#859900" "#b58900" "#268bd2" "#d33682" "#2aa198" "#657b83"])
 '(comint-buffer-maximum-size 20000)
 '(comint-completion-addsuffix t)
 '(comint-get-old-input (lambda nil "") t)
 '(comint-input-ignoredups t)
 '(comint-input-ring-size 5000)
 '(comint-move-point-for-output nil)
 '(comint-prompt-read-only nil)
 '(comint-scroll-show-maximum-output t)
 '(comint-scroll-to-bottom-on-input t)
 '(compilation-message-face (quote default))
 '(cua-global-mark-cursor-color "#2aa198")
 '(cua-normal-cursor-color "#839496")
 '(cua-overwrite-cursor-color "#b58900")
 '(cua-read-only-cursor-color "#859900")
 '(custom-enabled-themes (quote (tango-dark)))
 '(custom-safe-themes
   (quote
    ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(enwc-wired-device "wlp3s0")
 '(enwc-wireless-device "wlp3s0")
 '(evil-want-Y-yank-to-eol nil)
 '(fci-rule-color "#073642")
 '(global-font-lock-mode t)
 '(helm-source-names-using-follow nil)
 '(helm-youtube-key (quote AIzaSyA1KEHd-sBUxOKR-uv5zeFLzjrF45kDKLY) t)
 '(highlight-changes-colors (quote ("#d33682" "#6c71c4")))
 '(highlight-symbol-colors
   (--map
    (solarized-color-blend it "#002b36" 0.25)
    (quote
     ("#b58900" "#2aa198" "#dc322f" "#6c71c4" "#859900" "#cb4b16" "#268bd2"))))
 '(highlight-symbol-foreground-color "#93a1a1")
 '(highlight-tail-colors
   (quote
    (("#073642" . 0)
     ("#546E00" . 20)
     ("#00736F" . 30)
     ("#00629D" . 50)
     ("#7B6000" . 60)
     ("#8B2C02" . 70)
     ("#93115C" . 85)
     ("#073642" . 100))))
 '(hl-bg-colors
   (quote
    ("#7B6000" "#8B2C02" "#990A1B" "#93115C" "#3F4D91" "#00629D" "#00736F" "#546E00")))
 '(hl-fg-colors
   (quote
    ("#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36")))
 '(hl-paren-colors (quote ("#2aa198" "#b58900" "#268bd2" "#6c71c4" "#859900")))
 '(ivy-count-format "(%d/%d) ")
 '(ivy-display-style (quote fancy))
 '(ivy-use-virtual-buffers t)
 '(ivy-virtual-abbreviate (quote full))
 '(magit-diff-use-overlays nil)
 '(magit-log-arguments (quote ("--graph" "--decorate" "--stat" "-n20")))
 '(nrepl-message-colors
   (quote
    ("#dc322f" "#cb4b16" "#b58900" "#546E00" "#B4C342" "#00629D" "#2aa198" "#d33682" "#6c71c4")))
 '(org-directory "~/OneDrive/notes")
 '(org-support-shift-select t)
 '(org-trello-current-prefix-keybinding "C-c x")
 '(org-trello-files
   (quote
    ("/home/shane/notes2018/ws/trello/doc.trello" "/home/shane/notes2018/ws/trello/doc.org")))
 '(orgtrello-log-level orgtrello-log-debug)
 '(orgtrello-setup-use-position-in-checksum-computation nil)
 '(package-selected-packages
   (quote
    (jsonnet-mode fennel-mode counsel-css wiki-summary solidity-mode company-solidity tide helm-z helm-sql-connect helm-sage helm-ros helm-open-github helm-ls-git helm-orgcard helm-ispell helm-lastpass helm-ghs helm-ghq helm-ghc helm-go-package helm-filesets helm-ext helm-cider-history helm-chronos helm-bm helm-circe helm-bibtexkey helm-eww helm-firefox helm-aws helm-bind-key cargo flymake-rust dumb-jump vimrc-mode ob-coffee ob-rust ob-sql-mode ob-swift org-super-agenda org-seek org-sync-snippets encw enwc openwith key-seq inline-crypt erc-crypt ivy-hydra all-the-icons-ivy ivy-bibtex ivy-gitlab ivy-pass ivy-rich org-brain w3m undo-tree simpleclip shut-up s pcre2el magit lispy jedi-direx helm haskell-mode expand-region elisp-slime-nav codesearch annotate)))
 '(paradox-automatically-star t)
 '(paradox-github-token t t)
 '(pos-tip-background-color "#073642")
 '(pos-tip-foreground-color "#93a1a1")
 '(protect-buffer-bury-p nil)
 '(psc-ide-add-import-on-completion t t)
 '(psc-ide-rebuild-on-save nil t)
 '(safe-local-variable-values (quote ((no-byte-compile t) (org-confirm-babel-evaluate))))
 '(shackle-mode t)
 '(smartrep-mode-line-active-bg (solarized-color-blend "#859900" "#073642" 0.2))
 '(term-default-bg-color "#002b36")
 '(term-default-fg-color "#839496")
 '(vc-annotate-background nil)
 '(vc-annotate-background-mode nil)
 '(vc-annotate-color-map
   (quote
    ((20 . "#dc322f")
     (40 . "#ff7f00")
     (60 . "#ffbf00")
     (80 . "#b58900")
     (100 . "#ffff00")
     (120 . "#ffff00")
     (140 . "#ffff00")
     (160 . "#ffff00")
     (180 . "#859900")
     (200 . "#aaff55")
     (220 . "#7fff7f")
     (240 . "#55ffaa")
     (260 . "#2affd4")
     (280 . "#2aa198")
     (300 . "#00ffff")
     (320 . "#00ffff")
     (340 . "#00ffff")
     (360 . "#268bd2"))))
 '(vc-annotate-very-old-color nil)
 '(wakatime-cli-path "wakatime")
 '(wakatime-python-bin nil)
 '(weechat-color-list
   (quote
    (unspecified "#002b36" "#073642" "#990A1B" "#dc322f" "#546E00" "#859900" "#7B6000" "#b58900" "#00629D" "#268bd2" "#93115C" "#d33682" "#00736F" "#2aa198" "#839496" "#657b83")))
 '(xterm-color-names
   ["#073642" "#dc322f" "#859900" "#b58900" "#268bd2" "#d33682" "#2aa198" "#eee8d5"])
 '(xterm-color-names-bright
   ["#002b36" "#cb4b16" "#586e75" "#657b83" "#839496" "#6c71c4" "#93a1a1" "#fdf6e3"]))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((((class color) (min-colors 4096)) (:foreground "#c6c6c6" :background "#303030")) (((class color) (min-colors 256)) (:foreground "#c6c6c6" :background "#303030")) (((class color) (min-colors 89)) (:foreground "#c6c6c6" :background "#303030"))))
 '(aw-leading-char-face ((t (:inherit ace-jump-face-foreground :height 3.0))))
 '(magit-popup-argument ((t (:inverse-video t)))))
