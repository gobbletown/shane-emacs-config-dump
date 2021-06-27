;;; org-clock-csv-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "org-clock-csv" "org-clock-csv.el" (0 0 0 0))
;;; Generated autoloads from org-clock-csv.el

(autoload 'org-clock-csv "org-clock-csv" "\
Export clock entries from INFILE to CSV format.

When INFILE is a filename or list of filenames, export clock
entries from these files. Otherwise, use `org-agenda-files'.

When NO-SWITCH is non-nil, do not call `switch-to-buffer' on the
rendered CSV output, simply return the buffer.

USE-CURRENT takes the value of the prefix argument. When non-nil,
use the current buffer for INFILE.

See also `org-clock-csv-batch' for a function more appropriate
for use in batch mode.

\(fn &optional INFILE NO-SWITCH USE-CURRENT)" t nil)

(autoload 'org-clock-csv-to-file "org-clock-csv" "\
Write clock entries from INFILE to OUTFILE in CSV format.

See `org-clock-csv' for additional details.

\(fn OUTFILE &optional INFILE USE-CURRENT)" t nil)

(autoload 'org-clock-csv-batch-and-exit "org-clock-csv" "\
Export clock entries in CSV format to standard output.

This function is identical in function to `org-clock-csv' except
that it directs output to `standard-output'. It is intended for
use in batch mode." nil nil)

(register-definition-prefixes "org-clock-csv" '("org-clock-csv-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; org-clock-csv-autoloads.el ends here
