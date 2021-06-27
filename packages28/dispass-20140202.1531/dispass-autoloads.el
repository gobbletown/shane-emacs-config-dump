;;; dispass-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "dispass" "dispass.el" (0 0 0 0))
;;; Generated autoloads from dispass.el

(autoload 'dispass-create "dispass" "\
Create a new password for LABEL using PASS.

Optionally also specify to make the passphrase LENGTH long, use
the ALGO algorithm with sequence number SEQNO.

\(fn LABEL PASS &optional LENGTH ALGO SEQNO)" t nil)

(autoload 'dispass "dispass" "\
Recreate a passphrase for LABEL using PASS.

Optionally also specify to make the passphrase LENGTH long, use
the ALGO algorithm with sequence number SEQNO.  This is useful
when you would like to generate a one-shot passphrase, or prefer
not to have LABEL added to your labelfile for some other reason.

\(fn LABEL PASS &optional LENGTH ALGO SEQNO)" t nil)

(autoload 'dispass-insert "dispass" "\
Recreate a passphrase for LABEL using PASS.

This command does the exact same thing as `dispass', except it
inserts the results in the current buffer instead of copying them
into the `kill-ring' (and clipboard).  LABEL, PASS, LENGTH, ALGO
and SEQNO are directly passed on to `dispass--get-phrase'.

\(fn LABEL PASS &optional LENGTH ALGO SEQNO)" t nil)

(autoload 'dispass-add-label "dispass" "\
Add LABEL with length LENGTH and algorithm ALGO to DisPass.

Optionally also specify sequence number SEQNO.

\(fn LABEL LENGTH ALGO &optional SEQNO)" t nil)

(autoload 'dispass-remove-label "dispass" "\
Remove LABEL from DisPass.

If LABEL is not given `tabulated-list-get-id' will be used to get
the currently pointed-at label.  If neither LABEL is not found an
error is thrown.

\(fn LABEL)" t nil)

(autoload 'dispass-list-labels "dispass" "\
Display a list of labels for dispass." t nil)

(register-definition-prefixes "dispass" '("dispass-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; dispass-autoloads.el ends here
