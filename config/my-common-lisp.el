;; https://roswell.github.io/Initial-Recommended-Setup.html

;; ros install slime
(load (expand-file-name "~/.roswell/helper.el"))
(setq inferior-lisp-program "ros -Q run")

(provide 'my-common-lisp)