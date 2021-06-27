

;; M-m is better than M-l


;; This is not the same as change dir / cd. If you're in ranger, then open with ranger, etc.
(defun my-open-dir (dir)
  (setq dir (umn dir))
  (cond
   ;; Both dired-mode and ranger-mode can be true at the same time. Therefore, ranger must precede
   ((major-mode-p 'ranger-mode) (ranger dir))
   ((major-mode-p 'dired-mode) (dired dir))
   (t (dired dir))))


(df fz-find-ws (e (concat "$NOTES/ws/" (fz (b find "$NOTES/ws" -type d -mindepth 1 -maxdepth 1 | sed "s=.*/==") nil nil "fz-find-ws: "))))
(df fz-find-dir (e (fz (cat "$NOTES/directories.org") nil nil "fz-find-dir: ")))
(df fz-find-src (e (fz (cat "$NOTES/files.txt") nil nil "fz-find-src: ")))
(df fz-find-config (e (fz (b tm-list-config | mnm | s uniq) nil nil "fz-find-config: ")))

(defun swiper-swiper-dir (&optional dir)
  (interactive (list (read-string-hist "swiper dir:")))
  (with-current-buffer
      (dired dir)
    (call-interactively 'swiper)
    (ekm "RET")
    (call-interactively 'swiper)
    ;; (call-interactively 'my-counsel-ag)
    ))

(defun swiper-swiper-glossaries ()
  (interactive)
  (swiper-swiper-dir "/home/shane/glossaries"))

(defun ag-glossaries ()
  (interactive)
  (ag-dir "/home/shane/glossaries"))

(defun swiper-glossaries ()
  (interactive)
  (swiper-dir "/home/shane/glossaries"))

(defun ag-ws ()
  (interactive)
  (dired "/home/shane/notes/ws"))

;; (mu (s-replace-regexp "^$DUMP\\(.*\\)$" "\\1" "/home/shane/dump/home/shane/notes"))

(defun dired-toggle-dumpd-dir ()
  (interactive)
  (mu (let* ((cwd (umn (my/pwd)))
             (newdir (if (string-match-p "^$DUMP" cwd)
                         (s-replace-regexp "^$DUMP\\(.*\\)$" "\\1" "/home/shane/dump/home/shane/notes")
                       (concat "$DUMP" cwd))))
        (/mkdir-p newdir)
        (my-open-dir newdir))))

(define-key dired-mode-map (kbd "M-c") 'dired-toggle-dumpd-dir)
(define-key ranger-mode-map (kbd "M-c") 'dired-toggle-dumpd-dir)

;; (ms "/M-m/{p;s/M-m/M-l/}"
;;     (define-key my-mode-map (kbd "M-m d w") 'fz-find-ws))

(defun dired-fz-git-repo ()
  (interactive)
  (let ((sel (fz (chomp (sn "list-git-repos"))))
        (dir (concat "/home/shane/source/git/" sel)))
    (if (and (string-or sel) (f-directory-p dir)))))



(provide 'my-directory-navigation)