(defun widget-at-point (&optional p)
  (if (not p)
      (setq p (point)))
  (widget-at p))

;; v +/"(defun widget-get-action (widget &optional event)" "$EMACSD/config/my-right-click-context.el"

(provide 'my-widgets)