;; Mode is not enough information to determine

(defun antlr-list-all-grammars ()
  (snc "cd $MYGIT/antlr/grammars-v4/; find . -name '*.g4' | xargs -l basename | sed 's/\..*//'"))

(defun antlr-grammar-path-from-name (name)
  (let* ((cmd (concat "cd $MYGIT/antlr/grammars-v4/; { find . -iname '" name ".g4' -o -ipath '.*/" name "/*.g4'; } | sed 's/.\\///' | head -n 1"))
         (result (snc cmd)))
    (if (sor result)
        (umn (concat "$MYGIT/antlr/grammars-v4/"
                     result)))))

;; $MYGIT/antlr/grammars-v4/

(defun get-buffer-python-version ()
  (if (string-equal (detect-language) "python")
      (snc (cmd "vermin" (tf "python" (selection-or-buffer-string))))))

(defun antlr-detect-language ()
  ;; Detecting the language is not good enough
  ;; Sometimes I also need to know the language version, such as python3
  (let ((lang (detect-language)))
    (cond ((string-equal lang "python")
           (concat "python" (get-buffer-python-version)))
          ((string-equal lang "c++")
           "cpp14")
          (t lang))))

(defset file-parser-2-tuples
  '(((major-mode-p 'terraform-mode)
     . "json2hcl -reverse")
    ((major-mode-p 'json-mode)
     . "zh -j")
    ((major-mode-p 'org-mode)
     . "org-parser")
    ((and (major-mode-p 'clojure-mode)
          (string-equal "edn" (f-ext (get-path))))
     . "ej | jq .")
    ((major-mode-p 'flycheck-error-list-mode)
     . (call-interactively 'tablist-export-csv))
    ((major-mode-p 'org-brain-visualize-mode)
     . (call-interactively 'org-brain-to-dot-associates))
    ((or (and (major-mode-p 'c++-mode)
              (string-equal "cpp" (f-ext (get-path))))
         (and (major-mode-p 'python-mode)
              (string-equal "py" (f-ext (get-path))))
         (and (major-mode-p 'java-mode)
              (string-equal "java" (f-ext (get-path))))
         (and (major-mode-p 'haskell-mode)
              (string-equal "hs" (f-ext (get-path)))))
     . (snc (cmd "semantic-parse" (get-path))))
    ((sor (antlr-grammar-path-from-name (f-ext (get-path))))
     . (snc (cmd "universal-antlr-parse" (antlr-grammar-path-from-name (f-ext (get-path))) (tf "code" (selection-or-buffer-string)))))
    ((sor (antlr-grammar-path-from-name (antlr-detect-language)))
     . (snc (cmd "universal-antlr-parse" (antlr-grammar-path-from-name (antlr-detect-language)) (tf "code" (selection-or-buffer-string)))))))

(defun assoc-collect-true (al)
  (-filter 'identity
           (-distinct
            (cl-loop
             for
             kv
             in
             al
             collect
             (if (eval (car kv)) (cdr kv)))
            ;; (flatten-once
            ;;  (cl-loop
            ;;   for
            ;;   kv
            ;;   in
            ;;   al
            ;;   collect
            ;;   (if (eval (car kv)) (cdr kv))))
            )))

(defun assoc-get-first-true (al)
  (car (assoc-collect-true al)))


;; (defun get-parse-for-file (path)
;;   (interactive (list (current-path)))

;;   (assoc 'terraform-mode file-parser-2-tuples))

(defun parse-current-buffer ()
  (interactive)

  (let ((parser
         (assoc-get-first-true file-parser-2-tuples)))
    (if parser
        (let ((parse
               (if (stringp parser)
                   (snc (concat parser " 2>&1") (selection-or-buffer-string))
                 (eval parser))))
          (if (ignore-errors
                (and
                 (stringp parse)
                 (sor parse)))
              (with-current-buffer
                  (nbfs
                   parse)
                (detect-language-set-mode))
            (message "No parse created")))))

  ;; (let* (;; (p (current-path))
  ;;        (cm major-mode)
  ;;        (parser (assoc cm file-parser-2-tuples)))
  ;;   (if parser
  ;;       (let ((parse (snc (concat (cdr parser) " 2>&1") (buffer-string))))
  ;;         (if (sor parse)
  ;;             (with-current-buffer
  ;;                 (nbfs
  ;;                  parse)
  ;;               (detect-language-set-mode))
  ;;           (message "No parse created")))))
  )

(define-key my-mode-map (kbd "H-&") 'parse-current-buffer)

(provide 'my-file-parsers)