;;; org-table-comment-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "org-table-comment" "org-table-comment.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from org-table-comment.el

(defalias 'org-table-comment-mode 'orgtbl-comment-mode)

(autoload 'orgtbl-comment-mode "org-table-comment" "\
Orgtbl comment mode.  Changes how orgtbl works for modes that don't support block comment regions (like emacs-lisp).

If called interactively, enable Orgtbl-Comment mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp, also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

Currently supports radio tables through overlay interface.

\(fn &optional ARG)" t nil)

(register-definition-prefixes "org-table-comment" '("org-table-comment-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; org-table-comment-autoloads.el ends here
