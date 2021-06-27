;;; toggle-test-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "toggle-test" "toggle-test.el" (0 0 0 0))
;;; Generated autoloads from toggle-test.el

(defvar tgt-projects 'nil "\
Project entries. 
One entry per project that provides naming convention and folder structure")

(custom-autoload 'tgt-projects "toggle-test" t)

(defvar tgt-open-in-new-window t "\
Indicates if the files are opened in new window or current window")

(custom-autoload 'tgt-open-in-new-window "toggle-test" t)

(autoload 'tgt-toggle "toggle-test" nil t nil)

(register-definition-prefixes "toggle-test" '("tgt-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; toggle-test-autoloads.el ends here
