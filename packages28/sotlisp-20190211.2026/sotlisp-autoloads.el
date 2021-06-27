;;; sotlisp-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "sotlisp" "sotlisp.el" (0 0 0 0))
;;; Generated autoloads from sotlisp.el

(defvar speed-of-thought-mode nil "\
Non-nil if Speed-Of-Thought mode is enabled.
See the `speed-of-thought-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `speed-of-thought-mode'.")

(custom-autoload 'speed-of-thought-mode "sotlisp" nil)

(autoload 'speed-of-thought-mode "sotlisp" "\
Toggle Speed-Of-Thought mode on or off.

If called interactively, enable Speed-Of-Thought mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp, also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\\{speed-of-thought-mode-map}

\(fn &optional ARG)" t nil)

(autoload 'speed-of-thought-hook-in "sotlisp" "\
Add functions ON and OFF to `speed-of-thought-mode' hooks.
If `speed-of-thought-mode' is already on, call ON.

\(fn ON OFF)" nil nil)

(register-definition-prefixes "sotlisp" '("sotlisp-" "speed-of-thought-turn-o"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; sotlisp-autoloads.el ends here
