(require 'my-utils)

;; string=

;; vim +/"(defun clomacs-format-arg (a)" "$EMACSD/packages24/clomacs-20180211.421/clomacs.el"
;; 
;; (defun clomacs-format-arg (a)
;;   "Format Clojure representation of Elisp argument."
;;   (cond
;;    ((numberp a) (number-to-string a))
;;    ((stringp a) (clomacs-add-quotes a))
;;    ((booleanp a) (if a "true" "false"))
;;    ((clomacs-plist-p a) (clomacs-plist-to-map a))
;;    ((and (listp a) (equal (car a) 'quote))
;;     (concat "'" (clomacs-force-symbol-name
;;                  (cadr a))))
;;    ((symbolp a) (clomacs-force-symbol-name a))
;;    (t (replace-regexp-in-string
;;        "\\\\." "." (format "'%S" a)))))


(defun list-predicates ()
  "List all predicate functions."
  (interactive)

  ;; apropos-command
  ;; This only does interactive functions.

  ;; apropos-variable

  (new-buffer-from-string (list2str (apropos "-p$"))))


;; Predicates with no subject
(_ns state-predicates
     (defun my/has (package)
       (require package nil 'noerror)))

(defun at-shebang-p ()
  (looking-at auto-mode-interpreter-regexp))

(_ns predicates
     (defvar list-of-cursor-position-predicates
       '(at-shebang-p))

     (defun list-string-predicates ()
       "List predicates that accept a string.")

     (defun list-string-predicates-2 ()
       "List predicates that accept 2 strings."
       '(string=))

     (defun list-symbol-predicates ()
       "list predicates that accept a symbol.")

     (defun list-number-predicates ()
       "List predicates that accept a number."))

(_ns regex-predicates
     (defvar list-of-regex-predicates
       '(looking-at)))

(_ns apply-predicates
     (defun apply-string-predicate ()
       "This should convert the parameter to a string and then test it.")

     (defun apply-symbol-predicate ()
       "This should convert the parameter to a symbol and then test it.")

     (defun apply-number-predicate ()
       "This should convert the parameter to a number and then test it."))

(provide 'my-predicates)