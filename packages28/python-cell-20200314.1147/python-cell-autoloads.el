;;; python-cell-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "python-cell" "python-cell.el" (0 0 0 0))
;;; Generated autoloads from python-cell.el

(autoload 'python-cell-mode "python-cell" "\
Highlight MATLAB-like cells and navigate between them.

If called interactively, enable Python-Cell mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp, also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(autoload 'python-cell-mode-enable "python-cell" nil nil nil)

(autoload 'python-cell-mode-disable "python-cell" nil nil nil)

(register-definition-prefixes "python-cell" '("python-cell-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; python-cell-autoloads.el ends here
