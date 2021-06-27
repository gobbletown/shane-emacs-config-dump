;; But does this avoid opening? Try on pkl and see
(defun open-doc-as-text (&optional fp)
  ;; Is there a way to fully abort opening a file? videos take too long

  (if (not fp)
      (setq fp (get-path)))
  (let* ((dn (f-dirname fp))
         (bn (basename fp))
         (fn (file-name-sans-extension bn))
         (ext (file-name-extension bn)))

    (cond ((or (string-equal "pdf" ext)
               (string-equal "PDF" ext))
           (if (>= (prefix-numeric-value current-prefix-arg) 16)
               (progn
                 (sn "pdfs2txt" nil dn)
                 (let ((b (current-buffer)))
                   (find-file (concat dn "/" fn ".txt"))
                   (kill-buffer b)))
             (progn
               (if (yn "Add to calibredb?")
                   (progn
                     (calibredb-command :command "add"
                                        :input (shell-quote-argument (expand-file-name fp))
                                        :library (format "--library-path %s" (calibredb-root-dir-quote)))
                     (with-current-buffer (call-interactively 'calibredb)
                       (call-interactively 'calibredb-search-refresh-and-clear-filter)))
                 ;; (calibredb-counsel-add-file-action fp)
                 ))
             (if (or (>= (prefix-numeric-value current-prefix-arg) 4)
                     (not (yn "Open text form?")))
                 (progn
                   (kill-buffer (current-buffer))
                   ;; (r fp)
                   (sn (concat "z " (q fp)) nil nil nil t))
               (progn
                 (sn "pdfs2txt" nil dn)
                 (let ((b (current-buffer)))
                   (find-file (concat dn "/" fn ".txt"))
                   (kill-buffer b))))))

          ((string-equal "ipynb" ext)
           (progn
             (sn (concat "ipynb2py " (q bn)) nil dn)
             (let ((b (current-buffer)))
               (find-file (concat dn "/" fn ".py"))
               (kill-buffer b))))

          ((string-equal "emacsprofiler" ext)
           (let ((b (current-buffer)))
               (profiler-find-profile fp)
               (kill-buffer b)))

          ;; edbi-sqlite
          ((or (string-equal "sqlite" ext)
               (string-equal "sqlite3" ext)
               (string-equal "sqlitedb" ext)
               (string-equal "db" ext)
               (string-equal "db3" ext))
           (progn
             (let ((b (current-buffer)))
               (edbi-sqlite fp)
               (kill-buffer b))))

          ;; ((istr-match-p "md" ext)
          ;;  ;; save excursion fixes a wandering cursor
          ;;  ;; but it also shows the contents of the file which is being opened
          ;;  (save-excursion
          ;;    (eval `(hyn "Render md with glow"
          ;;                ;; (new-buffer-from-string (sn (concat "glow " (q ,fp) " | cat")) nil 'text-mode)
          ;;                (sps (concat "glow " (q ,fp) " | mnm | vs"))
          ;;                (find-file ,fp)))))
          ((istr-match-p "html" ext)
           ;; save excursion fixes a wandering cursor
           ;; but it also shows the contents of the file which is being opened
           (save-excursion
             (eval `(hyn "Open in eww"
                         (progn
                           (with-current-buffer (find-file ,fp)
                             (kill-buffer (current-buffer)))
                           (eww-open-file ,fp))
                         (find-file ,fp)
                         (not (>= (prefix-numeric-value current-prefix-arg) 4))))))
          ((string-equal "svg" ext)
           ;; (snd (concat "fehdf " (q fp)))
           ;; (save-excursion
           ;;   (eval `(hyn "Open in feh"
           ;;               (progn
           ;;                 (with-current-buffer (find-file ,fp)
           ;;                   (kill-buffer (current-buffer)))
           ;;                 (snd (concat "fehdf " (q ,fp))))
           ;;               (find-file ,fp))))

           ;; save excursion wont work for org-open-at-point
           ;; I need to wrap around org-open-at-point


           (if (>= (prefix-numeric-value current-prefix-arg) 4)
               (find-file fp)
             ;; (with-current-buffer (find-file fp)
             ;;   (kill-buffer (current-buffer)))
             (progn
               ;; This lambda works to kill the buffer and keep the current position in an org file
               (eval `(run-with-timer 0.1 nil (lambda () (kill-buffer (find-file ,fp)))))
               (snd (concat "fehdf " (q fp))))))

          ;; This is cool, but term just isnt able to render images well
          ;; I can reinstate this when I am using libvterm
          ((string-equal "jpg" ext)
           (let ((b (current-buffer)))
             (term-nsfa (concat "win ie " (q fp)))
             ;; (my/term "vim")
             (kill-buffer b)))
          ((string-equal "pkl" ext)
           (let ((b (current-buffer)))
             (sps (concat "orpy " (q fp)))
             (kill-buffer b))))))

;; It matters where in the list it is
;; The sooner the better
(remove-hook 'find-file-hooks 'open-doc-as-text)
(add-hook 'find-file-hooks 'open-doc-as-text)


(defun open-main ()
  (interactive)
  (let* ((cwd (get-dir))
         (dir (if (>= (prefix-numeric-value current-prefix-arg) 4)
                  (get-top-level)))
         (found (sor (fz (chomp (sn "open-main" nil dir)) nil nil nil nil t) nil)))
    (if found
        ;; (find-file found)
        (let ((path (s-replace-regexp "^\\([^:]+\\).*" "\\1" found))
              (pos (s-replace-regexp "^[^:]+:\\([0-9]+\\):.*" "\\1" found)))
          (with-current-buffer (find-file (if dir
                                              (concat dir "/" path)
                                            (concat cwd path)))
            ;; (goto-char (string-to-int pos))
            (goto-byte (string-to-int pos))))
      (message "Main function not found")
      ;; (etv found)
      )))

(define-key global-map (kbd "H-o") 'open-main)


(defun find-repo-by-ext (&optional ext)
  (interactive (list (read-string-hist "find-repo-by-ext ext: ")))
  (if (sor ext)
      (let ((repo (chomp (fz (sn (concat "oci list-repos-with-ext " ext))))))
        (if repo
            (e (concat "$MYGIT/" repo))))))

(define-key global-map (kbd "H-E") 'find-repo-by-ext)
(define-key global-map (kbd "H-t e") 'find-repo-by-ext)

(defun find-repo-by-content (&optional content)
  (interactive (list (read-string-hist "find-repo-by-content content: ")))
  (if (sor content)
      (let ((repo (chomp (fz (sn (concat "oci list-repos-containing " content))))))
        (if repo
            (e (concat "$MYGIT/" repo))))))

(define-key global-map (kbd "H-t t") 'find-repo-by-content)
(define-key global-map (kbd "H-t c") 'find-repo-by-content)

(defun list-mygit-for-paths (paths-string)
  (-non-nil (mapcar 'sor (str2list (chomp (sn "grep -P \"^/home/shane/source/git\" | sed \"s=^/home/shane/source/git/==\" | path-firsttwo | uniqnosort" paths-string))))))


(defun find-repo-by-path (&optional path-pat)
  (interactive (list (read-string-hist "find-repo-by-path pattern: ")))
  (if (sor path-pat)
      (let ((repo (fz (list-mygit-for-paths (sn (concat "oci locate -r " path-pat " | mnm | umn"))))))
        (if repo
            (e (concat "$MYGIT/" repo))))))


(define-key global-map (kbd "H-t f") 'find-repo-by-path)


;; (provide 'my-pdfs)
(provide 'my-find-file)