;;; pollen-mode-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "pollen-mode" "pollen-mode.el" (0 0 0 0))
;;; Generated autoloads from pollen-mode.el

(autoload 'pollen-minor-mode "pollen-mode" "\
pollen minor mode.

If called interactively, enable Pollen minor mode if ARG is
positive, and disable it if ARG is zero or negative.  If called
from Lisp, also enable the mode if ARG is omitted or nil, and
toggle it if ARG is `toggle'; disable the mode otherwise.

The mode's hook is called both when the mode is enabled and when
it is disabled.

Keybindings for editing pollen file.

\(fn &optional ARG)" t nil)

(autoload 'pollen-mode "pollen-mode" "\
Major mode for pollen file

\(fn)" t nil)

(add-to-list 'auto-mode-alist '("\\.pm$" . pollen-mode))

(add-to-list 'auto-mode-alist '("\\.pmd$" . pollen-mode))

(add-to-list 'auto-mode-alist '("\\.pp$" pollen-mode t))

(add-to-list 'auto-mode-alist '("\\.p$" pollen-mode t))

(autoload 'pollen-server-start "pollen-mode" "\
Start pollen server at the given ROOT-DIR.

Server output is stored in buffer *pollen-server*.

\(fn ROOT-DIR)" t nil)

(register-definition-prefixes "pollen-mode" '("pollen-"))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; pollen-mode-autoloads.el ends here
