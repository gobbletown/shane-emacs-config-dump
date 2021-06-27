(require 'clean-aindent-mode)

;; This didn't work
;; (define-key clean-aindent-mode--keymap (kbd "M-DEL") nil)

;; I think this is the way to override a binding more reliably
(define-key clean-aindent-mode--keymap [remap backward-kill-word] nil)

(provide 'my-clean-aindent)