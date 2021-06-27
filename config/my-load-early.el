;; before my-org.el and my-eww.el
(defsetface eww-cached
  '((t :foreground "#6699cc"
       :background "#331111"
       :weight bold
       :underline t))
  "Face for cached urls.")

(provide 'my-load-early)