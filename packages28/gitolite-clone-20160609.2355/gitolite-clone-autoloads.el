;;; gitolite-clone-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "gitolite-clone" "gitolite-clone.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from gitolite-clone.el

(autoload 'gitolite-clone "gitolite-clone" "\
Clone a gitolite repo to be selected by `completing-read'.

USERNAME and HOST will be used to determine how to talk to
gitolite using ssh.  They default to `gitolite-clone-username' and
`gitolite-clone-host' respectively.

DETERMINE-TARGET is a function with signature identical to that
of `gitolite-clone-default-determine-target'.  It will determine
the path to which the repository should be cloned, and it
defaults to `gitolite-clone-default-determine-target'.

ACTION is a function that will be executed once the repository
has been cloned.  It's signature should be that of
`gitolite-clone-default-action', which is also the default value
for this argument.

\(fn &optional USERNAME HOST DETERMINE-TARGET ACTION)" t nil)

(autoload 'gitolite-clone-force-refresh "gitolite-clone" "\


\(fn &optional USERNAME HOST)" t nil)

(register-definition-prefixes "gitolite-clone" '("gitolite-clone-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; gitolite-clone-autoloads.el ends here
