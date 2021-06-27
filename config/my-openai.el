(defun find-in-video (path thing)
  (interactive (list (or
                      (and (major-mode-p 'dired-mode)
                           ;; use umn because it may have ~ in the path
                           (sor (umn (car (dired-get-marked-files)))))
                      (fz (mnm (snc "ler avi mp4")))) (read-string-hist "thing in video: ")))
  ;; (zrepl (concat "find-in-video " (q query-or-url) " " (q thing)))
  (sps (concat "find-in-video " (q path) " " (q thing)) "-pak"))

(defun find-in-youtube (query-or-url thing)
  (interactive (let* ((query (read-string-hist "yt query or url: "))
                      (slug (slugify query nil 10))
                      (thing (read-string-hist (concat "thing in video " slug ": "))))
                 (list query thing)))
  (setq query-or-url (ytsearch query-or-url))
  ;; (zrepl (concat "find-in-video " (q query-or-url) " " (q thing)))
  (sps (concat "find-in-video " (q query-or-url) " " (q thing)) "-pak"))

(provide 'my-openai)