;;; sotclojure-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "sotclojure" "sotclojure.el" (0 0 0 0))
;;; Generated autoloads from sotclojure.el

(autoload 'sotclojure-mode "sotclojure" "\
Toggle SoTclojure mode on or off.

If called interactively, enable SoTclojure mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp, also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\\{sotclojure-mode-map}

\(fn &optional ARG)" t nil)

(register-definition-prefixes "sotclojure" '("sotclojure-"))

;;;***

;;;### (autoloads nil "sotclojure-on" "sotclojure-on.el" (0 0 0 0))
;;; Generated autoloads from sotclojure-on.el

(autoload 'sotclojure-turn-on-everywhere "sotclojure-on" "\
Call-once function to turn on sotclojure everywhere.
Calls `sotclojure-mode' on all `clojure-mode' buffers, and sets
up a hook and abbrevs." nil nil)

(eval-after-load 'sotlisp '(speed-of-thought-hook-in #'sotclojure-turn-on-everywhere #'sotclojure-turn-off-everywhere))

(register-definition-prefixes "sotclojure-on" '("sotclojure-turn-off-everywhere"))

;;;***

;;;### (autoloads nil nil ("sotclojure-pkg.el") (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; sotclojure-autoloads.el ends here
