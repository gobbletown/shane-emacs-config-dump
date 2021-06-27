;;; netrunner-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "netrunner" "netrunner.el" (0 0 0 0))
;;; Generated autoloads from netrunner.el

(autoload 'netrunner-toggle-netrunner-buffer "netrunner" "\
Toggle if this is a `netrunner-buffer' or not." t nil)

(autoload 'netrunner-download-all-images "netrunner" "\
Try to download images from all cards from NetrunnerDB into `netrunner-image-dir'." t nil)

(autoload 'helm-netrunner "netrunner" "\
Helm for Android: Netrunner cards." t nil)

(autoload 'helm-netrunner-corp "netrunner" "\
Helm for corp cards in Android: Netrunner." t nil)

(autoload 'helm-netrunner-runner "netrunner" "\
Helm for runner cards in Android: Netrunner." t nil)

(register-definition-prefixes "netrunner" '("company-netrunner-backend" "helm-" "netrunner-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; netrunner-autoloads.el ends here
