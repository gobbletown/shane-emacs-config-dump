(defun my-show-imports ()
  (interactive)
  ;; (etv (sn "architecture-summary"))
  (let* ((modules (sn "list-modules"))
         (sel (if (string-or modules)
                  (fz modules))))
    (if sel
        (my-counsel-ag sel))))

(define-key global-map (kbd "H-R") 'my-show-imports)

(provide 'my-code-architecture)