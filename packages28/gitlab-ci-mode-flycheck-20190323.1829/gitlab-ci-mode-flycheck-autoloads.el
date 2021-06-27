;;; gitlab-ci-mode-flycheck-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "gitlab-ci-mode-flycheck" "gitlab-ci-mode-flycheck.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from gitlab-ci-mode-flycheck.el

(autoload 'gitlab-ci-mode-flycheck-enable "gitlab-ci-mode-flycheck" "\
Enable Flycheck support for ‘gitlab-ci-mode’.

Enabling this checker will upload your buffer to the site
specified in ‘gitlab-ci-url’.  If your buffer contains sensitive
data, this is not recommended.  (Storing sensitive data in your
CI configuration file is also not recommended.)

If your GitLab API requires a private token, set
‘gitlab-ci-api-token’." nil nil)

(register-definition-prefixes "gitlab-ci-mode-flycheck" '("gitlab-ci-mode-flycheck--"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; gitlab-ci-mode-flycheck-autoloads.el ends here
