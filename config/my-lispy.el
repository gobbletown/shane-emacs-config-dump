(require 'lispy)
;; (load-library "lispy")

(require 'geiser)
(require 'my-lisp)
(require 'my-utils)
(require 'my-doc)
(require 'my-troubleshooting)
(require 'my-aliases)

(defun lispy-gy-emacs-vim-link (arg)
  (interactive "P")
  (if (selectedp)
      (if (>= (prefix-numeric-value current-prefix-arg) 4)
          (get-emacs-link)
        (get-vim-link))
    (call-interactively 'self-insert-command)))

;; TODO I want to capture the name of the defined symbol
;; Maybe it's just easier to do this more manually for the moment
(never
 (with-output-to-string)
 (etv (with-output-to-string (ekm "d C-x C-e")))
 (setq xbuff (generate-new-buffer "*my output*"))

 (with-output-to-temp-buffer xbuff

   ;; this is inserted in current buffer
   (insert "xyz")

   ;; this is printed in buffer xbuff
   (print "abc"))

 (switch-to-buffer xbuff))

(defun my-lispy-eval-eval ()
  "Evaluate sexp at point and then evaluate the result as a function."
  (interactive)
  (if (lispy-left-p)
      (cond
       ((major-mode-p 'emacs-lisp-mode)
        (let* ((result)
               (resultsym (save-excursion
                            (lispy-different)
                            (call-interactively 'eval-last-sexp))))
          (if (and (function-p resultsym) (commandp resultsym))
              (call-interactively resultsym)
            (progn
              (if (or (functionp resultsym)
                      (macrop resultsym))
                  (setq result
                        (str (eval `(,resultsym))))
                ;; unquote
                (setq result (eval-string result)))
              (new-buffer-from-string result)
              ;; (if (< 5 (length (s-match-strings-all "\n" result)))
              ;;     (new-buffer-from-string result)
              ;;   result)
              ))))
       ((major-mode-p 'clojure-mode)
        (progn
          (call-interactively 'my/lisp-e)
          (let ((symstr (sym2str (second (sexp-at-point)))))
            (ignore-errors
              (cider-nrepl-request:eval (concat "(" symstr ")") nil)))))
       (t (error (concat "No eval-eval handler for " (sym2str major-mode)))))))
;; (define-key lispy-mode-map (kbd "E") 'my-lispy-eval-eval)


;; Extend lispy-flow to also flow when you're on a #lang
;; Also, make it use my-lispy-flow when it's racket
(defun lispy-flow (arg)
  "Move inside list ARG times.
Don't enter strings or comments.
Return nil if can't move."
  (interactive "p")
  (lispy--remember)
  (let ((pt (point))
        r)
    (cond
     ((and (lispy-bolp)
           (or (looking-at ";")
               (looking-at "#lang")))
      (setq r (my-lispy-flow-left arg)))
     ((lispy-left-p)
      (setq r (my-lispy-flow-left arg)))
     ((lispy-right-p)
      (backward-char)
      (when (setq r (lispy--re-search-in-code lispy-right 'backward arg))
        (forward-char))))
    (or r
        (progn
          (goto-char pt)
          nil))))

; A placeholder
(if (not (symbolp 'get-vim-link))
    (defun get-vim-link ()))
(if (not (symbolp 'get-emacs-link))
    (defun get-emacs-link ()))

(lispy-defverb
 "other"
 (("h" lispy-move-left)
  ("j" lispy-down-slurp)
  ("k" lispy-up-slurp)
  ("l" lispy-move-right)
  ("SPC" lispy-other-space)
  ;; ("g" lispy-goto-mode)
  ))

;; works fine
(lispy-defverb
 "goto"
 (("d" lispy-goto)
  ("l" lispy-goto-local)
  ("r" lispy-goto-recursive)
  ("p" lispy-goto-projectile)
  ("f" lispy-follow)
  ("b" pop-tag-mark)
  ("q" lispy-quit)
  ("j" lispy-goto-def-down)
  ("a" lispy-goto-def-ace)
  ("e" lispy-goto-elisp-commands)
  ;; My addition
  ("Y" get-vim-link)
  ("y" get-emacs-link)))

(defun lispy-ace-paren-invert-prefix (proc &rest args)
  (cond
   ((equal current-prefix-arg (list 4)) (setq current-prefix-arg nil))
   ;; First check to see if it's on a paren. Otherwise I will get 4 Qs (QQQQ)
   ((and (lispy-left-p) (not current-prefix-arg)) (setq current-prefix-arg (list 4))))
  (let ((res (apply proc args)))
    res))
;; (advice-remove 'lispy-ace-paren #'lispy-ace-paren-invert-prefix)
(advice-add 'lispy-ace-paren :around #'lispy-ace-paren-invert-prefix)

;; (disable-advice-temporarily (special-lispy-ace-paren))

(defun lispy-ace-paren-global (&optional arg)
  "Jump to an open paren within the current defun.
ARG can extend the bounds beyond the current defun."
  (interactive "p")
  (setq arg 8)
  (lispy--remember)
  (deactivate-mark)
  (let ((avy-keys lispy-avy-keys)
        (bnd (if (eq arg 1)
                 (save-excursion
                   (lispy--out-backward 50)
                   (lispy--bounds-dwim))
               (cons (window-start)
                     (window-end nil t)))))
    (avy-with lispy-ace-paren
      (lispy--avy-do
       lispy-left
       bnd
       (lambda () (not (lispy--in-string-or-comment-p)))
       lispy-avy-style-paren))))


;; (defun lispy-ace-paren-global ()
;;   (interactive)
;;   (let ((current-prefix (list 4)))
;;     (disable-advice-temporarily (lispy-ace-paren))))

(defun lispy-ace-paren-visible ()
  (interactive)
  (disable-advice-temporarily (lispy-ace-paren)))

;; placeholder
(defun add-to-glossary-file-for-buffer () (interactive))
(defun glossary-add-link () (interactive))

;; This is how to set lispy maps.. Do this early in this file, so I can make mappings such as M-t later
(_ns lispy-special-maps

     ;; (define-key lispy-mode-map (kbd "g") nil)
     ;; This gets in the way
     (define-key lispy-mode-map (kbd "<backtab>") nil)
     ;; (define-key lispy-mode-map (kbd "g s") 'lispy-goto)
     ;; (define-key lispy-mode-map (kbd "g s") nil)
     ;; (define-key lispy-mode-map (kbd "g g") 'evil-goto-first-line)
     ;; (define-key lispy-mode-map (kbd "g g") nil)
     (defset lispy-mode-map-special
       (let ((map (make-sparse-keymap)))
         ;; navigation
         (lispy-define-key map "l" 'lispy-right)
         (lispy-define-key map "h" 'lispy-left)
         (lispy-define-key map "f" 'lispy-flow)
         (lispy-define-key map "j" 'lispy-down)
         (lispy-define-key map "k" 'lispy-up)
         (lispy-define-key map "d" 'lispy-different)
         ;; It has updated. No longer just lispy-goto
         ;; It's lispy-goto-mode now
         ;; But it's annoying and useless
         ;; (lispy-define-key map "g" 'lispy-goto-mode)
         (lispy-define-key map "g" 'lispy-gy-emacs-vim-link)
         (lispy-define-key map "o" 'lispy-other-mode)
         ;; This works
         ;; (lispy-define-key map "o" 'lispy-goto-mode)
         (lispy-define-key map "p" 'lispy-eval-other-window)
         ;; (lispy-define-key map "p" 'my-lispy-run-inner-sexp)
         (lispy-define-key map "P" 'lispy-paste)
         (lispy-define-key map "y" 'lispy-occur)
         (lispy-define-key map "z" 'lh-knight/body)
         (lispy-define-key map "E" 'my-lispy-eval-eval)
         ;; outline
         (lispy-define-key map "J" 'lispy-outline-next)
         (lispy-define-key map "K" 'lispy-outline-prev)
         (lispy-define-key map "L" 'lispy-outline-goto-child)
         ;; Paredit transformations
         (lispy-define-key map ">" 'lispy-slurp)
         (lispy-define-key map "<" 'lispy-barf)
         (lispy-define-key map "/" 'lispy-splice)
         (lispy-define-key map "r" 'lispy-raise)
         (lispy-define-key map "R" 'lispy-raise-some)
         (lispy-define-key map "+" 'lispy-join)
         ;; more transformations
         (lispy-define-key map "C" 'lispy-convolute)
         (lispy-define-key map "X" 'lispy-convolute-left)
         (lispy-define-key map "w" 'lispy-move-up)
         (lispy-define-key map "s" 'lispy-move-down)
         (lispy-define-key map "O" 'lispy-oneline)
         (lispy-define-key map "M" 'lispy-alt-multiline)
         (lispy-define-key map "S" 'lispy-stringify)
         ;; marking
         (lispy-define-key map "a" 'lispy-ace-symbol
           :override '(cond ((looking-at lispy-outline)
                             (lispy-meta-return))))
         ;; (lispy-define-key map "H" 'lispy-ace-symbol-replace)
         (lispy-define-key map "H" 'egr-thing-at-point-imediately)
         (lispy-define-key map "m" 'lispy-mark-list)
         ;; dialect-specific
         (lispy-define-key map "e" 'lispy-eval)
         ;; (lispy-define-key map "E" 'lispy-eval-and-insert)

         ;; Not sure if this is actually that useful
         ;; I put it in the :jumpto handler for handle
         ;; (lispy-define-key map "g" 'lispy-goto)
         ;; (lispy-define-key map "G" 'lispy-goto-local)
         (lispy-define-key map "G" 'go-to-fuzzy-list)

         (lispy-define-key map "g" 'lispy-gy-emacs-vim-link)

         ;; Chan the defverb instead
         ;; (lispy-define-key map "g y" #'get-vim-link)

         ;; (lispy-define-key map "F" 'lispy-follow t)
         (lispy-define-key map "F" 'add-to-fuzzy-list)
         (lispy-define-key map "D" 'pop-tag-mark)
         ;; (lispy-define-key map "A" 'lispy-beginning-of-defun)
         (lispy-define-key map "A" 'add-to-glossary-file-for-buffer)
         (lispy-define-key map "L" 'glossary-add-link)
         (lispy-define-key map "_" 'lispy-underscore)
         ;; miscellanea
         (define-key map (kbd "SPC") 'lispy-space)
         (lispy-define-key map "i" 'lispy-tab)
         (lispy-define-key map "I" 'lispy-shifttab)
         (lispy-define-key map "N" 'lispy-narrow)
         (lispy-define-key map "W" 'lispy-widen)
         ;; (lispy-define-key map (kbd "M-/") 'isearch-forward-region)
         (lispy-define-key map "c" 'lispy-clone)
         (lispy-define-key map "u" 'lispy-undo)
         ;; (lispy-define-key map "q" 'lispy-ace-paren
         ;;   :override '(cond ((bound-and-true-p view-mode)
         ;;                     (View-quit))))
         (lispy-define-key map "q" 'lispy-ace-paren-global
           :override '(cond ((bound-and-true-p view-mode)
                             (View-quit))))
         (lispy-define-key map "v" 'lispy-ace-paren-global
           :override '(cond ((bound-and-true-p view-mode)
                             (View-quit))))
         (lispy-define-key map "Q" 'lispy-ace-paren-visible
           :override '(cond ((bound-and-true-p view-mode)
                             (View-quit))))
         ;; (lispy-define-key map "Q" 'lispy-ace-char)
         (lispy-define-key map "V" 'lispy-view)
         (lispy-define-key map "t" 'lispy-teleport
           :override '(cond ((looking-at lispy-outline)
                             (end-of-line))))
         (lispy-define-key map "n" 'lispy-new-copy)
         (lispy-define-key map "b" 'lispy-ace-paren)
         ;; (lispy-define-key map "b" 'lispy-back)
         (lispy-define-key map "B" 'lispy-ediff-regions)
         (lispy-define-key map "x" 'lispy-x)
         (lispy-define-key map "Z" 'lispy-edebug-stop)
         ;; (lispy-define-key map "V" 'lispy-visit)
         (lispy-define-key map "-" 'lispy-ace-subword)
         (lispy-define-key map "." 'lispy-repeat)
         (lispy-define-key map "~" 'lispy-tilde)
         ;; digit argument
         (mapc (lambda (x) (lispy-define-key map (format "%d" x) 'digit-argument))
               (number-sequence 0 9))
         map))

     (lispy-set-key-theme '(special lispy c-digits)))


;; lispy--eval uses a string
(defun my/racket-eval (&optional str)
  (if (region-active-p)
      (racket-send-region (region-beginning) (region-end))
    ;; send with a temporary buffer
    (with-temp-buffer
      (insert str)
      (racket-send-region (point-min) (point-max))
      )))

(defun lispy--eval (e-str)
  "Eval E-STR according to current `major-mode'.
The result is a string."
  (if (string= e-str "")
      ""
    (funcall
     (cond ((memq major-mode lispy-elisp-modes)
            'lispy--eval-elisp)
           ((or (memq major-mode lispy-clojure-modes)
                (memq major-mode '(nrepl-repl-mode
                                   cider-clojure-interaction-mode)))
            (require 'le-clojure)
            'lispy-eval-clojure)
           ((eq major-mode 'scheme-mode)
            (require 'le-scheme)
            'lispy--eval-scheme)
           ((eq major-mode 'lisp-mode)
            (require 'le-lisp)
            'lispy--eval-lisp)
           ((eq major-mode 'hy-mode)
            (require 'le-hy)
            'lispy--eval-hy)
           ((eq major-mode 'python-mode)
            (require 'le-python)
            'lispy--eval-python)
           ((eq major-mode 'julia-mode)
            (require 'le-julia)
            'lispy--eval-julia)
           ((eq major-mode 'ruby-mode)
            'oval-ruby-eval)
           ((eq major-mode 'matlab-mode)
            'matlab-eval)
           ((eq major-mode 'racket-mode)
            'my/racket-eval)
           (t (error "%s isn't supported currently" major-mode)))
     e-str)))


;; Maybe I should make my/lispy into a mode so I can create bindings without needing to know how lispy's special mode works

;; Perhaps I should disable which-key for

(setq lispy-avy-style-symbol 'at)       ;This makes it so H key for replace doesnt add another character

;; Does not unbind
;; (define-key visual-line-mode-map (kbd "<end>") nil)

;; This is needed so the my/lisp e works
(define-key lispy-mode-map (kbd "e") nil)

;; Seems to be disabled :)
;; (define-key lispy-mode-map (kbd "g") #'special-lispy-goto)
;; (define-key lispy-mode-map (kbd "g") nil)
;; (define-key lispy-mode-map (kbd "G") nil)

;; (define-key lispy-mode-map-special (kbd "g t") #'special-lispy-goto)
;; (define-key lispy-mode-map-special (kbd "g r") #'special-lispy-goto)

(define-key lispy-mode-map (kbd "[") nil)
(define-key lispy-mode-map (kbd "]") nil)

;; THIS WORKS! -- unbind from lispy-mode-map-lispy
(define-key lispy-mode-map-lispy (kbd "[") nil)
(define-key lispy-mode-map-lispy (kbd "]") nil)
(define-key lispy-mode-map-lispy (kbd "<backtab>") nil) ;; ; This works

(define-key lispy-mode-map (kbd "M-n") nil)
(define-key lispy-mode-map-lispy (kbd "M-n") nil)
(define-key lispy-mode-map (kbd "M-p") nil)
(define-key lispy-mode-map-lispy (kbd "M-p") nil)


(defun my/lispy-unconvolute ()
  "The opposite of convolute. Like a demotion, from parent to child."
  (interactive)
  (ekm "f M-? f"))

;; my/lisp-mode is a mode that sits on top of lispy
(defun my/lisp-expand-contract-selection-right ()
  (interactive)
  (if (selected-p)
      (cond ((my/lispy-region-right-p)
             (let ((origmark (mark)))
               ;; expand rightwards
               (let ((my/lisp-mode nil))
                 (execute-kbd-macro (kbd "j"))
                 (push-mark origmark))))
            (t
             ;; contract rightwards
             (let ((my/lisp-mode nil))
               (paredit-forward)
               (if (eq (point) (mark))
                   (progn
                     (paredit-forward)
                     (if (lispy-right-p)
                         (ic 'er/expand-region)))
                 (progn
                   (activate-region)
                   (ekm "k j")))
               ;; (execute-kbd-macro (kbd "j"))
               )))
    (let ((my/lisp-mode nil))
      ;; Not sure why but this is broken
      ;; (ekm "J")
      (ekm "C-q J"))))

;; If I disable and reenable lispy, this stops working, so bind to lispy too
(define-key my/lisp-mode-map (kbd "J") 'my/lisp-expand-contract-selection-right)

(define-key lispy-mode-map (kbd "J") 'my/lisp-expand-contract-selection-right)

(defun my/lisp-expand-contract-selection-left ()
  (interactive)
  (if (selected-p)
      (cond ((my/lispy-region-left-p)
             (let ((origmark (mark)))
               ;; expand leftwards
               (let ((my/lisp-mode nil))
                 (execute-kbd-macro (kbd "k"))
                 (push-mark origmark))))
            (t
             ;; contract leftwards
             (let ((my/lisp-mode nil))
               (paredit-backward)
               (if (eq (point) (mark))
                   (progn
                     (paredit-backward)
                     (if (lispy-left-p)
                         (ic 'er/expand-region)))
                 (progn
                   (activate-region)
                   (ekm "j k")))
               ;; (execute-kbd-macro (kbd "k"))
               )))
    (let ((my/lisp-mode nil)
          (lispy-mode nil))
      (ekm "K"))))

;; If I disable and reenable lispy, this stops working, so bind to lispy too
(define-key my/lisp-mode-map (kbd "K") 'my/lisp-expand-contract-selection-left)

(define-key lispy-mode-map (kbd "K") 'my/lisp-expand-contract-selection-left)

(defun my/lispy-region-left-p ()
  "If you are on the left side of the region. If the mark is on the right."
  (= (point) (region-beginning)))

(defun my/lispy-region-right-p ()
  "If you are on the right side of the region. If the mark is on the right."
  (= (point) (region-end)))

(defun my/lispy-set-point-left ()
  (interactive)
  (when (my/lispy-region-right-p)
    ;; (lispy-different 1)
    (exchange-point-and-mark)))

(defun my/lispy-set-point-right ()
  (interactive)
  (when (my/lispy-region-left-p)
    ;; (lispy-different 1)
    (exchange-point-and-mark)))

;; TODO make keybindings
;; K and J, while selected
(defun my/lispy-slurp-left ()
  (interactive)
  (my/lispy-set-point-left)
  (lispy-slurp 1))

(defun my/lispy-slurp-right ()
  (interactive)
  (my/lispy-set-point-right)
  (lispy-slurp 1))


;; (let ((my/lisp-mode nil))
;;   (execute-kbd-macro (kbd "e")))



(define-key lispy-mode-map (kbd "M-t") 'paredit-forward-slurp-sexp)


;; DISCARD This did not remove the hooks. Actually, I think I don't want to remove the hook.
;; I want to change the function, or change the hook, if possible. semantic-default-elisp-setup
;; (remove-hook 'lisp-mode-hook 'semantic-default-elisp-setup t)

;; These two each work but I have to guarantee my functions are the last in the hook list
;; (add-hook 'emacs-lisp-mode-hook (lambda () (call-interactively 'my/fix-imenu-function)))
;; (add-hook 'emacs-lisp-mode-hook #'my/fix-imenu-function)


;; (define-key lispy-mode-map (kbd "g") nil)
;; (define-key lispy-mode-map (kbd "g d") #'special-lispy-goto)

;; (define-key lispy-mode-map (kbd "$") (kbd "C-e"))
;; (define-key lispy-mode-map (kbd "M-$") (kbd "C-e"))
;; (define-key lispy-mode-map (kbd "M-$") nil)
;; This is taken now
;; (define-key lispy-mode-map (kbd "M-4") (kbd "C-e"))
;; (define-key lispy-mode-map (kbd "M-4") nil)
;; (define-key lispy-mode-map (kbd "0") (kbd "C-a C-a"))


;; lispy flow does more than this
(defun my-lispy-flow-left (arg)
  (interactive)
  (if (major-mode-p 'racket-mode)
      (progn
        (let ((startpos (point)))
          (if (looking-at-p ".\(")
              (forward-char)
            (progn
              (forward-char)
              (search-forward "(")
              (backward-char)
              ))
          t                             ;Must return success so it does not revert

          ;; ;; Frustratingly, lispy-left-p is not actually checking that it's
          ;; ;; actually in lispy special mode
          ;; (if (and (lispy-left-p) (not (eq startpos (point))))
          ;;     (lispy-flow arg))
          ))
    (lispy--re-search-in-code lispy-left 'forward arg)))


(defun forward-sexp-start (arg)
  (interactive "p")
  (forward-sexp)
  (special-lispy-beginning-of-defun-noevil arg))

(define-key global-map (kbd "C-M-f") #'forward-sexp-start)


;; (define-key lispy-mode-map (kbd "M-W") #'evil-lisp-state-forward-symbol)

;; (defun mark-next ()
;;   (interactive)
;;   ;; (keyboard-quit)
;;   (lispy-mark-symbol)
;;   )
;; (defun my-mark-symbol (arg)
;;   (interactive "p")
;;   ;; (my/lisp-left-noevil arg)
;;   (lispy-mark-symbol arg))

;; (defun my-mark-right (arg)
;;   (interactive "p")
;;   ;; (my/lisp-left-noevil arg)
;;   (lispy-mark-right arg))

;; Use (deactivate-mark) instead of C-g


(defun my-lispy-goto-start (arg)
  (interactive "P")
  (deactivate-mark)
  (execute-kbd-macro (kbd "C-a C-a")))

;; (define-key lispy-mode-map (kbd "M-0") (kbd "C-a C-a"))
(define-key lispy-mode-map (kbd "M-0") #'my-lispy-goto-start)


(defun my-lispy-mark-symbol (arg)
  (interactive "P")
  ;; (forward-char 1)
  (lispy-mark-symbol)
  ;; (deactivate-mark)
  ;; (lispy-mark-symbol)
  )

(define-key lispy-mode-map (kbd "M-W") #'my-lispy-mark-symbol)
;; (define-key lispy-mode-map (kbd "M-j") #'my-lispy-mark-symbol)
(define-key lispy-mode-map (kbd "M-j") #'lispy-mark-symbol)


(defun my-lispy-mark-car (arg)
  "Frustratingly, this can't mark an empty list."
  (interactive "p")

  (my/lisp-left-noevil arg)
  (call-interactively (lispy-mark-car))

  ;; (call-interactively (my/lisp-left-noevil))
  ;; (lispy-mark-car )

  ;; (call-interactively (lispy-mark-car))
  )


(defun my-lispy-mark-list (arg)
  (interactive "p")
  ;; (message "marking list")
  ;; (call-interactively (lispy-mark-list))
  (my/lisp-right-noevil arg))


(defun my-lispy-mark-symbol-or-list (arg)
  (interactive "P")
  (if (region-active-p)
      (let ((rstart (region-beginning))
            (rend (region-end)))
        (call-interactively 'my-lispy-mark-list))
    (call-interactively 'my-lispy-mark-symbol)))


(define-key lispy-mode-map (kbd "M-A") #'my-lispy-mark-car)
;; (define-key lispy-mode-map (kbd "M-R") #'lispy-mark-list)

;; Keep for ranger
;; (define-key lispy-mode-map (kbd "M-R") #'my-lispy-mark-symbol-or-list)

;; ** I need =lispy-mark-left= to be bound to something
;; (define-key lispy-mode-map (kbd "M-F") #'lispy-mark-right)
(define-key lispy-mode-map (kbd "M-F") nil)

(require 'smartparens)


(my/with 'clojure-mode
         (defun cider-doc-thing-at-point ()
           (interactive)
           (cider-doc-lookup (str (symbol-at-point)))))


;; (define-key lispy-mode-map (kbd "M-9") #'my/doc-thing-at-point)
;; (define-key lispy-mode-map (kbd "M-9") nil)
;; (define-key lispy-mode-map (kbd "C-c C-z") #'my/repl-for-current-mode)
;; (define-key lispy-mode-map (kbd "C-c C-z") nil)


;; (define-key lispy-mode-map (kbd "M-A") #'sp-transpose-sexp)


;; Annoyingly, I think that lisp-mode-map mappings will not work for emacs-lisp, even though emacs-lisp-mode is derived from lisp-mode.
;; So redefine the keys.


;; (cider-doc &optional ARG)

;; (tvipe (pp (macroexpand '(my/with 'clojure-mode (define-key clojure-mode-map (kbd "M-n") #'evil-lisp-state-insert-sexp-after)))))

;; This does not prevent working with elisp. I simply need to do all my lisp editing in spacemacs
(if (cl-search "SPACEMACS" my-daemon-name)
    (progn
      (require 'evil-lisp-state)

      ;; Annoyingly this isnt working atm. Fix

      (defun evil-insert-sexp-before-noevil ()
        (interactive "p")
        (evil-lisp-state-insert-sexp-before)
        (evil-lisp-state/quit))

      ;; This doesn't work. Do I need to use a macro?
      ;; (mapcar (lambda (x) (define-key x (kbd "M-p") #'evil-lisp-state-insert-sexp-before)) '(lisp-mode-map emacs-lisp-mode-map))

      (defun evil-insert-sexp-before-noevil ()
        (interactive "p")
        (evil-lisp-state-insert-sexp-after)
        (evil-lisp-state/quit))

      (defun special-lispy-beginning-of-defun-noevil (arg)
        ;; If you use (interactive "p") then the defun needs an arg

        (interactive "p")
        (evil-lisp-state/quit)

        (lispy-left 20)
        (deselect))

      (define-key lispy-mode-map (kbd "C-M-a") #'special-lispy-beginning-of-defun-noevil)

      ;; (require 'racket-mode)
      ;; (require 'clojure-mode)
      (my/with 'clojure-mode
               (defun cider-doc-thing-at-point ()
                 (interactive)
                 (cider-doc-lookup (format "%s" (symbol-at-point))))
               )

      (my/with 'cider-repl
               (defun cider-doc-thing-at-point ()
                 (interactive)
                 (cider-doc-lookup (format "%s" (symbol-at-point))))
               )

      (my/with 'slime
               (define-key slime-mode-map (kbd "M-n") nil)
               (define-key slime-mode-map (kbd "M-p") nil))))


(setq lispy-completion-method 'helm)

(defun format-sexp-at-point (formatter)
  "Formats sexp code, if selected or on a starting parenthesis."
  (interactive)
  (message "Formatting sexp")
  (cond ((and (lispy-left-p) (not (selected-p)))
         (save-excursion
           (ekm "m")
           (region-pipe formatter)))
        ((selected-p)
         (save-mark-and-excursion
           (region-pipe formatter))
         ;; (reselect-last-region)
         )
        (t
         (sh-notty (concat formatter " " (e/q buffer-file-name))))))

(defun format-clojure-at-point ()
  "Formats clojure code, if selected or on a starting parenthesis."
  (interactive)
  (format-sexp-at-point "cljfmt"))

(defun my-lispy-format-or-company ()
  (interactive)
  (if (lispy-left-p)
      (cond
       ((major-mode-p 'racket-mode)
        (format-racket-at-point))
       ((major-mode-p 'clojure-mode)
        (format-clojure-at-point))
       (t
        (special-lispy-tab)))
    (call-interactively 'my-company-complete)))
(define-key lispy-mode-map (kbd "C-M-i") 'my-lispy-format-or-company)


(defun my-lispy-select-parent-sexp ()
  (interactive)
  (ekm "M-a m"))
(define-key lispy-mode-map (kbd "M-h") 'my-lispy-select-parent-sexp)

;; Why on earth
;; (define-key lispy-mode-map (kbd "J") (kbd "O"))

(define-key lispy-mode-map (kbd "\"") nil)
(define-key lispy-mode-map (kbd "M-d") nil)
(define-key lispy-mode-map (kbd "S") nil)

(defun my-lispy-run-inner-sexp (arg)
  (interactive "p")
  (save-excursion
    (if (not (lispy-left-p))
        (my/lisp-left-noevil arg))
    (my/lisp-e)))

;; (define-key my/lisp-mode-map (kbd "M-E") #'my-lispy-run-inner-sexp)
(define-key lispy-mode-map (kbd "M-W") #'my-lispy-run-inner-sexp)

;; This also removes the mapping from the lispy special map
;; (define-key lispy-mode-map (kbd "E") nil)


;; ;; Rather than fixing this, just remove the lispy binding
;; (defun lispy-kill-word (arg)
;;   "Kill ARG words, keeping parens consistent."
;;   (interactive "p")
;;   (if (< arg 0)
;;       (lispy-backward-kill-word (- arg))
;;     (let (bnd)
;;       (lispy-dotimes arg
;;         (while (not (or (eobp)
;;                         (memq (char-syntax (char-after))
;;                               '(?w ?_))))
;;           (forward-char 1))
;;         (unless (lispy-bolp)
;;           (delete-horizontal-space))
;;         (if (setq bnd (lispy--bounds-string))
;;             (save-restriction
;;               (narrow-to-region (1+ (car bnd)) (1- (cdr bnd)))
;;               (kill-word 1)
;;               (widen))
;;           (kill-word 1))))))


(define-key lispy-mode-map (kbd "M-.") nil)
(define-key lispy-mode-map (kbd "M-k") nil)

;; Can't do this because it needs to run in lispy special mode only
;; This is not the way
;; (define-key lispy-mode-map (kbd "g y") #'get-vim-link)
;; (define-key lispy-mode-map (kbd "g Y") #'get-emacs-link)

;; This is not the way
;; (define-key lispy-mode-map (kbd "g y") nil)
;; (define-key lispy-mode-map (kbd "g Y") nil)

(defvar lispy-string-edit-mode-map
       (let ((map (make-sparse-keymap))
             (menu-map (make-sparse-keymap "lispy string")))
         ;; (set-keymap-parent map text-mode-shared-map)
         ;; (define-key map "\e\C-x" 'lisp-eval-defun)
         (define-key map (kbd "C-c '") 'lispy-edit-string)
         map))


(define-derived-mode lispy-string-edit-mode text-mode "lispy string"
  "Major mode for editing lisp strings.")


(defun emacs-lisp-edit-string ()
  (interactive)
  (if (and (lispy--buffer-narrowed-p)
           (major-mode-p 'lispy-string-edit-mode))
      (progn
        (cfilter "q -f")
        (while (lispy--buffer-narrowed-p)
          (ignore-errors (call-interactively 'recursive-widen)))
        (emacs-lisp-mode))
    (if (lispy--in-string-p)
        (save-mark-and-excursion
          (progn (lispy-mark)
                 ;; (backward-char)
                 ;; (call-interactively 'cua-exchange-point-and-mark)
                 ;; (forward-char)
                 (call-interactively 'my/enter-edit-emacs)
                 (lispy-string-edit-mode)
                 (cfilter "uq"))))))
(defalias 'lispy-edit-string 'emacs-lisp-edit-string)


(define-key lispy-mode-map (kbd "C-c '") 'lispy-edit-string)
(define-key lispy-string-edit-mode-map (kbd "C-c '") 'lispy-edit-string)

;; (defun my-lispy-backspace ()
;;   (interactive)
;;   (ekm ""))

(require 'my-selected)
(define-key lispy-mode-map (kbd "C-h") 'selected-backspace-delete-and-deselect)

;; (define-key lispy-mode-map (kbd "C-h") 'my-lispy-backspace)
;; (define-key lispy-mode-map (kbd "C-h") nil)



(defun lispy--prin1-to-string (expr offset mode)
  "Return the string representation of EXPR.
EXPR is indented first, with OFFSET being the column position of
the first character of EXPR.
MODE is the major mode for indenting EXPR."
  (let ((lif lisp-indent-function))
    (with-temp-buffer
      (funcall mode)
      (dotimes (_i offset)
        (insert ?\ ))
      (let ((lisp-indent-function lif))
        (lispy--insert expr))
      (buffer-substring-no-properties
       (+ (point-min) offset)
       (point-max)))))

;; (defun my-lispy-add-to-glossary ()
;;   (if (region-active-p)))

(defun lispy-quotes (arg)
  "Insert a pair of quotes around the point.

When the region is active, wrap it in quotes instead.
When inside string, if ARG is nil quotes are quoted,
otherwise the whole string is unquoted."
  (interactive "P")
  (let (bnd)
    (cond ((region-active-p)
           (if arg
               (lispy-unstringify)
             ;; (lispy-stringify)
             ;; (save-region)
             ;; (etv (concat (str m1) " " (str m2)))
             (cfilter "q -f")))
          ((and (setq bnd (lispy--bounds-string))
                (not (= (point) (car bnd))))
           (if arg
               (lispy-unstringify)
             (if (and lispy-close-quotes-at-end-p (looking-at "\""))
                 (forward-char 1)
                 (progn (insert "\\\"\\\""))
                 (backward-char 2))))

          (arg
           (lispy-stringify))

          ((lispy-after-string-p "?\\")
           (self-insert-command 1))

          (t
           (lispy--space-unless "^\\|\\s-\\|\\s(\\|[#]")
           (insert "\"\"")
           (unless (looking-at "\n\\|)\\|}\\|\\]\\|$")
             (just-one-space)
             (backward-char 1))
           (backward-char)))))


(defun toggle-lispy-and-selected ()
  (interactive)
  (call-interactively 'lispy-mode)
  (call-interactively 'selected-minor-mode))

(define-key lispy-mode-map (kbd "M-o") 'toggle-lispy-and-selected)
(define-key my-mode-map (kbd "C-x M-o") 'toggle-lispy-and-selected)


(define-key lispy-mode-map (kbd "M-RET") nil)
(define-key lispy-mode-map (kbd "M-s [") 'geiser-squarify)

(provide 'my-lispy)