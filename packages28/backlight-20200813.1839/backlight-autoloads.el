;;; backlight-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "backlight" "backlight.el" (0 0 0 0))
;;; Generated autoloads from backlight.el

(autoload 'backlight "backlight" "\
Interactively adjust the backlight brightness in the minibuffer." t nil)

(autoload 'backlight-inc "backlight" "\
Increment the backlight brightness by the specified or default AMOUNT.

\(fn AMOUNT)" t nil)

(autoload 'backlight-dec "backlight" "\
Decrements the backlight brightness by the specified or default AMOUNT.

\(fn AMOUNT)" t nil)

(autoload 'backlight-set-raw "backlight" "\
Interactively set the raw backlight brightness value." t nil)

(register-definition-prefixes "backlight" '("backlight-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; backlight-autoloads.el ends here
