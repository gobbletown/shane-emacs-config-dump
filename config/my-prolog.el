(require 'ob-prolog)

;; Also see my-perl.el

;; TODO Start by making functions for constructing prolog databases 

;; =atomic formula= wrote(X,Y)
;; wrote(roger, sam). -> wrote
(defun pro-get-relation-names ()
  (snc "sed -n 's/\\b\\([a-z]\\+\\)([a-z]\\+, \\?[a-z]\\+).*/\\1/p'" (buffer-string)))

;; Permute the atomic formulae with wildcards for querying


;; =base clause=, which represents a simple fact
(defun pro-get-base-clause-names ()
  (snc "sed -n 's/\\b\\([a-z]\\+\\)([a-z]\\+).*/\\1/p'" (buffer-string)))

(define-key prolog-mode-map (kbd "M-o b") 'prolog-consult-buffer)
(define-key prolog-mode-map (kbd "M-o f") 'prolog-consult-file)
(define-key prolog-mode-map (kbd "M-o r") 'prolog-consult-region)
(define-key prolog-mode-map (kbd "M-o M-d") 'prolog-debug-on)
(define-key prolog-mode-map (kbd "M-o M-n") 'prolog-insert-predicate-template)

(provide 'my-prolog)