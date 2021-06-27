(require 'deadgrep)

;; This doesnt work because lexical binding is set in the deadgrep package
;; (setq deadgrep-executable "rga")
;; Just make a script called rg which points to rga

(provide 'my-deadgrep)