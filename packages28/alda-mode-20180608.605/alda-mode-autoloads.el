;;; alda-mode-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "alda-mode" "alda-mode.el" (0 0 0 0))
;;; Generated autoloads from alda-mode.el

(autoload 'alda-mode "alda-mode" "\
A major mode for alda-lang, providing syntax highlighting and basic indention.

\(fn)" t nil)

(add-to-list 'auto-mode-alist '("\\.alda\\'" . alda-mode))

(register-definition-prefixes "alda-mode" '("*alda-history*" "+alda-" "alda-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; alda-mode-autoloads.el ends here
