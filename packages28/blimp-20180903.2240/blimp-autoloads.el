;;; blimp-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "blimp" "blimp.el" (0 0 0 0))
;;; Generated autoloads from blimp.el

(autoload 'blimp-mode "blimp" "\
Toggle Blimp mode.

If called interactively, enable Blimp mode if ARG is positive,
and disable it if ARG is zero or negative.  If called from Lisp,
also enable the mode if ARG is omitted or nil, and toggle it if
ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(autoload 'blimp-toggle-prefix "blimp" "\
Toggle the command prefix.
If ARG is positive, use + as command prefix.
If ARG is negative, use - as command prefix.
Otherwise toggle between command prefixes.

\(fn &optional ARG)" t nil)

(autoload 'blimp-clear-command-stack "blimp" "\
Remove all unexecuted commands." t nil)

(autoload 'blimp-execute-command-stack "blimp" "\
Execute all unexecuted commands.
Also removes all unexecuted commands after executing them." t nil)

(autoload 'blimp-interface "blimp" "\
Prompt user for arguments of COMMAND if any and add to command stack.
If COMMAND is nil, prompt user for which command should be executed.

\(fn &optional COMMAND)" t nil)

(autoload 'blimp-interface-execute "blimp" "\
Prompt user for arguments of COMMAND if any and add to command stack.
If COMMAND is nil, prompt user for which command should be executed.
COMMAND will be executed instantly.

\(fn &optional COMMAND)" t nil)

(register-definition-prefixes "blimp" '("blimp-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; blimp-autoloads.el ends here
