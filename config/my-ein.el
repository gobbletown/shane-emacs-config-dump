(defun my-close-notebooks ()
  (interactive)
  (mapcar
   (lambda (b)
     (kill-buffer b))
   (-filter (lambda (x) (string-match-p "^\*ein:notebooklist http://127.0.0.1:.*" x)) (mapcar 'str (buffer-list)))))

(defun my-open-ipynb (path)
  (interactive (list (read-string "path:")))
  (ein:stop t)
  (let ((dn (sh/dirname path))
        (bn (sh/basename path)))
    ;; This is asynchronous, which is a problem
    (ein:run (executable-find ein:jupyter-default-server-command) (my/pwd))
    ;; This runs too early
    (let ((bufname (car (-filter (lambda (x) (string-match-p "^\*ein:notebooklist http://127.0.0.1:.*" x)) (mapcar 'str (buffer-list))))))
      (if bufname
          (progn
            (with-current-buffer bufname
              (switch-to-buffer bufname)
              (search-forward (concat ": " bn "  "))
              (beginning-of-line-or-indentation)
              (widget-forward)
              (widget-button-press)))))))