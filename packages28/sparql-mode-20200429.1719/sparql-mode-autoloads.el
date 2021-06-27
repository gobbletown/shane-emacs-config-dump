;;; sparql-mode-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "company-sparql" "company-sparql.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from company-sparql.el

(autoload 'company-sparql "company-sparql" "\
`company-mode' completion back-end for `sparql-mode'. Right
now it only completes prefixes, `company-keywords' takes care of
keywords.

\(fn COMMAND &optional ARG &rest IGNORED)" t nil)

(register-definition-prefixes "company-sparql" '("company-sparql-"))

;;;***

;;;### (autoloads nil "ob-sparql" "ob-sparql.el" (0 0 0 0))
;;; Generated autoloads from ob-sparql.el

(register-definition-prefixes "ob-sparql" '("org-babel-"))

;;;***

;;;### (autoloads nil "sparql-mode" "sparql-mode.el" (0 0 0 0))
;;; Generated autoloads from sparql-mode.el

(autoload 'sparql-mode "sparql-mode" "\
Major mode for SPARQL-queries.
\\{sparql-mode-map}

\(fn)" t nil)

(register-definition-prefixes "sparql-mode" '("ac-source-sparql-mode" "sparql-" "when-emacs<25.1"))

;;;***

;;;### (autoloads nil nil ("sparql-mode-pkg.el") (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; sparql-mode-autoloads.el ends here
