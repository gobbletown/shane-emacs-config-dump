;;; goldendict-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "goldendict" "goldendict.el" (0 0 0 0))
;;; Generated autoloads from goldendict.el

(autoload 'goldendict-dwim "goldendict" "\
Query current symbol/word at point or region selected with Goldendict.
If you invoke command with `RAISE-MAIN-WINDOW' prefix \\<universal-argument>, it will raise Goldendict main window.

\(fn &optional RAISE-MAIN-WINDOW)" t nil)

(register-definition-prefixes "goldendict" '("goldendict-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; goldendict-autoloads.el ends here
