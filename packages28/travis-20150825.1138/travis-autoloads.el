;;; travis-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "travis" "travis.el" (0 0 0 0))
;;; Generated autoloads from travis.el

(autoload 'emacs-travis-version "travis" "\
Get the emacs-travis version as string.
If called interactively or if SHOW-VERSION is non-nil, show the
version in the echo area and the messages buffer.
The returned string includes both, the version from package.el
and the library version, if both a present and different.
If the version number could not be determined, signal an error,
if called interactively, or if SHOW-VERSION is non-nil, otherwise
just return nil.

\(fn &optional SHOW-VERSION)" t nil)

;;;***

;;;### (autoloads nil "travis-api" "travis-api.el" (0 0 0 0))
;;; Generated autoloads from travis-api.el

(register-definition-prefixes "travis-api" '("travis--"))

;;;***

;;;### (autoloads nil "travis-auth" "travis-auth.el" (0 0 0 0))
;;; Generated autoloads from travis-auth.el

(register-definition-prefixes "travis-auth" '("travis--get-auth"))

;;;***

;;;### (autoloads nil "travis-builds" "travis-builds.el" (0 0 0 0))
;;; Generated autoloads from travis-builds.el

(register-definition-prefixes "travis-builds" '("travis--get-builds"))

;;;***

;;;### (autoloads nil "travis-mode" "travis-mode.el" (0 0 0 0))
;;; Generated autoloads from travis-mode.el

(register-definition-prefixes "travis-mode" '("travis-"))

;;;***

;;;### (autoloads nil "travis-repos" "travis-repos.el" (0 0 0 0))
;;; Generated autoloads from travis-repos.el

(register-definition-prefixes "travis-repos" '("travis--get-repositor"))

;;;***

;;;### (autoloads nil "travis-ui" "travis-ui.el" (0 0 0 0))
;;; Generated autoloads from travis-ui.el

(register-definition-prefixes "travis-ui" '("colorize-build-state"))

;;;***

;;;### (autoloads nil "travis-users" "travis-users.el" (0 0 0 0))
;;; Generated autoloads from travis-users.el

(register-definition-prefixes "travis-users" '("travis--get-users"))

;;;***

;;;### (autoloads nil "travis-utils" "travis-utils.el" (0 0 0 0))
;;; Generated autoloads from travis-utils.el

(register-definition-prefixes "travis-utils" '("travis-"))

;;;***

;;;### (autoloads nil "travis-version" "travis-version.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from travis-version.el

(register-definition-prefixes "travis-version" '("travis--library-version"))

;;;***

;;;### (autoloads nil nil ("travis-pkg.el") (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; travis-autoloads.el ends here
