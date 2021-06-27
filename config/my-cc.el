(require 'ccls)

(define-key ccls-tree-mode-map (kbd "TAB") 'ccls-tree-next-line)
(define-key ccls-tree-mode-map (kbd "SPC") 'ccls-tree-toggle-expand)

(provide 'my-cc)