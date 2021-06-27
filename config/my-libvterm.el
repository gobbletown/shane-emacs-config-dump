;; https://github.com/akermu/emacs-libvterm/issues/9
;; It's not working currently so I have disabled it

;; This is disabled
;; (never
;;  (if module-file-suffix
;;      (progn
;;        (module-load "/home/shane/var/smulliga/source/git/akermu/emacs-libvterm/vterm-module.so")
;;        (add-to-list 'load-path "/home/shane/source/git/akermu/emacs-libvterm")
;;        (require 'vterm))))

;; This works -- at least it does on neli
;; Disabled because I'm using Megn
;; (if module-file-suffix
;;     (progn
;;       (module-load "/home/shane/var/smulliga/source/git/akermu/emacs-libvterm/vterm-module.so")
;;       (add-to-list 'load-path "/home/shane/source/git/akermu/emacs-libvterm")
;;       (require 'vterm)))

;; Requires:
;; Compile emacs with module support
;; You can check that, by verifying that module-file-suffix is not nil.
;; module-file-suffix

(provide 'my-libverm)