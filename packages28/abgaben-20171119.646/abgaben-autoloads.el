;;; abgaben-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "abgaben" "abgaben.el" (0 0 0 0))
;;; Generated autoloads from abgaben.el

(let ((loads (get 'abgaben 'custom-loads))) (if (member '"abgaben" loads) nil (put 'abgaben 'custom-loads (cons '"abgaben" loads))))

(defvar abgaben-root-folder (expand-file-name "$HOME/abgaben/") "\
Directory in which submissions will be saved.")

(custom-autoload 'abgaben-root-folder "abgaben" t)

(defvar abgaben-org-file (f-join abgaben-root-folder "abgaben.org") "\
File in which the links and notes are saved.")

(custom-autoload 'abgaben-org-file "abgaben" t)

(defvar abgaben-heading "Abgaben" "\
Name or ID of the org heading under which submissions should be inserted.")

(custom-autoload 'abgaben-heading "abgaben" t)

(defvar abgaben-points-re "assignment [0-9.]*: ?\\([0-9.]*\\)/\\([0-9.]*\\)" "\
Regular expression to match points in comments.
Has two groups: first for points achieved, second for achievable points.")

(custom-autoload 'abgaben-points-re "abgaben" t)

(defvar abgaben-all-groups '("group1" "group2") "\
Groups which you have, e.g. different days.")

(custom-autoload 'abgaben-all-groups "abgaben" t)

(defvar abgaben-all-weeks (mapcar (lambda (x) (format "%02d" x)) (number-sequence 1 14)) "\
All weeks, defaults to 01..14.")

(custom-autoload 'abgaben-all-weeks "abgaben" t)

(autoload 'abgaben-capture-submission "abgaben" "\
Add this to your mu4e attachment actions.
Save an attachment from an e-mail and add information about this
assignment to the org file.  MSG is and ATTNUM are the message
and attachment number.

\(fn MSG ATTNUM)" nil nil)

(autoload 'abgaben-export-pdf-annot-to-org "abgaben" "\
Export annotations of the current submission as subheadings of the current entry." t nil)

(autoload 'abgaben-prepare-reply "abgaben" "\
Prepare an email to send the reviewed assignment.
Opens Mail corresponding to submission and
saves the response in the kill ring for sending a reply" t nil)

(register-definition-prefixes "abgaben" '("abgaben-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; abgaben-autoloads.el ends here
