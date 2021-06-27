(define-derived-mode clql-mode yaml-mode "clql"
  "major mode for editing clql.")

(define-key clql-mode-map (kbd "C-c '") 'lingo-extract-clql-from-yaml)

(provide 'my-clql-mode)