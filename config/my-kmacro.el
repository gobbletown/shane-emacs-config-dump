(defun last-kbd-macro-string ()
  (interactive)
  (message "%s " (replace-regexp-in-string "^Last macro: " "" (kmacro-view-macro))))

(defun copy-last-kbd-macro ()
  (interactive)
  (my/copy (q (sed "s/^Last macro: //" (kmacro-view-macro)))))

(provide 'my-kmacro)