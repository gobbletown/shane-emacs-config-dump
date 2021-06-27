(require 'edbi)

(add-hook 'edbi:sql-mode-hook (lambda () (auto-complete-mode 1)))

(define-key edbi:dbview-keymap (kbd "TAB") (lm (search-forward "|")))
(define-key edbi:dbview-keymap (kbd "<backtab>") (lm (search-backward "|")
                                                     (search-backward "|")
                                                     (forward-char)))


(provide 'my-edbi)