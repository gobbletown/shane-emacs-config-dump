;;; ejson-mode-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "ejson-mode" "ejson-mode.el" (0 0 0 0))
;;; Generated autoloads from ejson-mode.el

(autoload 'ejson-mode "ejson-mode" "\
Major mode for editing ejson files

\(fn)" t nil)

(add-to-list 'auto-mode-alist '("\\.ejson\\'" . ejson-mode))

(register-definition-prefixes "ejson-mode" '("ejson-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; ejson-mode-autoloads.el ends here
