;;; mysql-to-org-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "mysql-to-org" "mysql-to-org.el" (0 0 0 0))
;;; Generated autoloads from mysql-to-org.el

(autoload 'mysql-to-org-eval "mysql-to-org" "\
Evaluate the query inside the active region or current line." t nil)

(autoload 'mysql-to-org-eval-string-at-point "mysql-to-org" "\
Evaluate the string at point." t nil)

(autoload 'mysql-to-org-scratch "mysql-to-org" "\
Open mysql to org scratch buffer." t nil)

(autoload 'mysql-to-org-mode "mysql-to-org" "\
Minor mode to output the results of mysql queries to org tables.

If called interactively, enable Mysql-To-Org mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp, also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(register-definition-prefixes "mysql-to-org" '("mysql-to-org-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; mysql-to-org-autoloads.el ends here
