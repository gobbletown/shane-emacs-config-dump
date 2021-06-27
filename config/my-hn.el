(defun hn (title contents)
  "Search hacker news by title and contents"
  (interactive (list (read-string-hist "hn title:")
                     (read-string-hist "hn contents:")))
  (setq eww-use-chrome nil)
  ;; (eww (cl-sn (concat "SITE=news.ycombinator.com glt -q " (q title) " " (q contents)) :chomp t))
  (helm-google 'google (concat "site:news.ycombinator.com " (q title) " " (q contents))))

(defun gr-hn (query)
  (interactive (list (read-string-hist "hn query:")))
  (org-open-link-from-string (fz (str2lines (snc "oc -u" (scrape ".*news.ycombinator.com.*" (snc (concat (cmd "gl" "news.ycombinator.com") query))))))))

(defun gr-hn ()
  "Search hacker news by google"
  (interactive (list (read-string-hist "hn title:")
                     (read-string-hist "hn contents:")))
  (setq eww-use-chrome nil)
  ;; (eww (cl-sn (concat "SITE=news.ycombinator.com glt -q " (q title) " " (q contents)) :chomp t))
  (helm-google 'google (concat "site:news.ycombinator.com " (q title) " " (q contents))))

(provide 'my-hn)
