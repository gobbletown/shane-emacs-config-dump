;;; org-variable-pitch-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "org-variable-pitch" "org-variable-pitch.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from org-variable-pitch.el

(autoload 'org-variable-pitch-minor-mode "org-variable-pitch" "\
Set up the buffer to be partially in variable pitch.
Keeps some elements in fixed pitch in order to keep layout.

If called interactively, enable Org-Variable-Pitch minor mode if
ARG is positive, and disable it if ARG is zero or negative.  If
called from Lisp, also enable the mode if ARG is omitted or nil,
and toggle it if ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(autoload 'org-variable-pitch-setup "org-variable-pitch" "\
Set up ‘org-variable-pitch-minor-mode’.

This function is a helper to set up OVP.  It syncs
‘org-variable-pitch-fixed-face’ with ‘default’ face, and adds a
hook to ‘org-mode-hook’.  Ideally, you’d want to run this
function somewhere after you set up ‘default’ face.

A nice place to call this function is from within
‘after-init-hook’:

    (add-hook 'after-init-hook #'org-variable-pitch-setup)

Alternatively, you might want to manually set up the attributes
of ‘org-variable-pitch-fixed-face’, in which case you should
calling avoid this function, add ‘org-variable-pitch-minor-mode’
to ‘org-mode-hook’ manually, and set up the face however you
please." t nil)

(register-definition-prefixes "org-variable-pitch" '("org-variable-pitch-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; org-variable-pitch-autoloads.el ends here
