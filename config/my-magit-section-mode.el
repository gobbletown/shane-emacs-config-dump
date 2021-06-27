(require 'magit-section)
;; (load "/home/shane/var/smulliga/source/git/config/emacs/packages27/magit-section-20200226.1251/magit-section.el")

(define-key magit-section-mode-map (kbd "M-a") 'magit-section-up)
;; (define-key magit-section-mode-map (kbd "M-E") 'magit-section-backward-sibling)
(define-key magit-section-mode-map (kbd "M-E") 'magit-section-backward)
;; (define-key magit-section-mode-map (kbd "M-e") 'magit-section-forward-sibling)
(define-key magit-section-mode-map (kbd "M-e") 'magit-section-forward)

(provide 'my-magit-section)