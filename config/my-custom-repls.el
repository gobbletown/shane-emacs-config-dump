(defun call-command-or-function (funcsym &rest body)
  (if (and (function-p funcsym) (commandp funcsym))
      (if body (eval `(funcall-interactively funcsym ,@body))
        (call-interactively funcsym))
    (eval `(call-function funcsym ,@body))))

(defun degloved-command-to-sexp (s)
  (let ((lisp-code (concat "'(" (sn (concat "cmd-cip \\=" s)) ")")))
    (eval-string lisp-code)))

(defun degloved-get-command ()
  (interactive)
  (let* ((funname (str (car (find-function-read))))
         (funsym (str2sym funname))
         (arglist (help-function-arglist funsym))
         (cmd-arglist (cons funsym arglist))
         (cmd-arglist-string (str cmd-arglist))
         (full-command
          (if arglist
              (progn
                ;; (momentary-string-display (concat (str arglist) "\n\n") 0)
                (read-string-hist (concat cmd-arglist-string ": ") (concat funname " ") nil))
            funname)))
    (if (called-interactively-p 'interative)
        (new-buffer-from-string full-command)
      full-command)))

(defun degloved-run (command)
  (interactive (list (degloved-get-command)))
  (let* ((lisp-code (degloved-command-to-sexp command))
         (funcsym (car lisp-code))
         (body (cdr lisp-code)))
    (eval `(call-command-or-function funcsym ,@body))))

(define-key global-map (kbd "M-X") 'degloved-run)
(define-key global-map (kbd "H-D") 'degloved-run)

(provide 'my-custom-repls)