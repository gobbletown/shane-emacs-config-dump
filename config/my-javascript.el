(provide 'my-javascript)

(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
;; Better imenu
(add-hook 'js2-mode-hook #'js2-imenu-extras-mode)


;; https://github.com/emacs-lsp/lsp-mode/wiki/Using-Plugins-In-Typescript-Language-Server

;; (define-key js-mode-map (kbd "M-.") nil)
(define-key js-mode-map (kbd "M-.") 'handle-godef)

(require 'js2-mode)