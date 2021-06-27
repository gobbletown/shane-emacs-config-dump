;; DISCARD Enable syntax highlighting
;; This broke C-a. C-a relies on comint which needs the
;; correct text properties
;; https://stackoverflow.com/questions/25809493/how-can-i-get-syntax-highlighting-for-common-lisp-in-slimes-repl

;; (defvar slime-repl-font-lock-keywords lisp-font-lock-keywords-2)
;; (defun slime-repl-font-lock-setup ()
;;   (setq font-lock-defaults
;;         '(slime-repl-font-lock-keywords
;;          ;; From lisp-mode.el
;;          nil nil (("+-*/.<>=!?$%_&~^:@" . "w")) nil
;;          (font-lock-syntactic-face-function
;;          . lisp-font-lock-syntactic-face-function))))
;; 
;; (add-hook 'slime-repl-mode-hook 'slime-repl-font-lock-setup)
;; (remove-hook 'slime-repl-mode-hook 'slime-repl-font-lock-setup)
;; 
;; (defadvice slime-repl-insert-prompt (after font-lock-face activate)
;;   (let ((inhibit-read-only t))
;;     (add-text-properties
;;      slime-repl-prompt-start-mark (point)
;;      '(font-lock-face
;;        slime-repl-prompt-face
;;        rear-nonsticky
;;        (slime-repl-prompt read-only font-lock-face intangible)))))




;; ;; DISCARD Enable C-a
;; This function is no longer required, nor does it work. C-a does work under normal circumstances (i.e. take you to after CL-USER>).
;; What do I do to get it to work without trying to get this working
;; ;; It was deleted becaus apparently comint does it anyway
;; ;; cd "$MYGIT/slime/slime"; git-find-deleted slime-repl-bol
;; (defun slime-repl-bol ()
;;   "Go to the beginning of line or the prompt."
;;   (interactive)
;;   (cond ((and (>= (point) slime-repl-input-start-mark)
;;               (slime-same-line-p (point) slime-repl-input-start-mark))
;;          (goto-char slime-repl-input-start-mark))
;;         (t (beginning-of-line 1)))
;;   (slime-preserve-zmacs-region))


(defun my-slime ()
  (interactive)
  (if (buffer-exists "*slime-repl sbcl*")
      (switch-to-buffer "*slime-repl sbcl*")
    (call-interactively 'slime)))

(provide 'my-slime-repl)