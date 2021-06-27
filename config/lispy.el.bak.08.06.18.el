(require 'my-lisp)
(require 'my-utils)

;; Does not unbind
;; (define-key visual-line-mode-map (kbd "<end>") nil)

;; This is needed so the my/lisp e works
(define-key lispy-mode-map (kbd "e") nil)

(define-key lispy-mode-map (kbd "[") nil)
(define-key lispy-mode-map-lispy (kbd "[") nil)
(define-key lispy-mode-map (kbd "]") nil)
(define-key lispy-mode-map-lispy (kbd "]") nil) ;; ; This works

(define-key lispy-mode-map (kbd "M-n") nil)
(define-key lispy-mode-map-lispy (kbd "M-n") nil)
(define-key lispy-mode-map (kbd "M-p") nil)
(define-key lispy-mode-map-lispy (kbd "M-p") nil)

;; Use this instead of M-n, M-p
;; (define-key lispy-mode-map (kbd "M-(") #'evil-lisp-state-insert-sexp-before)
(define-key lispy-mode-map-lispy (kbd "M-(") #'evil-lisp-state-insert-sexp-before)
;; (define-key lispy-mode-map (kbd "M-)") #'evil-lisp-state-insert-sexp-after)
(define-key lispy-mode-map-lispy (kbd "M-)") #'evil-lisp-state-insert-sexp-after)

;; (define-key lispy-mode-map (kbd "g") nil)
;; (define-key lispy-mode-map (kbd "g d") #'special-lispy-goto)

;; (define-key lispy-mode-map (kbd "$") (kbd "C-e"))
(define-key lispy-mode-map (kbd "M-$") (kbd "C-e"))
(define-key lispy-mode-map (kbd "M-4") (kbd "C-e"))
;; (define-key lispy-mode-map (kbd "0") (kbd "C-a C-a"))


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
  (deactivate-mark)
  (lispy-mark-symbol))

(define-key lispy-mode-map (kbd "M-W") #'my-lispy-mark-symbol)
(define-key lispy-mode-map (kbd "M-j") #'my-lispy-mark-symbol)


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
(define-key lispy-mode-map (kbd "M-R") #'my-lispy-mark-symbol-or-list)
(define-key lispy-mode-map (kbd "M-F") #'lispy-mark-right)



(require 'smartparens)


;; (defun my/lisp-doc ()
;;   "Show lisp documentation for the appropriate dialect based on the current mode."
;;   (cond (derived-mode-p ')))

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

        ;; (kbd "C-u 2 0 M-a")

        ;; (kbd "C-a C-a C-f")
        ;; (my/lisp-left-noevil arg)
        ;; (slime-beginning-of-defun)
        )

      ;; (defun my/lisp-doc ()
      ;;   (interactive)
      ;;   (cond ((bound-and-true-p 'clojure-mode)
      ;;          (cider-doc-thing-at-point))
      ;;         ((bound-and-true-p 'inf-clojure)
      ;;          (cider-doc-thing-at-point))
      ;;         ((bound-and-true-p 'slime)
      ;;          (slime-documentation))))

      ;; (require 'racket-mode)
      ;; (require 'clojure-mode)
      (my/with 'clojure-mode
               (defun cider-doc-thing-at-point ()
                 (interactive)
                 (cider-doc-lookup (format "%s" (symbol-at-point))))

               ;; I want my/lisp-mode to work in a repl, so don't do this


               (define-key clojure-mode-map (kbd "C-M-a") #'special-lispy-beginning-of-defun-noevil)
               (define-key clojure-mode-map (kbd "M-9") #'cider-doc-thing-at-point))

      (my/with 'cider-repl
               (defun cider-doc-thing-at-point ()
                 (interactive)
                 (cider-doc-lookup (format "%s" (symbol-at-point))))

               ;; I want these usually when writing lisp, but not in the repl (where i need to use them for history).
               ;; But I can't disable them this way...
               ;; (define-key lispy-mode-map-lispy (kbd "M-p") nil)
               ;; (define-key lispy-mode-map-lispy (kbd "M-n") nil)

               (define-key cider-repl-mode-map (kbd "C-M-a") #'special-lispy-beginning-of-defun-noevil)
               (define-key cider-repl-mode-map (kbd "M-9") #'cider-doc-thing-at-point))

      (my/with 'inf-clojure
               (define-key inf-clojure-mode-map (kbd "M-9") #'cider-doc-thing-at-point))

      (my/with 'slime
               (define-key slime-mode-map (kbd "M-n") nil)
               (define-key slime-mode-map (kbd "M-p") nil)
               (define-key slime-mode-map (kbd "C-c C-z") #'my/repl-lisp))

      (my/with 'lisp-mode
               ;; (define-key lisp-mode-map (kbd "M-p") #'evil-lisp-state-insert-sexp-before)
               ;; (define-key lisp-mode-map (kbd "M-n") #'evil-lisp-state-insert-sexp-after)

               (define-key lisp-mode-map (kbd "C-M-a") #'special-lispy-beginning-of-defun-noevil))

      (my/with 'slime
               (define-key slime-mode-map (kbd "M-9") #'slime-documentation))

      (my/with 'racket-mode
               ;; (define-key racket-mode-map (kbd "M-p") #'evil-lisp-state-insert-sexp-before)
               ;; (define-key racket-mode-map (kbd "M-n") #'evil-lisp-state-insert-sexp-after)

               (define-key racket-mode-map (kbd "C-M-a") #'special-lispy-beginning-of-defun-noevil)
               (define-key racket-mode-map (kbd "M-9") #'racket-doc))

      ;; You can't "require" emacs-lisp-mode
      ;; (define-key emacs-lisp-mode-map (kbd "M-p") #'evil-lisp-state-insert-sexp-before)
      ;; (define-key emacs-lisp-mode-map (kbd "M-n") #'evil-lisp-state-insert-sexp-after)

      (define-key emacs-lisp-mode-map (kbd "C-M-a") #'special-lispy-beginning-of-defun-noevil)
      ;; (define-key emacs-lisp-mode-map (kbd "M-9") #'describe-thing-at-point)
      (define-key emacs-lisp-mode-map (kbd "M-9") #'helpful-symbol)
      (define-key emacs-lisp-mode-map (kbd "C-c C-z") #'ielm)))