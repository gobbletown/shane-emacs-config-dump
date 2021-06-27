;;; buffer-manage-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "buffer-manage" "buffer-manage.el" (0 0 0 0))
;;; Generated autoloads from buffer-manage.el

(register-definition-prefixes "buffer-manage" '("buffer-"))

;;;***

;;;### (autoloads nil "config-manage" "config-manage.el" (0 0 0 0))
;;; Generated autoloads from config-manage.el

(register-definition-prefixes "config-manage" '("config-manage"))

;;;***

;;;### (autoloads nil "config-manage-base" "config-manage-base.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from config-manage-base.el

(register-definition-prefixes "config-manage-base" '("config-"))

;;;***

;;;### (autoloads nil "config-manage-declare" "config-manage-declare.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from config-manage-declare.el

(autoload 'config-manage-declare-functions "config-manage-declare" "\
Declare functions in list FNS for the purposes of silencing the compiler.

This is used in the compiler module libraries to silence the compiler in
`eval-when-compile' scopes.

\(fn &rest FNS)" nil t)

(autoload 'config-manage-declare-methods "config-manage-declare" "\
Declare methods in list FNS for the purposes of silencing the compiler.

This is used in the compiler module libraries to silence the compiler in
`eval-when-compile' scopes.

\(fn &rest FNS)" nil t)

(autoload 'config-manage-declare-variables "config-manage-declare" "\
Declare variables in list VARS for the purposes of silencing the compiler.

This is used in the compiler module libraries to silence the compiler in
`eval-when-compile' scopes.

\(fn &rest VARS)" nil t)

(register-definition-prefixes "config-manage-declare" '("config-manage-"))

;;;***

;;;### (autoloads nil "config-manage-mode" "config-manage-mode.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from config-manage-mode.el

(register-definition-prefixes "config-manage-mode" '("config-manage-"))

;;;***

;;;### (autoloads nil "config-manage-prop" "config-manage-prop.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from config-manage-prop.el

(register-definition-prefixes "config-manage-prop" '("config-"))

;;;***

;;;### (autoloads nil nil ("buffer-manage-pkg.el") (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; buffer-manage-autoloads.el ends here
