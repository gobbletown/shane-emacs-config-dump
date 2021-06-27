;;; howdoyou-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "howdoyou" "howdoyou.el" (0 0 0 0))
;;; Generated autoloads from howdoyou.el

(autoload 'howdoyou-query "howdoyou" "\
Prompt for QUERY and search for answer.
Pop up *How Do You* buffer to show the answer.

\(fn QUERY)" t nil)

(autoload 'howdoyou-next-link "howdoyou" "\
Go to next link stored in google search." t nil)

(autoload 'howdoyou-previous-link "howdoyou" "\
Go to previous link stored in google search." t nil)

(autoload 'howdoyou-reload-link "howdoyou" "\
Reload current link in google search." t nil)

(autoload 'howdoyou-go-back-to-first-link "howdoyou" "\
Reload current link in google search." t nil)

(register-definition-prefixes "howdoyou" '("howdoyou-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; howdoyou-autoloads.el ends here
