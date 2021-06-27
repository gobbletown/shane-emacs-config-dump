; (load "/var/smulliga/source/git/config/emacs/packages27/popwin-20150315.1300/popwin.el")
(load "/home/shane/var/smulliga/source/git/config/emacs/packages28/popwin-20210215.1849/popwin.el")
(require 'popwin)
(load "/var/smulliga/source/git/config/emacs/packages28/guide-key-20150108.635/guide-key.el")
(require 'guide-key)

(try (guide-key-mode -1) nil)

;; This was forcing purcell to start with guide-key-mode on
(remove-hook 'after-init-hook 'guide-key-mode)

(provide 'my-guide-key)