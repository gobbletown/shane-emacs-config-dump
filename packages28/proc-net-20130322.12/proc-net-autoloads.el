;;; proc-net-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "proc-net" "proc-net.el" (0 0 0 0))
;;; Generated autoloads from proc-net.el

(autoload 'process-network-list-processes "proc-net" "\
List running network processes." t nil)

(defalias 'list-network-processes 'process-network-list-processes)

(register-definition-prefixes "proc-net" '("process-network"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; proc-net-autoloads.el ends here
