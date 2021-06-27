(if (cl-search "EXORDIUM" my-daemon-name)
    (exordium-global-display-line-numbers-mode -1)
    ;; (add-hook 'after-init-hook
    ;;           (lambda ()
    ;;             (exordium-global-display-line-numbers-mode -1)
    ;;             ;; (custom-set-variables '(exordium-display-line-numbers nil))
    ;;             ))
  )

(provide 'my-exordium)