;;; cerbere-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "cerbere" "cerbere.el" (0 0 0 0))
;;; Generated autoloads from cerbere.el

(autoload 'cerbere-current-test "cerbere" "\
Launch backend on current test, maybe being VERBOSE.

\(fn &optional VERBOSE)" t nil)

(autoload 'cerbere-current-file "cerbere" "\
Launch backend on current file, maybe being VERBOSE..

\(fn &optional VERBOSE)" t nil)

(autoload 'cerbere-current-project "cerbere" "\
Launch backend on current project, maybe being VERBOSE..

\(fn &optional VERBOSE)" t nil)

(autoload 'cerbere-last-test "cerbere" "\
Launch backend on the last test, maybe being VERBOSE..

\(fn &optional VERBOSE)" t nil)

(autoload 'cerbere-test-dwim "cerbere" "\
Try to launch the test at point or the last executed test.

This will check if the cursor is currently in a test function
definition.  If so it will run that test.  If there are no test
definition, it will run the last executed test.

The test will be run verbosely if VERBOSE is not nil.

\(fn &optional VERBOSE)" t nil)

(autoload 'cerbere-version "cerbere" "\
Dislay the Cerbere's version." t nil)

(defconst cerbere-mode-line-lighter " Cerbere" "\
The default lighter for `cerbere-mode'.")

(put 'cerbere-global-mode 'globalized-minor-mode t)

(defvar cerbere-global-mode nil "\
Non-nil if Cerbere-Global mode is enabled.
See the `cerbere-global-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `cerbere-global-mode'.")

(custom-autoload 'cerbere-global-mode "cerbere" nil)

(autoload 'cerbere-global-mode "cerbere" "\
Toggle Cerbere mode in all buffers.
With prefix ARG, enable Cerbere-Global mode if ARG is positive;
otherwise, disable it.  If called from Lisp, enable the mode if
ARG is omitted or nil.

Cerbere mode is enabled in all buffers where
`cerbere-on' would do it.
See `cerbere-mode' for more information on Cerbere mode.

\(fn &optional ARG)" t nil)

(register-definition-prefixes "cerbere" '("cerbere-"))

;;;***

;;;### (autoloads nil "cerbere-common" "cerbere-common.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from cerbere-common.el

(register-definition-prefixes "cerbere-common" '("cerbere-"))

;;;***

;;;### (autoloads nil "cerbere-elisp-ert-runner" "cerbere-elisp-ert-runner.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from cerbere-elisp-ert-runner.el

(register-definition-prefixes "cerbere-elisp-ert-runner" '("cerbere-elisp-ert-runner-"))

;;;***

;;;### (autoloads nil "cerbere-php-phpunit" "cerbere-php-phpunit.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from cerbere-php-phpunit.el

(register-definition-prefixes "cerbere-php-phpunit" '("cerbere-" "phpunit-arg"))

;;;***

;;;### (autoloads nil "cerbere-python-tox" "cerbere-python-tox.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from cerbere-python-tox.el

(autoload 'cerbere-python-tox "cerbere-python-tox" "\
Tox cerbere backend.

\(fn COMMAND &optional TEST)" nil nil)

(register-definition-prefixes "cerbere-python-tox" '("cerbere--python-tox-" "with-python-tox"))

;;;***

;;;### (autoloads nil "cerbere-ruby-minitest" "cerbere-ruby-minitest.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from cerbere-ruby-minitest.el

(register-definition-prefixes "cerbere-ruby-minitest" '("cerbere-ruby-minitest-"))

;;;***

;;;### (autoloads nil "cerbere-rust-libtest" "cerbere-rust-libtest.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from cerbere-rust-libtest.el

(register-definition-prefixes "cerbere-rust-libtest" '("cerbere-rust-libtest-"))

;;;***

;;;### (autoloads nil nil ("cerbere-pkg.el") (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; cerbere-autoloads.el ends here
