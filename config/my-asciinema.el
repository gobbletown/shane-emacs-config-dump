(defun tm-asciinema-play (url)
  (interactive (list (read-string "asciinema url:")))
  ;; (nw (concat "asciinema-play " (q url)))
  (sh-notty (concat "asciinema-play " (q url))))

(provide 'my-asciinema)