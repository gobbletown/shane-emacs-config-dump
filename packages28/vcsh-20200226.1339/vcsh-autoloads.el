;;; vcsh-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "vcsh" "vcsh.el" (0 0 0 0))
;;; Generated autoloads from vcsh.el

(autoload 'vcsh-link "vcsh" "\
Make REPO become the .git directory for vcsh base directory.
This is similar to vcsh \"enter\" command.

\(fn REPO)" t nil)

(autoload 'vcsh-unlink "vcsh" "\
Undo the effect of `vcsh-link' (vcsh \"enter\" command)." t nil)

(autoload 'vcsh-new "vcsh" "\
Init a new vcsh repo and add files to it.
NAME is the repository name, FILES is a list of file names.
After creation, this command also calls `vcsh-write-gitignore'
for the new repo, and runs `vcsh-after-new-functions'.

\(fn NAME FILES)" t nil)

(autoload 'vcsh-write-gitignore "vcsh" "\
Run \"vcsh write-gitignore\" for REPO.
With a prefix argument or if REPO is nil, run the command for all vcsh
repositories.

\(fn &optional REPO)" t nil)

(register-definition-prefixes "vcsh" '("vcsh-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; vcsh-autoloads.el ends here
