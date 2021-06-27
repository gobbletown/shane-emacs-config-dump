;; This is what caused my auto-mode-load hell
;; (use-package systemd
;;   :mode
;;   ("\\.service\\'" "\\.timer\\'" "\\.target\\'" "\\.mount\\'"
;;    "\\.automount\\'" "\\.slice\\'" "\\.socket\\'" "\\.path\\'"
;;    "\\.netdev\\'" "\\.network\\'" "\\.link\\'"))

(use-package systemd)

 ;; ("\\.network\\'" . systemd)
 ;; ("\\.netdev\\'" . systemd)
 ;; ("\\.path\\'" . systemd)
 ;; ("\\.socket\\'" . systemd)
 ;; ("\\.slice\\'" . systemd)
 ;; ("\\.automount\\'" . systemd)
 ;; ("\\.mount\\'" . systemd)
 ;; ("\\.target\\'" . systemd)
 ;; ("\\.timer\\'" . systemd)
 ;; ("\\.service\\'" . systemd)

:(remove-from-list 'auto-mode-alist '("\\.network\\'" . systemd))
:(remove-from-list 'auto-mode-alist '("\\.netdev\\'" . systemd))
:(remove-from-list 'auto-mode-alist '("\\.path\\'" . systemd))
:(remove-from-list 'auto-mode-alist '("\\.socket\\'" . systemd))
:(remove-from-list 'auto-mode-alist '("\\.slice\\'" . systemd))
:(remove-from-list 'auto-mode-alist '("\\.automount\\'" . systemd))
:(remove-from-list 'auto-mode-alist '("\\.mount\\'" . systemd))
:(remove-from-list 'auto-mode-alist '("\\.target\\'" . systemd))
:(remove-from-list 'auto-mode-alist '("\\.timer\\'" . systemd))
:(remove-from-list 'auto-mode-alist '("\\.service\\'" . systemd))

(provide 'my-systemd)