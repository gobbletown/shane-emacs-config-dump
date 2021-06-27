(add-to-list 'load-path (concat emacsdir "/manual-packages/org-roam"))

(require 'org-roam)

;; (setq org-roam-directory "/home/shane/notes")

(setq org-roam-directory "~/org-roam")

(add-hook 'after-init-hook 'org-roam-mode)

; Use this script to symlink all my org files
; $SCRIPTS/build-org-roam-links.sh

;; (use-package org-roam
;;   ;; :hook
;;   ;; (after-init . org-roam-mode)
;;   ;; :straight (:host github :repo "jethrokuan/org-roam")
;;   :custom
;;   (org-roam-directory "/home/shane/notes")
;;   :bind (:map org-roam-mode-map
;;               (("C-c n l" . org-roam)
;;                ("C-c n f" . org-roam-find-file)
;;                ("C-c n g" . org-roam-show-graph))
;;               :map org-mode-map
;;               (("C-c n i" . org-roam-insert))))

(provide 'my-org-roam)