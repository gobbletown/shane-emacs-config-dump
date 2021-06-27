;;; dired-atool-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "dired-atool" "dired-atool.el" (0 0 0 0))
;;; Generated autoloads from dired-atool.el

(autoload 'dired-atool-do-unpack "dired-atool" "\
Unpack file(s) with atool.
ARG is used for `dired-get-marked-files'.

\(fn &optional ARG)" t nil)

(autoload 'dired-atool-do-unpack-with-subdirectory "dired-atool" "\
Unpack file(s) with atool.
This command makes subdirectories in the current directory and unpacks
files into them.
ARG is used for `dired-get-marked-files'.

\(fn &optional ARG)" t nil)

(autoload 'dired-atool-do-pack "dired-atool" "\
Pack file(s) with atool.
ARG is used for `dired-get-marked-files'.

\(fn &optional ARG)" t nil)

(autoload 'dired-atool-setup "dired-atool" "\
Setup key bindings of dired-atool commands." t nil)

(register-definition-prefixes "dired-atool" '("dired-atool-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; dired-atool-autoloads.el ends here
