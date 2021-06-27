;;; draft-mode-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "draft-mode" "draft-mode.el" (0 0 0 0))
;;; Generated autoloads from draft-mode.el

(autoload 'draft-mode "draft-mode" "\
Toggle Draft mode.
Interactively with no argument, this command toggles the mode.
A positive prefix argument enables the mode, any other prefix
argument disables it.  From Lisp, argument omitted or nil enables
the mode, `toggle' toggles the state.

If called interactively, enable Draft mode if ARG is positive,
and disable it if ARG is zero or negative.  If called from Lisp,
also enable the mode if ARG is omitted or nil, and toggle it if
ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

When Draft mode is enabled, all input is inserted at the end of 
the buffer and disables most editing commands.

\(fn &optional ARG)" t nil)

(register-definition-prefixes "draft-mode" '("draft-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; draft-mode-autoloads.el ends here
