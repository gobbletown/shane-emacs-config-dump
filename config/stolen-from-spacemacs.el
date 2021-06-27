(require 'comint)
(require 'eshell)
(require 'shell)
(require 'term)

(defun spacemacs/disable-hl-line-mode ()
  "Locally disable global-hl-line-mode"
  (interactive)
  (setq-local global-hl-line-mode nil))

(add-hook 'comint-mode-hook 'spacemacs/disable-hl-line-mode)
(add-hook 'eshell-mode-hook 'spacemacs/disable-hl-line-mode)
(add-hook 'shell-mode-hook 'spacemacs/disable-hl-line-mode)
(add-hook 'term-mode-hook 'spacemacs/disable-hl-line-mode)

(provide 'stolen-from-spacemacs)