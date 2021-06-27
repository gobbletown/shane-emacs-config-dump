;;; django-commands-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "django-commands" "django-commands.el" (0 0
;;;;;;  0 0))
;;; Generated autoloads from django-commands.el

(autoload 'django-commands-shell "django-commands" "\
Run shell command.
If run with universal argument allow to edit command arguments" t nil)

(autoload 'django-commands-server "django-commands" "\
Run server command.
If run with universal argument allow to edit command arguments" t nil)

(autoload 'django-commands-test "django-commands" "\
Ask for test name and run test." t nil)

(autoload 'django-commands-restart "django-commands" "\
Restart django command associated with buffer.
If run with universal argument allow to edit command arguments" t nil)

(autoload 'django-commands-test-name "django-commands" "\
Return name of test case to run." nil nil)

(register-definition-prefixes "django-commands" '("django-commands-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; django-commands-autoloads.el ends here
