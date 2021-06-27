;;; rdf-prefix-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "rdf-prefix" "rdf-prefix.el" (0 0 0 0))
;;; Generated autoloads from rdf-prefix.el

(autoload 'rdf-prefix-insert "rdf-prefix" "\
Insert URI associated with PREFIX.
Prefixes are defined by the variable `rdf-prefix-alist'.

\(fn PREFIX)" t nil)

(register-definition-prefixes "rdf-prefix" '("rdf-prefix-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; rdf-prefix-autoloads.el ends here
