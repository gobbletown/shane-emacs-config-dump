;;; passmm-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "passmm" "passmm.el" (0 0 0 0))
;;; Generated autoloads from passmm.el

(autoload 'passmm-list-passwords "passmm" "\
List all passwords using a `dired' buffer.

The created `dired' buffer will have `passmm' running inside it.
If a `passm' buffer already exists it is made to be the current
buffer and refreshed." t nil)

(autoload 'passmm-completing-read "passmm" "\
Prompt for a password and then put it in the `kill-ring'." t nil)

(register-definition-prefixes "passmm" '("passmm-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; passmm-autoloads.el ends here
