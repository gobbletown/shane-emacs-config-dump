;;; navorski-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "navorski" "navorski.el" (0 0 0 0))
;;; Generated autoloads from navorski.el

(autoload 'nav/term "navorski" "\
Creates a multi-term on current directory

\(fn &optional PROFILE)" t nil)

(autoload 'nav/remote-term "navorski" "\
Creates a multi-term in a remote host. A user + host (e.g
user@host) value will be required to perform the connection.

\(fn &optional REMOTE-PROFILE)" t nil)

(autoload 'nav/persistent-term "navorski" "\
Creates a multi-term inside a GNU screen session. A screen
session name is required.

\(fn &optional PROFILE)" t nil)

(autoload 'nav/remote-persistent-term "navorski" "\
Creates multi-term buffer on a GNU screen session in a remote
host. A user + host (e.g user@host) value is required as well as
a GNU screen session name.

\(fn &optional PROFILE)" t nil)

(autoload 'nav/setup-tramp "navorski" "\
Setups tramp on a remote terminal" t nil)

(autoload 'nav/tramp-to-term "navorski" "\
Creates a terminal from the current TRAMP buffer." t nil)

(register-definition-prefixes "navorski" '("-navorski-" "nav"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; navorski-autoloads.el ends here
