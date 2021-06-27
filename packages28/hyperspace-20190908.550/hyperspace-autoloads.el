;;; hyperspace-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "hyperspace" "hyperspace.el" (0 0 0 0))
;;; Generated autoloads from hyperspace.el

(autoload 'hyperspace "hyperspace" "\
Execute action for keyword KEYWORD, with optional QUERY.

\(fn KEYWORD &optional QUERY)" t nil)

(autoload 'hyperspace-enter "hyperspace" "\
Enter Hyperspace, sending QUERY to the default action.

   If the region is active, use that as the query for
   ‘hyperspace-default-action’.  Otherwise, prompt the user.

\(fn &optional QUERY)" t nil)

(defvar hyperspace-minor-mode nil "\
Non-nil if Hyperspace minor mode is enabled.
See the `hyperspace-minor-mode' command
for a description of this minor mode.")

(custom-autoload 'hyperspace-minor-mode "hyperspace" nil)

(autoload 'hyperspace-minor-mode "hyperspace" "\
Global (universal) minor mode to jump from here to there.

If called interactively, enable Hyperspace minor mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp, also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(register-definition-prefixes "hyperspace" '("hyperspace-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; hyperspace-autoloads.el ends here
