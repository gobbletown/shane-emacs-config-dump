;; (use-package deft
;;   :bind ("<f8>" . deft)
;;   :commands (deft)
;;   :config (setq deft-directory "~/Dropbox/notes"
;;                 deft-extensions '("md" "org")))


;; (sh-notty "cd $HOME/.deft; find -L $NOTES/ws/glossaries -type f -exec ln -sf {} \\;")
;; $HOME/scripts/deft

(use-package deft
  ;; :bind ("<f8>" . deft)
  ;; This is horrible. It uses the global map
  ;; :bind (("M-DEL" . deft-filter-decrement-word)
  ;;        ("C-w" . deft-filter-decrement-word))
  :commands (deft)
  :config
  (setq deft-directory "~/.deft"
        deft-extensions '("txt" "md" "org"))
  (setq deft-recursive t))

(require 'deft)

;; Fix bindings
;; (define-key global-map (kbd "M-DEL") #'backward-kill-word)
;; (define-key global-map (kbd "C-w") #'kill-region)

;; purcell
;; (define-key global-map (kbd "C-w") #'whole-line-or-region-kill-region)


(define-key deft-mode-map (kbd "M-DEL") #'deft-filter-decrement-word)
(define-key deft-mode-map (kbd "C-w") #'deft-filter-decrement-word)
(define-key deft-mode-map (kbd "C-k") #'deft-filter-clear)



(provide 'my-deft)