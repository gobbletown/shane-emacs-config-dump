;;; nodemcu-mode-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "nodemcu-mode" "nodemcu-mode.el" (0 0 0 0))
;;; Generated autoloads from nodemcu-mode.el

(autoload 'nodemcu-mode "nodemcu-mode" "\
Toggle NodeMCU mode.

If called interactively, enable Nodemcu mode if ARG is positive,
and disable it if ARG is zero or negative.  If called from Lisp,
also enable the mode if ARG is omitted or nil, and toggle it if
ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

This mode provides interaction with NodeMCU devices.

\(fn &optional ARG)" t nil)

(register-definition-prefixes "nodemcu-mode" '("nodemcu-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; nodemcu-mode-autoloads.el ends here
