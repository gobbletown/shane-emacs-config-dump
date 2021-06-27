(require 'treemacs)

(define-key treemacs-mode-map (kbd "M-p") nil)
(define-key treemacs-mode-map (kbd "M-n") nil)
(define-key treemacs-mode-map (kbd "M-E") 'treemacs-previous-line)
(define-key treemacs-mode-map (kbd "M-e") 'treemacs-next-line)

;; This doesn't really fix the problem. Need a better solution
(defun treemacs-leftclick-or-RET-action ()
  (interactive)
  (try (treemacs-leftclick-action)
       (treemacs-RET-action)))

(defun treemacs-RET-or-leftclick-action ()
  (interactive)
  (try (treemacs-RET-action)
       (treemacs-leftclick-action)))

(define-key treemacs-mode-map (kbd "<down-mouse-1>") 'treemacs-leftclick-or-RET-action)
(define-key treemacs-mode-map (kbd "RET") 'treemacs-RET-or-leftclick-action)


(provide 'my-treemacs)