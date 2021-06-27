;;; cljsbuild-mode-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "cljsbuild-mode" "cljsbuild-mode.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from cljsbuild-mode.el

(autoload 'cljsbuild-mode "cljsbuild-mode" "\
ClojureScript Build mode

If called interactively, enable Cljsbuild mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp, also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(autoload 'cljsbuild-start "cljsbuild-mode" "\
Runs cljsbuild.

\(fn COMMAND)" t nil)

(register-definition-prefixes "cljsbuild-mode" '("cljsbuild-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; cljsbuild-mode-autoloads.el ends here
