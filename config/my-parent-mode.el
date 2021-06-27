(require 'parent-mode)

(defun parent-modes ()
  (interactive)
  (let ((ms (parent-mode-list major-mode)))
    (my/copy (car (last ms)) nil)
    (message (pp-to-string ms))))
(defalias 'mode-hierarchy 'parent-mode)

(provide 'my-parent-modes)