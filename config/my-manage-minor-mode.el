(require 'manage-minor-mode)

;; Ok, it seems that the code in here must enable
;; font-lock mode, making the REPLs read-only
;;(global-font-lock-mode 1)
;; I need rainbow-mode for the hex number highlighting

;; rainbow-mode kills magit syntax highlighting
;; How to exclude it from magit modes?

;; Selected minor mode will still not function correctly

;; This works when shackle fails
;; vim +/"\* Locally disable global mode" "$MYGIT/mullikine/my-rosetta-code/aggregations/emacs/modes.org"
;; v +/";; This works, but it doesn't show in the minor mode list, interestingly" "$EMACSD/config/my-tablist.el"

;; This works, but I don't want it because it enables everywhere, not just for an individual buffer
;; (add-hook 'text-mode-hook 'bannedit-mode)
;; (remove-hook 'text-mode-hook 'bannedit-mode)

;; Although semantic-mode is quice cool
(setq manage-minor-mode-default
      '(
        ;; TODO Make it so tabulated list mode and aws instances mode do not refresh when toggle-chrome is run
        ;; v +/"toggle-chrome" "$EMACSD/emacs"
        (aws-instances-mode
         ;; This doesn't work!
         (on tablist-minor-mode)
         (off hide-mode-line-mode)
         (off display-line-numbers-mode)
         (off visual-line-mode))
        (tabulated-list-mode
         ;; This doesn't work!
         (on tablist-minor-mode)
         (off hide-mode-line-mode)
         (off display-line-numbers-mode)
         (off visual-line-mode))
        (Info-mode
         ;; This creates insane lag in info-mode
         ;; I hope it has truly been disabled
         (off highlight-thing-mode))
        (sh-mode
         (off org-link-minor-mode))
        (racket-mode
         (off flycheck-mode)
         (off eldoc-mode))
        ;; (eww-mode
        ;;  (on flycheck-mode))
        (js-mode
         ;; (on electric-pair-local-mode)
         (off electric-pair-local-mode))
        (text-mode
         (on writegood-mode)
         ;; This doesnt work
         ;; (on bannedit-mode)
         )
        ;; (org-brain-visualize-mode
        ;;  ;; (off global-hl-line-mode) ; This doesn't work. See above
        ;;  )
        (term-mode
         ;; (off global-hl-line-mode) ; This doesn't work. See above
         ;; Turning off engine-mode here actually unbound the engine-mode bindings globally. It was horrible
         ;; (off engine-mode)
         (off my-mode)
         (off fringe-mode)
         (off semantic-mode)
         (off highlight-thing-mode)
         (off ivy-mode))
        ;; DONE: This is enough to unbind all the semantic keys
        ;; (define-key semantic-mode-map (kbd "C-c ,") nil)
        (global
         ;; This absolutely kills emacs for large org-mode files. It's
         ;; really just large files that kill it.
         ;; Because it's global it wont turn off while in, say, term-mode
         ;; That's really annoying because semantic occupies ~C-c~
         ;; I need to unbind them all manually
         (off prettify-symbols-mode)
         (on delete-selection-mode)
         ;; (on semantic-mode)
         ;; Disable semantic 18.07.20
         (off semantic-mode)
         ;; (on indent-tools-minor-mode)
         ;; paredit interferes with haskell-mode on purcell emacs
         (off paredit-mode)
         (on right-click-context-mode)
         (off sotlisp-mode)
         ;; I don't want helm to take over everything'
         ;; I can still use helm
         (off helm-mode)
         (off linum-mode)
         ;; (off git-gutter-mode)
         (off display-line-numbers-mode)
         (off insert-shebang-mode)      ;Just disable it
         (on eldoc-mode)
         (on tabbar-mode)
         (on solaire-mode)
         ;; (on engine-mode)
                                        ; This creates the C-x / prefix
         (on company-mode)  ;This appears to not work
         ;; (off eldoc-overlay-mode) ; disabling this breaks eldoc-mode
         ;; I have re-enabled semantic because imenu didnt work for spacemacs elisp
         ;; (off semantic-mode)
         ;; This was breaking magit
         ;; (on rainbow-mode)
         ;; This was breaking eww
         ;; (on highlight-indent-guides-mode)
         (off winum-mode)
         (off guide-key-mode)
         (off evil-escape-mode)
         (off selected-minor-mode)
         ;; (off selected-minor-mode)
         ;; this must be a default. It doesn't work as a default. It doesn't disable when you switch to a buffer. Perhaps I should modify selected to be buffer-local
         (off selected-region-active-mode))
        (minibuffer-inactive-mode
         ;; this is important
         (off company-mode))
        (java-mode
         (on electric-pair-local-mode))
        (python-mode
         ;; This is horrible in python. Disable it.
         (off electric-pair-local-mode)
         ;; Watch out for this, it doesn't show in the minor modes alist
         ;; (off electric-pair-local-mode)
         ;; Disable semantic. Python imenu is broken 18.07.20
         ;; (on semantic-mode)
         (off semantic-mode)
         ;; Why was this disabled?
         ;; (off semantic-mode)
         (on eldoc-mode)
         (off flymake-mode))
        (haskell-mode
         (off flymake-mode)
         ;; shm = structured-haskell-mode
         (off structured-haskell-mode))
        (markdown-mode
         ;; Markdown does not have tables, so this is a desired default
         ;; (on visual-line-mode)
         ;; I still don't want it
         (off visual-line-mode))
        (org-mode
         ;; ivy-mode breaks M-c. Not anymore it doesn't
         ;; (off ivy-mode)
         ;; (off semantic-mode)
         (off visual-line-mode)
         ;; (off git-gutter-mode)
         ;; (on selected-mode)
         ;; Enable selected mode in no other way than this
         ;; (on selected-region-active-mode)
         )
        ;; Not sure why but management appears to not work for eww
        (help-mode
         (off visual-line-mode))
        ;; No idea why this doesn't work
        (term-mode
         (off yas-minor-mode)
         (off org-indent-mode)
         (off persp-mode)
         (off which-key-mode)
         (off company-mode)
         (off gud-minor-mode))
        (magit-log-mode
         (off highlight-thing-mode))
        (eww-mode
         (off visual-line-mode)
         (off my-keywords-mode)
         (off rainbow-delimiters-mode)
         (off volatile-highlights-mode)
         (off highlight-indent-guides-mode)
         (off global-highlight-indent-guides-mode)
         ;; (off adaptive-wrap-prefix-mode)
         ;; (off anzu-mode)
         ;; (off evil-escape-mode)
         ;; (off evil-snipe-local-mode)
         ;; (off flx-ido-mode)
         ;; (off helm-mode)
         ;; (off holy-mode)
         ;; (off persp-mode)
         ;; (off projectile-mode)
         )
        ;; (emacs-lisp-mode
        ;;  (off selected-mode)         ;; Why did the default not work
        ;;  (off selected-region-active-mode) ;; Why did the default not work
        ;;  )

        ;; THis doesnt work
        ;; (prog-mode
        ;;  (on highlight-indent-guides-mode))

        ;; Sadly, prog-mode doesn't work at all
        ;; (prog-mode
        ;;  (on electric-pair-local-mode)
        ;;  ;; (on selected-minor-mode)
        ;;  ;; (on selected-region-active-mode)
        ;;  )

        ;; but this does -- it's in auto-mode-load.el
        ;; (add-hook 'prog-mode-hook 'highlight-indent-guides-mode)

        (emacs-lisp-mode
         ;; (on highlight-indent-guides-mode)
         ;; (on company-mode)
         ;; (off company-mode)
         ;; (off selected-mode)
         (off semantic-mode)
         ;; (off selected-region-active-mode)
         ;; Why did the default not work
         )))

;; Putting this in the list is bad. It will make error messages pop up
;; in the minibuffer, I think. If the messages are caused elsewhere, I
;; should change this.
;; (off dtrt-indent-mode)

(require 'dtrt-indent)
;; Adapt to foreign indentation offsets
;; (dtrt-indent-global-mode 1)

(provide 'my-manage-minor-mode)