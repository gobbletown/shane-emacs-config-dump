(require 'jenkins)

(setq jenkins-api-token "11efd3e74dd66a51ebd8fb86f685e746fe")
(setq jenkins-url "http://localhost:8080")
(setq jenkins-username "admin")

(define-derived-mode jenkins-mode tabulated-list-mode "Jenkins"
  "Special mode for jenkins status buffer."
  ;; (setq truncate-lines t)
  ;; (kill-all-local-variables)
  (setq mode-name "Jenkins")
  (setq major-mode 'jenkins-mode)
  ;; (use-local-map jenkins-mode-map)
  ;; (hl-line-mode 1)
  (setq tabulated-list-format (jenkins-list-format))

  ;; It's strange that I had to manually add this as the hooks dont work
  (tablist-mode)

  (setq tabulated-list-entries 'jenkins--refresh-jobs-list)
  (tabulated-list-init-header)
  (tabulated-list-print)
  ;; (run-hooks 'tabulated-list-mode-hook)
  )

(provide 'my-jenkins)