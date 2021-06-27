;;; djangonaut-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "djangonaut" "djangonaut.el" (0 0 0 0))
;;; Generated autoloads from djangonaut.el

(autoload 'djangonaut-mode "djangonaut" "\
Minor mode to interact with Django project.

If called interactively, enable Djangonaut mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp,  also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\\{djangonaut-mode-map}

\(fn &optional ARG)" t nil)

(put 'global-djangonaut-mode 'globalized-minor-mode t)

(defvar global-djangonaut-mode nil "\
Non-nil if Global Djangonaut mode is enabled.
See the `global-djangonaut-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `global-djangonaut-mode'.")

(custom-autoload 'global-djangonaut-mode "djangonaut" nil)

(autoload 'global-djangonaut-mode "djangonaut" "\
Toggle Djangonaut mode in all buffers.
With prefix ARG, enable Global Djangonaut mode if ARG is positive;
otherwise, disable it.  If called from Lisp, enable the mode if
ARG is omitted or nil.

Djangonaut mode is enabled in all buffers where
`(lambda nil (ignore-errors (when (djangonaut-get-project-root) (let ((directory (pythonic-python-readable-file-name default-directory))) (dolist (path (djangonaut-get-pythonpath)) (when (or (f-same? path directory) (f-ancestor-of? path directory)) (djangonaut-mode 1)))))))' would do it.
See `djangonaut-mode' for more information on Djangonaut mode.

\(fn &optional ARG)" t nil)

(register-definition-prefixes "djangonaut" '("djangonaut-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; djangonaut-autoloads.el ends here
