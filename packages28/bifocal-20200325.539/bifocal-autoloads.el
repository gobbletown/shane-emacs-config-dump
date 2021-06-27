;;; bifocal-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "bifocal" "bifocal.el" (0 0 0 0))
;;; Generated autoloads from bifocal.el

(autoload 'bifocal-mode "bifocal" "\
Toggle bifocal-mode on or off.

If called interactively, enable Bifocal mode if ARG is positive,
and disable it if ARG is zero or negative.  If called from Lisp,
also enable the mode if ARG is omitted or nil, and toggle it if
ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

  bifocal-mode splits the buffer into a head and a tail when
paging up and down in a comint-mode derived buffer (such as
shell-mode, inferior-python-mode, etc).

  Use `bifocal-global-mode' to enable `bifocal-mode' in all
buffers that support it.

  Provides the following bindings:

\\{bifocal-mode-map}

\(fn &optional ARG)" t nil)

(put 'bifocal-global-mode 'globalized-minor-mode t)

(defvar bifocal-global-mode nil "\
Non-nil if Bifocal-Global mode is enabled.
See the `bifocal-global-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `bifocal-global-mode'.")

(custom-autoload 'bifocal-global-mode "bifocal" nil)

(autoload 'bifocal-global-mode "bifocal" "\
Toggle Bifocal mode in all buffers.
With prefix ARG, enable Bifocal-Global mode if ARG is positive;
otherwise, disable it.  If called from Lisp, enable the mode if
ARG is omitted or nil.

Bifocal mode is enabled in all buffers where
`bifocal--turn-on' would do it.
See `bifocal-mode' for more information on Bifocal mode.

\(fn &optional ARG)" t nil)

(register-definition-prefixes "bifocal" '("bifocal-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; bifocal-autoloads.el ends here
