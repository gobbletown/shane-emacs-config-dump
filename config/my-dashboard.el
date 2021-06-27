;; dashboard appears to have broken lsp-mode as well

;; Appears to have broken purcell

;; (use-package dashboard
;;   :diminish
;;   (dashboard-mode page-break-lines-mode)
;;   :custom
;;   (dashboard-center-content t)
;;   (dashboard-startup-banner 4)
;;   (dashboard-items '((recents . 15)
;;                      (projects . 5)
;;                      (bookmarks . 5)))
;;   :custom-face
;;   (dashboard-heading ((t (:foreground "#f1fa8c" :weight bold))))
;;   :hook
;;   (after-init . dashboard-setup-startup-hook))


(defun my/dashboard-banner ()
  """Set a dashboard banner including information on package initialization
   time and garbage collections."""
  (setq dashboard-banner-logo-title
        (format "Emacs ready in %.2f seconds with %d garbage collections."
                (float-time (time-subtract after-init-time before-init-time)) gcs-done)))

(use-package dashboard
  :init
  (add-hook 'after-init-hook 'dashboard-refresh-buffer)
  (add-hook 'dashboard-mode-hook 'my/dashboard-banner)
  :config
  (setq dashboard-startup-banner 'logo)
  (dashboard-setup-startup-hook))


(require 'dashboard)


(require 'dashboard-hackernews)
;; (setq dashboard-items '((hackernews . 10)))
;; (add-to-list 'dashboard-items '(hackernews . 10))

(setq dashboard-footer
      (let ((list '("The one true editor, Emacs!"
                    "Free as free speech, free as free Beer"
                    "Happy coding!")))
        (nth (random (1- (1+ (length list)))) list)))

(provide 'my-dashboard)