;;; rase-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "rase" "rase.el" (0 0 0 0))
;;; Generated autoloads from rase.el

(defvar rase-functions nil "\
List of two-argument functions to run at sun event.
Possible values for the first argument are the symbols
`sunrise', `midday', `sunrise' and `midnight'.
The second argument is non-nil only the very start of rase daemon.
If it's a list, it holds the previous events for the day.")

(custom-autoload 'rase-functions "rase" t)

(autoload 'rase-start "rase" "\
Start run-at-sun-event daemon.  If IMMEDIATELY is non-nil, execute hooks for the previous event.

\(fn &optional IMMEDIATELY)" nil nil)

(register-definition-prefixes "rase" '("*rase-timer*" "rase-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; rase-autoloads.el ends here
