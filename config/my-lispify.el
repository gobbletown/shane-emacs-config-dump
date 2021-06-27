(require 'my-hy)

(defun lispify-unlispify ()
  (interactive)
  (cond ((major-mode-p 'python-mode) (py2hy))
        ((major-mode-p 'hy-mode) (hy2py))))

(provide 'my-lispify)