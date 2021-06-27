(require 'gitignore-mode)

(define-key gitignore-mode-map (kbd "C-c TAB") #'gitignore-templates-insert)

(provide 'my-gitignore)