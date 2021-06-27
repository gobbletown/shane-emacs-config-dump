(require 'dash)

(defun str2chrs (s)
  (mapcar 'string-to-char (-butlast (tail (split-string s "")))))

(defalias 'chrs2str 'concat)

;; (concat (str2chrs "shane"))


(defun increment-char-at-point ()
  "Increment number or character at point."
  (interactive)
  (condition-case nil
      (save-excursion
        (let ((chr  (1+ (char-after))))
          (unless (characterp chr) (error "Cannot increment char by one"))
          (delete-char 1)
          (insert chr)))
    (error (error "No character at point"))))

;; This works the same as incrementing a number
(defun increment-char (c)
  (if (not (characterp c))
      (error "not a character"))
  (1+ c))


(defun increment-string (s)
  (let* ((xs (str2chrs s))
         (lastel (car (last xs 1))))
    (chrs2str (append (-butlast xs) (list (1+ lastel))))))


;;This make "M-x to-underscore" available
(defun to-underscore ()
  (interactive)
  (progn
    (replace-regexp "\\([A-Z]\\)" "_\\1" nil (region-beginning) (region-end))
    (downcase-region (region-beginning) (region-end))))

;; (defmacro my/nil (body)
;;   "Do not return anything."
;;   ;; body
;;   `(progn (,@body) nil))


;; def sh filter
(defmacro defshf (sn &rest body)
  `(defun ,sn (,@body input)
     (sh-notty (concat ,(sym2str sn) " " (mapconcat 'q (list ,@body) " ")) input)
     ;; quote-args does not evaluate its arguments. so you get symbols instead of values
     ;; (sh-notty (concat ,(sym2str sn) " " (quote-args ,@body)) input)
     ))


(defun delete-2nd-of-two-consecutive-lines-if-match (pat1 pat2)
  (sh-notty (concat "sed-delete-2nd-of-two-consecutive-lines-if-match" " " (q pat1) " " (q pat2))))


;; (sed-delete-2nd-of-two-consecutive-lines-if-match "e" "p" "hello\nsup")
; (eval (expand-macro '(defshf sed-delete-2nd-of-two-consecutive-lines-if-match pat1 pat2)))
(defshf sed-delete-2nd-of-two-consecutive-lines-if-match pat1 pat2)
;; (sed-delete-two-consecutive-lines-if-match "e" "p" "hello\nsup")
; (eval (expand-macro '(defshf sed-delete-two-consecutive-lines-if-match pat1 pat2)))
(defshf sed-delete-two-consecutive-lines-if-match pat1 pat2)


;; This works
;; (defun sed-delete-2nd-of-two-consecutive-lines-if-match (pat1 pat2 input)
;;   (sh-notty
;;    (concat
;;     "sed-delete-2nd-of-two-consecutive-lines-if-match"
;;     " "
;;     (mapconcat 'q `(,pat1 ,pat2) " ")
;;     ;; `(quote-args ,pat1 ,pat2)
;;     )
;;    input))


(defun sed-delete-two-consecutive-lines-if-match (pat1 pat2)
  (sh-notty (concat "sed-delete-two-consecutive-lines-if-match" " " (q pat1) " " (q pat2))))


;; /home/shane/scripts/sed-delete-2nd-of-two-consecutive-lines-if-match
;; /home/shane/scripts/sed-delete-two-consecutive-lines-if-match

;; (esed "\\(.\\)" "\\1 " prefix)
(defalias 'esed 'replace-regexp-in-string)


(defalias 'stl 'string-to-list)
(defalias 's2l 'string-to-list)


(provide 'my-strings)