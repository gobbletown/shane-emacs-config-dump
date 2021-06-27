;;; closure-lint-mode-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "closure-lint-mode" "closure-lint-mode.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from closure-lint-mode.el

(autoload 'closure-lint-mode "closure-lint-mode" "\
Closure Lint mode.
     With no argument, this command toggles the mode.
     Non-null prefix argument turns on the mode.
     Null prefix argument turns off the mode.

If called interactively, enable Closure-Lint mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp, also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(register-definition-prefixes "closure-lint-mode" '("closure-lint-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; closure-lint-mode-autoloads.el ends here
