(defun uniqify-buffer (b)
  "Give the buffer a unique name"
  (with-current-buffer b
    (ignore-errors (let* ((hash (short-hash (str (time-to-seconds))))
                          (new-buffer-name (pcre-replace-string "(\\*?)$" (concat "-" hash "\\1") (current-buffer-name))))
                     (rename-buffer new-buffer-name)))
    b))

(provide 'my-uniqify)