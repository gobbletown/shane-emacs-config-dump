(require 'ace-window)


(defun column-at (point)
  "Return column number at POINT."
  (save-excursion
    (goto-char point)
    (current-column)))


(defun pos-at-line-col (l c)
  (save-excursion
    (goto-char (point-min))
    (forward-line l)
    (move-to-column c)
    (point)))

(defun pos-at-start-of-line ()
  (save-excursion
    (call-interactively 'move-beginning-of-line)
    (point)))



;; (define-key my-mode-map (kbd "M-j M-w") nil)
;; (define-key my-mode-map (kbd "M-m w s") #'eshell-sph)

(provide 'my-navigation)