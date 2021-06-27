(require 'rust-playground)
(provide 'my-rust-playground)

; Defaults
; --------
;(define-key rust-playground-mode-map (kbd "C-c C-c") 'rust-playground-exec)
;(define-key rust-playground-mode-map (kbd "C-c b") 'rust-playground-switch-between-cargo-and-main)
;(define-key rust-playground-mode-map (kbd "C-c k") 'rust-playground-rm)

(define-key rust-playground-mode-map (kbd "M-RET") 'rust-playground-exec)