(provide 'my-macros)

;;;; macros
(defmacro after (mode &rest body)
  "`eval-after-load' MODE evaluate BODY."
  (declare (indent defun))
  `(eval-after-load ,mode
     '(progn ,@body)))


;; An easy way to write strings
;; (message (qs hi (str (+ 5 5)) "yo"))
;; (message (qs hi there "yo"))
;; (my:string "hi there" "hi")
(defmacro my:string (&rest body)
  "An easy DWIM way to write strings. Not perfect."
  `(concat (mapconcat
            (lambda
              (input)
              (if (char-or-string-p input)
                  (q input)
                (progn
                  (if (listp input)
                      (setq input (eval input)))
                  (setq input (str input)))))
            '(,@body)
            " ")))
(defalias 'qs 'my:string)



;; (set-major-mode (language-detection-string (buffer-contents)))