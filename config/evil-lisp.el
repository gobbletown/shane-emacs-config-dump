;; This does not prevent working with elisp. I simply need to do all my lisp editing in spacemacs
(if (cl-search "SPACEMACS" my-daemon-name)
    (progn
      (require 'evil-lisp-state)

      ;; I should try to make these not require evil-lisp
      ;; In fact, I should make my own lisp editing mode if I am to be truly serious
      (defun my/evil-lisp-state-insert-sexp-after ()
        "Insert sexp after the current one."
        (interactive)
        (let ((sp-navigate-consider-symbols nil))
          (if (char-equal (char-after) ?\() (forward-char))
          (sp-up-sexp)
          (evil-insert-state)
          (insert " ")
          ;; (sp-newline)
          (sp-insert-pair "(")))

      (defun my/evil-lisp-state-insert-sexp-before ()
        "Insert sexp before the current one."
        (interactive)
        (let ((sp-navigate-consider-symbols nil))
          (if (char-equal (char-after) ?\() (forward-char))
          (sp-backward-sexp)
          (evil-insert-state)
          ;; (sp-newline)
          ;; (evil-previous-visual-line)
          ;; (evil-end-of-line)
          (insert "  ")
          (backward-char)
          (sp-insert-pair "(")
          ;; (indent-for-tab-command) ; This starts the function completion
          ))

      ;; Use this instead of M-n, M-p
      ;; (define-key lispy-mode-map (kbd "M-(") #'evil-lisp-state-insert-sexp-before)
      ;; (define-key lispy-mode-map-lispy (kbd "M-(") #'my/evil-lisp-state-insert-sexp-before)
      (define-key lispy-mode-map-lispy (kbd "M-(") nil)
      ;; (define-key lispy-mode-map (kbd "M-)") #'evil-lisp-state-insert-sexp-after)
      ;; (define-key lispy-mode-map-lispy (kbd "M-)") #'my/evil-lisp-state-insert-sexp-after)
      (define-key lispy-mode-map-lispy (kbd "M-)") nil)

      (define-key evil-lisp-state-map (kbd "M-m k q") 'evil-lisp-state/quit)

      (define-key evil-lisp-state-map (kbd "q") #'evil-lisp-state/quit)

      (define-key evil-motion-state-map (kbd "q") (kbd "C-g"))))