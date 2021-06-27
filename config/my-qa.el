;; https://emacs.stackexchange.com/questions/4167/how-can-i-read-a-single-character-from-the-minibuffer

;; (read-char-picky "(C)hoose (A)n (O)ption: " "CAO")

(defun read-char-picky (prompt chars &optional inherit-input-method seconds)
  "Read characters like in `read-char-exclusive', but if input is
not one of CHARS, return nil.  CHARS may be a list of characters,
single-character strings, or a string of characters."
  (let ((chars (mapcar (lambda (x)
                         (if (characterp x) x (string-to-char x)))
                       (append chars nil)))
        (char  (read-char-exclusive prompt inherit-input-method seconds)))
    (when (memq char chars)
      char)))

;; (defalias 'qa 'read-char-picky)

(defmacro qa (&rest body)
  ""
  (let ((m
         (list2str (loop for i from 0 to (- (length body) 1) by 2
                         collect
                         (pp-oneline
                          (list
                           (try
                            (sym2str
                             (nth i body))
                            (str
                             (nth i body)))
                           (nth (+ i 1) body))))))
        (code
         (loop for i from 0 to (- (length body) 1) by 2
               collect
               (let ((fstone (nth i body))
                     (sndone (nth (+ i 1) body)))
                 (list
                  (string-to-char
                   (string-reverse
                    (sym2str
                     fstone)))
                  sndone)))))
    (append `(case (read-key ,m))
            code)))

;; (qa -a (message "apple")
;;     -b (message "banana"))

; https://stackoverflow.com/a/25117392

;; (defalias 'sw 'cl-case)

(defmacro sw (expr &rest body)
  "cond for strings"
  (let ((b
         (mapcar
          (lambda (e)
            (list
             (list 'string-equal expr (car e))
             (cadr e)))
          body)))
    `(
      cond
      ,@b)))

;; (sw "hello"
;;     ("hello" "hi"))


(provide 'my-qa)