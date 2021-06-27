;;; ghci-completion-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "ghci-completion" "ghci-completion.el" (0 0
;;;;;;  0 0))
;;; Generated autoloads from ghci-completion.el

(autoload 'turn-on-ghci-completion "ghci-completion" "\
Turn on GHCi completion mode." nil nil)

(autoload 'ghci-completion-mode "ghci-completion" "\
GHCi completion mode.
Provides basic TAB-completion of GHCi commands.

\(fn &optional ARG)" t nil)

(register-definition-prefixes "ghci-completion" '("ghci-completion-" "pcomplete/:" "turn-off-ghci-completion"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; ghci-completion-autoloads.el ends here
