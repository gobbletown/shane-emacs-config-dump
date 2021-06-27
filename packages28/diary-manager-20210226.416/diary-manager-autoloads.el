;;; diary-manager-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "diary-manager" "diary-manager.el" (0 0 0 0))
;;; Generated autoloads from diary-manager.el

(autoload 'diary-manager-edit-mode "diary-manager" "\
Minor mode for editing diary entries.
Use \\[diary-manager-edit] to edit a diary entry in
`diary-manager-location', or \\[diary-manager-find-file] to edit
an arbitrary file as a diary entry. Alternatively, you can invoke
this mode to 

If called interactively, enable Diary-Manager-Edit mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp,  also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(autoload 'diary-manager-edit "diary-manager" "\
Edit the diary entry for DATE.
Interactively, select DATE using
`diary-manager-read-date-function'.

\(fn DATE)" t nil)

(autoload 'diary-manager-find-file "diary-manager" "\
Edit FILE as a diary entry.
Interactively, select DATE using `read-file-name'.

\(fn FILE)" t nil)

(autoload 'diary-manager-remove "diary-manager" "\
Remove the diary entry for DATE.
Interactively, select DATE using
`diary-manager-read-date-function'.

\(fn DATE)" t nil)

(autoload 'diary-manager-move "diary-manager" "\
Move the diary entry for OLD-DATE to NEW-DATE.
If either of OLD-DATE and NEW-DATE are not given, they are read
interactively from the user.

\(fn &optional OLD-DATE NEW-DATE)" t nil)

(autoload 'diary-manager-copy "diary-manager" "\
Copy the diary entry for OLD-DATE to NEW-DATE.
If either of OLD-DATE and NEW-DATE are not given, they are read
interactively from the user.

\(fn &optional OLD-DATE NEW-DATE)" t nil)

(autoload 'diary-manager-browse "diary-manager" "\
Open Dired on `diary-manager-location'." t nil)

(register-definition-prefixes "diary-manager" '("diary-manager-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; diary-manager-autoloads.el ends here
