;; See
;; $EMACSD/config/my-x.el

(defun git-get-top-fast ()
  (locate-dominating-file default-directory ".git"))

(defun sh/git-get-commit-message ()
  (e/chomp (sh-notty "git get-commit-message")))

(defun sh/git-amend-all-below ()
  "Show git amend in tmux."
  (interactive)
  (let ((mess (sh/git-get-commit-message)))
    (save-buffer)
    (sh-notty (concat "git add -A .; git amend"))
    (revert-buffer nil t)
    (message (concat "Amended -A . with original message " (q mess)))))

(defun sh/git-add-all-below ()
  (interactive)
  (let ((mess (e/chomp (vime "strftime(\"%c\")"))))
    (if (buffer-file-name)
        (save-buffer))
    (sh-notty (concat "git add -A .; git commit -m " (q mess)))
    (save-excursion
      (if (buffer-file-name)
          (save-buffer)))
    (message (concat "Committed -A . with message " (q mess)))))

(defun sh/git-get-url ()
  (sh-notty "git config --get remote.origin.url"))


(use-package gitattributes-mode :defer t)

(defun gitattributes-whitespace-apply-around-advice (proc &rest args)
  (let ((res (ignore-errors (apply proc args))))
    res))
(advice-add 'gitattributes-whitespace-apply :around #'gitattributes-whitespace-apply-around-advice)

(use-package gitconfig-mode :defer t)
(use-package gitignore-mode :defer t)

(use-package github-pullrequest)

(defun git-d-unstaged (&optional path)
  (interactive)
  (if (not path)
      (setq path (get-path)))
  (sph (concat "git d " (q path))))


(define-key global-map (kbd "C-\\") nil)
(define-key global-map (kbd "C-\\ '") 'git-d-unstaged)

;; (defalias 'get-top-level 'gitlab--get-top-level-dir)
(defalias 'get-top-level 'projectile-project-root)

(defun my-cd (dir)
  (cond
   ;; Both dired-mode and ranger-mode can be true at the same time. Therefore, ranger must precede
   ((major-mode-p 'ranger-mode) (ranger dir))
   ((major-mode-p 'dired-mode) (dired dir))
   (t (cd dir)))
  (message (mnm (concat "cd " (q dir)))))

(defun vc-cd-top-level ()
  (interactive)
  (my-cd (get-top-level)))
                                        ; is-git && cd "$(vc get-top-level)" && pwd


(defun cd-vc-cd-top-level ()
  (interactive)
  (dired (get-top-level)))

(define-key global-map (kbd "M-^") 'cd-vc-cd-top-level)


(provide 'my-git)