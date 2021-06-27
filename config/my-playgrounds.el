(defun term-pg-for-mode-or-lang (&optional lang)
  ;; (interactive (list (read-string "lang:")))
  (interactive)
  (if (not lang)
      (setq lang (detect-language)))
  (nw (concat "pg " lang)))

(provide 'my-playgrounds)