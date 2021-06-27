(require 'cc-playground)

(define-key cc-playground-mode-map (kbd "M-RET") nil)
(define-key cc-playground-mode-map (kbd "C-c C-c") 'cc-playground-exec-test)


(provide 'cc-playground)