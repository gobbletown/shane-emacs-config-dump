(require 'lfe-mode)

;; This breaks function keys and other functionality
(define-key lfe-mode-map (kbd "M-[") nil)

(provide 'my-lfe)