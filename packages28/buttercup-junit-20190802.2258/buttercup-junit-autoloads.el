;;; buttercup-junit-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "buttercup-junit" "buttercup-junit.el" (0 0
;;;;;;  0 0))
;;; Generated autoloads from buttercup-junit.el

(autoload 'buttercup-junit-at-point "buttercup-junit" "\
Execute `buttercup-run-at-point' with `buttercup-junit-reporter' set.
The JUnit report will be written to thte file specified by
`buttercup-junit-result-file'.  If OUTER or
`buttercup-junit-master-suite' is a non-empty string, a wrapper
testsuite of that name will be added.

\(fn &optional OUTER)" t nil)

(autoload 'buttercup-junit-run-discover "buttercup-junit" "\
Execute `buttercup-run-discover' with `buttercup-junit-reporter' set.
The JUnit report will be written to the file specified by
`buttercup-junit-result-file', and to stdout if
`buttercup-junit-to-stdout' is non-nil.  If
`buttercup-junit-master-suite' is set a wrapper testsuite of that
name will be added.  These variables can be overriden by the
options `--xmlfile XMLFILE', `--junit-stdout', and `--outer-suite
SUITE' in `commandline-args-left'." nil nil)

(autoload 'buttercup-junit-run-markdown-buffer "buttercup-junit" "\
Execute `buttercup-run-markdown-buffer' with `buttercup-junit-reporter'.
MARKDOWN-BUFFERS is passed to `buttercup-run-markdown-buffer'.
The JUnit report will be written to the file specified by
`buttercup-junit-result-file', and to stdout if
`buttercup-junit-to-stdout' is non-nil.  If
`buttercup-junit-master-suite' is set a wrapper testsuite of that
name will be added.  These variables can be overriden by the
options `--xmlfile XMLFILE', `--junit-stdout', and `--outer-suite
SUITE' in `commandline-args-left'.

\(fn &rest MARKDOWN-BUFFERS)" t nil)

(autoload 'buttercup-junit-run-markdown "buttercup-junit" "\
Execute `buttercyp-run-markdown' with `buttercup-junit-reporter'." nil nil)

(autoload 'buttercup-junit-run-markdown-file "buttercup-junit" "\
Pass FILE to `buttercup-run-markdown-file' using `buttercup-junit-reporter'.

\(fn FILE)" t nil)

(autoload 'buttercup-junit-run "buttercup-junit" "\
Execute `buttercup-run' with `buttercup-junit-reporter'." t nil)

(autoload 'buttercup-junit-reporter "buttercup-junit" "\
Insert JUnit tags into the `*junit*' buffer according to EVENT and ARG.
See `buttercup-reporter' for documentation on the values of EVENT
and ARG.  A new output buffer is created on the
`buttercup-started' event, and its contents are written to
`buttercup-junit-result-file' and possibly stdout on the
`buttercup-done' event.

\(fn EVENT ARG)" nil nil)

(register-definition-prefixes "buttercup-junit" '("buttercup-junit-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; buttercup-junit-autoloads.el ends here
