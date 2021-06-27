;;; pest-mode-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "pest-mode" "pest-mode.el" (0 0 0 0))
;;; Generated autoloads from pest-mode.el

(autoload 'pest-mode "pest-mode" "\
Major mode for editing Pest files.

\\{pest-mode-map}

\(fn)" t nil)

(add-to-list 'auto-mode-alist '("\\.pest\\'" . pest-mode))

(add-to-list 'interpreter-mode-alist '("pest" . pest-mode))

(register-definition-prefixes "pest-mode" '("pest-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; pest-mode-autoloads.el ends here
