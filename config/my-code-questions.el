(defun tm-code-question (question)
  (interactive (list (read-string-hist "code-question: ")))
  (sps (cmd "tcq" question)))
(defalias 'tcq 'tm-code-question)

(provide 'my-code-questions)