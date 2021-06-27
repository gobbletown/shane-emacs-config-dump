;;; double-saber-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "double-saber" "double-saber.el" (0 0 0 0))
;;; Generated autoloads from double-saber.el

(autoload 'double-saber-mode "double-saber" "\
Delete/narrow text with regular expressions or multiple keywords.

If called interactively, enable Double-Saber mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp,  also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(register-definition-prefixes "double-saber" '("double-saber-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; double-saber-autoloads.el ends here
