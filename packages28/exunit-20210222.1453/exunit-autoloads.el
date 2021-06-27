;;; exunit-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "exunit" "exunit.el" (0 0 0 0))
;;; Generated autoloads from exunit.el

(autoload 'exunit-mode "exunit" "\
Minor mode for ExUnit test runner

If called interactively, enable Exunit mode if ARG is positive,
and disable it if ARG is zero or negative.  If called from Lisp,
also enable the mode if ARG is omitted or nil, and toggle it if
ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(autoload 'exunit-rerun "exunit" "\
Re-run the last test invocation." t nil)

(autoload 'exunit-verify-all "exunit" "\
Run all the tests in the current project." t nil)

(autoload 'exunit-verify-all-in-umbrella "exunit" "\
Run all the tests in the current umbrella project." t nil)

(autoload 'exunit-verify-single "exunit" "\
Run the test under the point." t nil)

(autoload 'exunit-debug "exunit" "\
Run the test under the point in IEx shell.

This allows the usage of IEx.pry method for debugging." t nil)

(autoload 'exunit-verify "exunit" "\
Run all the tests associated with the current buffer." t nil)

(autoload 'exunit-toggle-file-and-test "exunit" "\
Toggle between a file and its tests in the current window." t nil)

(autoload 'exunit-toggle-file-and-test-other-window "exunit" "\
Toggle between a file and its tests in other window." t nil)

(register-definition-prefixes "exunit" '("exunit-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; exunit-autoloads.el ends here
