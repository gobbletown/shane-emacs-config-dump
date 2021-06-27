;;; flimenu-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "flimenu" "flimenu.el" (0 0 0 0))
;;; Generated autoloads from flimenu.el

(autoload 'flimenu-mode "flimenu" "\
Toggle the automatic flattening of imenu indexes.

If called interactively, enable Flimenu mode if ARG is positive,
and disable it if ARG is zero or negative.  If called from Lisp,
also enable the mode if ARG is omitted or nil, and toggle it if
ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(put 'flimenu-global-mode 'globalized-minor-mode t)

(defvar flimenu-global-mode nil "\
Non-nil if Flimenu-Global mode is enabled.
See the `flimenu-global-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `flimenu-global-mode'.")

(custom-autoload 'flimenu-global-mode "flimenu" nil)

(autoload 'flimenu-global-mode "flimenu" "\
Toggle Flimenu mode in all buffers.
With prefix ARG, enable Flimenu-Global mode if ARG is positive;
otherwise, disable it.  If called from Lisp, enable the mode if
ARG is omitted or nil.

Flimenu mode is enabled in all buffers where
`flimenu-mode-turn-on' would do it.
See `flimenu-mode' for more information on Flimenu mode.

\(fn &optional ARG)" t nil)

(register-definition-prefixes "flimenu" '("flimenu-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; flimenu-autoloads.el ends here
