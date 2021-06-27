;;; undercover-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "undercover" "undercover.el" (0 0 0 0))
;;; Generated autoloads from undercover.el

(autoload 'undercover "undercover" "\
Enable test coverage for files using CONFIGURATION.

If undercover.el is not enabled, do nothing.  Otherwise,
configure undercover.el using CONFIGURATION, and queue generating
and saving/uploading a coverage report before Emacs exits.

Undercover is enabled if any of the following is true:

- Emacs is detected to be running under a CI service.
- `undercover-force-coverage' is non-nil.
- The \"UNDERCOVER_FORCE\" environment variable exists in Emacs'
  environment.

Each item of CONFIGURATION can be one of the following:

STRING                  Indicates a wildcard of Emacs Lisp files
                        to include in the coverage.  Examples:
                        \"*.el\" \"subdir/*.el\"

\(:exclude STRING)       Indicates a wildcard of Emacs Lisp files
                        to exclude form the coverage.
                        Example: (:exclude \"exclude-*.el\")

\(:report-file STRING)   Sets the path of the file where the
                        coverage report will be written to.

\(:send-report BOOLEXP)  Sets whether to upload the report to the
                        detected/configured coverage service
                        after generating it.  Enabled by default.

\(:report-format SYMBOL) Sets the report target (file format or
                        coverage service), i.e., what to do with
                        the collected coverage information.


Currently supported values for :report-format are:

nil          Detect an appropriate service automatically.

'text        Save or display the coverage information as a simple
             text report.

'coveralls   Upload the coverage information to coveralls.io.

'codecov     Save the coverage information in a format compatible
             with the CodeCov upload script
             (https://codecov.io/bash).

             Because CodeCov natively understands Coveralls'
             report format, all this does (compared to
             'coveralls) is configure the default save path to a
             location that the upload script will look for.

             Uploading from within Undercover is currently not
             supported, and will raise an error.

'simplecov   Save the coverage information as a SimpleCov
             .resultset.json file.


Example invocation:

\(undercover \"*.el\"
            \"subdir/*.el\"
            (:exclude \"exclude-*.el\")
            (:report-format 'text)
            (:report-file \"coverage.txt\"))

Options may also be specified via the environment variable
\"UNDERCOVER_CONFIG\", which should be formatted as a literal
Emacs Lisp list consisting of items as defined above.
Configuration options in \"UNDERCOVER_CONFIG\" override those in
CONFIGURATION.

\(fn &rest CONFIGURATION)" nil t)

(register-definition-prefixes "undercover" '("undercover-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; undercover-autoloads.el ends here
