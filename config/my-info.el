(require 'swiper)

(defun Info-search-toc ()
  (interactive)
  (call-interactively 'Info-toc)
  (call-interactively 'my-swipe))

(defun my-Info-copy-current-node-name ()
  (interactive)
  (if (>= (prefix-numeric-value current-prefix-arg) 4)
      (call-interactively 'Info-copy-current-node-name)
    (progn
      (call-interactively 'Info-copy-current-node-name)
      (my/copy (concat "[[info:" (xc) "]]")))))

;; (define-key Info-mode-map (kbd "w") 'Info-copy-current-node-name)
(define-key Info-mode-map (kbd "w") 'my-Info-copy-current-node-name)

(provide 'my-info)