(require 'calc)

(defun calc-clear()
  (interactive
  (calc-pop (calc-stack-size))))
(defalias 'calc-cls 'calc-clear)

(define-key calc-mode-map (kbd "<home>") 'calc-clear)

(provide 'my-calc)