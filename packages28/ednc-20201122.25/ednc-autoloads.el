;;; ednc-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "ednc" "ednc.el" (0 0 0 0))
;;; Generated autoloads from ednc.el

(defvar ednc-mode nil "\
Non-nil if Ednc mode is enabled.
See the `ednc-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `ednc-mode'.")

(custom-autoload 'ednc-mode "ednc" nil)

(autoload 'ednc-mode "ednc" "\
Act as a Desktop Notifications server and track notifications.

If called interactively, enable Ednc mode if ARG is positive, and
disable it if ARG is zero or negative.  If called from Lisp,
also enable the mode if ARG is omitted or nil, and toggle it if
ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(register-definition-prefixes "ednc" '("ednc-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; ednc-autoloads.el ends here
