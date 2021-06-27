;;; cpanfile-mode-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "cpanfile-mode" "cpanfile-mode.el" (0 0 0 0))
;;; Generated autoloads from cpanfile-mode.el

(autoload 'cpanfile-mode "cpanfile-mode" "\
Major mode for editing Perl CPANfiles.

\(fn)" t nil)

(add-to-list 'auto-mode-alist '("cpanfile\\'" . cpanfile-mode))

(register-definition-prefixes "cpanfile-mode" '("cpanfile-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; cpanfile-mode-autoloads.el ends here
