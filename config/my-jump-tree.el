(require 'jump-tree)

(global-jump-tree-mode 1)

(define-key my-mode-map (kbd "C-o") #'my-holy-jump)

(advice-add 'jump-tree-visualize-jump-next :around #'ignore-errors-around-advice)

(defun my-holy-jump ()
  (interactive)
  (cond
   ((>= (prefix-numeric-value current-prefix-arg) 4)
    (progn
      ;; None of these seem to work at all
      ;; (call-interactively 'evil-jump-forward)
      ;; (call-interactively 'jump-tree-jump-next)
      ;; (call-interactively 'jump-tree-buffer-next)
      (jump-tree-visualize)
      (ekm "<down>")
      ;; It saves (doesn't keep in the same part of the tree, when you quit the visualiser)
      ;; That's the problem
      (jump-tree-kill-visualizer)))
   (t
    (progn
      ;; (call-interactively 'evil-jump-backward)
      ;; This appears to not even work
      ;; (call-interactively 'jump-tree-jump-prev)
      ;; (call-interactively 'jump-tree-buffer-prev)

      (jump-tree-visualize)
      (ekm "<up>")
      ;; It saves (doesn't keep in the same part of the tree, when you quit the visualiser)
      ;; That's the problem
      (jump-tree-kill-visualizer)))))
(advice-add 'jump-tree-visualize-jump-prev :around #'ignore-errors-around-advice)

(define-key jump-tree-map (kbd "M-.") nil)

(provide 'my-jump-tree)