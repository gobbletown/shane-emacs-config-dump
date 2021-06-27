;;; jar-manifest-mode-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "jar-manifest-mode" "jar-manifest-mode.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from jar-manifest-mode.el

(autoload 'jar-manifest-mode "jar-manifest-mode" "\
Major mode for editing JAR Manifest (Manifest.mf) files.

\(fn)" t nil)

(add-to-list 'auto-mode-alist '("[Mm][Aa][Na][Ii][Ff][Ee][Ss][Tt]\\.[Mm][Ff]\\'" . jar-manifest-mode))

(register-definition-prefixes "jar-manifest-mode" '("jar-manifest-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; jar-manifest-mode-autoloads.el ends here
