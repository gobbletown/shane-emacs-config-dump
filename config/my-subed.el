(require 'subed)

(defun show-clean-subs ()
  (interactive)
  (if (major-mode-p 'subed-mode)
      (nbfs (sn "clean-subs" (buffer-string)))))

(define-key subed-mode-map (kbd "M-[") nil)
(define-key subed-mode-map (kbd "M-]") nil)

(provide 'my-subed)