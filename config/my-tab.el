(require 'company)

;; This is bad

;; (defun my/easy-tab ()
;;   (eval `(define-key ,(current-major-mode-map) (kbd "TAB") 'company-complete)))
;; (add-hook 'haskell-mode-hook 'my/easy-tab t)
;; (add-hook 'python-mode-hook 'my/easy-tab t)
;; (add-hook 'emacs-lisp-mode-hook 'my/easy-tab t)
;; (add-hook 'racket-mode-hook 'my/easy-tab t)

(provide 'my-tab)