;;; erc-view-log-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "erc-view-log" "erc-view-log.el" (0 0 0 0))
;;; Generated autoloads from erc-view-log.el

(autoload 'erc-view-log-mode "erc-view-log" "\
Major mode for viewing ERC logs.
Colorizes the log file as if it were a standard ERC buffer.

Special commands:

\\{erc-view-log-mode-map}

Turning on `erc-view-log-mode' runs the hook `erc-view-log-mode-hook'.

\(fn)" t nil)

(register-definition-prefixes "erc-view-log" '("erc-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; erc-view-log-autoloads.el ends here
