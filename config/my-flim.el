;; I have no idea what this plugin does but it's breaking wanderlust
;; So I have to fix it

;; (defmacro eval-when-compile (&rest body)
;;   "Like `progn', but evaluates the body at compile time if you're compiling.
;; Thus, the result of the body appears to the compiler as a quoted
;; constant.  In interpreted code, this is entirely equivalent to
;; `progn', except that the value of the expression may be (but is
;; not necessarily) computed at load time if eager macro expansion
;; is enabled."
;;   (declare (debug (&rest def-form)) (indent 0))
;;   (list 'quote (eval (cons 'progn body) lexical-binding)))

(defmacro eval-when-compile (&rest body)
  `(progn ,@body))

(require 'mel-q-ccl)

(provide 'my-flim)
