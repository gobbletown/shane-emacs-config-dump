;;; git-identity-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "git-identity" "git-identity.el" (0 0 0 0))
;;; Generated autoloads from git-identity.el

(defvar git-identity-git-executable "git" "\
Executable file of Git.")

(custom-autoload 'git-identity-git-executable "git-identity" t)

(defvar git-identity-default-username (when (and (stringp user-full-name) (not (string-empty-p user-full-name))) user-full-name) "\
Default full name of the user set in Git repositories.")

(custom-autoload 'git-identity-default-username "git-identity" t)

(defvar git-identity-list nil "\
List of plists of Git identities.")

(custom-autoload 'git-identity-list "git-identity" t)

(autoload 'git-identity-complete "git-identity" "\
Display PROMPT and select an identity from `git-identity-list'.

\(fn PROMPT)" nil nil)

(autoload 'git-identity-set-identity "git-identity" "\
Set the identity for the repository at the working directory.

This function lets the user choose an identity for the current
repository using `git-identity-complete' function and sets the
user name and the email address in the local configuration of the
Git repository.

Optionally, you can set PROMPT for the identity.
If it is omitted, the default prompt is used.

\(fn &optional PROMPT)" t nil)
 (autoload 'git-identity-info "git-identity")

(autoload 'git-identity-ensure "git-identity" "\
Ensure that the current repository has an identity." nil nil)

(defvar git-identity-magit-mode nil "\
Non-nil if Git-Identity-Magit mode is enabled.
See the `git-identity-magit-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `git-identity-magit-mode'.")

(custom-autoload 'git-identity-magit-mode "git-identity" nil)

(autoload 'git-identity-magit-mode "git-identity" "\
Global minor mode for running Git identity checks in Magit.

If called interactively, enable Git-Identity-Magit mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp, also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

This mode enables the following features:

- Add a hook to `magit-commit' to ensure that you have a
  global/local identity configured in the repository.

\(fn &optional ARG)" t nil)

(register-definition-prefixes "git-identity" '("git-identity-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; git-identity-autoloads.el ends here
