;;; org-dropbox-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "org-dropbox" "org-dropbox.el" (0 0 0 0))
;;; Generated autoloads from org-dropbox.el

(let ((loads (get 'org-dropbox 'custom-loads))) (if (member '"org-dropbox" loads) nil (put 'org-dropbox 'custom-loads (cons '"org-dropbox" loads))))

(defconst org-dropbox-version "1.2" "\
Version of the org-dropbox package.")

(autoload 'org-dropbox-version "org-dropbox" "\
Version of the org-dropbox package." t nil)

(autoload 'org-dropbox-mode "org-dropbox" "\
Minor mode adding Dropbox notes to datetree.

If called interactively, enable Org-Dropbox mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp, also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

With no argument, this command toggles the mode. Non-null prefix
argument turns on the mode. Null prefix argument turns off the
mode.

\(fn &optional ARG)" t nil)

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; org-dropbox-autoloads.el ends here
