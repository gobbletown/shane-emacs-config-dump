;;; prosjekt-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "async-shell-command-prosjekt" "async-shell-command-prosjekt.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from async-shell-command-prosjekt.el

(register-definition-prefixes "async-shell-command-prosjekt" '("prosjekt-"))

;;;***

;;;### (autoloads nil "find-project-file-prosjekt" "find-project-file-prosjekt.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from find-project-file-prosjekt.el

(autoload 'prosjekt-find-project-file "find-project-file-prosjekt" "\
Find a file in the current project." t nil)

;;;***

;;;### (autoloads nil "prosjekt" "prosjekt.el" (0 0 0 0))
;;; Generated autoloads from prosjekt.el

(autoload 'prosjekt-new "prosjekt" "\
Create a new project.

\(fn DIRECTORY NAME)" t nil)

(autoload 'prosjekt-delete "prosjekt" "\
Delete an existing project.

\(fn FILENAME)" t nil)

(autoload 'prosjekt-open-recent "prosjekt" "\
Open a project named PROJ in the recent-list.

\(fn FILENAME)" t nil)

(autoload 'prosjekt-open "prosjekt" "\
Open the project defined in FILENAME.

\(fn FILENAME)" t nil)

(autoload 'prosjekt-clone "prosjekt" "\
Clone a new project from an existing project.

\(fn DIRECTORY NAME CLONE_FROM)" t nil)

(autoload 'prosjekt-save "prosjekt" "\
Save the current project." t nil)

(autoload 'prosjekt-close "prosjekt" "\
Close the current project." t nil)

(autoload 'prosjekt-setup "prosjekt" "\
Edit the project configuration in a new buffer." t nil)

(autoload 'prosjekt-repopulate "prosjekt" "\
Repopulate the project." t nil)

(autoload 'prosjekt-run-tool-by-name "prosjekt" "\


\(fn NAME)" t nil)

(autoload 'prosjekt-setup-save-and-close "prosjekt" "\
Save the prosjekt-buffer contents and the new project definition,
and kill that buffer." t nil)

(register-definition-prefixes "prosjekt" '("defun-autosave" "prosjekt-"))

;;;***

;;;### (autoloads nil nil ("prosjekt-pkg.el") (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; prosjekt-autoloads.el ends here
