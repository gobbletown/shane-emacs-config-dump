(defun my-serialise-demo ()
  (read (prin1-to-string (make-hash-table :test 'equal))))

(defalias 'unserialize 'read)
(defalias 'serialize 'prin1-to-string)

(provide 'my-serialise)