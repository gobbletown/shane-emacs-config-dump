;;; plsense-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "plsense" "plsense.el" (0 0 0 0))
;;; Generated autoloads from plsense.el

(autoload 'plsense-setup-current-buffer "plsense" "\
Do setup for using plsense in current buffer." t nil)

(autoload 'plsense-server-sync-trigger-ize "plsense" "\
Define advice to FUNC for informing changes of current buffer to server.

FUNC is symbol not quoted. e.g. (plsense-server-sync-trigger-ize newline)

\(fn FUNC)" nil t)

(autoload 'plsense-config-default "plsense" "\
Do setting recommemded configuration." nil nil)

(autoload 'plsense-version "plsense" "\
Show PlSense Version." t nil)

(autoload 'plsense-server-status "plsense" "\
Show status of server process." t nil)

(autoload 'plsense-server-start "plsense" "\
Start server process." t nil)

(autoload 'plsense-server-stop "plsense" "\
Stop server process." t nil)

(autoload 'plsense-server-refresh "plsense" "\
Refresh server process." t nil)

(autoload 'plsense-server-task "plsense" "\
Show information of active task on server process." t nil)

(autoload 'plsense-buffer-is-ready "plsense" "\
Show whether or not plsense is available on current buffer." t nil)

(autoload 'plsense-popup-help "plsense" "\
Popup help about something at point." t nil)

(autoload 'plsense-display-help-buffer "plsense" "\
Display help buffer about something at point." t nil)

(autoload 'plsense-jump-to-definition "plsense" "\
Jump to method definition at point." t nil)

(autoload 'plsense-delete-help-buffer "plsense" "\
Delete help buffers." t nil)

(autoload 'plsense-reopen-current-buffer "plsense" "\
Re-open current buffer." t nil)

(autoload 'plsense-update-location "plsense" "\
Update location of plsense process." t nil)

(autoload 'plsense-delete-all-cache "plsense" "\
Delete all cache data of plsense." t nil)

(autoload 'plsense-update-current-buffer "plsense" "\
Request updating about contents of current buffer to server process." t nil)

(register-definition-prefixes "plsense" '("ac-source-plsense-" "plsense-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; plsense-autoloads.el ends here
