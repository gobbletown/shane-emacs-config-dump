;;; clocker-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "clocker" "clocker.el" (0 0 0 0))
;;; Generated autoloads from clocker.el

(autoload 'clocker-org-clock-goto "clocker" "\
Open file that has the currently clocked-in entry, or to the
most recently clocked one.

With prefix arg SELECT, offer recently clocked tasks for selection.

\(fn &optional SELECT)" t nil)

(autoload 'clocker-open-org-file "clocker" "\
Open an appropiate org file.

It traverses files in the following order:

1) It tries to find an open buffer that has a file with .org
extension, if found switch to it.

2) If 1 is nil and `clocker-issue-format-regex' is not nil, it
   tries to open/create an org file using the issue number on the
   branch

3) If `clocker-issue-format-regex' is nil, it will traverse your
tree hierarchy and finds the closest org file." t nil)

(autoload 'clocker-auto-save-hook "clocker" "\
Set `clocker-on-auto-save' to t" t nil)

(autoload 'clocker-before-save-hook "clocker" "\
Execute `clocker-open-org-file' and asks even more annoying questions if not clocked-in." t nil)

(autoload 'clocker-after-save-hook "clocker" "\
Execute `'clocker-open-org-file' and asks annoying questions if not clocked-in." t nil)

(autoload 'clocker-skip-on-major-mode "clocker" "\
Add given mode to the
`clocker-skip-after-save-hook-on-mode' list.

\(fn A-MODE)" t nil)

(autoload 'clocker-stop-skip-on-major-mode "clocker" "\
Remove given mode from
`clocker-skip-after-save-hook-on-mode' list.

\(fn A-MODE)" t nil)

(defvar clocker-mode nil "\
Non-nil if Clocker mode is enabled.
See the `clocker-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `clocker-mode'.")

(custom-autoload 'clocker-mode "clocker" nil)

(autoload 'clocker-mode "clocker" "\
Enable clock-in enforce strategies

If called interactively, enable Clocker mode if ARG is positive,
and disable it if ARG is zero or negative.  If called from Lisp,
also enable the mode if ARG is omitted or nil, and toggle it if
ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(register-definition-prefixes "clocker" '("clocker-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; clocker-autoloads.el ends here
