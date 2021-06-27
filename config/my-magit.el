(require 'magit)
(require 'magit)
(require 'my-syntax-extensions)

;; (setenv "GITHS" "y")

;; Use the one in the path (usually in scripts)

(defun magit-eww-releases ()
  (interactive)
  (if (magit-git-repo-p (my/pwd))
      (eww (concat (sn "vc url" (vc-get-top-level)) "/releases"))))

(defun toggle-magit-hs (&optional enable disable)
  (interactive)
  (if (or enable disable)
      (if enable
          (setq magit-git-executable "/home/shane/scripts/git-hs")
        (string-equal magit-git-executable "/usr/bin/git"))
    (if (string-equal magit-git-executable "/usr/bin/git")
        (setq magit-git-executable "/home/shane/scripts/git-hs")
      (setq magit-git-executable "/usr/bin/git")))
  (message (concat "magit-git-executable: " magit-git-executable)))

;; (setq magit-git-executable "/home/shane/scripts/git-hs")
(setq magit-git-executable "/usr/bin/git")

;; In the 'me' script, "$HOME/scripts/me", rainbow delimiters are disabled
;; This allows the diffs to display correctly.
;; Main magit highlighting is still disabled.


;; Now magit-popup highlights options -- if only magit highlighting worked. What breaks it again?
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(magit-popup-argument ((t (:inverse-video t)))))


;; (add-hook 'magit-log-mode-hook (lambda () (setq truncate-lines t)))


;; (defadvice magit-diff (after switch-to-diff activate) (my/beep))

(define-key magit-log-mode-map (kbd "M-j") (kbd "M-m"))

(defun my/magit-make-worktree ()
  (interactive)
  (let ((dir (concat "/home/shane/programs/git-worktrees/" (magit-commit-at-point)))
        (commit (magit-commit-at-point)))
    (if (file-exists-p dir)
        ;; (message "it exists")
        (progn
          (magit-worktree-checkout dir (magit-commit-at-point))
          (spv (concat "zcd " (q dir))))
        (progn
          (magit-worktree-checkout dir commit)
          ;; (sleep 0.5)
          (if (not (file-exists-p dir))
              (sleep 1))
          (if (file-exists-p dir)
              (progn
                (sh-notty (concat "cd " (q dir) " && git checkout -b " commit) nil dir)
                ;; (message (concat "cd " (q dir) " && git checkout -b " commit" && pak"))
                (spv (concat "zcd " (q dir)))))))))


;; (defun my/magit-make-worktree-dir ()
;;   (interactive)
;;   (let ((dir (concat "/home/shane/programs/git-worktrees/" (magit-commit-at-point))))
;;     (sh-notty (concat "cd " (q dir) "; git checkout -b " (magit-commit-at-point)) nil dir)))


;; The hook happens before the buffer loads. Use advice instead, then.
;; (add-hook 'magit-log-mode-hook #'my/magit-log-hook-body)
(defun my/magit-log-hook-body ()
  (setq truncate-lines t)
  ;; (my/beep)
  ;; (toggle-truncate-lines +1)
  (define-key magit-log-mode-map (kbd "M-e") #'magit-section-forward-sibling)
  ;; (define-key magit-log-mode-map (kbd "j S") #'my/magit-make-worktree)
  ;; (define-key magit-log-mode-map (kbd "j s") #'my/magit-make-worktree)
  )

;; TODO extend using el-patch
;; v +/"(transient-define-prefix magit-log ()" "$EMACSD/packages27/magit-20200927.1644/magit-log.el"

(defadvice magit-log (after switch-to-log activate) (my/magit-log-hook-body))
(defun my/magit-diff-hook-body ()
  (setq truncate-lines t)

  ;; (my/beep)
  ;; (toggle-truncate-lines +1)

  (define-key magit-log-mode-map (kbd "M-e") #'magit-section-forward-sibling)

  ;; (ns "hi")
  (tsk (concat "d--" (l2c magit-buffer-log-files)))
  (tsk "Enter"))

;; (defadvice magit-diff (after switch-to-diff activate) (my/magit-diff-hook-body))
;; (advice-remove-all-from 'magit-diff)

;; (defun my-magit-diff ()
;;   (interactive)
;;   (magit-diff)
;;   (ekm "--")
;;   ;; (with-current-buffer (magit-diff)
;;   ;;   (ekm "--")
;;   ;;   )
;;   )

(define-key magit-log-mode-map (kbd "d") 'magit-diff)
;; (define-key magit-log-mode-map (kbd "d") 'my-magit-diff)

(defun my/magit-status-hook-body ()
  (define-key magit-status-mode-map (kbd "M-e") #'magit-section-forward-sibling)
  ;; (define-key magit-status-mode-map (kbd "j S") #'my/magit-make-worktree)
  ;; (define-key magit-status-mode-map (kbd "j s") #'my/magit-make-worktree)
  )

;; (add-hook 'magit-log-select-mode-hook #'my/magit-log-hook-body)


(_ns magit-settings
     ;; Don't use customize to save defaults. It sucks.

     ;; Find the variables here
     ;; $EMACSD/packages24/magit-20180307.631/magit-log.el
     ;; And here:
     ;; $EMACSD/config/my-custom.el
     ;; And here (because custom is everywhere). Disable custom.
     ;; $EMACSD/packages.el

     (setq-default magit-log-arguments '("-n20" "--graph" "--stat" "--decorate"))
     (setq-default magit-commit-arguments (quote ("--verbose"))))

    (custom-set-variables
     '(magit-log-arguments (quote ("--graph" "--decorate" "--stat" "-n20")))
     ;; '(magit-log-arguments (quote ("--graph" "--decorate" "--patch" "--stat" "-n20")))
     )

(_ns magit-highlight-settings
     ;; This WORKS!
     ;; (setq-default magit-diff-refine-hunk t) ;; For currently selected hunk only
     (setq-default magit-diff-refine-hunk 'all)
     ;; (setq-default magit-diff-refine-hunk-related t) ;; Deprecated

     ;; this breaks magit commit! how frustrating!
                                        ;(setq-default magit-diff-highlight-indentation t)

     (setq-default magit-diff-highlight-trailing t)
     (setq-default magit-diff-paint-whitespace t)
     (setq-default magit-diff-highlight-hunk-body t)

     ;; The final piece of the puzzle is how to get a magit-refresh to happen
     ;; after magit-diff? Do I need to use an advice wrapper?

     ;; Not sure what these do. Don't set them though until I know there are
     ;; no bugs
                                        ;(setq-default magit-diff-highlight-keywords t)
                                        ;(setq-default magit-diff-hunk-region-functions t)



     ;; ;; THIS is how magit deals with incompatible modes
     ;;(defvar whitespace-mode)
     ;;
     ;;(defun whitespace-dont-turn-on-in-magit-mode (fn)
     ;;  "Prevent `whitespace-mode' from being turned on in Magit buffers.
     ;;
     ;;Because `whitespace-mode' uses font-lock and Magit does not, they
     ;;are not compatible.  Therefore you cannot turn on that minor-mode
     ;;in Magit buffers.  If you try to enable it anyway, then this
     ;;advice prevents that.
     ;;
     ;;It the reason the attempt is made is that `global-whitespace-mode'
     ;;is enabled, then that is done silently.  However if you you call
     ;;the local minor-mode interactively, then that results in an error.
     ;;
     ;;See `magit-diff-paint-whitespace' for an alternative."
     ;;  (if (not (derived-mode-p 'magit-mode))
     ;;      (funcall fn)
     ;;    (setq whitespace-mode nil)
     ;;    (when (eq this-command 'whitespace-mode)
     ;;      (user-error
     ;;       "Whitespace mode NOT enabled because it is not compatible with Magit"))))
     ;;
     ;;(advice-add 'whitespace-turn-on :around
     ;;            'whitespace-dont-turn-on-in-magit-mode)
     )

(_ns vimdiff
     ;; (defun my-magit-diff-setup (rev-or-range const args files)
     ;;   (require 'magit)
     ;;   (magit-mode-setup #'magit-diff-mode rev-or-range const args files))

     (defun magit-diff-vim-unmerged (&optional args files)
       "Show changes that are being merged."
       (interactive (magit-diff-arguments))
       (unless (magit-merge-in-progress-p)
         (user-error "No merge is in progress"))
       (magit-diff-setup (magit--merge-range) nil args files))

     (defun magit-diff-vim-staged (&optional rev args files)
       "Show changes between the index and the `HEAD' commit."
       (interactive
        (cons (and current-prefix-arg
                   (magit-read-branch-or-commit "Diff index and commit"))
              (magit-diff-arguments)))
       (magit-diff-setup rev (list "--cached") args files))

     (defun magit-diff-vim (rev-or-range &optional args files)
       "Show differences between two commits."
       (interactive (cons (magit-diff-read-range-or-commit "Diff for range"
                                                           nil current-prefix-arg)
                          (magit-diff-arguments)))
       (sph (concat "git d " rev-or-range " -- " (mapconcat 'identity files " ")))
       )

     (defun magit-diff-vim-term (rev-or-range &optional args files)
       "Show differences between two commits."
       (interactive (cons (magit-diff-read-range-or-commit "Diff for range"
                                                           nil current-prefix-arg)
                          (magit-diff-arguments)))
       (term-sph (concat "git d " rev-or-range " -- " (mapconcat 'identity files " "))))

     (defun git-get-files-for-commit (&optional commit)
       (if (not commit)
           (setq commit (cdr (magit-diff--dwim))))
       (if commit
           (str2list (chomp (sh-notty (concat "git-show-files-for-commit " commit))))))

     (defun magit-diff-dwim-vim (&optional args files)
       "Show changes for the thing at point."
       (interactive (magit-diff-arguments))
       (pcase (magit-diff--dwim)
         (`unmerged (magit-diff-unmerged args files))
         (`unstaged (magit-diff-unstaged args files))
         (`staged
          (let ((file (magit-file-at-point)))
            (if (and file (equal (cddr (car (magit-file-status file))) '(?D ?U)))
                ;; File was deleted by us and modified by them.  Show the latter.
                (magit-diff-vim-unmerged args (list file))
              (magit-diff-vim-staged nil args files))))
         (`(commit . ,value)
          (magit-diff-vim (format "%s^..%s" value value) args files))
         (`(stash  . ,value) (magit-stash-show value args))
         ((and range (pred stringp))
          (magit-diff-vim range args files))
         (_
          (call-interactively #'magit-diff-vim))))

     (defun magit-diff-dwim-vim-choose (&optional args files)
       "Show changes for the thing at point."
       (interactive (magit-diff-arguments))
       (setq files (str2list (fzf (git-get-files-for-commit (cdr (magit-diff--dwim))))))
       ;; (sleep 1.5)
       ;; (tvd files)
       ;; (tvd commit)
       (pcase (magit-diff--dwim)
         (`unmerged (magit-diff-unmerged args files))
         (`unstaged (magit-diff-unstaged args files))
         (`staged
          (let ((file (magit-file-at-point)))
            (if (and file (equal (cddr (car (magit-file-status file))) '(?D ?U)))
                ;; File was deleted by us and modified by them.  Show the latter.
                (magit-diff-vim-unmerged args (list file))
              (magit-diff-vim-staged nil args files))))
         (`(commit . ,value)
          (magit-diff-vim (format "%s^..%s" value value) args files))
         (`(stash  . ,value) (magit-stash-show value args))
         ((and range (pred stringp))
          (magit-diff-vim range args files))
         (_
          (call-interactively #'magit-diff-vim))))

     (defun magit-diff-dwim-vim-term-choose (&optional args files)
       "Show changes for the thing at point."
       (interactive (magit-diff-arguments))
       (setq files (str2list (fz (git-get-files-for-commit (cdr (magit-diff--dwim))))))
       ;; (tvd files)
       ;; (tvd commit)
       (pcase (magit-diff--dwim)
         (`unmerged (magit-diff-unmerged args files))
         (`unstaged (magit-diff-unstaged args files))
         (`staged
          (let ((file (magit-file-at-point)))
            (if (and file (equal (cddr (car (magit-file-status file))) '(?D ?U)))
                ;; File was deleted by us and modified by them.  Show the latter.
                (magit-diff-vim-unmerged args (list file))
              (magit-diff-vim-staged nil args files))))
         (`(commit . ,value)
          (magit-diff-vim-term (format "%s^..%s" value value) args files))
         (`(stash  . ,value) (magit-stash-show value args))
         ((and range (pred stringp))
          (magit-diff-vim-term range args files))
         (_
          (call-interactively #'magit-diff-vim-term))))

     (defun magit-diff-dwim-vim-term (&optional args files)
       "Show changes for the thing at point."
       (interactive (magit-diff-arguments))
       (pcase (magit-diff--dwim)
         (`unmerged (magit-diff-unmerged args files))
         (`unstaged (magit-diff-unstaged args files))
         (`staged
          (let ((file (magit-file-at-point)))
            (if (and file (equal (cddr (car (magit-file-status file))) '(?D ?U)))
                ;; File was deleted by us and modified by them.  Show the latter.
                (magit-diff-vim-unmerged args (list file))
              (magit-diff-vim-staged nil args files))))
         (`(commit . ,value)
          (magit-diff-vim-term (format "%s^..%s" value value) args files))
         (`(stash  . ,value) (magit-stash-show value args))
         ((and range (pred stringp))
          (magit-diff-vim-term range args files))
         (_
          (call-interactively #'magit-diff-vim-term)))))

(_ns meld
     (defun magit-diff-meld-unmerged (&optional args files)
       "Show changes that are being merged."
       (interactive (magit-diff-arguments))
       (unless (magit-merge-in-progress-p)
         (user-error "No merge is in progress"))
       (magit-diff-setup (magit--merge-range) nil args files))

     (defun magit-diff-meld-staged (&optional rev args files)
       "Show changes between the index and the `HEAD' commit.
With a prefix argument show changes between the index and
a commit read from the minibuffer."
       (interactive
        (cons (and current-prefix-arg
                   (magit-read-branch-or-commit "Diff index and commit"))
              (magit-diff-arguments)))
       (magit-diff-setup rev (list "--cached") args files))

     (defun magit-diff-meld (rev-or-range &optional args files)
       "Show differences between two commits.

REV-OR-RANGE should be a range or a single revision.  If it is a
revision, then show changes in the working tree relative to that
revision.  If it is a range, but one side is omitted, then show
changes relative to `HEAD'.

If the region is active, use the revisions on the first and last
line of the region as the two sides of the range.  With a prefix
argument, instead of diffing the revisions, choose a revision to
view changes along, starting at the common ancestor of both
revisions (i.e., use a \"...\" range)."
       (interactive (cons (magit-diff-read-range-or-commit "Diff for range"
                                                           nil current-prefix-arg)
                          (magit-diff-arguments)))
       ;; (magit-diff-setup rev-or-range nil args files)
       ;; (tvipe files)
       (sph (concat "git d -t meld " rev-or-range " -- " files)))


     (defun magit-diff-dwim-meld (&optional args files)
       "Show changes for the thing at point."
       (interactive (magit-diff-arguments))
       (pcase (magit-diff--dwim)
         (`unmerged (magit-diff-unmerged args files))
         (`unstaged (magit-diff-unstaged args files))
         (`staged
          (let ((file (magit-file-at-point)))
            (if (and file (equal (cddr (car (magit-file-status file))) '(?D ?U)))
                ;; File was deleted by us and modified by them.  Show the latter.
                (magit-diff-meld-unmerged args (list file))
              (magit-diff-meld-staged nil args files))))
         (`(commit . ,value)
          (magit-diff-meld (format "%s^..%s" value value) args files))
         (`(stash  . ,value) (magit-stash-show value args))
         ((and range (pred stringp))
          (magit-diff-meld range args files))
         (_
          (call-interactively #'magit-diff-meld)))))


;; I need defset or setq here
;; That's not enough, because magit-diff-popup-common is also not
;; defined.
;; Also, I can't simply require magit-diff. That does not load it
;; (defset magit-diff-popup
;;   `(,@magit-diff-popup-common
;;     :switches ((?f "Show surrounding functions"     "--function-context")
;;                (?b "Ignore whitespace changes"      "--ignore-space-change")
;;                (?w "Ignore all whitespace"          "--ignore-all-space")
;;                (?x "Disallow external diff drivers" "--no-ext-diff")
;;                (?s "Show stats"                     "--stat"))
;;     :actions  ((?d "Dwim"          magit-diff-dwim)
;;                (?v "vim"           magit-diff-dwim-vim)
;;                (?m "meld"           magit-diff-dwim-meld)
;;                (?u "Diff unstaged" magit-diff-unstaged)
;;                (?c "Show commit"   magit-show-commit)
;;                (?r "Diff range"    magit-diff)
;;                (?s "Diff staged"   magit-diff-staged)
;;                (?t "Show stash"    magit-stash-show)
;;                (?p "Diff paths"    magit-diff-paths)
;;                (?w "Diff worktree" magit-diff-working-tree))
;;     :default-action magit-diff-dwim
;;     :max-action-columns 3))


(defun magit-sph ()
  "Run magit in a split window."
  (interactive)
  (if (cl-search "magit" my-daemon-name)
      (magit-status)
    (sph "magit")
    ))

;; Can't call this magit-current-file because there already is one
(defun magit-sps-current-file ()
  "Run magit in a split window."
  (interactive)
  (sps (concat "magit " (q (buffer-name)))))

(df magit-diff-unstaged-this (magit-diff-unstaged nil `(,(get-current-path))))


(defun git-timemachine-show-revision-around-advice (proc &rest args)
  (magit-blame-quit)
  (let ((res (apply proc args)))
    res))
(advice-add 'git-timemachine-show-next-revision :around #'git-timemachine-show-revision-around-advice)
(advice-add 'git-timemachine-show-previous-revision :around #'git-timemachine-show-revision-around-advice)

;; For speed
(define-key magit-diff-mode-map (kbd "M-P") (lambda () (interactive) (ekm "q M-p dd")))
(define-key magit-diff-mode-map (kbd "M-N") (lambda () (interactive) (ekm "q M-n dd")))

;; (define-infix-argument magit:-= ()
;;   :description "Limit to commit files"
;;   :class 'transient-files
;;   :key "-="
;;   :argument "-="
;;   :prompt "Limit to file(s): "
;;   :reader 'magit-read-commit-files
;;   :multi-value t)

;; (defun magit-read-commit-files (prompt initial-input history)
;;   (str2list (git-get-files-for-commit)))

(defun magit-read-files (prompt initial-input history)
  (magit-completing-read-multiple* prompt
                                   (or (third magit-refresh-args) (git-get-files-for-commit) (magit-list-files))
                                   nil nil initial-input history))


;; (put 'magit-status-mode 'magit-diff-default-arguments
;;      '("--no-ext-diff"))
;; (put 'magit-status-mode 'magit-log-default-arguments
;;      '("-n256" "--decorate"))

;; Disable this and update

;; (define-transient-command magit-diff ()
;;   "Show changes between different versions."
;;   :man-page "git-diff"
;;   :class 'magit-diff-prefix
;;   ["Limit arguments"
;;    (magit:--)
;;    ;; (magit:-=)
;;    (magit-diff:--ignore-submodules)
;;    ("-b" "Ignore whitespace changes"      ("-b" "--ignore-space-change"))
;;    ("-w" "Ignore all whitespace"          ("-w" "--ignore-all-space"))]
;;   ["Context arguments"
;;    (magit-diff:-U)
;;    ("-W" "Show surrounding functions"     ("-W" "--function-context"))]
;;   ["Tune arguments"
;;    (magit-diff:--diff-algorithm)
;;    (magit-diff:-M)
;;    (magit-diff:-C)
;;    ("-x" "Disallow external diff drivers" "--no-ext-diff")
;;    ("-s" "Show stats"                     "--stat")
;;    ("=g" "Show signature"                 "--show-signature")
;;    (5 magit-diff:--color-moved)
;;    (5 magit-diff:--color-moved-ws)]
;;   ["Actions"
;;    [("d" "Dwim"          magit-diff-dwim)
;;     ("r" "Diff range"    magit-diff-range)
;;     ("p" "Diff paths"    magit-diff-paths)
;;     ("F" "Dwim vim choose" magit-diff-dwim-vim-choose)]
;;    [("u" "Diff unstaged" magit-diff-unstaged)
;;     ("s" "Diff staged"   magit-diff-staged)
;;     ("w" "Diff worktree" magit-diff-working-tree)
;;     ("f" "Dwim vim term choose" magit-diff-dwim-vim-term-choose)]
;;    [("c" "Show commit"   magit-show-commit)
;;     ("t" "Show stash"    magit-stash-show)
;;     ("V" "Dwim vim" magit-diff-dwim-vim)
;;     ("v" "Dwim vim term" magit-diff-dwim-vim-term)]])

(transient-define-prefix magit-diff ()
  "Show changes between different versions."
  :man-page "git-diff"
  :class 'magit-diff-prefix
  ["Limit arguments"
   (magit:--)
   (magit-diff:--ignore-submodules)
   ("-b" "Ignore whitespace changes"      ("-b" "--ignore-space-change"))
   ("-w" "Ignore all whitespace"          ("-w" "--ignore-all-space"))
   (5 "-D" "Omit preimage for deletes"    ("-D" "--irreversible-delete"))]
  ["Context arguments"
   (magit-diff:-U)
   ("-W" "Show surrounding functions"     ("-W" "--function-context"))]
  ["Tune arguments"
   (magit-diff:--diff-algorithm)
   (magit-diff:-M)
   (magit-diff:-C)
   ("-x" "Disallow external diff drivers" "--no-ext-diff")
   ("-s" "Show stats"                     "--stat")
   ("=g" "Show signature"                 "--show-signature")
   (5 magit-diff:--color-moved)
   (5 magit-diff:--color-moved-ws)]
  ["Actions"
   [("d" "Dwim"          magit-diff-dwim)
    ("r" "Diff range"    magit-diff-range)
    ("p" "Diff paths"    magit-diff-paths)
    ("F" "Dwim vim choose" magit-diff-dwim-vim-choose)]
   [("u" "Diff unstaged" magit-diff-unstaged)
    ("s" "Diff staged"   magit-diff-staged)
    ("w" "Diff worktree" magit-diff-working-tree)
    ("f" "Dwim vim term choose" magit-diff-dwim-vim-term-choose)]
   [("c" "Show commit"   magit-show-commit)
    ("t" "Show stash"    magit-stash-show)
    ("V" "Dwim vim" magit-diff-dwim-vim)
    ("v" "Dwim vim term" magit-diff-dwim-vim-term)
    ("v" "Dwim git diff pretty" magit-diff-dwim-vim-term)]])


(require 'magit-circleci)
(setq magit-circleci-token "b3963f42e3df0177260fcb4afbf6d7e32c4f968b")

(define-key global-map (kbd "M-m g f h") 'magit-log-buffer-file)

;; I think that the wrong version of magit was loaded, but this appears to fix it
(load "/home/shane/.emacs.d/packages27/magit-20200927.1644/magit-status.el")
;; forge wasn't able to start

(use-package forge
  :after magit)
;; forge uses ghub
;; https://github.com/magit/ghub

(require 'magit-todos)


(define-key magit-log-mode-map (kbd "H") 'magit-status)

(defun date-short ()
  (interactive)
  (cl-sn "date-short" :chomp t))

(defun magit-commit-instant (&optional args)
  "Instant commit.
\n(git commit --amend ARGS)"
  (interactive (list (magit-commit-arguments)))
  (magit-run-git-with-editor "commit" "-m" (date-short) args)
  (magit-run-git-with-editor "commit" "-m" (date-short) args))

(defun magit-commit-add-instant (&optional args)
  "Instant commit.
\n(git commit --amend ARGS)"
  (interactive (list (magit-commit-arguments)))
  (magit-run-git-with-editor "add" "-A" "." args)
  (magit-run-git-with-editor "commit" "-m" (date-short) args))


(define-transient-command magit-commit ()
  "Create a new commit or replace an existing commit."
  :info-manual "(magit)Initiating a Commit"
  :man-page "git-commit"
  ["Arguments"
   ("-a" "Stage all modified and deleted files"   ("-a" "--all"))
   ("-e" "Allow empty commit"                     "--allow-empty")
   ("-v" "Show diff of changes to be committed"   ("-v" "--verbose"))
   ("-n" "Disable hooks"                          ("-n" "--no-verify"))
   ("-R" "Claim authorship and reset author date" "--reset-author")
   (magit:--author :description "Override the author")
   (7 "-D" "Override the author date" "--date=" transient-read-date)
   ("-s" "Add Signed-off-by line"                 ("-s" "--signoff"))
   (5 magit:--gpg-sign)
   (magit-commit:--reuse-message)]
  [["Create"
    ("c" "Commit"         magit-commit-create)
    ("i" "Instant commit" magit-commit-instant)
    ("t" "Instant add commit" magit-commit-instant)]
   ["Edit HEAD"
    ("e" "Extend"         magit-commit-extend)
    ("w" "Reword"         magit-commit-reword)
    ("a" "Amend"          magit-commit-amend)
    (6 "n" "Reshelve"     magit-commit-reshelve)]
   ["Edit"
    ("f" "Fixup"          magit-commit-fixup)
    ("s" "Squash"         magit-commit-squash)
    ("A" "Augment"        magit-commit-augment)
    (6 "x" "Absorb changes" magit-commit-absorb)]
   [""
    ("F" "Instant fixup"  magit-commit-instant-fixup)
    ("S" "Instant squash" magit-commit-instant-squash)]]
  (interactive)
  (if-let ((buffer (magit-commit-message-buffer)))
      (switch-to-buffer buffer)
    (transient-setup 'magit-commit)))


;; (dff (sn "vc pull" nil (my/pwd)))
(defun -sn-vc-pull-nil-my-pwd- nil
  (interactive)
  (sn "vc pull" nil
      (my/pwd)))

(transient-define-prefix magit-pull ()
  "Pull from another repository."
  :man-page "git-pull"
  [:description
   (lambda () (if magit-pull-or-fetch "Pull arguments" "Arguments"))
   ("-r" "Rebase local commits" ("-r" "--rebase"))
   ("-A" "Autostash" "--autostash" :level 7)]
  [:description
   (lambda ()
     (if-let ((branch (magit-get-current-branch)))
         (concat
          (propertize "Pull into " 'face 'transient-heading)
          (propertize branch       'face 'magit-branch-local)
          (propertize " from"      'face 'transient-heading))
       (propertize "Pull from" 'face 'transient-heading)))
   ("p" magit-pull-from-pushremote)
   ("u" magit-pull-from-upstream)
   ("F" "vc pull" -sn-vc-pull-nil-my-pwd-)
   ("e" "elsewhere"         magit-pull-branch)]
  ["Fetch from"
   :if-non-nil magit-pull-or-fetch
   ("f" "remotes"           magit-fetch-all-no-prune)
   ("F" "remotes and prune" magit-fetch-all-prune)]
  ["Fetch"
   :if-non-nil magit-pull-or-fetch
   ("o" "another branch"    magit-fetch-branch)
   ("s" "explicit refspec"  magit-fetch-refspec)
   ("m" "submodules"        magit-fetch-modules)]
  ["Configure"
   ("r" magit-branch.<branch>.rebase :if magit-get-current-branch)
   ("C" "variables..." magit-branch-configure)]
  (interactive)
  (transient-setup 'magit-pull nil nil :scope (magit-get-current-branch)))



;; (dff (sn "vc p" nil (my/pwd)))
(defun -sn-vc-p-nil-my-pwd- nil
  (interactive)
  (sn "vc p" nil
      (my/pwd)))


(define-transient-command magit-push ()
  "Push to another repository."
  :man-page "git-push"
  ["Arguments"
   ("-f" "Force with lease" (nil "--force-with-lease"))
   ("-F" "Force" ("-f" "--force"))
   ("-h" "Disable hooks" "--no-verify")
   ("-n" "Dry run" ("-n" "--dry-run"))
   (5 "-u" "Set upstream" "--set-upstream")
   (7 "-t" "Follow tags" "--follow-tags")]
  [:if magit-get-current-branch
       :description (lambda ()
                      (format (propertize "Push %s to" 'face 'transient-heading)
                              (propertize (magit-get-current-branch)
                                          'face 'magit-branch-local)))
       ("p" magit-push-current-to-pushremote)
       ("u" magit-push-current-to-upstream)
       ("P" "vc p" -sn-vc-p-nil-my-pwd-)
       ("e" "elsewhere" magit-push-current)]
  ["Push"
   [
    ("o" "another branch" magit-push-other)
    ("r" "explicit refspecs" magit-push-refspecs)
    ("m" "matching branches" magit-push-matching)]
   [("T" "a tag" magit-push-tag)
    ("t" "all tags" magit-push-tags)]]
  ["Configure"
   ("C" "Set variables..." magit-branch-configure)])



(defun -interactive-sn-git-add-a-nil-my-pwd- nil
  (interactive)
  (interactive)
  (sn "git add -A ." nil
      (my/pwd))
  (magit-refresh))


(define-transient-command magit-dispatch ()
  "Invoke a Magit command from a list of available commands."
  ["Transient and dwim commands"
   [("A" "Apply"          magit-cherry-pick)
    ("b" "Branch"         magit-branch)
    ("B" "Bisect"         magit-bisect)
    ("c" "Commit"         magit-commit)
    ("C" "Clone"          magit-clone)
    ("d" "Diff"           magit-diff)
    ("D" "Diff (change)"  magit-diff-refresh)
    ("e" "Ediff (dwim)"   magit-ediff-dwim)
    ("E" "Ediff"          magit-ediff)]
   [("f" "Fetch"          magit-fetch)
    ("F" "Pull"           magit-pull)
    ("l" "Log"            magit-log)
    ("L" "Log (change)"   magit-log-refresh)
    ("m" "Merge"          magit-merge)
    ("M" "Remote"         magit-remote)
    ("o" "Submodule"      magit-submodule)
    ("O" "Subtree"        magit-subtree)]
   [("P" "Push"           magit-push)
    ("r" "Rebase"         magit-rebase)
    ("t" "Tag"            magit-tag)
    ("T" "Note"           magit-notes)
    ("V" "Revert"         magit-revert)
    ("w" "Apply patches"  magit-am)
    ("W" "Format patches" magit-patch)
    ("X" "Reset"          magit-reset)]
   [("y" "Show Refs"      magit-show-refs)
    ("Y" "Cherries"       magit-cherry)
    ("z" "Stash"          magit-stash)
    ("!" "Run"            magit-run)
    ("%" "Worktree"       magit-worktree)]]
  ["Applying changes"
   :if-derived magit-mode
   [("a" "Apply"          magit-apply)
    ("v" "Reverse"        magit-reverse)
    ("k" "Discard"        magit-discard)]
   [("s" "Stage"          magit-stage)
    ("u" "Unstage"        magit-unstage)]
   [("N" "git add -A ."   -interactive-sn-git-add-a-nil-my-pwd-)
    ("S" "Stage all"      magit-stage-modified)
    ("U" "Unstage all"    magit-unstage-all)]]
  ["Essential commands"
   :if-derived magit-mode
   ("g" "       refresh current buffer"   magit-refresh)
   ("<tab>" "   toggle section at point"  magit-section-toggle)
   ("<return>" "visit thing at point"     magit-visit-thing)
   ("C-h m" "   show all key bindings"    describe-mode)])



;; (define-key magit-mode-map (kbd "N") '-interactive-sn-git-add-a-nil-my-pwd-)
(define-key magit-status-mode-map (kbd "N") '-interactive-sn-git-add-a-nil-my-pwd-)


;; I need to authenticate ghub

;; https://magit.vc/manual/ghub/Authentication.html#Authentication
;; https://magit.vc/manual/ghub/Configuration-Variables.html


(use-package magithub
  :after magit
  :config
  (magithub-feature-autoinject t)
  (setq magithub-clone-default-directory "~/github"))


(defun magit-next-line-around-advice (proc &rest args)
  (let ((res (try (apply proc args)
                  (next-line))))
    res))
(advice-add 'magit-next-line :around #'magit-next-line-around-advice)


(defun magit-previous-line-around-advice (proc &rest args)
  (let ((res (try (apply proc args)
                  (previous-line))))
    res))
(advice-add 'magit-previous-line :around #'magit-previous-line-around-advice)

(advice-add 'magithub-issue-repo :around #'ignore-errors-around-advice)
(advice-remove 'magithub-issue-repo #'ignore-errors-around-advice)

(define-key magit-mode-map (kbd "M-^") 'vc-cd-top-level)


;; I'm not sure where this was set, but this is what it needs to be set to
(setq magit-display-buffer-function
      (lambda
        (buffer)
        (if magit-display-buffer-noselect
            (magit-display-buffer-traditional buffer)
          (delete-other-windows)
          (set-window-dedicated-p nil nil)
          (set-window-buffer nil buffer)
          (get-buffer-window buffer))))


(require 'magit-gitflow)
(add-hook 'magit-mode-hook 'turn-on-magit-gitflow)

(require 'magit-circleci)
(add-hook 'magit-mode-hook 'magit-circleci-mode)

(provide 'my-magit)