;; create more of these
(require 'my-vim)
(require 'my-utils)
(require 'selected)

(defalias 'evil-goto-last-line 'evil-goto-line)

;; bindings for more things such as help-mode and calendar. disable this
;; (evil-collection-init)

;;  this is the proper way to define evil key-bindings
;; (evil-define-key 'visual evil-surround-mode-map "S" 'evil-surround-region)
;; (evil-define-key 'visual evil-surround-mode-map "gS" 'evil-Surround-region)

;;  Fix M-p and M-p while in insert mode -- paste
;; Fix 'checking' every time I evaluate some elisp

;; Fix M-d for M-d d (delete line)

;;        (global-evil-swap-keys-mode)
;; I should create a function for creating normal and insert mode
;; bindings.

                                        ; (defun magit-and-cd (cwd)

;;write (inc x) and have the effect of (setq x (1+ x))
;;(defmacro inc (var)
;;(list 'setq var (list '1+ var)))


;; (evil-mode)
;; (global-evil-swap-keys-mode)
;; (evil-swap-keys)

;; (global-set-key (kbd "M-;") 'evil-ex)


;; (global-set-key "\C-n" "\C-u8\C-v")
;; (global-set-key "\C-p" "\C-u8\M-v")

;; Can't do this because in evil-mode C-y is select to the end of line, and subsequent C-y will copy
;; (define-key evil-insert-state-map (kbd "C-p") (kbd "8 C-y"))
;; (define-key evil-normal-state-map (kbd "C-n") (kbd "8 C-e"))
(define-key evil-normal-state-map (kbd "C-p") (lm (evil-scroll-line-up 8)))
(define-key evil-normal-state-map (kbd "C-n") (lm (evil-scroll-line-down 8)))

;; These should be complete if in insert mode
(define-key evil-insert-state-map (kbd "C-p") #'hippie-expand) ; This should start at the opposite end that C-n does
(define-key evil-insert-state-map (kbd "C-n") #'hippie-expand)

(defun evil-ex-normal ()
  (interactive)
  (evil-normal-state)
  (evil-ex))

(defun evil-eval-expression ()
     (interactive)
     (eval-expression))


;; Need a my-evil map that its on top of evil
;; (defun my-semicolon ()
;;   (interactive)
;;   (if (region-active-p)
;;       (progn
;;         (evil-ex)
;;         )))
;;
;; (define-key global-map (kbd ";") )
;; (let ((my/lisp-mode nil))
;;   (execute-kbd-macro (kbd ";")))


(define-key evil-insert-state-map (kbd "M-;") 'evil-ex-normal)
(define-key evil-normal-state-map (kbd "M-;") 'my/enter-evil-ex)
(define-key evil-normal-state-map (kbd ":") 'eval-expression)
;; (define-key evil-insert-state-map (kbd ":") #'eval-expression) ; OMG! wtf is this Is this mapping : in evil insert mode? Cos that's annoying. Yes it was.
(define-key evil-insert-state-map (kbd "M-:") #'eval-expression) ; This does not
(define-key global-map (kbd "M-:") #'eval-expression)


(defun my-c-g-test ()
  "test catching control-g"
  (interactive)
  (let ((inhibit-quit t))
    (unless (with-local-quit
              (y-or-n-p "arg you gonna type C-g?")
              t)
      (progn
        (message "you hit C-g")
        (setq quit-flag nil)))))


;; Beep minibuffer
(defun my/enter-evil-ex ()
  (interactive)
  ;; (evil-ex "'<,'>")
  (if (region-active-p)
      (do-in-evil
       (evil-ex "'<,'>"))
    (do-in-evil
     (evil-ex "")))
  ;; (call-interactively 'evil-ex)
  )


;; (define-key global-map (kbd "M-;") 'evil-ex)
(define-key global-map (kbd "M-;") 'my/enter-evil-ex)
(define-key evil-insert-state-map (kbd ":") nil)


;; This overwrites something important
(define-key evil-normal-state-map (kbd "C-u") #'evil-scroll-up)

;;; M-Y is an evil keyboard macro. How to unset this?
(define-key evil-insert-state-map (kbd "M-Y") #'my-copy-line)
(define-key evil-normal-state-map (kbd "M-Y") #'my-copy-line-evil-normal)
;
;(define-key evil-normal-state-map (kbd "M-Y") (my-copy-line))
;(define-key evil-normal-state-map (kbd "M-:") 'evil-ex)

;; (define-key evil-insert-state-map (kbd "C-k") 'avy-goto-word-0)
;; (define-key evil-normal-state-map (kbd "C-k") 'avy-goto-word-0)
(define-key evil-insert-state-map (kbd "C-k") 'avy-goto-char)
;; (define-key evil-insert-state-map (kbd "C-k") 'evil-insert-digraph)
(define-key evil-normal-state-map (kbd "C-k") 'avy-goto-char)


; This works but breaks arrows. Do not enable!
; ; ; This breaks arrow keys, but maybe if I have arrow keys defined also,
; ; ; it will be fine. NOPE!
; ; (defun evil-open-above-normal ()
; ;   (interactive)
; ;   (evil-normal-state)
; ;   (call-interactively #'evil-open-above))
; ; (define-key evil-insert-state-map (kbd "M-O") #'evil-open-above-normal)
; ; (define-key evil-normal-state-map (kbd "M-O") #'evil-open-above)

;(defun my/evil-paste-after-normal ()
;  (interactive)
;  (evil-normal-state)
;  (evil-paste-after (point))
;  )
;(defun my/evil-paste-after-unmark ()
;  (interactive)
;  (deactivate-mark)
;  (evil-paste-after (point))
;  )
;(define-key evil-insert-state-map (kbd "M-p") #'my/evil-paste-after-normal)
;(define-key evil-normal-state-map (kbd "M-p") #'my/evil-paste-after-unmark)

;(defun my/evil-delete-line-normal ()
;  (interactive)
;  (evil-normal-state)
;  (execute-kbd-macro (kbd "d d"))
;(defun my/evil-delete-line-unmark ()
;  (interactive)
;  (deactivate-mark)
;  (execute-kbd-macro (kbd "d d"))
;(define-key evil-insert-state-map (kbd "M-d d") 'my/evil-delete-line-normal)
;(define-key evil-normal-state-map (kbd "M-d d") 'my/evil-delete-line-unmark)
;; (global-set-key (kbd "M-d d") 'my/evil-delete-line-unmark)




;; (defmacro my/with (package &rest body)
;;   "This attempts to run code dependent on a package and otherwise doesn't run the code."
;;   (setq package (concat "" package))
;;   `(when (require ,package nil 'noerror)
;;      ,@body))
;; This is a redefinition from utils.
;; This works perfectly
;; (defmacro my/with (package &rest body)
;;   "This attempts to run code dependent on a package and otherwise doesn't run the code."
;;   `(when (require ,package nil 'noerror)
;;      ,@body))


;; ` , &rest @ syntax
;; The ` means that everything in this lisp comes out the other end unchanged.
;; The , breaks out of ` for a given term. So it is evaluated.
;; &rest puts all the remaining arguments into a sexp
;; An @ unpacks a sexp


(defmacro insert-map (KEYS fun)
  (setq fun (eval fun))
  ;; An insert mapping creates a function that goes to normal
  `(progn (defun ,(str2sym (concat "my/evil-" (sym2str fun) "-normal")) ()
            (interactive)
            (evil-normal-state)
            (deactivate-mark)
            (call-interactively ',fun))
          (define-key evil-insert-state-map (kbd ,KEYS) ',(str2sym (cc "my/evil-" (sym2str fun) "-normal")))))

(defmacro normal-map (KEYS fun)
  (setq fun (eval fun))
  ;; A normal mapping creates a function that unmarks
  `(progn (defun ,(str2sym (concat "my/evil-" (sym2str fun) "-unmark")) ()
            (interactive)
            ;; Why was this deactivated?
            (if (evil-visual-state-p)
                (deactivate-mark))
            (call-interactively ',fun))
          (define-key evil-normal-state-map (kbd ,KEYS) ',(str2sym (cc "my/evil-" (sym2str fun) "-unmark")))))

(defmacro visual-map (KEYS fun)
  (setq fun (eval fun))
  ;; A normal mapping creates a function that unmarks
  `(progn (defun ,(str2sym (concat "my/evil-" (sym2str fun) "-visual")) ()
            (interactive)
            (call-interactively ',fun))
          (define-key evil-visual-state-map (kbd ,KEYS) ',(str2sym (cc "my/evil-" (sym2str fun) "-visual")))))


(evil-define-motion evil-visual-corner-start ()
  "Put the cursor at the top left part of the block"
  (let* ((point (point))
         (mark (or (mark t) point)))

    (if (> point mark)
        ;; (and (eq evil-visual-selection 'line) (> point mark))
        (evil-visual-exchange-corners))))


;; Normal is used if visual doesnt exist and there is a region
(defmacro visual-to-normal-map (KEYS fun)
  (setq fun (eval fun))
  ;; A normal mapping creates a function that unmarks
  `(progn (defun ,(str2sym (concat "my/evil-" (sym2str fun) "-visual")) ()
            (interactive)
            ;; (evil-visual-corner-start)

            ;; (if (eq evil-visual-selection 'line)
            ;;     (evil-goto-column 0))

            (let* ((point (point))
                   (mark (or (mark t) point)))

              (if (and (eq evil-visual-selection 'line) (> point mark))
                  (progn
                    ;; (a/beep) ;This is too slow
                    (evil-normal-state)
                    (evil-backward-char 1))
                (evil-normal-state))

              ;; (let* ((point (point))
              ;;        (mark (or (mark t) point)))

              ;;   (if (and (eq evil-visual-selection 'line) (> point mark))
              ;;       (evil-goto-column 0)
              ;;     ;; (evil-visual-ex  change-corners)
              ;;     ))

              ;; (deactivate-mark)
              ;; (evil-normal-state)
                                        ;Does the same thing as deactivate-mark
              (call-interactively ',fun)
              (define-key evil-visual-state-map (kbd ,KEYS) ',(str2sym (cc "my/evil-" (sym2str fun) "-visual")))))))


(defmacro my/truly-evil-binding (KEYS fun)
  "This creates 2 new vim-like functions for both insert and a normal mode on a given keybinding."
  `(progn
     (normal-map ,KEYS ,fun)
     (insert-map ,KEYS ,fun)
     (visual-to-normal-map ,KEYS ,fun)))


(defmacro my/truly-selective-binding (KEYS fun)
  "This binds both selected and evil visual mode keybindings"
  `(progn
     ;; Do visual maps even work?
     (visual-map ,(sed "s/\\b\\w\\+\\b/M-&/g" KEYS)
                 ;; (concat "M-" KEYS)
                 ,fun)
     (define-key selected-keymap (kbd ,KEYS) ,fun)))


(defmacro my/truly-evil-ekm (KEYS)
  (let ((ekm-name (bp slugify KEYS)))
    `(progn
       (my/truly-evil-binding "M-:" 'eval-expression)
       )))


;; (lookup-key evil-normal-state-map (kbd "s"))


;; (my/truly-selective-binding "N" (df ns-region () (interactive) (bp ns (selection))))
;; I think N is taken by evil
;; This is paste over. What was I thinking? I know I'll prefix meta for these keys
(my/truly-selective-binding "P" (df pb-region () (bp-tty pb (selection)) (deselect)))

;; (df spv-egr () (spv (concat "egr " (selection))) (deselect))

(defun spv-egr (query)
  (interactive (list (or (selected-text)
                         (read-string "egr:"))))
  (spv
   (concat "egr " query))
  (deselect))
(defalias 'egr 'spv-egr)

;; This is goto in visual mode
;; (my/truly-selective-binding "G" (df spv-egr () (spv (concat "egr " (selection))) (deselect)))
(my/truly-selective-binding "G" 'egr)

(require 'evil-surround)
(visual-map "S" #'evil-surround-region)
(my/truly-selective-binding "S \"" (df fi-qftln (cfilter "q -ftln")))
(my/truly-selective-binding "S $" (df fi-surround-dollar (cfilter "surround '$' '$'")))
(my/truly-selective-binding "S =" (df fi-surround-equals (cfilter "surround '=' '='")))
(my/truly-selective-binding "S ~" (df fi-surround-tilde (cfilter "surround '~' '~'")))
(my/truly-selective-binding "S {" (df fi-surround-parens (cfilter "surround '{' '}'")))
(my/truly-selective-binding "S }" (df fi-surround-parens-pad (cfilter "surround '{' '}'")))
(my/truly-selective-binding "S )" (df fi-surround-parens (cfilter "surround '(' ')'")))
(my/truly-selective-binding "S (" (df fi-surround-parens-pad (cfilter "surround '( ' ' )'")))
(my/truly-selective-binding "S >" (df fi-asurround-angle (cfilter "surround '<' '>'")))
(my/truly-selective-binding "S <" (df fi-surround-angle-pad (cfilter "surround '< ' ' >'")))
(my/truly-selective-binding "S ]" (df fi-surround-square (cfilter "surround '[' ']'")))
(my/truly-selective-binding "S [" (df fi-surround-square-pad (cfilter "surround '[ ' ' ]'")))

;; This is 'change' in visual mode
(my/truly-selective-binding "C" (df spv-ifl-code () (spv (concat "ifl " (buffer-language) " " (selection))) (deselect)))
;; (my/truly-selective-binding "H" (df spv-filter-thing-open () (spv (concat "python $HOME$MYGIT/ranger/ranger/ranger/ext/rifle.py " (bp filter-things.sh | head -n 1 | s chomp (selection)))) (deselect)))
;; (my/truly-selective-binding "H" (df spv-filter-thing-open () (spvp "fto" (selection)) (deselect)))
(my/truly-selective-binding "H" 'egr-thing-at-point-imediately)

;; This is an evil-mode navigation key
(my/truly-selective-binding "w" (df spv-wiki () (spv (concat "wiki " (selection))) (deselect)))
(my/truly-selective-binding "W" (df spv-wiki () (spv (concat "wiki " (selection))) (deselect)))

;; This works great
(my/truly-selective-binding "Y" #'new-buffer-from-selection-detect-language)

;; This is needed to replace a selection
;; (my/truly-selective-binding "S" (df spv-ifl () (spv (concat "ifl " (selection))) (deselect)))
;; This doesn't even override the evil X binding
;; So why have it defined with this?
;; I would probably prefer to use this to kill a rectangle
;; (my/truly-selective-binding "X" (df spv-sx-code () (spv (concat "sx " (buffer-language) " " (selection))) (deselect)))
(df spv-sx-code () (spv (concat "sx " (buffer-language) " " (selection))) (deselect))
(my/truly-selective-binding "X" 'kill-rectangle)

;; This is evil navigation -- search ahead
;; (my/truly-selective-binding "F" #'my/fwfzf)
;; This is horrible. Under what circumstances would I want evil-mode to not have uppercase
;; (my/truly-selective-binding "U" (df spv-wordnut () (spv (concat "wu " (selection))) (deselect)))

;; this is nice but
;;(define-key global-map (kbd "g w") #'GoWhich)
(my/truly-selective-binding "g w" #'GoWhich)
(my/truly-selective-binding "g h" #'get-vimlinks-url)
(my/truly-selective-binding "g Y" #'get-vim-link)
(my/truly-selective-binding "g f" #'open-selection-sps)
(my/truly-selective-binding "g y" #'get-emacs-link)
(my/truly-selective-binding "\"" (defun filter-q () "Filter selection with q" (interactive) (filter-selection 'q)))
(my/truly-selective-binding "M-g M-w" #'GoWhich)
;; (my/truly-selective-binding "W" (df spv-wiki () (spv (concat "wu " (selection))) (deselect)))


(my/truly-evil-binding "M-(" (df my-evil-select-word (if (selected) (progn (ns "hi" t) (deselect) (left-char)) nil) (ekm "viw")))
(my/truly-evil-binding "M-)" (df my-evil-select-WORD (if (selected) (progn (ns "hi" t) (deselect) (left-char)) nil) (ekm "viW")))

(my/truly-evil-binding "M-:" 'eval-expression)
;; (my/truly-evil-binding "M-u" 'undo-tree-undo)
(my/truly-evil-binding "M-u" 'undo)
(my/truly-evil-binding "M-o" 'evil-open-below)
(my/truly-evil-binding "M-k" 'evil-previous-line)
(my/truly-evil-binding "M-j" 'evil-next-line)
(my/truly-evil-binding "M-l" 'evil-forward-char)
(my/truly-evil-binding "M-h" 'evil-backward-char)
(my/truly-evil-binding "M-A" 'evil-append-line)
(my/truly-evil-binding "M-w" 'evil-forward-word-begin)
(my/truly-evil-binding "M-W" 'evil-forward-WORD-begin)
(my/truly-evil-binding "M-E" 'evil-forward-WORD-end)
(my/truly-evil-binding "M-e" 'evil-forward-word-end)
(my/truly-evil-binding "M-B" 'evil-backward-WORD-begin)
(my/truly-evil-binding "M-b" 'evil-backward-word-begin)
(my/truly-evil-binding "M-0" 'evil-digit-argument-or-evil-beginning-of-line)
(my/truly-evil-binding "M-$" 'evil-end-of-line)
(my/truly-evil-binding "M-G" 'evil-goto-line)
(my/truly-evil-binding "M-P" 'evil-paste-before)
(my/truly-evil-binding "M-/" 'evil-search-forward)
(my/truly-evil-binding "M-?" 'evil-search-backward)
(my/truly-evil-binding "M-p" 'evil-paste-after)
(my/truly-evil-binding "M-a" 'evil-append)
(my/truly-evil-binding "M-v" 'evil-visual-char)
(my/truly-evil-binding "M-s" 'evil-snipe-s)
(my/truly-evil-binding "M-r" 'evil-replace)
(my/truly-evil-binding "M-J" 'evil-join)
(my/truly-evil-binding "M-n" 'evil-search-next)
(my/truly-evil-binding "M-N" 'evil-search-previous)
(my/truly-evil-binding "M-{" 'evil-backward-paragraph)
(my/truly-evil-binding "M-}" 'evil-forward-paragraph)


(defun my/evil-insert-normal-kbd (binding)
  "Annoyingly, this must be called with a complete mapping. Can't simply press d once."
  (interactive)
  (evil-normal-state)
  ;; (concat "tmux send-keys -l " (qne (qftln "binding")))
  (tm/send-keys-literal binding)
  ;; (execute-kbd-macro (kbd binding))
  )

;; This is so I can do an "M-d w" for delete word. Annoyingly, this is not working at the moment, anyway
(define-key evil-insert-state-map (kbd "M-d") (lambda () (interactive) (my/evil-insert-normal-kbd "define-key")))



;; (define-key evil-insert-state-map (kbd "M-O A") #'my/evil-previous-line-normal)
;; (define-key evil-normal-state-map (kbd "M-O A") #'evil-previous-line)

;; (define-key evil-insert-state-map (kbd "M-O B") #'evil-next-line-normal)
;; (define-key evil-normal-state-map (kbd "M-O B") #'evil-next-line)

;; Can't have this one because it's used for hydra

;; How on earth do I swap s and S but only for evil?

;; (define-key evil-normal-state-map "s" 'evil-substitute)

(define-key evil-insert-state-map (kbd "M-g") (lm (evil-normal-state) (tsk "M-g")))
(define-key evil-normal-state-map (kbd "M-g g") 'evil-goto-first-line)
(define-key evil-normal-state-map (kbd "M-g M-g") 'evil-goto-first-line)
;; (define-key my/lisp-mode-map (kbd "M-g M-g") 'evil-goto-first-line) ;; Defined in my/lisp

;; GoWhich
(define-key evil-visual-state-map (kbd "g w") #'GoWhich)
                                        ; looks interesting
                                        ;(add-hook 'prog-mode-hook #'evil-swap-keys-swap-number-row)
                                        ;(add-hook 'python-mode-hook #'evil-swap-keys-swap-colon-semicolon)
                                        ;(add-hook 'python-mode-hook #'evil-swap-keys-swap-underscore-dash)
;;;(add-hook 'text-mode-hook #'evil-swap-keys-swap-question-mark-slash)


;; This doesn't appear to work. It's so annoying though.
;; (define-key evil-ex-map (kbd "C-j") (kbd "C-m"))

(eval-after-load 'evil-vars
  '(define-key evil-ex-completion-map (kbd "C-m") 'exit-minibuffer))

;; This is it
(define-key evil-ex-completion-map (kbd "C-j") (kbd "C-m"))

;; Need to use a macro because this tries to save the ex buffer, not the actual buffer
;; (define-key evil-ex-completion-map (kbd "M-;") #'save-buffer)
;; (define-key evil-ex-completion-map (kbd "M-;") (kbd "C-g"))

;; This fixes it
(define-key evil-ex-completion-map (kbd "C-a") nil)
(define-key evil-ex-completion-map (kbd "C-d") nil)
(define-key evil-ex-completion-map (kbd "C-k") nil)
;; (define-key evil-ex-completion-map (kbd "C-f") nil)
;; This doesn't work
;; (define-key evil-ex-completion-map (kbd "C-f") #'miniedit)

;; This is the solution
(define-key evil-ex-completion-map (kbd "M-;") (kbd "C-a w C-m"))
(define-key evil-ex-completion-map (kbd "M-w") (kbd "C-a w C-m"))
(define-key evil-ex-completion-map (kbd "M-e") (kbd "C-a e! C-m"))
(define-key evil-ex-completion-map (kbd "M-q") (kbd "C-a q! C-m"))
(define-key evil-ex-completion-map (kbd "M-d") (kbd "C-a bd! C-m"))

;; This would end up being "M-; M-m", which is "run current line" in vim
;; cmap <Esc>m <C-e><C-u>silent! call YRun()<CR>
;; I don't think the macro can persist outside of the environment it was mapped? (once the minibuffer closes)
;; (define-key evil-ex-completion-map (kbd "M-m") (kbd "C-a bd! C-m"))

;; This is possible
;; (define-key evil-normal-state-map (kbd "C-B") (kbd ":buffers"))


;; Disable this. M-F and M-B should do symmetrical things.
;; (define-key global-map (kbd "M-F") #'evil-find-char)
(define-key global-map (kbd "M-F") nil)


(define-key evil-normal-state-map (kbd "\\ \"") 'git-d-unstaged)


(define-key evil-normal-state-map (kbd "\\ '") 'magit-diff-unstaged)

(defun evil-mark-from-point-to-end-of-line ()
  "Marks everything from point to end of line"
  (interactive)
  (set-mark (line-end-position))
  (activate-mark))

(defun evil-visual-copy ()
  "Marks everything from point to end of line"
  (interactive)
  (call-interactively 'evil-yank)
  (chomp (ns (clipboard))))


;; (defun select-to-end-of-line ()
;;   (interactive)
;;   ()
;;   )

(define-key evil-normal-state-map (kbd "C-y") #'evil-mark-from-point-to-end-of-line)
;; (define-key evil-visual-state-map (kbd "C-y") (kbd "y"))
(define-key evil-visual-state-map (kbd "C-y") #'evil-visual-copy)

;; (define-key my-mode-map (kbd "\\ =") (lambda () (interactive)(magit-diff "HEAD^!")))



(defun magit-dp (arg)
  "Uses magit to diff the revisions of this file"
  (interactive "P")
  (cond
   ((equal current-prefix-arg nil)      ; no C-u
    (magit-ediff-show-commit "HEAD^!"))
   (t                                   ; all other cases, prompt
    (list
     (magit-ediff-show-commit (concat "HEAD~" (number-to-string current-prefix-arg)))))))
(define-key evil-normal-state-map (kbd "\\ -") 'magit-dp)


(defun git-dp (arg)
  "Uses vimdiff to diff the revisions of this file"
  (interactive "P")
  (if
      (equal current-prefix-arg nil)    ; no C-u
      (nw (concat "git-dp.sh" " " buffer-file-name))
    (nw (concat "git-dp.sh" " " buffer-file-name " " (number-to-string current-prefix-arg)))))
(define-key evil-normal-state-map (kbd "\\ =") 'git-dp)


;; (defun insert-slash ()
;;   "Just inserts a slash"
;;   (interactive)
;;   (insert "\\"))
;; (define-key evil-normal-state-map (kbd "\\") #'insert-slash)


(defun describe-this-file ()
  (interactive)
  (spv (cc "ct describe-file " (e/q buffer-file-name) " | v")))
(define-key evil-normal-state-map (kbd "\\ t") 'describe-this-file)


(defun my-evil-ge ()
  (interactive)
  (bld ge -e -v (selection)))
(define-key evil-visual-state-map (kbd "g e") 'my-evil-ge)

(defun my-expand-lines ()
  (interactive)
  (let ((hippie-expand-try-functions-list
         '(try-expand-line-all-buffers)))
    (call-interactively 'hippie-expand)))

(define-key evil-insert-state-map (kbd "C-x C-l") 'my-expand-lines)

;; TODO: Try to make an evil ex command to rename a file
;; (evil-ex-define-cmd "Rename" 'buffer-menu)

;; This force overwrites. I need to ensure
(defun my-rename-file-and-buffer (newname cp)
  "Rename current buffer and if the buffer is visiting a file, rename it too."
  (interactive)
  (let ((filename (buffer-file-name)))
    (if cp
        (if (and filename (file-exists-p filename))
            (let* ((containing-dir (file-name-directory newname)))
            (if containing-dir (make-directory containing-dir t))
            (copy-file filename newname t)
            (find-file newname)))
      (if (not (and filename (file-exists-p filename)))
            (rename-buffer newname)

          (let* ((containing-dir (file-name-directory newname)))
            ;; DONE Sometimes it doesn't have a containing dir.
            (if containing-dir (make-directory containing-dir t))
            ;; (message (concat "filename: " filename))
            ;; (message (concat "filename: " filename))
            (cond
             ((vc-backend filename) (vc-rename-file filename newname))
             (t
              (rename-file filename newname t)
              (set-visited-file-name newname t t))))))))

;; Unfortunately, I can't do % <tab><C-w>

;; I want the bang because I don't want to overwrite by default
;; This isn't working properly at the moment. Do not rely on it.
(evil-define-command evil-rename (file &optional bang)
  "Rename FILE."
  :repeat nil
  (interactive "<f><!>")
  ;; Interactive sets 'bang' to 't' or 'nil'
  (save-buffer)
  ;; (error "Whoops!")

  (if bang
      (progn
        ;; overwrite
        (my-rename-file-and-buffer file))
    (progn
      ;; do not overwrite
      (if (not (file-exists-p file))
          (my-rename-file-and-buffer file)
        (message (concat "Aborted. File exists: " file)))))

  ;; (if file
  ;;     (find-file file)
  ;;   (revert-buffer bang (or bang (not (buffer-modified-p))) t))
  )


(evil-ex-define-cmd "Rename" 'evil-rename)


(evil-define-command evil-open (fp &optional bang)
  "Open FILE."
  :repeat nil
  (interactive "<f><!>")

  (if (not fp)
      (setq fp (xc)))

  (setq eww-no-external-handler nil)
  (cond
   ((re-match-p "^http" fp) (eww fp))
   ((re-match-p "\\.html$" fp) (eww-open-file fp))
   (t (find-file (tv fp)))))

(evil-ex-define-cmd "O" 'evil-open)


(evil-define-command evil-dired (dir &optional bang)
  "Open DIR with dired."
  :repeat nil
  (interactive "<f><!>")

  (if (not dir)
      (setq dir (xc)))

  (let ((path
         (cond ((f-file-p dir) (setq path (f-dirname dir)))
               ((f-directory-p dir) dir)
               (t nil))))
    (if path
        (dired path))))

(evil-ex-define-cmd "Dired" 'evil-dired)



(evil-define-command evil-cp (file &optional bang)
  "Cp FILE."
  :repeat nil
  (interactive "<f><!>")
  ;; Interactive sets 'bang' to 't' or 'nil'
  (save-buffer)
  ;; (error "Whoops!")

  (if bang
      (progn
        ;; overwrite
        (my-rename-file-and-buffer file t))
    (progn
      ;; do not overwrite
      (if (not (file-exists-p file))
          (my-rename-file-and-buffer file t)
        (message (concat "Aborted. File exists: " file)))))

  ;; (if file
  ;;     (find-file file)
  ;;   (revert-buffer bang (or bang (not (buffer-modified-p))) t))
  )
(evil-ex-define-cmd "CP" 'evil-cp)


(evil-define-command evil-vw (fp &optional bang)
  "Edit FP on path."
  :repeat nil
  (interactive "<f><!>")
  ;; Interactive sets 'bang' to 't' or 'nil'

  ;; If bang then just edit fp which is here.
  (if bang
      (find-fp fp)
    (edit-fp-on-path fp)))
(evil-ex-define-cmd "vw" 'evil-vw)
(evil-ex-define-cmd "ew" 'evil-vw)



;; Make evil =bd= use =kill-buffer-immediately= because currently, it is killing the frame
(evil-define-command evil-bd (&optional bang)
  "Kill buffer."
  :repeat nil
  (interactive "<!>")

  (if bang
      (kill-buffer)
    (kill-buffer-immediately)))
(evil-ex-define-cmd "bd" 'evil-bd)


(evil-define-command evil-other-file ()
  "Go to other file."
  :repeat nil
  (interactive)
  (call-interactively 'ff-get-other-file))
(evil-ex-define-cmd "A" 'evil-other-file)


;; Same arguments as original function (message) to advise
;; (defun sh/ad-unminimise-ex-parse (string &optional syntax start)
;;   (setq string (tvipe (umn string))))

;; (advice-add 'evil-ex-parse :before 'sh/ad-unminimise-ex-parse)
;; (advice-remove 'evil-ex-parse 'sh/ad-unminimise-ex-parse)

;; (defun sh/ad-unminimise-ex-parse-command (string)
;;   (setq string (tvipe (umn string))))

;; (advice-add 'evil-ex-parse-command :before 'sh/ad-unminimise-ex-parse-command)
;; (advice-remove 'evil-ex-parse-command 'sh/ad-unminimise-ex-parse-command)

;; (defun compile-always-comint (orig-fun &rest args)
;;   (apply orig-fun (list (first args) t)))
;; (advice-add 'compile :around #'compile-always-comint)


;; Evil interpret environment variables
;; (defun sh/ad-unminimise-ex-parse (orig-fun string &optional syntax start)
;;   (setq string (umn string))
;;   (apply orig-fun string syntax start))

;; (advice-add 'evil-ex-parse :around 'sh/ad-unminimise-ex-parse)
;; Parse is called every time I make a keyboard press. Put it only at the final execution stage
;; (advice-remove 'evil-ex-parse 'sh/ad-unminimise-ex-parse)

;; (defun evil-ex-call-command-around-advice (orig-fun range command argument)
;;   (setq command (umn command))
;;   (let ((res (apply range command argument)))
;;     res))
;; (advice-add 'evil-ex-call-command :around #'evil-ex-call-command-around-advice)
;; (advice-remove 'evil-ex-call-command #'evil-ex-call-command-around-advice)


;; result is the command
;; (defun evil-ex-execute-around-advice (proc result)
;;   (setq result (umn result))
;;   ;; (tvipe result)
;;   (let ((res (apply proc result)))
;;     res))
;; (advice-add 'evil-ex-execute :around #'evil-ex-execute-around-advice)
(advice-remove 'evil-ex-execute #'evil-ex-execute-around-advice)

;; I had to edit the function directly
(defun evil-ex-execute (result)
  "Execute RESULT as an ex command on `evil-ex-current-buffer'."
  ;; empty input means repeating the previous command
  (when (zerop (length result))
    (setq result evil-ex-previous-command))
  (setq result (umn result))
  ;; parse data
  (evil-ex-update nil nil nil result)
  ;; execute command
  (unless (zerop (length result))
    (if evil-ex-expression
        (eval evil-ex-expression)
      (user-error "Ex: syntax error"))))


;; (defun evil-forward-word-begin-doc (arg)
;;   (interactive "P")
;;   (call-interactively 'evil-forward-word-begin t (vector arg))
;;   (ekm "M-9"))

;; (normal-map "w" #'evil-forward-word-begin-doc)
;; (normal-map "w" #'evil-forward-word-begin)

;; advice-add is the new way of adding advice
;; ad-advice is the old way of adding advice

;; DISCARD Do not use advice to do this, as new advice can't be temporarily disabled
;; Use advice anyway. Just do this:
;; vim +/"(advice-remove 'evil-forward-word-begin #'my\/doc-thing-at-point)" "$EMACSD/config/my-utils.el"

;; This is simply too slow
(if nil (progn
          (advice-add 'evil-forward-word-begin :after #'my/doc-thing-at-point)
          (advice-add 'evil-backward-word-begin :after #'my/doc-thing-at-point)
          (advice-add 'evil-next-line :after #'my/doc-thing-at-point)
          (advice-add 'evil-previous-line :after #'my/doc-thing-at-point)
          (advice-add 'evil-end-of-line :after #'my/doc-thing-at-point)
          ))

(if nil (progn
          (advice-remove 'evil-forward-word-begin #'my/doc-thing-at-point)
          (advice-remove 'evil-backward-word-begin #'my/doc-thing-at-point)
          (advice-remove 'evil-next-line #'my/doc-thing-at-point)
          (advice-remove 'evil-previous-line #'my/doc-thing-at-point)
          (advice-remove 'evil-end-of-line #'my/doc-thing-at-point)))

;; (advice-add 'evil-digit-argument-or-evil-beginning-of-line :after #'my/doc-thing-at-point)
;; (advice-remove 'evil-digit-argument-or-evil-beginning-of-line #'my/doc-thing-at-point)


;; extra digraphs
;; vim +/"extra digraphs" "$VIMCONFIG/vimrc"
(setq evil-digraphs-table-user '(((?N ?N) . ?\x2115)
                                 ((?Z ?Z) . ?\x2124)
                                 ((?R ?R) . ?\x211D)
                                 ((?^ ?_) . ?\x304)
                                 ((?. ?o) . ?\x25cc)
                                 ((?, ?.) . ?\x2026)
                                 ((?  ? ) . ?\x00a0)
                                 ((?| ?=) . ?\x22a7)
                                 ((?| ?-) . ?\x22a2)
                                 ((?| ?>) . ?\x21a6)))
;; digr ^_ 0772


;; This makes =C-r *= correctly paste the clipboard
;; I used (my/clipboard-string)
(defun evil-get-register (register &optional noerror)
  "Return contents of REGISTER.
Signal an error if empty, unless NOERROR is non-nil.

The following special registers are supported.
  \"  the unnamed register
  *  the clipboard contents
  +  the clipboard contents
  <C-w> the word at point (ex mode only)
  <C-a> the WORD at point (ex mode only)
  <C-o> the symbol at point (ex mode only)
  <C-f> the current file at point (ex mode only)
  %  the current file name (read only)
  #  the alternate file name (read only)
  /  the last search pattern (read only)
  :  the last command line (read only)
  .  the last inserted text (read only)
  -  the last small (less than a line) delete
  _  the black hole register
  =  the expression register (read only)"
  (condition-case err
      (when (characterp register)
        (or (cond
             ((eq register ?\")
              (current-kill 0))
             ((and (<= ?1 register) (<= register ?9))
              (let ((reg (- register ?1)))
                (and (< reg (length kill-ring))
                     (current-kill reg t))))
             ((memq register '(?* ?+))
              (my/clipboard-string))
             ((eq register ?\C-W)
              (unless (evil-ex-p)
                (user-error "Register <C-w> only available in ex state"))
              (with-current-buffer evil-ex-current-buffer
                (thing-at-point 'evil-word)))
             ((eq register ?\C-A)
              (unless (evil-ex-p)
                (user-error "Register <C-a> only available in ex state"))
              (with-current-buffer evil-ex-current-buffer
                (thing-at-point 'evil-WORD)))
             ((eq register ?\C-O)
              (unless (evil-ex-p)
                (user-error "Register <C-o> only available in ex state"))
              (with-current-buffer evil-ex-current-buffer
                (thing-at-point 'evil-symbol)))
             ((eq register ?\C-F)
              (unless (evil-ex-p)
                (user-error "Register <C-f> only available in ex state"))
              (with-current-buffer evil-ex-current-buffer
                (thing-at-point 'filename)))
             ((eq register ?%)
              (or (buffer-file-name (and (evil-ex-p)
                                         (minibufferp)
                                         evil-ex-current-buffer))
                  (user-error "No file name")))
             ((= register ?#)
              (or (with-current-buffer (other-buffer) (buffer-file-name))
                  (user-error "No file name")))
             ((eq register ?/)
              (or (car-safe
                   (or (and (boundp 'evil-search-module)
                            (eq evil-search-module 'evil-search)
                            evil-ex-search-history)
                       (and isearch-regexp regexp-search-ring)
                       search-ring))
                  (user-error "No previous regular expression")))
             ((eq register ?:)
              (or (car-safe evil-ex-history)
                  (user-error "No previous command line")))
             ((eq register ?.)
              evil-last-insertion)
             ((eq register ?-)
              evil-last-small-deletion)
             ((eq register ?=)
              (let* ((enable-recursive-minibuffers t)
                     (result (eval (car (read-from-string (read-string "="))))))
                (cond
                 ((or (stringp result)
                      (numberp result)
                      (symbolp result))
                  (prin1-to-string result))
                 ((sequencep result)
                  (mapconcat #'prin1-to-string result "\n"))
                 (t (user-error "Using %s as a string" (type-of result))))))
             ((eq register ?_)          ; the black hole register
              "")
             (t
              (setq register (downcase register))
              (get-register register)))
            (user-error "Register `%c' is empty" register)))
    (error (unless err (signal (car err) (cdr err))))))


(require 'helm-projectile)
;; (define-key evil-ex-map "g" nil)
;; (define-key evil-ex-map "f" nil)
;; M- bindings do not work
;; (define-key evil-ex-map "M-g" nil)
;; (define-key evil-ex-map "M-f" nil)
(define-key evil-ex-map "G" 'helm-projectile-grep)
(define-key evil-ex-map "F" 'helm-projectile-find-file)

(define-key evil-ex-completion-map (kbd "TAB") 'evil-ex-completion)

(defun evil-command-window-close ()
  "Like evil-command-window-execute but runs an empty command and closes the window gracefully."
  (interactive)
  (let ((execute-fn evil-command-window-execute-fn)
        (command-window (get-buffer-window)))
    (select-window (previous-window))
    (unless (equal evil-command-window-current-buffer (current-buffer))
      (user-error "Originating buffer is no longer active"))
    (kill-buffer "*Command Line*")
    (delete-window command-window)
    (funcall execute-fn "")
    (setq evil-command-window-current-buffer nil)))

;; Can't use =C-c= because it's a prefix
;; evil-command-window-execute
(define-key evil-command-window-mode-map (kbd "C-c C-c") 'evil-command-window-close)
(define-key evil-command-window-mode-map (kbd "C-g") 'evil-command-window-close)

;; Not sure why this does not work
;; I can however, define them once inside evil-ex.
;; Therefore, it mmust be possible.

;; evil-ex-abort

;; (defun evil-ex-setup-around-advice (proc &rest args)
;;   (let ((res (apply proc args)))
;;     (define-key evil-ex-map (kbd "C-c") (kbd "C-g"))
;;     (define-key evil-ex-completion-map (kbd "C-c") (kbd "C-g"))

;;     res))
;; (advice-add 'evil-ex-setup :around #'evil-ex-setup-around-advice)
;; (advice-remove 'evil-ex-setup  #'evil-ex-setup-around-advice)
                                        ;(define-key evil-ex-map (kbd "C-c C-c") (kbd "C-g"))

;(define-key evil-ex-completion-map (kbd "C-c C-c") (kbd "C-g"))
;; (define-key evil-ex-map (kbd "C-c") (kbd "C-g"))
;; (define-key evil-ex-map (kbd "C-c") nil)
;; (define-key global-map (kbd "C-c C-c") (kbd "C-g"))
;; (define-key global-map (kbd "C-c C-c") nil)

;; I may need to remove ivy
;; (defun evil-ex-completion ()
;;   "Completes the current ex command or argument."
;;   (interactive)
;;   (let (after-change-functions)
;;     (evil-ex-update)
;;     ;; (let ((completion-at-point-functions)))
;;     ;; (evil-ex-command-completion-at-point evil-ex-argument-completion-at-point)
;;     (let ((completing-read-function 'completing-read-default)) (completion-at-point))
;;     ;; (letf ((ivy-completing-read 'completing-read-default)) (completion-at-point))
;;     (remove-text-properties (minibuffer-prompt-end) (point-max) '(face nil evil))))

;; (defun evil-ex-command-completion-at-point ()
;;   (let ((context (evil-ex-syntactic-context (1- (point)))))
;;     (when (memq 'command context)
;;       (let ((beg (or (get-text-property 0 'ex-index evil-ex-cmd)
;;                      (point)))
;;             (end (1+ (or (get-text-property (1- (length evil-ex-cmd))
;;                                             'ex-index
;;                                             evil-ex-cmd)
;;                          (1- (point))))))
;;         (list beg end (evil-ex-completion-table))))))


;; Because the current version of evil search doesnt work. I may be able to revert this in the future
(define-key evil-motion-state-map (kbd "?") 'isearch-backward)
(define-key evil-motion-state-map (kbd "N") 'isearch-repeat-backward)
(define-key evil-motion-state-map (kbd "/") 'isearch-forward-regexp)
(define-key evil-motion-state-map (kbd "n") 'isearch-repeat-forward)


;; C++ stuff
(evil-define-key 'normal c++-mode-map (kbd ", v f") 'mark-defun)


(define-key evil-list-view-mode-map (kbd "RET") 'evil-list-view-goto-entry)


;; set-window-buffer

(ignore-errors (ad-remove-advice 'set-window-buffer 'before 'evil))

;; Adding ignore-errors to this fixes an issue tab completing in helm
;; Despite this being an evil function and having nothing to do directly with helm
(defadvice set-window-buffer (before evil)
  "Initialize Evil in the displayed buffer."
  (ignore-errors
    (when evil-mode
      (when (and
             (ad-get-arg 1)
             (get-buffer (ad-get-arg 1)))
        (with-current-buffer (ad-get-arg 1)
          (unless evil-local-mode
            (evil-local-mode 1)))))))

;; (ad-get-advice-info 'set-window-buffer)
(ad-update 'set-window-buffer)

(defun fix-region ()
  (interactive)
  ;; (selected-region-active-mode -2)
  ;; (evil-force-normal-state)
  ;; (transient-mark-mode -2)
  ;; (setq mark-active nil)
  ;; (never
  ;;  ;; This stuff isn't actually needed
  ;;  (evil-transient-mark -1)
  ;;  (evil-active-region -1))
  ;; (evil-transient-mark 1)

  (with-current-buffer (nbfs "test")
    (if (not (and (region-active-p)
                mark-active))
      (progn
        (evil-active-region 1)
        (deselect)))
    (kill-buffer))
  ;; Enabling evil-active-region and killing the buffer are all that is required to fix it
  ;; But this *has* to be run in a broken buffer, not an OK one, such as the one that broke it

  ;; But I need to detect *when* I should enable the region.

  ;; I don't even need to kill the buffer
  ;; (if (yn "kill buffer")
  ;;     (kill-buffer))
  )

;; I want a-z to be global and A-Z to be local

(defun evil-global-marker-p (char)
  "Whether CHAR denotes a global marker."
  ;; (or (and (>= char ?A) (<= char ?Z))
  ;;     (assq char (default-value 'evil-markers-alist)))
  (or (and (>= char ?a) (<= char ?z))
      (assq char (default-value 'evil-markers-alist))))

(provide 'my-my-evil)