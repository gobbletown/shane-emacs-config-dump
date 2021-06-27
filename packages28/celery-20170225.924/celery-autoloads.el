;;; celery-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "celery" "celery.el" (0 0 0 0))
;;; Generated autoloads from celery.el

(autoload 'celery-stats-to-org-row "celery" "\
Compute simplified stats with optional REFRESH.
if REFRESH is non nil or no known stats exists, trigger a computation.
Otherwise, reuse the latest known values.
Also, use `celery-workers-list' to order/filter celery output.
Otherwise, reuse the latest known stats `celery-last-known-stats'.
This command writes a dummy formatted org-table row.
So this needs to be applied in an org context to make sense.

\(fn &optional REFRESH)" t nil)

(autoload 'celery-compute-stats-workers "celery" "\
Compute the simplified workers' stats.
if REFRESH is non nil, trigger a computation.
Otherwise, reuse the latest known values.

\(fn &optional REFRESH)" t nil)

(autoload 'celery-compute-tasks-consumed-workers "celery" "\
Check the current number of tasks executed by workers in celery.
if REFRESH is mentioned, trigger a check, otherwise, use the latest value.

\(fn &optional REFRESH)" t nil)

(autoload 'celery-mode "celery" "\
Minor mode to consolidate Emacs' celery extensions.

If called interactively, enable Celery mode if ARG is positive,
and disable it if ARG is zero or negative.  If called from Lisp,
also enable the mode if ARG is omitted or nil, and toggle it if
ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\\{celery-mode-map}

\(fn &optional ARG)" t nil)

(register-definition-prefixes "celery" '("celery-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; celery-autoloads.el ends here
