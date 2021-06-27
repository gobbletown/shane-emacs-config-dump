(require 'highlight-indent-guides)

(setq highlight-indent-guides-method 'column)

;; (set-face-background 'highlight-indent-guides-even-face "#0f0f0f")
(set-face-background 'highlight-indent-guides-even-face nil)
(set-face-background 'highlight-indent-guides-odd-face "#202020")
; (set-face-foreground 'highlight-indent-guides-character-face "dimgray")
; (set-face-foreground 'highlight-indent-guides-character-face "#ff0000")

;; This prevents the highlighting from resetting
(setq highlight-indent-guides-auto-enabled nil)

(provide 'my-highlight-indent-guides)