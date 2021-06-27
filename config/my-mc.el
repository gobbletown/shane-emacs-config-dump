(require 'multiple-cursors-core)

;; multiple cursors
;; http://pragmaticemacs.com/emacs/multiple-cursors/
(global-set-key (kbd "C-c m c") 'mc/edit-lines)

(define-key global-map (kbd "C-g") 'mc/keyboard-quit)

(provide 'my-mc)