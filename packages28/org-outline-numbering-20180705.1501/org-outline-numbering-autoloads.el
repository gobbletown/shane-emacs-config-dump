;;; org-outline-numbering-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "org-outline-numbering" "org-outline-numbering.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from org-outline-numbering.el

(autoload 'org-outline-numbering-mode "org-outline-numbering" "\
Minor mode to number ‘org-mode’ headings.

If called interactively, enable Org-Outline-Numbering mode if ARG
is positive, and disable it if ARG is zero or negative.  If
called from Lisp, also enable the mode if ARG is omitted or nil,
and toggle it if ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(autoload 'org-outline-numbering-display "org-outline-numbering" "\
Put numbered overlays on ‘org-mode’ headings." t nil)

(autoload 'org-outline-numbering-clear "org-outline-numbering" "\
Clear outline numbering overlays in widened buffer." t nil)

(register-definition-prefixes "org-outline-numbering" '("org-outline-numbering-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; org-outline-numbering-autoloads.el ends here
