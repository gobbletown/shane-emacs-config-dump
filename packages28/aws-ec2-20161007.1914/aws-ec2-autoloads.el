;;; aws-ec2-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "aws-ec2" "aws-ec2.el" (0 0 0 0))
;;; Generated autoloads from aws-ec2.el

(defvar aws-command (executable-find "aws") "\
The command for \\[aws-instances] and other aws-ec2 commands.")

(custom-autoload 'aws-command "aws-ec2" t)

(autoload 'aws-instances "aws-ec2" "\
List aws instances using aws-cli. (The `aws` command)." t nil)

(register-definition-prefixes "aws-ec2" '("aws-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; aws-ec2-autoloads.el ends here
