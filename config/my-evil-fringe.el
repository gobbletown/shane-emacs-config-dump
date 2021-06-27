(require 'evil-fringe-mark)

(provide 'my-evil-fringe)

; this only works for gui emacs. So forget it.

(setq-default left-fringe-width 16)
(setq-default evil-fringe-mark-side 'left-fringe)
(global-evil-fringe-mark-mode)

;; Display special marks
(setq-default evil-fringe-mark-show-special t)

;; Hide special marks (default)
(setq-default evil-fringe-mark-show-special nil)