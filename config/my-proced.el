(require 'proced)

(defun proced-pretty ()
  (interactive)
  (etv (pps (mapcar
             (lambda (e)
               (let* ((pid (car e))
                      (props (cdr e))
                      (argstr (cdr (assoc 'args props))))
                 (setcdr (assq 'args props) (q argstr))
                 e))
             (proced-process-attributes)))))


(defun proced-copy-process ()
  (interactive)

  )

(defun proced-get-pwd (&optional pid)
  (interactive (list (proced-pid-at-point)))
  (message (xc (snc (concat (cmd "pwdx" pid) " | s field 2 -d ': '")))))

(provide 'my-proced)