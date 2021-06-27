(provide 'my-prelude)

; https://github.com/bbatsov/guru-mode
(setq prelude-guru nil)


; I don't know what to check for. I can't use daemonp here.
(ignore-errors (define-key prelude-mode-map (kbd "C-c o") nil))