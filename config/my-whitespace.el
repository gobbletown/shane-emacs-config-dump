(require 'whitespace)

(defun better-whitespace ()
  (interactive)
  (global-whitespace-mode 0)
  ;; I don't care about long lines
  
  (let ((ws-small '(face lines-tail))
        (ws-big '(face tabs spaces trailing lines-tail space-before-tab
                       newline indentation empty space-after-tab space-mark
                       tab-mark newline-mark)))
    (if (eq whitespace-style ws-small)
        (setq whitespace-style ws-big)
      (setq whitespace-style ws-small))) 
  (global-whitespace-mode 1))

(define-key global-map (kbd "C-x t W") 'better-whitespace)

(provide 'my-whitespace)