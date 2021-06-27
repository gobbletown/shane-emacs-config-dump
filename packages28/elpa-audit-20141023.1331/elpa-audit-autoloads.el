;;; elpa-audit-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "elpa-audit" "elpa-audit.el" (0 0 0 0))
;;; Generated autoloads from elpa-audit.el

(autoload 'elpa-audit-dump-package-list-to-buffer "elpa-audit" "\
Write a list of packages in ARCHIVE-NAME into a new buffer.

\(fn ARCHIVE-NAME)" t nil)

(autoload 'elpa-audit-ediff-archives "elpa-audit" "\
Start an ediff session comparing the package lists for ARCHIVE1 and ARCHIVE2.

\(fn ARCHIVE1 ARCHIVE2)" t nil)

(autoload 'elpa-audit-show-package-versions "elpa-audit" "\
Write info about available versions of PACKAGE-NAME into a new buffer.

\(fn PACKAGE-NAME)" t nil)

(register-definition-prefixes "elpa-audit" '("elpa-audit/"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; elpa-audit-autoloads.el ends here
