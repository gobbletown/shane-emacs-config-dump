;;; flex-compile-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "flex-compile" "flex-compile.el" (0 0 0 0))
;;; Generated autoloads from flex-compile.el

(register-definition-prefixes "flex-compile" '("flex-compile-"))

;;;***

;;;### (autoloads nil "flex-compile-base" "flex-compile-base.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from flex-compile-base.el

(register-definition-prefixes "flex-compile-base" '("flex-compiler" "no-op-flex-compiler"))

;;;***

;;;### (autoloads nil "flex-compile-choice-program" "flex-compile-choice-program.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from flex-compile-choice-program.el

(register-definition-prefixes "flex-compile-choice-program" '("choice-program-flex-compiler"))

;;;***

;;;### (autoloads nil "flex-compile-clojure" "flex-compile-clojure.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from flex-compile-clojure.el

(register-definition-prefixes "flex-compile-clojure" '("clojure-flex-compiler"))

;;;***

;;;### (autoloads nil "flex-compile-comint" "flex-compile-comint.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from flex-compile-comint.el

(register-definition-prefixes "flex-compile-comint" '("comint-flex-compiler"))

;;;***

;;;### (autoloads nil "flex-compile-command" "flex-compile-command.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from flex-compile-command.el

(register-definition-prefixes "flex-compile-command" '("command-flex-compiler" "config-sexp-prop"))

;;;***

;;;### (autoloads nil "flex-compile-config" "flex-compile-config.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from flex-compile-config.el

(register-definition-prefixes "flex-compile-config" '("conf-f"))

;;;***

;;;### (autoloads nil "flex-compile-ess" "flex-compile-ess.el" (0
;;;;;;  0 0 0))
;;; Generated autoloads from flex-compile-ess.el

(register-definition-prefixes "flex-compile-ess" '("ess-flex-compiler"))

;;;***

;;;### (autoloads nil "flex-compile-make" "flex-compile-make.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from flex-compile-make.el

(register-definition-prefixes "flex-compile-make" '("make-flex-compiler"))

;;;***

;;;### (autoloads nil "flex-compile-manage" "flex-compile-manage.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from flex-compile-manage.el

(register-definition-prefixes "flex-compile-manage" '("flex-compile-manage"))

;;;***

;;;### (autoloads nil "flex-compile-org-export" "flex-compile-org-export.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from flex-compile-org-export.el

(register-definition-prefixes "flex-compile-org-export" '("org-export-flex-compiler"))

;;;***

;;;### (autoloads nil "flex-compile-python" "flex-compile-python.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from flex-compile-python.el

(register-definition-prefixes "flex-compile-python" '("flex-compile-python-path" "python-flex-compiler"))

;;;***

;;;### (autoloads nil "flex-compile-repl" "flex-compile-repl.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from flex-compile-repl.el

(register-definition-prefixes "flex-compile-repl" '("repl-flex-compiler"))

;;;***

;;;### (autoloads nil "flex-compile-script" "flex-compile-script.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from flex-compile-script.el

(register-definition-prefixes "flex-compile-script" '("script-flex-compiler"))

;;;***

;;;### (autoloads nil "flex-compile-single-buffer" "flex-compile-single-buffer.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from flex-compile-single-buffer.el

(autoload 'flex-compile-single-buffer-set-buffer-exists-mode "flex-compile-single-buffer" "\
Query and set the value for the display mode for existing buffers.
This sets but doesn't configure
`flex-compile-single-buffer-display-buffer-exists-mode'." t nil)

(register-definition-prefixes "flex-compile-single-buffer" '("config-timeout-prop" "flex-compile-single-buffer-" "single-buffer-flex-compiler"))

;;;***

;;;### (autoloads nil "flex-compile-xml-validate" "flex-compile-xml-validate.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from flex-compile-xml-validate.el

(register-definition-prefixes "flex-compile-xml-validate" '("config-schema-file-prop" "xml-validate-flex-compiler"))

;;;***

;;;### (autoloads nil "flex-compiler" "flex-compiler.el" (0 0 0 0))
;;; Generated autoloads from flex-compiler.el

(autoload 'flex-compiler-config-save "flex-compiler" "\
Save all compiler and manager configuration." t nil)

(autoload 'flex-compiler-config-load "flex-compiler" "\
Load all compiler and manager configuration." t nil)

(autoload 'flex-compiler-list "flex-compiler" "\
Display the flex compiler list." t nil)

(autoload 'flex-compiler-reset-configuration "flex-compiler" "\
Reset every compiler's configuration." t nil)

(autoload 'flex-compiler-doc-show "flex-compiler" "\
Create markdown documentation on all compilers and their meta data." t nil)

(autoload 'flex-compiler-show-configuration "flex-compiler" "\
Create a buffer with the configuration of the current compiler." t nil)

(autoload 'flex-compiler-do-activate "flex-compiler" "\
Activate/select a compiler.

COMPILER-NAME the name of the compiler to activate.

\(fn COMPILER-NAME)" t nil)

(autoload 'flex-compiler-do-compile "flex-compiler" "\
Invoke compilation polymorphically.

CONFIG-OPTIONS, if non-nil invoke the configuration options for the compiler
before invoking the compilation.  By default CONFIG-OPTIONS is only detected
config-options by the \\[universal-argument] but some compilers use the numeric
argument as well.  This creates the need for an awkward key combination of:

  \\[digital-argument] \\[universal-argument] \\[flex-compiler-compile]

to invoke this command with full configuration support.

\(fn CONFIG-OPTIONS)" t nil)

(autoload 'flex-compiler-do-run-or-set-config "flex-compiler" "\
This either invokes the `run' compilation functionality or it configures it.

ACTION is the interactive argument given by the read function.

\(fn ACTION)" t nil)

(autoload 'flex-compiler-do-eval "flex-compiler" "\
Evaluate the current form for the (usually REPL based compiler).
FORM is the form to evaluate (if implemented).  If called with
\\[universal-argument] then prompt the user with the from to evaluation.

\(fn &optional FORM)" t nil)

(autoload 'flex-compiler-do-clean "flex-compiler" "\
Invoke the clean functionality of the compiler." t nil)

(register-definition-prefixes "flex-compiler" '("flex-compiler-"))

;;;***

;;;### (autoloads nil nil ("flex-compile-pkg.el") (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; flex-compile-autoloads.el ends here
