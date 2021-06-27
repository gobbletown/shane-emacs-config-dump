;;; digit-groups-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "digit-groups" "digit-groups.el" (0 0 0 0))
;;; Generated autoloads from digit-groups.el

(put 'digit-groups-global-mode 'globalized-minor-mode t)

(defvar digit-groups-global-mode nil "\
Non-nil if Digit-Groups-Global mode is enabled.
See the `digit-groups-global-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `digit-groups-global-mode'.")

(custom-autoload 'digit-groups-global-mode "digit-groups" nil)

(autoload 'digit-groups-global-mode "digit-groups" "\
Toggle Digit-Groups mode in all buffers.
With prefix ARG, enable Digit-Groups-Global mode if ARG is positive;
otherwise, disable it.  If called from Lisp, enable the mode if
ARG is omitted or nil.

Digit-Groups mode is enabled in all buffers where
`(lambda nil (digit-groups-mode 1))' would do it.
See `digit-groups-mode' for more information on Digit-Groups mode.

\(fn &optional ARG)" t nil)

(autoload 'digit-groups-mode "digit-groups" "\
Minor mode that highlights selected place-value positions in numbers.
See the `digit-groups` customization group for more information.

If called interactively, enable Digit-Groups mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp, also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(register-definition-prefixes "digit-groups" '("digit-groups-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; digit-groups-autoloads.el ends here
