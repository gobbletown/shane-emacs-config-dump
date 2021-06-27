;; Frank sent me this
;; It's cool because this decodes stuff.

;; Emacs already interprets these
;; My tmux converts C-left into left

;; (add-hook 'buffer-list-update-hook
;;           '(lambda ()
;;              (unless (display-graphic-p)
;;                (if (equal major-mode 'org-mode)
;;                    (progn
;;                      (define-key input-decode-map "\e[1;5D" [M-left])
;;                      (define-key input-decode-map "\e[1;5C" [M-right]))
;;                  (define-key input-decode-map "\e[1;5D" [C-left])
;;                  (define-key input-decode-map "\e[1;5C" [C-right])))))

(provide 'my-tty)