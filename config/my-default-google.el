(defset my-mode-default-google-queries
  '((terraform-mode . ("terraform providers"))
    (emacs-lisp-mode . ("elisp"))))

(defun mode-default-google-search ()
  (interactive)

  (let ((l (assoc major-mode my-mode-default-google-queries))
        (ms (sym2str major-mode)))
    (if l
        (let ((q (fz (cdr l) nil nil (concat ms " queries:"))))
          (if (sor q)
              (egr (read-string-hist (format "egr (%s): " ms) q)))))))

(provide 'my-default-google)