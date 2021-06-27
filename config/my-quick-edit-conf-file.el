(defun quick-conf-touch ()
  (interactive)
  (let ((cmd
         (fz (list
              "json-set-value"
              "json-get-value"
              "json-edit-value"
              "json-iedit-value"
              "json-filter-value"
              "yaml-set-value"
              "yaml-get-value"
              "yaml-edit-value"
              "yaml-iedit-value"
              "yaml-filter-value"
              )
             nil
             nil
             "quick conf command:")))
    (sps cmd)))
(define-key my-mode-map (kbd "H-;") 'quick-conf-touch)

(provide 'my-quick-edit-conf-file)