;;; cmm-mode-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "cmm-mode" "cmm-mode.el" (0 0 0 0))
;;; Generated autoloads from cmm-mode.el

(autoload 'cmm-mode "cmm-mode" "\
A major mode for editing Cmm files.

\(fn)" t nil)

(add-to-list 'auto-mode-alist '("\\.cmm\\'" . cmm-mode))

(register-definition-prefixes "cmm-mode" '("cmm-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; cmm-mode-autoloads.el ends here
