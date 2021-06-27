;; $HOME/blog/posts/convert-hydra-to-regular-bindings.org

;; I don't know how to temporarily disable major modes to run bindings
;; If I need to do this, I should move those bindings into a minor mode
;; Another possibility is switching mode temporarily to fundamental-mode
;; But this might cause side-effects, so I'd like to avoid this.

(defun helpful-symbol-at-point ()
  (interactive)
  (helpful-symbol (symbol-at-point)))

(defun my-elisp-expand-macro-or-copy ()
  (interactive)
  (if (selected-p)
      ;; (setq emacs-lisp-mode-map (make-sparse-keymap))
      ;; (call-interactively '(ov-highlight-copy-advice 'kill-ring-save))
      (my/copy)
    ;; (ov-highlight-copy-advice 'identity)
    ;; (tsk "M-w") ; Can't use tmux because it will spam M-w infinitely due to the map not being truly disabled
    ;; (ekm "M-w")
                                        ; execute-keyboard-macro still uses the original emacs-lisp-mode-map
    (call-interactively 'macrostep-expand)))


;; This seems to work
(add-hook 'emacs-lisp-mode-hook #'company-mode)

;; This fixes the checkdoc error
(defun emacs-lisp-mode-hook-run ()
  ;; (setq flycheck-disabled-checkers '(emacs-lisp-checkdoc))
  (add-to-list 'flycheck-disabled-checkers 'emacs-lisp-checkdoc)

  ;; (remove-from-list 'company-backends 'company-capf)
  (remove-from-list 'completion-at-point-functions 'elisp-completion-at-point)
  ;; (remove-from-list 'completion-at-point-functions 't)
  )

(add-hook 'emacs-lisp-mode-hook 'emacs-lisp-mode-hook-run t)


(define-key emacs-lisp-mode-map (kbd "M-w") #'my-elisp-expand-macro-or-copy)
;; (define-key emacs-lisp-mode-map (kbd "M-w") nil)



(require 'elisp-slime-nav)
(define-key elisp-slime-nav-mode-map (kbd "M-.") nil)

;; (defun org-open-at-point-around-advice (proc &rest args)
;;   (let ((res (save-excursion (apply proc args))))
;;     res))
;; (advice-add 'org-open-at-point :around #'org-open-at-point-around-advice)
;; (advice-remove 'org-open-at-point #'org-open-at-point-around-advice)

(define-key emacs-lisp-mode-map (kbd "C-c C-o") 'org-open-at-point)


(provide 'my-emacs-lisp)