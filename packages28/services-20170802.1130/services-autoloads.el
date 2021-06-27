;;; services-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "services" "services.el" (0 0 0 0))
;;; Generated autoloads from services.el

(autoload 'services-lookup "services" "\
Find a service given by SEARCH and PROTOCOL and display its details.

\(fn SEARCH PROTOCOL)" t nil)

(autoload 'services-clear-cache "services" "\
Clear the services \"cache\"." t nil)

(register-definition-prefixes "services" '("services-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; services-autoloads.el ends here
