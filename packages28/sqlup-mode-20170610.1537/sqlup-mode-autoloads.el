;;; sqlup-mode-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "sqlup-mode" "sqlup-mode.el" (0 0 0 0))
;;; Generated autoloads from sqlup-mode.el

(autoload 'sqlup-mode "sqlup-mode" "\
Capitalizes SQL keywords for you.

If called interactively, enable Sqlup mode if ARG is positive,
and disable it if ARG is zero or negative.  If called from Lisp,
also enable the mode if ARG is omitted or nil, and toggle it if
ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(autoload 'sqlup-capitalize-keywords-in-region "sqlup-mode" "\
Call this function on a region to capitalize the SQL keywords therein.

\(fn START-POS END-POS)" t nil)

(register-definition-prefixes "sqlup-mode" '("sqlup-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; sqlup-mode-autoloads.el ends here
