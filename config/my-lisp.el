(require 'lispy)
(require 'my-utils)

(setq show-paren-delay 0
      show-paren-style 'parenthesis)

(show-paren-mode 1)

(defvar my/lisp-mode-map (make-sparse-keymap)
  "Keymap for `my/lisp-mode'.")

;; :lighter :: lisp expression that is evaluated to get text used in the display of minor mode in mode line.
;; in emacs27 a docstring is required,
(define-minor-mode my/lisp-mode
  "docstring"
  :init-value nil         ; I don't want this to be t. I don't want it enabled everywhere.
  :lighter " my/lisp"
  :keymap my/lisp-mode-map)

;; I don't want a globalised minor mode for this one
;; (define-globalized-minor-mode global-my/lisp-mode my/lisp-mode my/lisp-mode)

(require 'smartparens)

(if (cl-search "SPACEMACS" my-daemon-name)
    (require 'evil-lisp-state))

;; Maybe we don't want to require it. Use my/with
;(require 'paredit)

;(define-key ac-mode-map (kbd "C-h") nil)


(my/with 'paredit (add-hook 'my/lisp-mode-hook '(lambda () (paredit-mode 1))))

;; The reason why paredit is good (and fast) is because it uses meta keybindings to do everything, instead of requiring you to be at a 'special' position, as is the case with lispy

;; This would raise the sexp, replacing the parent.
(define-key paredit-mode-map (kbd "M-r") nil)
(define-key paredit-mode-map (kbd "C-M-n") nil)
(define-key paredit-mode-map (kbd ";") nil)
(define-key paredit-mode-map (kbd "C-d") nil)


;; M-TAB should retab. I should train myself to use 'i' though.
(define-key lispy-mode-map-special (kbd "M-TAB") (kbd "i"))


(require 'lispy)


;; (defun my/lisp-mark-car (arg)
;;   "Frustratingly, this can't mark an empty list."
;;   (interactive "p")

;;   ;; (my/lisp-left-noevil arg)
;;   (if (region-active-p)
;;       (if (cursor-at-region-start-p)
;;           (execute-kbd-macro (kbd "d"))
;;         (lispy-mark-car)
;;         )
;;     (progn
;;       (execute-kbd-macro (kbd "M-a"))
;;       (lispy-mark-car)))
;;   ;; (execute-kbd-macro (kbd "d"))

;;   ;; (call-interactively (my/lisp-left-noevil))
;;   ;; (lispy-mark-car )

;;   ;; (call-interactively (lispy-mark-car))
;;   )


;; Start using this if I have paren backspacing problems again
(defun my/lisp-backward-delete ()
  "This tries to delete a paren pair. If it fails, it will try to delete a single char."
  (interactive)
  (try (paredit-backward-delete) (backward-delete-char)))

(define-key my/lisp-mode-map (kbd "DEL") 'my/lisp-backward-delete)


;; (define-key my/lisp-mode-map (kbd "M-1") (lambda () (interactive) (my/lisp-mark-n 1)))
;; (define-key my/lisp-mode-map (kbd "M-1") nil)
;; (define-key my/lisp-mode-map (kbd "M-1") #'my/lisp-mark-car)
;; (define-key my/lisp-mode-map (kbd "M-2") #'my/lisp-mark-2)
;; (define-key my/lisp-mode-map (kbd "M-2") nil)
;; /home/shane/var/smulliga/source/git/config/emacs/config/my-doc.el
;; (define-key my/lisp-mode-map (kbd "M-3") (lambda () (interactive) (my/lisp-mark-n 3)))
;; This is taken now
;; (define-key my/lisp-mode-map (kbd "M-4") (lambda () (interactive) (my/lisp-mark-n 4)))
;; (define-key my/lisp-mode-map (kbd "M-5") (lambda () (interactive) (my/lisp-mark-n 5)))
;; (define-key my/lisp-mode-map (kbd "M-5") nil)
;; (define-key my/lisp-mode-map (kbd "M-6") (lambda () (interactive) (my/lisp-mark-n 6)))
;; (define-key my/lisp-mode-map (kbd "M-6") (lambda () (interactive) (my/lisp-mark-last-n 3)))
;; (define-key my/lisp-mode-map (kbd "M-6") nil)
;; (define-key my/lisp-mode-map (kbd "M-7") (lambda () (interactive) (my/lisp-mark-n 7)))

;; I'm using this for 'immediate' docs now
;; (define-key my/lisp-mode-map (kbd "M-7") (lambda () (interactive) (my/lisp-mark-last-n 2)))
;; (define-key my/lisp-mode-map (kbd "M-8") #'my/lisp-mark-last)
(define-key my/lisp-mode-map (kbd "M-8") nil)
;; M-9 is used for documentation
(define-key my/lisp-mode-map (kbd "M-0") (kbd "M-a"))

;; (defun my/lisp-e ()
;;   "I want this to work in elisp as well as clojure and perhaps all lisp modes. Done."
;;   (interactive)
;;   (if (region-active-p)
;;       (if (lispy-left-p)
;;           (progn
;;             (save-mark-and-excursion
;;               (execute-kbd-macro
;;                (kbd "d C-x C-e"))))
;;         ;; (execute-kbd-macro
;;         ;;    (kbd "d C-x C-e d"))
;;         (execute-kbd-macro
;;          (kbd "C-x C-e")))
;;     (let ((my/lisp-mode nil))
;;       (execute-kbd-macro (kbd "e")))    ; This is actually good and shows how to run a kbd macro temporarily disabling the mode
;;     ;; (special-lispy-eval)
;;     ))

;; (my/beep)


(defun my/lisp-e ()
  "I want this to work in elisp as well as clojure and perhaps all lisp modes. Done."
  (interactive)
  (save-window-excursion
    (cond ((lispy-left-p)
           ;; This is better. Now it works for interactive sexps, e.g. (fz)
           ;; But this needs an elisp check
           ;; Now I have the best of both worlds. This uses the old way for non-emacs lisps in which interactive is not an issue
           (if (major-mode-p 'emacs-lisp-mode)
               (eval (sexp-at-point))
             (save-mark-and-excursion
               (ekm "d C-x C-e")))
           ;; Using tmux overcomes the interactive limitation but the final d is consumed by the interactive command, e.g. helm
           ;; (tsk "d C-x C-e d")
           )
          ((lispy-right-p)
           (ekm "C-x C-e"))
          (t
           (special-lispy-eval)
           ;; I disabled lispy's e.

           ;; (let ((my/lisp-mode nil))
           ;;   (execute-kbd-macro (kbd "e")))
           ))))

(define-key my/lisp-mode-map (kbd "e") #'my/lisp-e)
(define-key my/lisp-mode-map (kbd "M-a") #'my/lisp-left-noevil)
;; (define-key my/lisp-mode-map (kbd "M-e") #'my/lisp-right-noevil)

(defun my/lisp-first-child ()
  (interactive)
  (if (region-active-p)
      (let ((originalselection (selection)))
        (if (cursor-at-region-start-p)
            ;; (progn
            ;;   (if (lispy-left-p)
            ;;       (deactivate-mark)))
            ;; (execute-kbd-macro (kbd "d M-a M-j"))
            (progn
              (execute-kbd-macro (kbd "d"))
              (lispy-mark-car))
          (progn ;; (execute-kbd-macro (kbd "d"))
            ;; (execute-kbd-macro (kbd "M-a d"))
            ;; (execute-kbd-macro (kbd "M-a"))
            (lispy-mark-car)
            ;; (execute-kbd-macro (kbd "d"))
            ))

        ;; This is for clojure eg. (server/run-server!)
        (if (and (string-equal originalselection (selection))
                 (re-match-p "[/.]" originalselection))
            (progn
              (if (> (point) (mark))
                  (call-interactively 'exchange-point-and-mark))
              (re-search-forward "[/.]")
              (call-interactively 'exchange-point-and-mark))))
    (progn
      ;; TODO Instead of using M-j here, first select the sexp and then do M-e, or run my/lisp-first-child again after selecting the sexp. This will fix the problem selecting these regexes:
      ;; $EMACSD/packages24/strace-mode-20171116.1239/strace-mode.el
      ;; (execute-kbd-macro (kbd "M-j"))
      (call-interactively 'lispy-mark-symbol)
      )))

(define-key my/lisp-mode-map (kbd "M-e") #'my/lisp-first-child)

(defun my/lisp-mark-n (n)
  (interactive)
  (deactivate-mark)
  ;; (execute-kbd-macro (kbd "M-a M-j"))
  (execute-kbd-macro (kbd "M-a d"))
  (lispy-mark-car)
  ;; (my/lisp-mark-car 0)
  (dotimes (_n (- n 1))
    (execute-kbd-macro (kbd "j"))))

(defun my/lisp-mark-last-n (n)
  (interactive)
  (deactivate-mark)
  ;; (execute-kbd-macro (kbd "M-a M-j"))
  (execute-kbd-macro (kbd "M-a d"))
  (lispy-mark-car)
  (my/lisp-mark-last)
  (dotimes (_n (- n 1))
    (execute-kbd-macro (kbd "k"))))

(defun my/lisp-mark-2 ()
  (interactive)
  (deactivate-mark)
  ;; (execute-kbd-macro (kbd "M-a M-j"))
  (execute-kbd-macro (kbd "M-a d"))
  (lispy-mark-car)
  ;; (my/lisp-mark-car 0)
  (execute-kbd-macro (kbd "j")))

(defun my/lisp-mark-last ()
  (interactive)
  (deactivate-mark)
  ;; (execute-kbd-macro (kbd "M-a M-j"))
  (execute-kbd-macro (kbd "M-a d"))
  (lispy-mark-car)
  ;; (my/lisp-mark-car 0)
  (dotimes (_n 100)
    (execute-kbd-macro (kbd "j"))))

(defun my/lisp-go-top ()
  (interactive)
  (dotimes (i 100)
    (special-lispy-up)))

;; (define-key lispy-mode-map (kbd "g g") nil)
;; (lispy-define-key lispy-mode-map-special (kbd "g g") #'lispy-go-top)
;; (lispy-define-key lispy-mode-map-special (kbd "^") #'lispy-left-noevil)
;; (define-key lispy-mode-map-lispy (kbd "g g") nil)

(defun my/lisp-left-noevil (arg)
  (interactive "p")
  (my/with 'evil-lisp-state
           ;; Only exit evil lisp if evil is enabled. Otherwise, it will start evil
           (if evil-state
               (evil-lisp-state/quit)))
  (my/with 'lispy
           (lispy-left arg))
  (deselect))

(defun my/lisp-right-noevil (arg)
  (interactive "p")
  (my/with 'evil-lisp-state
           (if evil-state
               (evil-lisp-state/quit)))
  (my/with 'lispy
           (lispy-right arg)))

(defun my/select-sexp ()
  (interactive)
  (ekm "C-M-a m"))

;; Home is C-M-y
(define-key my/lisp-mode-map (kbd "<home>") 'my/select-sexp)

;; (lispy--current-function) ; This gets the function name and is sometimes what I need instead of preceding-sexp-or-element
(defun preceding-sexp-or-element ()
  "Returns the preceding sexp or element or nil if the current is the first in the sexp."
  (interactive)
  (save-excursion
    (try
     (progn
       (let ((orig-pos (point)))
         ;; (ns (concat "Old pos: " (str orig-pos)))
         (if (not (or (equal (current-column) 0) (string-equal " " (char-to-string (preceding-char)))))
             (backward-sexp))
         (backward-sexp)
         ;; (message (concat "New pos: " (str (point))))
         (if (equal orig-pos (point))
             nil
           (str (thing-at-point 'sexp)))))
     nil)))

(defun my/lispy-delete-or-h ()
  "If selected, delete, otherwise, send h."
  (interactive)
  (if (selected)
      (call-interactively 'lispy-delete)
    (let ((my/lisp-mode nil))
      ;; I also have to hardcode this
      ;; (execute-kbd-macro (kbd "h"))
      (if (or (lispy-left-p)
              (lispy-right-p))
          (special-lispy-left)
        (self-insert-command 1)))))

(defun my/lispy-delete-or-c-h ()
  "If selected, delete, otherwise, send h."
  (interactive)
  (if (selected)
      (call-interactively 'lispy-delete)

    (let ((my/lisp-mode nil))
      ;; (execute-kbd-macro (kbd "C-h"))
      ;; It was still not getting through, so I hardcoded it. The call to disable my/lisp-mode is still necessary
      (selected-backspace-delete-and-deselect))))

(define-key my/lisp-mode-map (kbd "h") #'my/lispy-delete-or-h)
(define-key my/lisp-mode-map (kbd "DEL") #'my/lispy-delete-or-c-h) ; C-h is translated to DEL which is bound to this

(provide 'my-lisp)