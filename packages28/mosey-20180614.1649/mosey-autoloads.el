;;; mosey-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "mosey" "mosey.el" (0 0 0 0))
;;; Generated autoloads from mosey.el

(autoload 'mosey "mosey" "\
Move the point according to the list of MOVE-FUNCS.

Each function in MOVE-FUNCS should move the point to a
significant position, usually on the current line, but
potentially across lines.

If BACKWARD is set, move backwards.

If BOUNCE is set, bounce back to the next-to-last position when
the last one is hit.

If CYCLE is set, cycle around when the beginning/end of line is
hit.  Otherwise, stop at beginning/end of line.

\(fn MOVE-FUNCS &key BACKWARD BOUNCE CYCLE)" t nil)

(autoload 'defmosey "mosey" "\
Define `mosey-forward' and `mosey-backward' functions, with `-bounce' and `-cycle' variants.

MOVE-FUNCS is a list of functions that should should move the
point to a significant position, usually on the current line, but
potentially across lines.

PREFIX, if set, appends a prefix to the function names, like
`mosey-prefix-forward', useful for defining different sets of
moseys for different modes.

\(fn MOVE-FUNCS &key PREFIX)" nil t)

(defmosey '(beginning-of-line back-to-indentation mosey-goto-end-of-code mosey-goto-beginning-of-comment-text end-of-line))

(register-definition-prefixes "mosey" '("mosey-goto-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; mosey-autoloads.el ends here
