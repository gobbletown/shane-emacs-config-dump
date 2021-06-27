;;; litecoin-ticker-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "litecoin-ticker" "litecoin-ticker.el" (0 0
;;;;;;  0 0))
;;; Generated autoloads from litecoin-ticker.el

(defvar litecoin-ticker-mode nil "\
Non-nil if Litecoin-Ticker mode is enabled.
See the `litecoin-ticker-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `litecoin-ticker-mode'.")

(custom-autoload 'litecoin-ticker-mode "litecoin-ticker" nil)

(autoload 'litecoin-ticker-mode "litecoin-ticker" "\
Minor mode to display the lastest litecoin price

If called interactively, enable Litecoin-Ticker mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp, also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(register-definition-prefixes "litecoin-ticker" '("litecoin-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; litecoin-ticker-autoloads.el ends here
