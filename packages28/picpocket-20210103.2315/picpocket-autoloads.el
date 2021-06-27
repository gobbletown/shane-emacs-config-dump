;;; picpocket-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "picpocket" "picpocket.el" (0 0 0 0))
;;; Generated autoloads from picpocket.el

(autoload 'picpocket "picpocket" "\
View the pictures in the current directory." t nil)

(autoload 'picpocket-list-all-tags "picpocket" "\
Browse database of picpocket tags.

Tags are added to pictures with for example the
`picpocket-edit-tags' command inside the picpocket buffer (bound to
\\[picpocket-edit-tags])." t nil)

(autoload 'picpocket-db-update "picpocket" "\
Manage the tag database.

Enter a special buffer where any suspicious database entries are
listed.  Suspicious entries are for example when files that have
disappeared.  Maybe they have been deleted outside of picpocket.
And the entries in picpocket now points to nowhere.  If there are
any such entries they will be listed in this buffer.  And there
will be an offer to clean up those entries from the database.

Note that this command can take some time to finish since it goes
through the entire database." t nil)

(register-definition-prefixes "picpocket" '("picpocket-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; picpocket-autoloads.el ends here
