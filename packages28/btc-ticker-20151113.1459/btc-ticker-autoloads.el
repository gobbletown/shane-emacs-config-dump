;;; btc-ticker-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "btc-ticker" "btc-ticker.el" (0 0 0 0))
;;; Generated autoloads from btc-ticker.el

(defvar btc-ticker-mode nil "\
Non-nil if Btc-Ticker mode is enabled.
See the `btc-ticker-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `btc-ticker-mode'.")

(custom-autoload 'btc-ticker-mode "btc-ticker" nil)

(autoload 'btc-ticker-mode "btc-ticker" "\
Minor mode to display the latest BTC price.

If called interactively, enable Btc-Ticker mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp, also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(register-definition-prefixes "btc-ticker" '("bitstamp-api-url" "btc-ticker-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; btc-ticker-autoloads.el ends here
