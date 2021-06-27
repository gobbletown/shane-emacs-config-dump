(defmacro save-kill-ring-excursion (&rest body)
  "save and restore the kill ring around executing body"
  `(let ((kr kill-ring)
         (ret ,@body))
    (setq kill-ring kr)
    ret))

(provide 'my-kill)