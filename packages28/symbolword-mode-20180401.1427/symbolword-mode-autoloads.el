;;; symbolword-mode-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "symbolword-mode" "symbolword-mode.el" (0 0
;;;;;;  0 0))
;;; Generated autoloads from symbolword-mode.el

(autoload 'symbolword-mode "symbolword-mode" "\
Change word breaks

If called interactively, enable Symbolword mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp,  also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(register-definition-prefixes "symbolword-mode" '("symbolword-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; symbolword-mode-autoloads.el ends here
