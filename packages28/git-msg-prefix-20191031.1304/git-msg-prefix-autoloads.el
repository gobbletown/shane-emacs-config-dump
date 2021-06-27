;;; git-msg-prefix-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "git-msg-prefix" "git-msg-prefix.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from git-msg-prefix.el

(autoload 'git-msg-prefix "git-msg-prefix" "\
Insert the relevant part of the chosen commit.
Relevant meaning the result of `git-msg-prefix-regex'
substitution." t nil)

(register-definition-prefixes "git-msg-prefix" '("git-msg-prefix-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; git-msg-prefix-autoloads.el ends here
