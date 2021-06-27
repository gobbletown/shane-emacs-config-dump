;;; icsql-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "icsql" "icsql.el" (0 0 0 0))
;;; Generated autoloads from icsql.el

(autoload 'icsql-command "icsql" "\
Create a command used to start the Clojure REPL for connection NAME.
If LEINP is non-nil create the command as a Leinnigen development
REPL session.

\(fn NAME &optional LEINP)" t nil)

(autoload 'icsql-set-sqli-buffer "icsql" "\
Set a SQLi buffer to the to ciSQL ENTRY provided by the user interactively.
See `sql-set-sqli-buffer'.

\(fn &optional ENTRY)" t nil)

(autoload 'icsql "icsql" "\
Create and start a new icSQL entry." t nil)

(autoload 'icsql-send-line "icsql" "\
Send the current line to the SQL process." t nil)

(autoload 'icsql-send-input "icsql" "\
Send SQL to the last visited icSQL buffer.

\(fn SQL)" t nil)

(register-definition-prefixes "icsql" '("icsql-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; icsql-autoloads.el ends here
