(define-globalized-minor-mode global-hide-mode-line-mode hide-mode-line-mode hide-mode-line-mode)
(define-globalized-minor-mode global-indent-tools-minor-mode indent-tools-minor-mode indent-tools-minor-mode)

;; this is bad. enable it only in org-mode
;; (define-globalized-minor-mode global-dired-hide-details-mode dired-hide-details-mode dired-hide-details-mode)

;; this breaks syntax highlighting
;; (define-globalized-minor-mode global-highlight-indent-guides-mode highlight-indent-guides-mode highlight-indent-guides-mode)
;; (global-highlight-indent-guides-mode 1)

(global-indent-tools-minor-mode 1)

(provide 'my-globalized-minor-modes)