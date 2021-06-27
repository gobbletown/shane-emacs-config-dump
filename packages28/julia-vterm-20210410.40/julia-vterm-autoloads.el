;;; julia-vterm-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "julia-vterm" "julia-vterm.el" (0 0 0 0))
;;; Generated autoloads from julia-vterm.el

(autoload 'julia-vterm-mode "julia-vterm" "\
A minor mode for a Julia script buffer that interacts with an inferior Julia REPL.

If called interactively, enable Julia-Vterm mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp,  also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(register-definition-prefixes "julia-vterm" '("julia-vterm-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; julia-vterm-autoloads.el ends here
