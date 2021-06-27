(use-package anzu
  :diminish
  ;; :bind
  ;; ("C-r"   . anzu-query-replace-regexp)
  ;; ("C-M-r" . anzu-query-replace-at-cursor-thing)
  :hook
  (after-init . global-anzu-mode))

(provide 'my-anzu)