;;; eshell-outline-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "eshell-outline" "eshell-outline.el" (0 0 0
;;;;;;  0))
;;; Generated autoloads from eshell-outline.el

(autoload 'eshell-outline-mode "eshell-outline" "\
Outline-mode in Eshell.

If called interactively, enable Eshell-Outline mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp, also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\\{eshell-outline-mode-map}

\(fn &optional ARG)" t nil)

(autoload 'eshell-outline-view-buffer "eshell-outline" "\
Clone the current eshell buffer, and enable `outline-mode'.
This will clone the buffer via `clone-indirect-buffer', so all
following changes to the original buffer will be transferred.
The command `eshell-outline-mode' offers a more interactive
version, with specialized keybindings." t nil)

(register-definition-prefixes "eshell-outline" '("eshell-outline-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; eshell-outline-autoloads.el ends here
