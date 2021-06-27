;;; speedbar-git-respect-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "speedbar-git-respect" "speedbar-git-respect.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from speedbar-git-respect.el

(defvar speedbar-git-respect-mode nil "\
Non-nil if Speedbar-Git-Respect mode is enabled.
See the `speedbar-git-respect-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `speedbar-git-respect-mode'.")

(custom-autoload 'speedbar-git-respect-mode "speedbar-git-respect" nil)

(autoload 'speedbar-git-respect-mode "speedbar-git-respect" "\
Toggle speedbar-git-respect mode

If called interactively, enable Speedbar-Git-Respect mode if ARG
is positive, and disable it if ARG is zero or negative.  If
called from Lisp, also enable the mode if ARG is omitted or nil,
and toggle it if ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(register-definition-prefixes "speedbar-git-respect" '("speedbar-git-respect--"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; speedbar-git-respect-autoloads.el ends here
