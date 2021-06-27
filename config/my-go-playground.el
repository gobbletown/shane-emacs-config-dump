(require 'go-playground)

(defun my-go-playground-exec()
  (interactive)
  ;; (go-playground-rm)
  (call-interactively 'go-playground-exec))

(define-key go-playground-mode-map [C-return] nil)
(define-key go-playground-mode-map (kbd "M-RET") nil)
(define-key go-playground-mode-map (kbd "M-C-m") 'go-playground-exec)
(define-key go-playground-mode-map (kbd "C-c C-c") 'my-go-playground-exec)

;; (define-key go-playground-mode-map (kbd "C-z C-r") 'go-playground-exec)
;; (define-key go-playground-mode-map (kbd "C-z C-r") nil)

;; Instead of doing this, I should make a leader-key binding for when not in evil mode
;; compile-run handles go-playground-exec. Just use that

(provide 'my-go-playground)