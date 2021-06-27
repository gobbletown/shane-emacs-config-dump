(require 'poly-org)

(ignore-errors (remove-from-list 'auto-mode-alist '("\\.org\\'" . poly-org-mode)))

(defun poly-org-mode-around-advice (proc &rest args)
  (let ((res (apply proc args)))
    (if res
        (message "poly-org-mode enabled globally")
      (message "poly-org-mode disabled globally"))
    res))
(advice-add 'poly-org-mode :around #'poly-org-mode-around-advice)

(advice-add 'polymode-inhibit-during-initialization :around #'ignore-errors-around-advice)

(provide 'my-polymode)