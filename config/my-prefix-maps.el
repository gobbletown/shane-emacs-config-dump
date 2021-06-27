(provide 'my-prefix-maps)

;; This is a lot nicer than hydra
;; $EMACSD/config/hydra.el
;; I have disabled the hydra.
(if t
    (progn
      (define-prefix-command 'endless/toggle-map)
      ;; The manual recommends C-c for user keys, but C-x t is
      ;; always free, whereas C-c t is used by some modes.
      (define-key ctl-x-map "t" 'endless/toggle-map)
      (define-key endless/toggle-map "c" #'column-number-mode)
      (define-key endless/toggle-map "d" #'toggle-debug-on-error)
      (define-key endless/toggle-map "e" #'toggle-debug-on-error)
      (define-key endless/toggle-map "f" #'auto-fill-mode)
      (define-key endless/toggle-map "l" #'toggle-truncate-lines)
      (define-key endless/toggle-map "q" #'toggle-debug-on-quit)
      (define-key endless/toggle-map "t" #'endless/toggle-theme)
;;; Generalized version of `read-only-mode'.
      (define-key endless/toggle-map "r" #'dired-toggle-read-only)
      (autoload 'dired-toggle-read-only "dired" nil t)
      (define-key endless/toggle-map "w" #'whitespace-mode)
      )
  )