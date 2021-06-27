(defvar pair-programming--pair-programmer
  nil
  "The current pair programmer as (name email)")

(defun enable-pair-programming-mode ()
  "Sets visuals for pair programming mode and prompt for your buddy."
  (global-display-line-numbers-mode 1)
  (let ((pair-programmer (git-commit-read-ident nil)))
    (setq pair-programming--pair-programmer pair-programmer)
    (message (concat "Pair programming with " (car pair-programmer)))))

(defun disable-pair-programming-mode ()
  "Disable pair programming visuals and settings."
  (setq pair-programming--pair-programmer nil)
  (global-display-line-numbers-mode -1)
  (message "PP mode disabled"))

(define-minor-mode pair-programming-mode ()
  "Toggle Pair Programming Mode.

This prompts for a pair programmer from your current git commit history.
When you commit with (ma)git, the pair programmer is inserted as a co-author.
Additionally, line number mode is enabled."
  :global t
  :lighter " PP"
  (if pair-programming-mode
      (enable-pair-programming-mode)
    (disable-pair-programming-mode)))

(defun insert-pair-programmer-as-coauthor ()
  "Insert your pair programer into the current git commit."
  (when (and pair-programming-mode git-commit-mode)
    (pcase pair-programming--pair-programmer
      (`(,name ,email) (git-commit-insert-header "Co-authed-by" name email))
      (_ (error "No pair programmer found or wrong content")))))

(add-hook 'git-commit-setup-hook 'insert-pair-programmer-as-coauthor)
(remove-hook 'git-commit-setup-hook 'insert-pair-programmer-as-coauthor)

(provide 'my-pair-programming)