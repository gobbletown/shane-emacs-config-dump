(provide 'my-basic.el)

(defun str (thing)
  "Converts object or string to an unformatted string."
  (setq thing (format "%s" thing))
  (set-text-properties 0 (length thing) nil thing)
  thing)

;; This is like (q)
(defun e/escape-string (string)
  (let ((print-escape-newlines t))
    (prin1-to-string string)))
(defalias 'e/q 'e/escape-string)

;; this will get redefined with an improved version
;; this has to work even when debug startup crashes
(defun tmux-edit (&optional editor)
  "Simple function that allows us to open the underlying file of a buffer in an external program."
  (interactive)
  (if (not editor)
      (setq editor "v"))

  (let ((line-and-col (cc "+" (line-number-at-pos) ":" (current-column))))
    (if buffer-file-name
        (progn
          (save-buffer)
          ;; this uses sph because it's more useful when emacs crashes
          ;; and I want to split the debug window
          (shell-command (concat "tm -d -te sph -fa " editor " " line-and-col " " (e/q buffer-file-name))))
      (shell-command-on-region (point-min) (point-max) (concat "tsph -fa " editor " " line-and-col)))))

;; These definitions are overridden in shane-minor-mode.el
;; These exists to work when startup crashes
;; This is also unbound when global-command-log-mode is enabled
(global-set-key (kbd "C-c o") 'tmux-edit)

;; (global-set-key (kbd "C-c O") (df tmux-edit-vs (tmux-edit "vs")))