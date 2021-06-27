;;; ecukes-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "ecukes" "ecukes.el" (0 0 0 0))
;;; Generated autoloads from ecukes.el

(register-definition-prefixes "ecukes" '("ecukes"))

;;;***

;;;### (autoloads nil "ecukes-cli" "ecukes-cli.el" (0 0 0 0))
;;; Generated autoloads from ecukes-cli.el

(register-definition-prefixes "ecukes-cli" '("ecukes-"))

;;;***

;;;### (autoloads nil "ecukes-core" "ecukes-core.el" (0 0 0 0))
;;; Generated autoloads from ecukes-core.el

(register-definition-prefixes "ecukes-core" '("ecukes-"))

;;;***

;;;### (autoloads nil "ecukes-def" "ecukes-def.el" (0 0 0 0))
;;; Generated autoloads from ecukes-def.el

(register-definition-prefixes "ecukes-def" '("ecukes-"))

;;;***

;;;### (autoloads nil "ecukes-helpers" "ecukes-helpers.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from ecukes-helpers.el

(register-definition-prefixes "ecukes-helpers" '("ecukes-f"))

;;;***

;;;### (autoloads nil "ecukes-hooks" "ecukes-hooks.el" (0 0 0 0))
;;; Generated autoloads from ecukes-hooks.el

(register-definition-prefixes "ecukes-hooks" '("After" "Before" "Fail" "Setup" "Teardown" "define-hook" "ecukes-hooks-"))

;;;***

;;;### (autoloads nil "ecukes-load" "ecukes-load.el" (0 0 0 0))
;;; Generated autoloads from ecukes-load.el

(register-definition-prefixes "ecukes-load" '("ecukes-"))

;;;***

;;;### (autoloads nil "ecukes-new" "ecukes-new.el" (0 0 0 0))
;;; Generated autoloads from ecukes-new.el

(register-definition-prefixes "ecukes-new" '("ecukes-new"))

;;;***

;;;### (autoloads nil "ecukes-parse" "ecukes-parse.el" (0 0 0 0))
;;; Generated autoloads from ecukes-parse.el

(register-definition-prefixes "ecukes-parse" '("ecukes-"))

;;;***

;;;### (autoloads nil "ecukes-project" "ecukes-project.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from ecukes-project.el

(register-definition-prefixes "ecukes-project" '("ecukes-project-"))

;;;***

;;;### (autoloads nil "ecukes-reporter" "ecukes-reporter.el" (0 0
;;;;;;  0 0))
;;; Generated autoloads from ecukes-reporter.el

(register-definition-prefixes "ecukes-reporter" '("ecukes-reporter"))

;;;***

;;;### (autoloads nil "ecukes-run" "ecukes-run.el" (0 0 0 0))
;;; Generated autoloads from ecukes-run.el

(register-definition-prefixes "ecukes-run" '("ecukes-run"))

;;;***

;;;### (autoloads nil "ecukes-stats" "ecukes-stats.el" (0 0 0 0))
;;; Generated autoloads from ecukes-stats.el

(register-definition-prefixes "ecukes-stats" '("ecukes-stats-"))

;;;***

;;;### (autoloads nil "ecukes-steps" "ecukes-steps.el" (0 0 0 0))
;;; Generated autoloads from ecukes-steps.el

(defalias 'Given 'ecukes-steps-define-or-call-step "\
Put the system in a known state.")

(defalias 'When 'ecukes-steps-define-or-call-step "\
Describe the key action.")

(defalias 'Then 'ecukes-steps-define-or-call-step "\
Observe outcomes.")

(defalias 'And 'ecukes-steps-define-or-call-step "\
Make Given/When/Then read more fluently.")

(defalias 'But 'ecukes-steps-define-or-call-step "\
Make Given/When/Then read more fluently.")

(autoload 'ecukes-steps-define-or-call-step "ecukes-steps" "\
Define or call step.

When *defining* a step, argument takes the following form:
    (STEP-REGEXP [DOC] FUNCTION)
where STEP-REGEXP is a regular expression defining a step and
FUNCTION is the definition of the step.  You can optionally
give a docstring DOC as the second argument.

When *calling* a step, argument takes the following form:
    (STEP-NAME [ARG [ARG ..]])

\(fn STEP-REGEXP [DOC] FUNCTION | STEP-NAME &optional ARGS)" nil nil)

(put 'ecukes-steps-define-or-call-step 'lisp-indent-function 'defun)

(put 'ecukes-steps-define-or-call-step 'doc-string-elt 2)

(register-definition-prefixes "ecukes-steps" '("ecukes-steps-"))

;;;***

;;;### (autoloads nil "ecukes-template" "ecukes-template.el" (0 0
;;;;;;  0 0))
;;; Generated autoloads from ecukes-template.el

(register-definition-prefixes "ecukes-template" '("ecukes-"))

;;;***

;;;### (autoloads nil nil ("ecukes-byte-compile.el" "ecukes-pkg.el")
;;;;;;  (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; ecukes-autoloads.el ends here
