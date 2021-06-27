;;; learn-ocaml-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "learn-ocaml" "learn-ocaml.el" (0 0 0 0))
;;; Generated autoloads from learn-ocaml.el

(autoload 'learn-ocaml-grade "learn-ocaml" "\
Grade the current .ml buffer." t nil)

(autoload 'learn-ocaml-display-exercise-list "learn-ocaml" "\
Get the exercise list and render it in buffer `learn-ocaml-exo-list-name'." t nil)

(autoload 'learn-ocaml-mode "learn-ocaml" "\
Minor mode for students using the LearnOCaml platform.

If called interactively, enable Learn-Ocaml mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp, also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

Version of learn-ocaml.el: `learn-ocaml-mode-version'

Shortcuts for the learn-ocaml mode:
\\{learn-ocaml-mode-map}

\(fn &optional ARG)" t nil)

(register-definition-prefixes "learn-ocaml" '("learn-ocaml-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; learn-ocaml-autoloads.el ends here
