;; https://kitchingroup.cheme.cmu.edu/blog/2018/05/14/f-strings-in-emacs-lisp/

;; (defmacro f-string (fmt)
;;   "Like `s-format' but with format fields in it.
;; FMT is a string to be expanded against the current lexical
;; environment. It is like what is used in `s-lex-format', but has
;; an expanded syntax to allow format-strings. For example:
;; ${user-full-name 20s} will be expanded to the current value of
;; the variable `user-full-name' in a field 20 characters wide.
;;   (let ((f (sqrt 5)))  (f-string \"${f 1.2f}\"))
;;   will render as: 2.24
;; This function is inspired by the f-strings in Python 3.6, which I
;; enjoy using a lot.
;; "
;;   (let* ((matches (s-match-strings-all"${\\(?3:\\(?1:[^} ]+\\) *\\(?2:[^}]*\\)\\)}" fmt))
;;          (agetter (cl-loop for (m0 m1 m2 m3) in matches
;;                            collect `(cons ,m3  (format (format "%%%s" (if (string= ,m2 "")
;;                                                                           (if s-lex-value-as-lisp "S" "s")
;;                                                                         ,m2))
;;                                                        (symbol-value (intern ,m1)))))))
;; 
;;     `(s-format ,fmt 'aget (list ,@agetter))))
;; 
;; 
;; (let ((username "John Kitchin")
;;       (somevar (sqrt 5)))
;;   (f-string "${username -30s}${somevar 1.2f}"))

(provide 'my-kitchin)