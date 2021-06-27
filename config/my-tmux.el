;; It would be nice to have a preview, though
(defun tmux-find-text-in-panes (query)
  (interactive (list (read-string-hist "tmux-find-text-in-panes: ")))
  (let ((sel (fz (snc (cmd "find-text-in-terminals" query))
                 nil nil "tmux-find-text-in-panes copy: ")))
    (if (interactive-p)
        (xc sel)
      sel)))

(defun tmux-list-panes (&optional return-full)
  (interactive)

  (let ((sel (fz (snc "tm-lsp.sh")
                 nil nil "tmux-list-panes copy: ")))
    (if (not return-full)
        (setq sel (snc "s field 2" sel)))
    (if (interactive-p)
        (xc sel)
      sel)))

(defun tmux-sel (target)
  (interactive (list (tmux-list-panes)))
  (snc (cmdp "tm" "sel" target)))

(defun tmux-find-and-select (query)
  (interactive (list (read-string-hist "tmux-find-and-select: ")))
  (let ((sel (tmux-find-text-in-panes query)))
    (if (sor sel)
        (tmux-sel sel))))

(defun tmux-pane-capture (&optional show-buffer)
  (interactive)
  ;; Rather than toggle window margins, remove the window margin width from the start of each line
  (let* ((margin-width (or (car (window-margins))
                           0))
         (wincontents (sn (concat "tm cap-pane -nohist | sed \"s/^.\\{" (str margin-width) "\\}//\""))))

    (if (or (interactive-p)
            show-buffer)
        (let ((frame (make-frame-command)
                     ;; termframe
                     ))
          (with-current-buffer (new-buffer-from-string wincontents)
            (defset-local termframe-local frame)
            (current-buffer)))
      wincontents)))
;; If called interactively it makes a window
(defalias 'new-buffer-from-tmux-pane-capture 'tmux-pane-capture)

;; (if (and (variable-p 'frame-local)
;;          frrame-local)
;;     (delete-frame frame-local t))

;; (defun new-buffer-from-tmux-pane-capture ()
;;   (interactive)
;;   (new-buffer-from-string (sh-notty "tm cap-pane -nohist")))

(defun new-buffer-from-tmux-main-capture ()
  (interactive)

  (save-window-excursion
    (let ((b (new-buffer-from-string (sh-notty "tm cap -nohist") "*capture*")))
      (with-current-buffer b
        (get-path)
        (generate-glossary-buttons-over-buffer nil nil nil t))
      (nw (concat "sp -e " (q (concat "(switch-to-buffer " (q (buffer-name b))) ")"))))))

(defun new-buffer-from-tmux-main-capture-to-english ()
  (interactive)
  (new-buffer-from-string (sh-notty "tm cap -nohist | translate-to-english")))


(defun tm-open-buf-in-tmux ()
  (interactive)
  (let ((fp (buffer-file-path)))
    (if (and fp
             (f-exists-p fp))
        (snc (cmd "tm" "open-list-of-files-in-windows" fp)))))

;; Using my-mode-map would mess with lispy and other modes that rely on M-t
(define-key my-mode-map (kbd "M-t M-p") 'tm-open-buf-in-tmux)
(define-key my-mode-map (kbd "M-t M-p") nil)
(define-key my-mode-map (kbd "M-t") nil)


(defun tmux-attach-window (id)
  (interactive (list ;; (read-string-hist "tmux window id: ")
                (snc "s field 2" (fz (snc "tm-lsp.sh")))))
  (if (sor id)
      (term-sps (cmd "tmux-attach-window" id))))
(define-key my-mode-map (kbd "H-t w") 'tmux-attach-window)


(defun tmux-goto-window (id)
  (interactive (list ;; (read-string-hist "tmux window id: ")
                (snc "s field 2" (fz (snc "tm-lsp.sh")))))
  (if (sor id)
      (snc (cmd "tm" "sel" id))))
(define-key my-mode-map (kbd "H-t g") 'tmux-goto-window)


(provide 'my-tmux)