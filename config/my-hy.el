(require 'hy-mode)

(define-key hy-mode-map (kbd "C-x C-e") 'hy-shell-eval-last-sexp)


(defun py2hy ()
  (interactive)
  (with-current-buffer (new-buffer-from-string (sh-notty "py2hy" (region-or-buffer-string)) "new-hy-buffer")
    (hy-mode)))

(defun hy2py ()
  (interactive)
  (with-current-buffer (new-buffer-from-string (sh-notty "hy2py" (region-or-buffer-string)) "new-py-buffer")
    (python-mode)))


(defun my/hy-mode-hook ()
  (interactive)
  (add-to-list 'company-backends 'company-hy))


(add-hook 'hy-mode-hook 'my/hy-mode-hook t)


;; vim +/"defun company-hy" "$EMACSD/packages27/hy-mode-20190524.2030/hy-mode.el"
(defun company-hy (command &optional arg &rest ignored)
  (interactive (list 'interactive))
  (cl-case command
    (prefix (company-grab-symbol))
    (candidates (hy--company-candidates arg))
    (annotation (hy--company-annotate arg))
    (meta (-> arg hy--eldoc-get-docs hy--str-or-empty))))


(provide 'my-hy)