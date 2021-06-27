(setq xah-fly-use-control-key nil)      ; must come before require
(require 'xah-fly-keys)

(provide 'my-xah-fly-keys)
(xah-fly-keys-set-layout "qwerty") ; required if you use qwerty



;; http://ergoemacs.org/misc/ergoemacs_vi_mode.html

;; for other layout, use one of
;; "workman"
;; "qwertz"
;; "programer-dvorak"
;; "dvorak"
;; "colemak"
;; "colemak-mod-dh"
;; dvorak is the default


;; Do not activate it
(xah-fly-keys 1)


;; This is easier than editing fly-keys
(defalias 'smex 'helm-M-x)



;; This is not enough. I have to modify the plugin, here
;; I don't want to disable it for xah insert-mode, only command-mode
;; (define-key xah-fly-key-map (kbd "C-w") nil) ; xah-close-current-buffer
;; (define-key xah-fly-key-map (kbd "C-v") nil) ;; Paste. yank
;; (define-key xah-fly-key-map (kbd "C-d") nil) ;; pop-global-mark ;; TODO: put this under a different binding
;; (define-key xah-fly-key-map (kbd "C-s") nil) ;; save-buffer
;; (define-key xah-fly-key-map (kbd "C-s") nil) ;; save-buffer
;; (define-key xah-fly-key-map (kbd "C-n") nil)     ;; xah-new-empty-buffer TODO
;; (define-key xah-fly-key-map (kbd "C-TAB") nil)   ;; xah-next-user-buffer
;; (define-key xah-fly-key-map (kbd "C-S-TAB") nil) ;; xah-previous-user-buffer
;; (define-key xah-fly-key-map (kbd "C-s") nil)


(define-key xah-fly-key-map (kbd "q") nil) ; reformat lines (extremely annoying when i want to close windows)