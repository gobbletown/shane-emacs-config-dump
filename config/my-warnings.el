(require 'recentf)
(require 'warnings)

;; (custom-set-variables
;;  ;; custom-set-variables was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(warning-suppress-types (quote ((undo discard-info)))))

;; I can't figure out how to disable these damn warnings properly, so I did this
(setq warning-minimum-level :error)

;; I can't figure out how to disable these damn warnings properly
(add-to-list 'warning-suppress-types (quote ((undo discard-info))))
(add-to-list 'warning-suppress-types '(yasnippet backquote-change))

(provide 'my-warnings)