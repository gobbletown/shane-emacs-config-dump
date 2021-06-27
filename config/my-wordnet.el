(require 'wordnut)
(require 'define-it)

(df spv-wordnut () (spv (concat "wu " (selection))) (deselect))

(defun dict-word (word)
  (interactive (list (my/thing-at-point)))
  (if (>= (prefix-numeric-value current-prefix-arg) 4)
      (define-it word)
    (wordnut-lookup-current-word)))

(define-key wordnut-mode-map (kbd "M-9") 'dict-word)

(provide 'my-wordnet)