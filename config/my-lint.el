(defun lint (lintercmd &optional path)
  (interactive (list (read-string-hist "lintercmd: ") (buffer-file-path)))
  (setq path (or path (buffer-file-path)))
  (new-buffer-from-string (sn (cc lintercmd " " (q path) " 2>&1"))))

(provide 'my-lint)