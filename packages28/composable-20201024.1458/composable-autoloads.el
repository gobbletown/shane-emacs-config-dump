;;; composable-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "composable" "composable.el" (0 0 0 0))
;;; Generated autoloads from composable.el

(defvar composable-mode nil "\
Non-nil if Composable mode is enabled.
See the `composable-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `composable-mode'.")

(custom-autoload 'composable-mode "composable" nil)

(autoload 'composable-mode "composable" "\
Toggle Composable mode.

If called interactively, enable Composable mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp, also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(defvar composable-mark-mode nil "\
Non-nil if Composable-Mark mode is enabled.
See the `composable-mark-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `composable-mark-mode'.")

(custom-autoload 'composable-mark-mode "composable" nil)

(autoload 'composable-mark-mode "composable" "\
Toggle composable mark mode.

If called interactively, enable Composable-Mark mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp, also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(register-definition-prefixes "composable" '("composable-"))

;;;***

;;;### (autoloads nil "composable-mark" "composable-mark.el" (0 0
;;;;;;  0 0))
;;; Generated autoloads from composable-mark.el

(register-definition-prefixes "composable-mark" '("composable-"))

;;;***

;;;### (autoloads nil nil ("composable-pkg.el") (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; composable-autoloads.el ends here
