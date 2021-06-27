;;; dictcc-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "dictcc" "dictcc.el" (0 0 0 0))
;;; Generated autoloads from dictcc.el

(autoload 'dictcc "dictcc" "\
Search dict.cc for QUERY and insert a result at point.

Call it with a prefix argument to replace the source language and
with double prefix argument to replace both.

\(fn QUERY &optional SOURCE-LANG DESTINATION-LANG)" t nil)

(autoload 'dictcc-at-point "dictcc" "\
Run a dict.cc search for the word at point or in an active region." t nil)

(register-definition-prefixes "dictcc" '("dictcc-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; dictcc-autoloads.el ends here
