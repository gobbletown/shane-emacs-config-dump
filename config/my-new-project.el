(defun selection-new-project (&optional input)
  (interactive)
  (if (not input)
      (setq input (my/selected-text)))
  (sn "play-spacy" input))

(define-key global-map (kbd "H-S") 'selection-new-project)

(provide 'my-new-project)