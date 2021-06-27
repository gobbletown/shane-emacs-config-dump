;;; flx-isearch-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "flx-isearch" "flx-isearch.el" (0 0 0 0))
;;; Generated autoloads from flx-isearch.el

(autoload 'flx-isearch-mode "flx-isearch" "\
Minor mode to allow you to use `flx' fuzzy match with `isearch'.

If called interactively, enable Flx-Isearch mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp, also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(autoload 'flx-isearch-forward "flx-isearch" "\
Start a fuzzy forward isearch

\(fn &optional REGEXP-P NO-RECURSIVE-EDIT)" t nil)

(autoload 'flx-isearch-backward "flx-isearch" "\
Start a fuzzy backward isearch

\(fn &optional REGEXP-P NO-RECURSIVE-EDIT)" t nil)

(register-definition-prefixes "flx-isearch" '("flx-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; flx-isearch-autoloads.el ends here
