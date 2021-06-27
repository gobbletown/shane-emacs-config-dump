(require 'flymake)

;; I Disabled this. DOn't use flymake. Use flycheck.

;; This is not a real thing, unfortunately.
;; (setq flymake-run-in-place nil)

;; This lets me say where my temp dir is.
;; (setq temporary-file-directory "~/.emacs.d/tmp/")

(setq flymake-gui-warnings-enabled nil)
(setq flymake-log-level 0)

(provide 'my-flymake)