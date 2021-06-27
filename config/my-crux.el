(require 'crux)

(use-package crux
  :bind
  (
   ;; ([remap move-beginning-of-line] . crux-move-beginning-of-line)
   ;; ("C-x 4 t" . crux-transpose-windows)
   ;; ("C-x K" . crux-kill-other-buffers)
   ;; ("C-k" . crux-smart-kill-line)
   ;; ("RET" . crux-smart-open-line)
   )
  :config
  (crux-with-region-or-buffer indent-region)
  (crux-with-region-or-buffer untabify)
  (crux-with-region-or-point-to-eol kill-ring-save)
  (defalias 'rename-file-and-buffer #'crux-rename-file-and-buffer))

(provide 'my-crux)