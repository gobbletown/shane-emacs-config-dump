;;; gitpatch-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "gitpatch" "gitpatch.el" (0 0 0 0))
;;; Generated autoloads from gitpatch.el

(autoload 'gitpatch-mail "gitpatch" "\
Mail a git-format patch file ‘message-mode’ or its derived mode." t nil)

(autoload 'gitpatch-mail-attach-patch "gitpatch" "\
Attach a patch file to mail.
The patch is in directory `gitpatch-mail--patch-directory'." t nil)

(register-definition-prefixes "gitpatch" '("gitpatch-mail-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; gitpatch-autoloads.el ends here
