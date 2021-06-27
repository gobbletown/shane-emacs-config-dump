(require 'key-chord)

;; I'm not a big fan of chords yet
;; They're actually awful

;; Order of keys doesn't matter
;;(key-chord-define-global "FF" 'find-file)
;;(key-chord-define-global "up" 'beginning-of-buffer)
;;(key-chord-define-global "jk" 'end-of-buffer)

(key-chord-mode +1)

;;Exit insert mode by pressing j and then j quickly
(setq key-chord-two-keys-delay 0.5)
(key-chord-define evil-insert-state-map "jj" 'evil-normal-state)
(key-chord-mode 1)