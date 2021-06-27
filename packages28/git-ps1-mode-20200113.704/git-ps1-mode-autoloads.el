;;; git-ps1-mode-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "git-ps1-mode" "git-ps1-mode.el" (0 0 0 0))
;;; Generated autoloads from git-ps1-mode.el

(defvar git-ps1-mode nil "\
Non-nil if Git-Ps1 mode is enabled.
See the `git-ps1-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `git-ps1-mode'.")

(custom-autoload 'git-ps1-mode "git-ps1-mode" nil)

(autoload 'git-ps1-mode "git-ps1-mode" "\
Minor-mode to print __git_ps1.

If called interactively, enable Git-Ps1 mode if ARG is positive,
and disable it if ARG is zero or negative.  If called from Lisp,
also enable the mode if ARG is omitted or nil, and toggle it if
ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(autoload 'git-ps1-mode-get-current "git-ps1-mode" "\
Return current __git_ps1 execution output as string.

Give FORMAT if you want to specify other than \"%s\".
If optional argument DIR is given, run __git_ps1 in that directory.
This function returns nil if the output is not available for some reasons.

\(fn &optional FORMAT DIR)" nil nil)

(register-definition-prefixes "git-ps1-mode" '("git-ps1-mode-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; git-ps1-mode-autoloads.el ends here
