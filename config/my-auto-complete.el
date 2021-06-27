(require 'auto-complete)

;; TODO Make it so these functions do not
;; conflict when existing autocomplete windows
;; appear before I type the binding
(defun my/complete-words-in-buffer ()
  (interactive)
  (let ((auto-complete-mode t) (company-mode -1))
    ;; (ekm "C-g")
    (ac-complete-words-in-buffer)))

(defun my/complete-words-in-all-buffer ()
  (interactive)
  (let ((auto-complete-mode t) (company-mode -1))
    ;; (ekm "C-g")
    (ac-complete-words-in-all-buffer)))

(defun my/complete-words-in-same-mode-buffers ()
  (interactive)
  (let ((auto-complete-mode t) (company-mode -1))
    ;; (ekm "C-g")
    (ac-complete-words-in-same-mode-buffers)))


(define-key global-map (kbd "M-l TAB b") 'my/complete-words-in-buffer)

(provide 'my-auto-complete)