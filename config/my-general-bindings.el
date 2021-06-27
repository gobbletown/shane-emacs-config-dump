(require 'counsel)

;; This is too slow
(global-set-key (kbd "M-x") 'helm-M-x)


(defun my-counsel-M-x ()
  (interactive)
  (counsel-M-x ""))

;; This is faster
(global-set-key (kbd "M-x") 'my-counsel-M-x)


(global-set-key (kbd "M-/") 'hippie-expand)


(require 'expand-region)
;;(global-set-key (kbd "C-=") 'er/expand-region)
(global-set-key (kbd "M-r") 'er/expand-region)
