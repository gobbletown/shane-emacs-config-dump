(require 'evil-escape)

;; I want to disable 'fd' chord

(setq evil-escape-key-sequence (kbd "fd"))

;; This disables it, but now I may as well remove evil-escape
(setq evil-escape-inhibit t)

(provide 'my-evil-escape)