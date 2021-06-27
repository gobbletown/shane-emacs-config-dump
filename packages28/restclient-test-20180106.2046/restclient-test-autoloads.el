;;; restclient-test-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "restclient-test" "restclient-test.el" (0 0
;;;;;;  0 0))
;;; Generated autoloads from restclient-test.el

(autoload 'restclient-test-current "restclient-test" "\
Test query at point.
When the test contains an \"Expect\" entry, return `pass' if the
test passed and `fail' if the test failed.  Else return nil.'" t nil)

(autoload 'restclient-test-buffer "restclient-test" "\
Test every query in the current buffer." t nil)

(autoload 'restclient-test-mode "restclient-test" "\
Minor mode with key-bindings for restclient-test commands.
With a prefix argument ARG, enable the mode if ARG is positive,
and disable it otherwise.  If called from Lisp, enable the mode
if ARG is omitted or nil.

\(fn &optional ARG)" t nil)

(register-definition-prefixes "restclient-test" '("restclient-test-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; restclient-test-autoloads.el ends here
