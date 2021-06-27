;;; nix-modeline-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "nix-modeline" "nix-modeline.el" (0 0 0 0))
;;; Generated autoloads from nix-modeline.el

(defvar nix-modeline-mode nil "\
Non-nil if Nix-Modeline mode is enabled.
See the `nix-modeline-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `nix-modeline-mode'.")

(custom-autoload 'nix-modeline-mode "nix-modeline" nil)

(autoload 'nix-modeline-mode "nix-modeline" "\
Displays the number of running Nix builders in the modeline.

If called interactively, enable Nix-Modeline mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp,  also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

\(fn &optional ARG)" t nil)

(register-definition-prefixes "nix-modeline" '("nix-modeline-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; nix-modeline-autoloads.el ends here
