(require 'man)

;; This fixes an issue with the glossary
(defun Man--window-state-change (window))

(define-key Man-mode-map (kbd "K") 'man-thing-at-point)

;; # Why is this non-deterministic?
(defun mag (ag-query)
  "man + ag (search man pages)"
  (interactive (list (read-string-hist "mag: ")))
  (etv (snc (cmd "mag" ag-query))))

(provide 'my-man)