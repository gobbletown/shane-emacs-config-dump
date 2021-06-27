(require 'k8s-mode)

;; If you're using yas-minor-mode and want to enable on k8s-mode
(add-hook 'k8s-mode-hook 'yas-minor-mode)
;;
;; With use-package style
(use-package k8s-mode
 :ensure t
 :config
 (setq k8s-search-documentation-browser-function 'browse-url-firefox)
 :hook (k8s-mode . yas-minor-mode))

(provide 'my-k8s)