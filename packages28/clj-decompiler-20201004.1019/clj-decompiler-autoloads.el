;;; clj-decompiler-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "clj-decompiler" "clj-decompiler.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from clj-decompiler.el

(autoload 'clj-decompiler-setup "clj-decompiler" "\
Ensure decompiler dependencies are injected to cider." t nil)

(autoload 'clj-decompiler-disassemble "clj-decompiler" "\
Invoke \\=`disassemble\\=` on the expression preceding point." t nil)

(autoload 'clj-decompiler-decompile "clj-decompiler" "\
Invoke \\=`decompile\\=` on the expression preceding point." t nil)

(register-definition-prefixes "clj-decompiler" '("clj-decompiler-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; clj-decompiler-autoloads.el ends here
