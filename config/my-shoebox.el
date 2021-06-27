(defun my/shoebox/duplicate-line ()
  (interactive)
  (save-mark-and-excursion
    (beginning-of-line)
    (insert (thing-at-point 'line t))))

(defun my/shoebox/duplicate-line ()
   (interactive)
   (let ((col (current-column)))
     (move-beginning-of-line 1)
     (kill-line)
     (yank)
     (newline)
     (yank)
     (move-to-column col)))

(provide 'my-shoebox)