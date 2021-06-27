;; (defun my-update-header ()
;;   (mapc
;;    (lambda (window)
;;      (with-current-buffer (window-buffer window)
;;        ;; don't mess with buffers that don't have a header line
;;        (when header-line-format
;;          (let ((original-format (get 'header-line-format 'original))
;;                (inactive-face 'warning)) ; change this to your favorite inactive header line face
;;            ;; if we didn't save original format yet, do it now
;;            (when (not original-format)
;;              (put 'header-line-format 'original header-line-format)
;;              (setq original-format header-line-format))
;;            ;; check if this window is selected, set faces accordingly
;;            (if (eq window (selected-window))
;;                (setq header-line-format original-format)
;;              (setq header-line-format `(:propertize ,original-format face ,inactive-face)))))))
;;    (window-list)))

;; (defun my-update-header ()
;;   (mapc
;;    (lambda (window)
;;      (with-current-buffer (window-buffer window)
;;        (if (eq window (selected-window))
;;            (setq header-line-format (propertize "selected" 'face 'mode-line))
;;          (setq header-line-format (propertize "inactive" 'face 'mode-line-inactive)))))
;;    (window-list)))

(defface my-header-line-face-active
  '((t :foreground "#d2268b"
       :background "#111111"
       :weight bold
       :underline t))
  "Face for org-mode bold."
  :group 'header-line-faces)

(defsetface my-header-line-face-active
  '((t :foreground "#991111"
       :background "#111111"
       :weight bold
       :underline t))
  "Face for org-mode bold.")

(defface my-header-line-face-inactive
  '((t :foreground "#8bd226"
       :background "#2e2e2e"
       :weight normal
       :slant italic
       :underline t))
  "Face for org-mode italic."
  :group 'header-line-faces)

(defsetface my-header-line-face-inactive
  '((t :foreground "#333333"
       :background "#111111"
       :weight normal
       :slant italic
       :underline t))
  "Face for org-mode italic.")

;; (set-face-foreground 'calibredb-date-face "#550099")
;; (set-face-background 'calibredb-date-face nil)

(defun s-no-properties-p (s)
  (equal-including-properties s (substring-no-properties s)))

(defun my-update-header ()
  (mapc
   (lambda (window)
     (with-current-buffer (window-buffer window)
       (if (and
            (not (minor-mode-p lsp-mode))
            (not (minor-mode-p elfeed-mode))
            (not (minor-mode-p ranger-mode))
            ;; (not lsp-ui-doc-header)
            (not (major-mode-p 'calibredb-search-mode))
            (not (major-mode-p 'Info-mode))
            header-line-format
            (sor header-line-format)
            (s-no-properties-p header-line-format))
           (if (eq window (selected-window))
               ;; 'mode-line
               (setq header-line-format (propertize header-line-format 'face 'my-header-line-face-active))
             ;; 'mode-line-inactive
             (setq header-line-format (propertize header-line-format 'face 'my-header-line-face-inactive))))))
   (window-list)))

;; This is breaking info mode
;; Also breaking ranger
;; (add-hook 'buffer-list-update-hook #'my-update-header)
;; (remove-hook 'buffer-list-update-hook #'my-update-header)

(require 'tablist)
;; I think it doesn't need to be added to shrink. Enlarge may call shrink
(advice-add 'tablist-enlarge-column :after '(lambda (&rest args) (my-update-header)))

;; (remove-hook 'buffer-list-update-hook #'my-update-header)

(provide 'my-header-line)