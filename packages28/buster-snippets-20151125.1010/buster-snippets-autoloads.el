;;; buster-snippets-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "buster-snippet-helpers" "buster-snippet-helpers.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from buster-snippet-helpers.el

(register-definition-prefixes "buster-snippet-helpers" '("buffer-file-name-body" "buster--" "capitalized-words" "chop-" "comma-if-looking-at-whitespace-and-quotes" "lower-camel-case" "mapcar-head" "snake-case" "split-name" "upper-camel-case"))

;;;***

;;;### (autoloads nil "buster-snippets" "buster-snippets.el" (0 0
;;;;;;  0 0))
;;; Generated autoloads from buster-snippets.el

(autoload 'buster-snippets-initialize "buster-snippets" nil nil nil)

(eval-after-load "yasnippet" '(buster-snippets-initialize))

(register-definition-prefixes "buster-snippets" '("buster-"))

;;;***

;;;### (autoloads nil nil ("buster-snippets-pkg.el") (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; buster-snippets-autoloads.el ends here
