;;; opensource-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "opensource-api" "opensource-api.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from opensource-api.el

(register-definition-prefixes "opensource-api" '("opensource--"))

;;;***

;;;### (autoloads nil "opensource-http" "opensource-http.el" (0 0
;;;;;;  0 0))
;;; Generated autoloads from opensource-http.el

(register-definition-prefixes "opensource-http" '("opensource--"))

;;;***

;;;### (autoloads nil "opensource-licenses" "opensource-licenses.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from opensource-licenses.el

(register-definition-prefixes "opensource-licenses" '("opensource-"))

;;;***

;;;### (autoloads nil "opensource-utils" "opensource-utils.el" (0
;;;;;;  0 0 0))
;;; Generated autoloads from opensource-utils.el

(register-definition-prefixes "opensource-utils" '("opensource-"))

;;;***

;;;### (autoloads nil "opensource-version" "opensource-version.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from opensource-version.el

(autoload 'opensource-version "opensource-version" "\
Get the opensource version as string.
If called interactively or if SHOW-VERSION is non-nil, show the
version in the echo area and the messages buffer.
The returned string includes both, the version from package.el
and the library version, if both a present and different.
If the version number could not be determined, signal an error,
if called interactively, or if SHOW-VERSION is non-nil, otherwise
just return nil.

\(fn &optional SHOW-VERSION)" t nil)

(register-definition-prefixes "opensource-version" '("opensource--library-version"))

;;;***

;;;### (autoloads nil nil ("opensource-pkg.el" "opensource.el") (0
;;;;;;  0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; opensource-autoloads.el ends here
