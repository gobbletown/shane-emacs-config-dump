;;; sailfish-scratchbox-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "sailfish-scratchbox" "sailfish-scratchbox.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from sailfish-scratchbox.el

(autoload 'sailfish-scratchbox-mb2-build "sailfish-scratchbox" "\
Build the project inside the sdk this file is in." t nil)

(autoload 'sailfish-scratchbox-deploy-rpms "sailfish-scratchbox" "\
Copy the the built project artifacts to the phone." t nil)

(autoload 'sailfish-scratchbox-install-rpms "sailfish-scratchbox" "\
Install project rpm packages into the sailfish os scratchbox." t nil)

(register-definition-prefixes "sailfish-scratchbox" '("run-with-project-path" "sailfish-scratchbox-" "scratchbox-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; sailfish-scratchbox-autoloads.el ends here
