(require 'selected)

(setq expand-region-fast-keys-enabled nil)





(define-key selected-keymap (kbd "C-S") 'isearch-forward-region)
(define-key selected-keymap (kbd "/") 'isearch-forward-region)

(provide 'my-expand-region)