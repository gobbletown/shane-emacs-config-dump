;;; comint-hyperlink-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "comint-hyperlink" "comint-hyperlink.el" (0
;;;;;;  0 0 0))
;;; Generated autoloads from comint-hyperlink.el

(autoload 'comint-hyperlink-process-output "comint-hyperlink" "\
Convert SGR control sequences of comint into clickable text properties.

This is a good function to put in
`comint-output-filter-functions'.

\(fn &optional _)" t nil)

(register-definition-prefixes "comint-hyperlink" '("comint-hyperlink"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; comint-hyperlink-autoloads.el ends here
