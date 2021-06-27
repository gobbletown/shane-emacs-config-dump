;;; auth-source-xoauth2-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "auth-source-xoauth2" "auth-source-xoauth2.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from auth-source-xoauth2.el

(autoload 'auth-source-xoauth2-enable "auth-source-xoauth2" "\
Enable auth-source-xoauth2.

This function installs hooks that allow the use of a `xoauth2' authenticator
with `nnimap' and `smtpmail'.  To use this with other services, similar hooks
may have to be written to add the necessary protocol handling code to those
services.  If you write such a hook, please consider sending it for inclusion
in this package." nil nil)

(register-definition-prefixes "auth-source-xoauth2" '("auth-source-xoauth2-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; auth-source-xoauth2-autoloads.el ends here
