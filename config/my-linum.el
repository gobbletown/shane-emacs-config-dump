(require 'linum)

;; Don't forget linum-relative-mode but it is distracting in emacs
;; Better left to vim

;; Disable this for the moment. It doesn't work properly with git gutter
;; (global-linum-mode t)

;; (setq linum-format "%d ") ; adds a space after the line-number
(setq linum-format "%3d ")

(provide 'my-linum)