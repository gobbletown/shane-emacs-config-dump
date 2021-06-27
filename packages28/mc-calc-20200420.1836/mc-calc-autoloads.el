;;; mc-calc-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "mc-calc" "mc-calc.el" (0 0 0 0))
;;; Generated autoloads from mc-calc.el

(autoload 'mc-calc-eval "mc-calc" "\
Eval each cursor region in calc.

You can use $ and $$ in the region:
- $ will be substituted by the cursor number (starting with 0) and
- $$ will be substituted by the number of cursors.

Set `mc-calc-eval-options' to configure calc options." t nil)

(autoload 'mc-calc "mc-calc" "\
Open calc and set values in order to use `mc-calc-copy-to-buffer'." t nil)

(autoload 'mc-calc-grab "mc-calc" "\
Collect each cursor region into a vector and push it to calc.

After some operations are performed on the vector
the result can be copied back with `mc-calc-copy-to-buffer'." t nil)

(register-definition-prefixes "mc-calc" '("mc-calc-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; mc-calc-autoloads.el ends here
