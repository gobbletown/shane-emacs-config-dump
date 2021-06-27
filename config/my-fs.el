(require 'fs-mode)

(defset fs-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "M") 'fs-mount)
    (define-key map (kbd "E") 'fs-umount)
    (define-key map (kbd "F") 'fs-refresh)
    (define-key map (kbd "RET") 'fs-goto-directory)
    (define-key map (kbd "q") 'fs-quit)
    map)
  "fs-mode keymap.")

(provide 'my-fs)
