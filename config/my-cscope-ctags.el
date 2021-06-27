(defun show-uml ()
  (interactive)
  ;; (new-buffer-from-string (cl-sn "uml-gen" :dir (e/pwd) :chomp t))
  (cl-sn "nw uml-gen" :dir (e/pwd) :chomp t))

(defun cq-lookup (path lookupcmd)
  (setq path (or path (e/pwd)))
  (setq lookupcmd (or lookupcmd "cq-functions"))
  (let ((cmd (concat "quiet " lookupcmd)))
    (cond
     ((f-directory-p path) (sh-notty cmd nil (replace-regexp-in-string "/$" "" (e/chomp path))))
     ((f-file-p path) (sh-notty (concat cmd " -R " (q path)) nil (cl-sn "u dn" :stdin (e/chomp path) :chomp t))))))

(defun cq-classes (&optional path)
  "list classes"
  (cq-lookup path "cq-classes"))

(defun cq-symbols (&optional path)
  "list symbols"
  (cq-lookup path "cq-symbols"))

(defun cq-functions (&optional path)
  "list symbols"
  (cq-lookup path "cq-functions"))

;; If C-u then find the symbols for the current file only
(defun fz-cq-classes (&optional arg)
  (interactive "P")
  (goto-cq-sel (fz (b-tabulate (cq-classes (if (equalp arg '(4)) (current-file-path)))) nil nil "cq classes: " (default-search-string))))

(defun fz-cq-symbols (&optional arg)
  (interactive "P")
  (goto-cq-sel (fz (b-tabulate (cq-symbols (if (equalp arg '(4)) (current-file-path)))) nil nil "cq symbols: " (default-search-string))))

(defun fz-cq-functions (&optional arg)
  (interactive "P")
  (goto-cq-sel (fz (b-tabulate (cq-functions (if (equalp arg '(4)) (current-file-path)))) nil nil "cq functions: " (default-search-string))))

(defun goto-cq-sel (sel)
  (interactive)
  (if (not (empty-string-p sel))
      (let* ((target (e/chomp (bp s field 2 sel)))
             (path (e/chomp (bp cut -d : -f 1 target)))
             (line (e/chomp (bp cut -d : -f 2 target)))
             (toplevel (e/chomp (b vc get-top-level))))
        (with-current-buffer
            (find-file (concat toplevel "/" path))
          (goto-line (string-to-int line))))))

(provide 'my-cscope-ctags)