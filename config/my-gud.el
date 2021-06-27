;; This prefix must never be accessible
(define-prefix-command 'my-prefix-tick)
(global-set-key (kbd "✓") 'my-prefix-tick)

(setq gud-key-prefix (kbd "✓"))

(provide 'my-gud)