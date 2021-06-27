;;; emoji-cheat-sheet-plus-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "emoji-cheat-sheet-plus" "emoji-cheat-sheet-plus.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from emoji-cheat-sheet-plus.el

(autoload 'emoji-cheat-sheet-plus-buffer "emoji-cheat-sheet-plus" "\
Open a new buffer with all the emojis." t nil)

(autoload 'emoji-cheat-sheet-plus-insert "emoji-cheat-sheet-plus" "\
Insert selected emojis from helm source." t nil)

(autoload 'emoji-cheat-sheet-plus-display-mode "emoji-cheat-sheet-plus" "\
Minor mode to display emoji cheat sheet images in buffer.

If called interactively, enable Emoji-Cheat-Sheet-Plus-Display
mode if ARG is positive, and disable it if ARG is zero or
negative.  If called from Lisp, also enable the mode if ARG is
omitted or nil, and toggle it if ARG is `toggle'; disable the
mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(register-definition-prefixes "emoji-cheat-sheet-plus" '("emoji-cheat-sheet-plus-"))

;;;***

;;;### (autoloads nil nil ("emoji-cheat-sheet-plus-pkg.el") (0 0
;;;;;;  0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; emoji-cheat-sheet-plus-autoloads.el ends here
