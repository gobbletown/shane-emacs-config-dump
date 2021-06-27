(provide 'my-rainbow)

;; This puts it everywhere. I hope it doesn't cause problems

; (exit)
; (tvipe "hi")
;; I really don't need this rubbish
;; (my/with 'rainbow-delimiters
;;          (progn
;;            (define-globalized-minor-mode
;;              global-rainbow-delimiters-mode
;;              rainbow-delimiters-mode
;;              rainbow-delimiters-mode)
;;            (global-rainbow-delimiters-mode 1)))

(my/with 'rainbow-identifiers
         (progn
           (define-globalized-minor-mode
             global-rainbow-identifiers-always-mode
             rainbow-identifiers-mode
             rainbow-identifiers-mode)

           ;; It's not good. Don't do it. Was this making exordium horrible?
           ;; (if (not (cl-search "SPACEMACS" my-daemon-name))
           ;;     (global-rainbow-identifiers-always-mode 1))
           ))