(require 'robe)

;; https://dev.to/thiagoa/ruby-and-emacs-tip-advanced-pry-integration-33bk

;; sudo -E gem install rubocop

(define-key robe-mode-map (kbd "M-.") nil)


(defun my/ruby-mode-hook ()
  (interactive)
  (add-to-list 'company-backends 'company-lsp)
  ;; (remove-from-list 'company-backends 'company-complete)
  )

(add-hook 'ruby-mode-hook 'my/ruby-mode-hook t)


(provide 'my-ruby)