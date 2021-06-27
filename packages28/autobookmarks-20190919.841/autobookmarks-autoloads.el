;;; autobookmarks-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "autobookmarks" "autobookmarks.el" (0 0 0 0))
;;; Generated autoloads from autobookmarks.el

(defvar autobookmarks-mode nil "\
Non-nil if Autobookmarks mode is enabled.
See the `autobookmarks-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `autobookmarks-mode'.")

(custom-autoload 'autobookmarks-mode "autobookmarks" nil)

(autoload 'autobookmarks-mode "autobookmarks" "\
Autobookmarks.

If called interactively, enable Autobookmarks mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp, also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(register-definition-prefixes "autobookmarks" '("abm-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; autobookmarks-autoloads.el ends here
