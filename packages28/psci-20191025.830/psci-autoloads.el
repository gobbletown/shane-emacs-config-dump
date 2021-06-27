;;; psci-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "psci" "psci.el" (0 0 0 0))
;;; Generated autoloads from psci.el

(autoload 'psci "psci" "\
Run an inferior instance of \"psci\" inside Emacs, in PROJECT-ROOT-FOLDER.
If not supplied, the root folder will be guessed using
`projectile-project-root' (if available), otherwise it will
default to the current buffer's directory.

\(fn PROJECT-ROOT-FOLDER)" t nil)

(autoload 'psci-mode "psci" "\
Major mode for `run-psci'.

\\<psci-mode-map>

\(fn)" t nil)

(autoload 'psci/load-current-file! "psci" "\
Load the current file in the psci repl." t nil)

(autoload 'psci/load-module! "psci" "\
Load the module inside the repl session." t nil)

(autoload 'psci/reset! "psci" "\
Reset the current status of the repl session." t nil)

(autoload 'psci/quit! "psci" "\
Quit the psci session." t nil)

(autoload 'inferior-psci-mode "psci" "\
psci minor mode to define default bindings.

If called interactively, enable Inferior-Psci mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp, also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(register-definition-prefixes "psci" '("inferior-psci-mode-map" "psci"))

;;;***

;;;### (autoloads nil "psci-dev" "psci-dev.el" (0 0 0 0))
;;; Generated autoloads from psci-dev.el

(register-definition-prefixes "psci-dev" '("psci/--debug-setup!"))

;;;***

;;;### (autoloads nil nil ("psci-pkg.el") (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; psci-autoloads.el ends here
