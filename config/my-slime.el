;; I want to set up sly and roswell
;; http://joaotavora.github.io/sly/#A-SLY-tour-for-SLIME-users

;; Use sly or slime
(defvar my-lisp-mode "sly")
;; (defset my-lisp-mode "slime")

;; Unfortunately, sly is very sly indeed and forces you to use slime because it an autoload coupled with a question
;; v +/"SLIME detected" "$EMACSD/packages27/sly-20200314.55/sly.el"

;; (defun my-lisp-hook ()
;;     (slime)
;;     )
;; 
;; (add-hook 'lisp-mode-hook 'my-lisp-hook)


;; This is common-lisp stuff, not elisp
;; ====================================

;; Don't do anything with common lisp until I can get it right without
;; disrupting elisp.

;; (add-to-list 'load-path (expand-file-name "~/.emacs.d/site-lisp/slime"))
;;(require 'slime)

(setq inferior-lisp-program "sbcl")

;; sly or slime
;; (cond
;;  ((string= my-lisp-mode "slime") 
;;   (if (cl-search "SPACEMACS" my-daemon-name)
;;       (ignore-errors
;;         (progn
;;           (require 'slime)

;;           ;; slime may not be installed, so ignore errors
;;           (add-hook 'lisp-mode-hook (lambda () (slime-mode t)))
;;           (add-hook 'inferior-lisp-mode-hook (lambda () (inferior-slime-mode t)))
;;           (setq inferior-lisp-program "sbcl")
;;           (setq inferior-lisp-program "sbcl" ; Steel Bank Common Lisp
;;                 slime-contribs '(slime-fancy))
;;           (slime-setup '(slime-fancy slime-asdf))))))
;;  ((string= my-lisp-mode "sly")
;;   ;; This needs to run before spacemacs is booted
;;   (remove-hook 'lisp-mode-hook #'slime-lisp-mode-hook)
;;   nil
;;   ))

(yes (require 'sly))
(require 'sly-asdf)
(require 'sly-hello-world)
(require 'sly-named-readtables)
(require 'sly-quicklisp)
(require 'sly-repl-ansi-color)

(provide 'my-slime)