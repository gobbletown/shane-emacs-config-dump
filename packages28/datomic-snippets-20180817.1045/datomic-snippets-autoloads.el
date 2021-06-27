;;; datomic-snippets-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "datomic-snippets" "datomic-snippets.el" (0
;;;;;;  0 0 0))
;;; Generated autoloads from datomic-snippets.el

(autoload 'datomic-snippets-show-docs-at-point "datomic-snippets" nil t nil)

(autoload 'datomic-snippets-initialize "datomic-snippets" nil nil nil)

(eval-after-load "yasnippet" '(datomic-snippets-initialize))

(register-definition-prefixes "datomic-snippets" '("-aget" "datomic-snippets/"))

;;;***

;;;### (autoloads nil nil ("datomic-snippets-pkg.el") (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; datomic-snippets-autoloads.el ends here
