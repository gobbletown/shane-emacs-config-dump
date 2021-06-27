;;; vdm-snippets-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "vdm-snippets" "vdm-snippets.el" (0 0 0 0))
;;; Generated autoloads from vdm-snippets.el

(autoload 'vdm-snippets-initialize "vdm-snippets" "\
Initialize VDM snippets such that YASnippet can see them." nil nil)

(eval-after-load 'yasnippet '(vdm-snippets-initialize))

(register-definition-prefixes "vdm-snippets" '("vdm-snippets-root"))

;;;***

;;;### (autoloads nil nil ("vdm-snippets-pkg.el") (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; vdm-snippets-autoloads.el ends here
