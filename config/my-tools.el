(require 'my-utils)
(require 'my-nix)


(defun write(fp s)
  "Write string to a file"
  (eval `(bp cat > ,fp s)))

;; (bp cat > /home/shane/notes2018/programs/eci/test.el "5")
;; (write "/home/shane/notes2018/programs/eci/test.el" "5dsjfkl")

;; Cacheit should really be able to save and restore variables with their types
;; A protobuf for emacs lol
;; Perhaps I can use yaml saving and loading, along with a hash map?
;; The macro version should memoise, not based on the value of the expression
(defmacro cacheit (exp &optional b_update)
  "Caches something. Saves an expression."
  (let* ((name (str exp))
         (result nil)
         (b_update
          (or sh-update
              b_update
              (>= (prefix-numeric-value current-prefix-arg) 4)))
         ;; (fp (concat "/home/shane/notes/programs/eci/" (sha1 (str exp))))
         (fp (concat "/home/shane/notes/programs/eci/" (slugify (str exp)))))
    (if (and (file-exists-p fp)
             (not b_update))
        (progn
          (message "loading from cache")
          (setq result (cat fp))

          ;; (message result)
          )
      (progn
        (setq result (str (eval exp)))
        ;; (write fp (tvipe (str result)))
        (write fp (str result))))
    ;; (show (concat "ci result: " (str result)))
    ;; (show (concat "ci exp: " name))
    ;; (show (type result))
    ;; (show (read result))
    ;; (show (type exp))
    ;; (show exp)
    ;; result
    ;; exp
    ;; (show result)
    ;; `(read ,(str result))
    ;; (tvipe result)
    (if (or (string-match-p "^[0-9.]+$" result) ; number
            (string-match-p "^(.*)$" result)
            (string-match-p "^nil$" result)
            (string-match-p "^t$" result) ; sexp
            )
        (setq result (read result)))
    result
    ;; exp
    ;; `(read ,result)
    )
  ;; `(str ,@body)
  ;; `(ns "cacheit")
  )
(defalias 'ci 'cacheit)
;; (ci (+ 5 5))


(provide 'my-tools)
