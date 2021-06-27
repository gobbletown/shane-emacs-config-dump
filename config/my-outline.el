(define-key outline-mode-map (kbd "C-c C-x C-p") 'backward-button)
(define-key outline-mode-map (kbd "C-c C-x C-n") 'forward-button)

(define-key outline-mode-map (kbd "<backtab>") 'backward-button)
(define-key outline-mode-map (kbd "TAB") 'forward-button)

(define-key outline-mode-map (kbd "M-e") 'outline-next-visible-heading)

(provide 'my-outline)