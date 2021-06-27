;;; therapy-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "therapy" "therapy.el" (0 0 0 0))
;;; Generated autoloads from therapy.el

(autoload 'therapy-interpreter-changed "therapy" "\
Call this when the Python interpreter is changed.

This will run the correct hooks for the new version." t nil)

(autoload 'therapy-set-python-interpreter "therapy" "\
Set the `python-shell-interpreter' variable to CMD and run the hooks.

\(fn CMD)" t nil)

(register-definition-prefixes "therapy" '("therapy-python"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; therapy-autoloads.el ends here
