;;; evalator-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "evalator" "evalator.el" (0 0 0 0))
;;; Generated autoloads from evalator.el

(autoload 'evalator-insert-equiv-expr "evalator" "\
Insert the equivalent expression of the previous evalator session into the current buffer." t nil)

(autoload 'evalator-resume "evalator" "\
Resume last evalator session." t nil)

(autoload 'evalator "evalator" "\
Start an evalator session.

Function accepts an optional MODE keyword and a CONTEXT symbol.

If MODE is non-nil and a currently supported mode value then that mode
will be used for the session.

Below are currently supported values for MODE:

`:explicit'

If MODE is nil evalator will start in normal mode.

If CONTEXT is non-nil, then the result of calling CONTEXT's function
definition will be used as the session's evaluation context.

If CONTEXT is nil, then the current buffer's major mode will be
searched for in `evalator-config-mode-context-alist'.  If a match is
found, the context associated with that major mode is used in the
evalator session.  If no match is found, an elisp evaluation context
is used instead.

\(fn &optional MODE CONTEXT)" t nil)

(autoload 'evalator-explicit "evalator" "\
Helper function to start an evalator-session in explicit mode.

In explicit mode the data generated will always be represented as a
single candidate.  This is the only mode that allows an equivalent
expression of the session to be generated through
`evalator-insert-equiv-expr'.

\(fn &optional CONTEXT)" t nil)

(register-definition-prefixes "evalator" '("evalator-"))

;;;***

;;;### (autoloads nil "evalator-config" "evalator-config.el" (0 0
;;;;;;  0 0))
;;; Generated autoloads from evalator-config.el

(register-definition-prefixes "evalator-config" '("evalator-config-"))

;;;***

;;;### (autoloads nil "evalator-context" "evalator-context.el" (0
;;;;;;  0 0 0))
;;; Generated autoloads from evalator-context.el

(register-definition-prefixes "evalator-context" '("evalator-context"))

;;;***

;;;### (autoloads nil "evalator-elisp" "evalator-elisp.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from evalator-elisp.el

(autoload 'evalator-elisp-context "evalator-elisp" nil nil nil)

(register-definition-prefixes "evalator-elisp" '("evalator-elisp-"))

;;;***

;;;### (autoloads nil "evalator-history" "evalator-history.el" (0
;;;;;;  0 0 0))
;;; Generated autoloads from evalator-history.el

(register-definition-prefixes "evalator-history" '("evalator-history"))

;;;***

;;;### (autoloads nil "evalator-key-map" "evalator-key-map.el" (0
;;;;;;  0 0 0))
;;; Generated autoloads from evalator-key-map.el

(register-definition-prefixes "evalator-key-map" '("evalator-key-map"))

;;;***

;;;### (autoloads nil "evalator-state" "evalator-state.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from evalator-state.el

(register-definition-prefixes "evalator-state" '("evalator-state"))

;;;***

;;;### (autoloads nil "evalator-utils" "evalator-utils.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from evalator-utils.el

(register-definition-prefixes "evalator-utils" '("evalator-utils-"))

;;;***

;;;### (autoloads nil nil ("evalator-faces.el" "evalator-pkg.el")
;;;;;;  (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; evalator-autoloads.el ends here
