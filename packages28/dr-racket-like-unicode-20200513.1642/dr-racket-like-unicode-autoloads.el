;;; dr-racket-like-unicode-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "dr-racket-like-unicode" "dr-racket-like-unicode.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from dr-racket-like-unicode.el

(autoload 'dr-racket-like-unicode-char "dr-racket-like-unicode" "\
Transform the TeX-style code immediately prior to point into Unicode.

Customize `dr-racket-like-unicode-table' to change the collection of unicode symbols." t nil)

(autoload 'dr-racket-like-unicode-mode "dr-racket-like-unicode" "\
A minor mode for writing Unicode as in DrDr-Racket.

If called interactively, enable Dr-Racket-Like-Unicode mode if
ARG is positive, and disable it if ARG is zero or negative.  If
called from Lisp, also enable the mode if ARG is omitted or nil,
and toggle it if ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

This minor mode binds one command: `dr-racket-like-unicode-char'.

\\{dr-racket-like-unicode-map}

\(fn &optional ARG)" t nil)

(register-definition-prefixes "dr-racket-like-unicode" '("dr-racket-like-unicode-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; dr-racket-like-unicode-autoloads.el ends here
