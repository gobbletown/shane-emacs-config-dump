;;; wdl-mode-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "wdl-mode" "wdl-mode.el" (0 0 0 0))
;;; Generated autoloads from wdl-mode.el

(autoload 'wdl-mode "wdl-mode" "\
Major mode for editing WDL (Workflow Definition Language)

\(fn)" t nil)

(add-to-list 'auto-mode-alist '("\\.wdl\\'" . wdl-mode))

(register-definition-prefixes "wdl-mode" '("wdl-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; wdl-mode-autoloads.el ends here
