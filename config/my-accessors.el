(defun get-interpreter-under-cursor ()
  (str (if (looking-at auto-mode-interpreter-regexp) (match-string 2))))

(provide 'my-accessors)