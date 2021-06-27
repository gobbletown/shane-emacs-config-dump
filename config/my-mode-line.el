;; ;; disable status line from current buffer
;; (setq mode-line-format nil)
;; ;; disable status line from all future buffers
;; (setq-default mode-line-format nil)

;; Originally
;; (setq mode-line-buffer-identification (propertized-buffer-identification "%12b"))

(defun mode-line-buffer-file-parent-directory ()
  (when buffer-file-name
    (concat "[" (file-name-nondirectory (directory-file-name (file-name-directory buffer-file-name))) "/" (basename buffer-file-name) "]")))

(setq-default mode-line-buffer-identification
              (cons (car mode-line-buffer-identification) '((:eval (mode-line-buffer-file-parent-directory)))))

(provide 'my-mode-line)