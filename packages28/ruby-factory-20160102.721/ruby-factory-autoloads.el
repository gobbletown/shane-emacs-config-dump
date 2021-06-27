;;; ruby-factory-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "ruby-factory" "ruby-factory.el" (0 0 0 0))
;;; Generated autoloads from ruby-factory.el

(autoload 'ruby-factory-girl-mode "ruby-factory" "\
Minor mode for the Ruby factory_girl object generation library

If called interactively, enable Ruby-Factory-Girl mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp, also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\\{ruby-factory-mode-map}

\(fn &optional ARG)" t nil)

(autoload 'ruby-factory-fabrication-mode "ruby-factory" "\
Minor mode for the Ruby Fabrication object generation library

If called interactively, enable Ruby-Factory-Fabrication mode if
ARG is positive, and disable it if ARG is zero or negative.  If
called from Lisp, also enable the mode if ARG is omitted or nil,
and toggle it if ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\\{ruby-factory-mode-map}

\(fn &optional ARG)" t nil)

(autoload 'ruby-factory-model-mode "ruby-factory" "\
Minor mode for Ruby test object generation libraries

If called interactively, enable Ruby-Factory-Model mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp, also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\\{ruby-factory-mode-map}

\(fn &optional ARG)" t nil)

(autoload 'ruby-factory-mode "ruby-factory" "\


\(fn &optional PREFIX)" t nil)

(autoload 'ruby-factory-switch-to-buffer "ruby-factory" nil t nil)

(register-definition-prefixes "ruby-factory" '("ruby-factory--"))

;;;***

;;;### (autoloads nil nil ("ruby-factory-pkg.el") (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; ruby-factory-autoloads.el ends here
