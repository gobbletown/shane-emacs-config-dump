(require 'ipretty)

;; I don't know how this works yet
;; https://github.com/steckerhalter/ipretty

(global-set-key (kbd "C-c h C-j") 'ipretty-last-sexp)
(global-set-key (kbd "C-c h C-k") 'ipretty-last-sexp-other-buffer)