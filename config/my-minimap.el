;; In the terminal, this is not a minimap
(use-package minimap
  :commands
  (minimap-bufname minimap-create minimap-kill)
  :custom
  ;; (minimap-major-modes '(prog-mode))
  (minimap-window-location 'right)
  (minimap-update-delay 0.2)
  (minimap-minimum-width 20)
  :bind
  ;; ("M-t p" . ladicle/toggle-minimap)
  :preface
  (defun ladicle/toggle-minimap ()
    "Toggle minimap for current buffer."
    (interactive)
    (if (null minimap-bufname)
        (minimap-create)
      (minimap-kill)))
  :config
  (custom-set-faces
   '(minimap-active-region-background
     ((((background dark)) (:background "#555555555555"))
      (t (:background "#C847D8FEFFFF"))) :group 'minimap)))

(provide 'my-minimap)