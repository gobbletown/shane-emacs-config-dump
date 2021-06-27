(require 'luarocks)
(require 'company-lua)
(require 'flymake-lua)
(require 'auctex-lua)
(require 'lua-eldoc-mode)

;; e ia luarocks company-lua flymake-lua auctex-lua

(defun lua-mode-hook-after ()
  (interactive)
  (add-to-list 'company-backends 'company-lua))

(add-hook 'lua-mode-hook 'lua-mode-hook-after t)
(add-hook 'lua-mode-hook 'lua-eldoc-mode)

(provide 'my-lua)