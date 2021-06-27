;;; dired-lsi-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "dired-lsi" "dired-lsi.el" (0 0 0 0))
;;; Generated autoloads from dired-lsi.el

(autoload 'dired-lsi-add-description "dired-lsi" "\
In dired, add DESC for DIR on this line.

\(fn DIR DESC)" t nil)

(autoload 'dired-lsi-mkdir-with-description "dired-lsi" "\
Make directory named NAME with dired-lsi DESC.

\(fn NAME DESC)" t nil)

(autoload 'dired-lsi-mode "dired-lsi" "\
Display all-the-icons icon for each files in a dired buffer.

If called interactively, enable Dired-Lsi mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp,  also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(register-definition-prefixes "dired-lsi" '("dired-lsi-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; dired-lsi-autoloads.el ends here
