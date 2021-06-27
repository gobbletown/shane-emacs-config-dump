(require 'dictionary)

(defun en (word)
  "Look up word"
  (interactive)
  (dictionary-new-search (cons word dictionary-default-dictionary)))

(provide 'my-dictionary)