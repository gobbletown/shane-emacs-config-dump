;;; bang-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "bang" "bang.el" (0 0 0 0))
;;; Generated autoloads from bang.el

(autoload 'bang "bang" "\
Intelligently execute string COMMAND in inferior shell.

When COMMAND starts with
  <  the output of COMMAND replaces the current selection
  >  COMMAND is run with the current selection as input
  |  the current selection is filtered through COMMAND
  !  COMMAND is simply executed (same as without any prefix)

Without any argument, `bang' will behave like `shell-command'.

Before these characters, one may also place a relative or
absolute path, which will be the current working directory in
which the command will be executed.  See `bang-expand-path' for
more details on this expansion.

Inside COMMAND, % is replaced with the current file name.  To
insert a literal % quote it using a backslash.

In case a region is active, bang will only work with the region
between BEG and END.  Otherwise the whole buffer is processed.

\(fn COMMAND BEG END)" t nil)

(register-definition-prefixes "bang" '("bang-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; bang-autoloads.el ends here
