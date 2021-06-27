(provide 'my-regex)

;; This is horrible
(defun my-select-regex-at-point (pat &optional literal)
  (interactive (list (read-string-hist "re: ")))

  (deselect)

  (let ((ogpat pat))
    (if literal
        (setq p (regexp-quote pat)))

    (while (and (not (looking-at-p pat))
                (not (bolp)))
      (backward-char 1))
    (while (and (looking-at-p pat)
                (not (bolp)))
      (backward-char 1))
    (if (not (looking-at-p pat))
        (forward-char 1))

    (set-mark (point))

    (if literal
        (forward-char (length ogpat))
      (let ((boundedpat (setq pat (concat "\\`" pat "\\'"))))
        (while (and (not (string-match pat (buffer-substring (mark) (point))))
                    (not (eolp)))
          (forward-char 1))
        (while (and (string-match pat (buffer-substring (mark) (point)))
                    (not (eolp)))
          (forward-char 1))
        (if (not (string-match pat (buffer-substring (mark) (point))))
            (backward-char 1))))))

(defun regex-at-point-p (re)
  (let ((found)
        (sel))
    (save-excursion-and-region-reliably
     (my-select-regex-at-point re)
     (setq sel (selection))
     (let ((m (mark)))
       (goto-char m)
       (setq found (looking-at-p re))))
    (if found
        sel)))
(defalias 'regex-at-point 'regex-at-point-p)

(defmacro re-sensitive (&rest body)
  `(let ((case-fold-search nil))
     ,@body))
(defmacro re-insensitive (&rest body)
  `(let ((case-fold-search t))
     ,@body))

(defun string-match-literal (literal-pattern string &optional start)
  (if (stringp string)
      (re-sensitive
       (string-match (regexp-quote literal-pattern) string start))))
(defalias 'str-match-p 'string-match-literal)

(defun string-match-literal-insensitive (pattern string &optional start)
  (if (stringp string)
      (re-insensitive
       (string-match (regexp-quote pattern) string start))))
(defalias 'istring-match-literal 'string-match-literal-insensitive)
(defalias 'istr-match-p 'string-match-literal-insensitive)

(defalias 're-match-p 'string-match)

(defun string-match-insensitive (pattern string &optional start)
  (if (stringp string)
      (re-insensitive
       (string-match pattern string start))))
(defalias 'ire-match-p 'string-match-insensitive)

(defun string-in-region-p (s)
  (if (use-region-p)
      (let ((bs (selection)))
        (if (stringp bs)
            (re-sensitive
             (string-match-literal s bs))))))
(defalias 'str-in-region-p 'string-in-region-p)

(defun string-in-buffer-p (s)
  (let ((bs (buffer-string)))
    (if (stringp bs)
        (re-sensitive
         (string-match-literal s bs)))))
(defalias 'str-in-buffer-p 'string-in-buffer-p)

(defun istring-in-region-p (s)
  (istring-match-literal s (sor (selection) "")))
(defalias 'istr-in-region-p 'istring-in-region-p)

(defun istring-in-buffer-p (s)
  (istring-match-literal s (buffer-string)))
(defalias 'istr-in-buffer-p 'istring-in-buffer-p)

(defun istr-in-region-or-path-p (s)
  (let ((p (get-path-nocreate))
        (rs (sor (selection) "")))
    (if (and (stringp s)
             (stringp rs))
        (or (istring-match-literal s rs)
            (istring-match-literal s p)))))

(defun istr-in-buffer-or-path-p (s)
  (let ((p (get-path-nocreate))
        (bs (buffer-string)))
    (if (and (stringp s)
             (stringp bs))
        (or (istring-match-literal s bs)
            (istring-match-literal s p)))))

(defun re-in-buffer-p (s)
  (if (stringp s)
      (re-sensitive
       (string-match s (buffer-string)))))

(defun ire-in-region-p (s)
  (if (use-region-p)
      (let ((bs (selection)))
        (if (stringp bs)
            (string-match-insensitive s bs)))))

(defun ire-in-buffer-p (s)
  (let ((bs (buffer-string)))
    (if (stringp bs)
        (string-match-insensitive s bs))))

(defun re-in-region-or-path-p (s)
  (let ((p (get-path-nocreate))
        (rs (sor (selection) "")))
    (re-sensitive
     (or (and (stringp s) (stringp rs) (string-match s rs))
         (and (stringp s) (stringp p) (string-match s p))))))

(defun re-in-buffer-or-path-p (s)
  (let ((p (get-path-nocreate))
        (bs (buffer-string)))
    (re-sensitive
     (or (and (stringp s) (stringp bs) (string-match s bs))
         (and (stringp s) (stringp p) (string-match s p))))))

(defun ire-in-region-or-path-p (s)
  (let ((p (get-path-nocreate))
        (rs (sor (selection) "")))
    (re-insensitive
     (or (and (stringp s) (stringp rs) (string-match s rs))
         (and (stringp s) (stringp p) (string-match s p))))))

(defun ire-in-buffer-or-path-p (s)
  (let ((p (get-path-nocreate))
        (bs (buffer-string)))
    (re-insensitive
     (or (and (stringp s) (stringp bs) (string-match s bs))
         (and (stringp s) (stringp p) (string-match s p))))))

;; (re-insensitive (string-match "\\bamazon\\b" (buffer-string)))
(defun ieat-in-region-or-path-p (s)
  (ire-in-region-or-path-p (concat "\\b" s "\\b")))
(defun eat-in-region-or-path-p (s)
  (re-in-region-or-path-p (concat "\\b" s "\\b")))

(defun ieat-in-buffer-or-path-p (s)
  (ire-in-buffer-or-path-p (concat "\\b" s "\\b")))
(defun eat-in-buffer-or-path-p (s)
  (re-in-buffer-or-path-p (concat "\\b" s "\\b")))



(defun unregexify (re)
  "Escapes a regex"
  ;; (escape "^[]$.+" re)
  (regexp-quote re))

(defun regex-match-string-1 (pat s)
  "Get first match from substring"
  (save-match-data
    (and (string-match pat s)
         (match-string-no-properties 0 s))))
(defalias 'regex-match-string 'regex-match-string-1)

(defun re-seq (regexp string)
  "Get a list of all regexp matches in a string"
  (save-match-data
    (let ((pos 0)
          matches)
      (while (string-match regexp string pos)
        (push (match-string-no-properties 0 string) matches)
        (setq pos (match-end 0)))
      matches)))
(defalias 'regex-matches 're-seq)

                                        ; ; Sample URL
;; https://www.gnu.org/software/emacs/manual/html_node/elisp/Simple-Match-Data.html
;; (setq urlreg "\\(?:http://\\)?www\\(?:[./#\+-]\\w*\\)+")
                                        ; ; Sample invocation
;; (re-seq urlreg (buffer-string))