(provide 'my-dumb-jump)

;; Jump to definitions using ag
(use-package dumb-jump
  :bind (
         ("M-g o" . dumb-jump-go-other-window)
         ("M-g j" . dumb-jump-go)
         ("M-g q" . dumb-jump-quick-look))
  :config
  (setq dumb-jump-selector 'helm)
  (setq dumb-jump-prefer-searcher 'ag))