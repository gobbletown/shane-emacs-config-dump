(require 'my-prefixes)
(require 'my-fuzzy-lists)
(require 'my-nix)

(require 'uuidgen)

;; when python in unavailable (because hd is disconnected), emacs wont start
;; How to inject this in? I had to modify spacemacs itself
;; vim +/"(defun spacemacs/python-setup-shell (&rest args)" "$MYGIT/spacemacs/layers/+lang/python/funcs.el"
;;(defun spacemacs/python-setup-shell (&rest args)
;;  (ignore-errors
;;  (if (spacemacs/pyenv-executable-find "ipython")
;;      (progn (setq python-shell-interpreter "ipython")
;;             (if (version< (replace-regexp-in-string "\n$" "" (shell-command-to-string "ipython --version")) "5")
;;                 (setq python-shell-interpreter-args "-i")
;;               (setq python-shell-interpreter-args "--simple-prompt -i")))
;;    (progn
;;      (setq python-shell-interpreter-args "-i")
;;      (setq python-shell-interpreter "python")))))

;; Does not change away from * buffers after current buffer is closed
;; This was breaking grep
(setq spacemacs-useless-buffers-regexp "")

;; In here, put things relating to non-spacemacs too. But require a
;; check.

;; term can only take the address of a real program
;; I need to make a script which creates a new script that runs the arguments, and returns the path to that script without executing it

(defun eshell-unique (&optional arg)
  (interactive "P")
  (progn
    (eshell arg)
    ;; (rename-buffer "*eshell*" t ;; (concat "*eshell-" (substring (uuidgen-4) 0 8) "*")
    ;;                )
    (rename-buffer (concat "*eshell-" (substring (uuidgen-4) 0 8) "*")
                   )))

(defun myuuid ()
  (uuidgen-4))

(defun shorten (s)
  (substring s 0 8))

(defun myuuidshort ()
  (shorten (uuidgen-4)))

(defun eshell-nw ()
  (interactive)
  (e/nw 'eshell-unique)
  ;; (split-window-vertically)
  ;; (other-window 1)
  ;; (shell) ; this is a real terminal
  ;; (eshell)
  )

(defun eshell-sps ()
  (interactive)
  (e/sps 'eshell-unique)
  ;; (split-window-vertically)
  ;; (other-window 1)
  ;; (shell) ; this is a real terminal
  ;; (eshell)
  )

(defun eshell-sph ()
  (interactive)
  (e/sph 'eshell-unique)
  ;; (split-window-vertically)
  ;; (other-window 1)
  ;; (shell) ; this is a real terminal
  ;; (eshell)
  )

(defun eshell-spv ()
  (interactive)
  (e/spv 'eshell-unique)
  ;; (split-window-horizontally)
  ;; (other-window 1)
  ;; (shell) ; shell is zsh or whatever the default shell is
  ;; (eshell)
  )

;; delete-other-windows

;; (define-key my-mode-map (kbd (concat)))

(defmacro et (&rest body)
  "emacs term"
  `(term (chomp (b new-script-from-args ,@body))))

(defun ansi-term-cmd (cmd)
  "ansi term"
  (ansi-term (chomp (sh-notty (concat "new-script-from-args " cmd)))))

(defmacro etansi (&rest body)
  "ansi term"
  `(ansi-term (chomp (b new-script-from-args ,@body))))

(defmacro etm (&rest body)
  "tmux term"
  `(b tm -d sph -args ,@body))


(defun run-code-maybe-interactively (expression)
  (interactive (list (read-string "expression or function name:")))

  (let* ((resultsym (str2sym expression)))
    (if (and (function-p resultsym) (commandp resultsym))
        (call-interactively resultsym)
      (progn
        (if (or (functionp resultsym)
                (macrop resultsym))
            (setq result
                  (str (eval `(,result))))
          ;; unquote
          (setq result (eval-string result)))
        (new-buffer-from-string result)
        ;; (if (< 5 (length (s-match-strings-all "\n" result)))
        ;;     (new-buffer-from-string result)
        ;;   result)
        ))))

(defun e/nw (&optional run)
  (interactive)
  (if run
      (call-interactively run)))
(defalias 'enw 'e/nw)

(defun e/sps (&optional run)
  (interactive)
  (split-window-sensibly)
  (other-window 1)
  (if run
      (call-interactively run)))
(defalias 'esps 'e/sps)


(defun e/spv (&optional run)
  (interactive)
  (split-window-horizontally)
  (other-window 1)
  (if run
      (call-interactively run)))
(defalias 'espv 'e/spv)

(defun e/sph (&optional run)
  (interactive)
  (split-window-vertically)
  (other-window 1)
  (if run
      (call-interactively run)))
(defalias 'esph 'e/sph)

;; (esph 'eshell)
;; (defmacro e/sph (&optional run)
;;   (interactive)
;;   `(progn
;;      (split-window-vertically)
;;      (other-window 1)
;;      (if (and (symbolp ,run) (function-p ,run))
;;          (call-interactively ,run)
;;        ,run)))
;; (esph (lm (term-nsfa "vim")))

(defun e/spv-tmux ()
  (interactive)
  (e/spv (lm (term-nsfa "tmux new zsh"))))

(defun e/spv-tmux ()
  (interactive)
  (e/sph (lm (term-nsfa "tmux new zsh"))))

;; (defun e/spv-zsh ()
;;   (interactive)
;;   (e/spv (lm (ansi-term "zsh"))))


;; (defun tmuxify-cmd (cmd)
;;   (concat "TMUX= tmux new -n zsh " (q (concat "CWD= ") (q cmd))))


(defun e/sph-zsh (&optional cmd dir)
  (interactive)
  (if (not dir)
      (setq dir (cwd)))
  (if (not cmd)
      (setq cmd (tmuxify-cmd "zsh"))
    ;; (setq cmd "TMUX= tmux new -n zsh \"CWD= zsh\"")
    )
  (e/sph (lm (term-nsfa cmd nil "zsh" nil nil dir))))
(defalias 'sph-term 'e/sph-zsh)
(defalias 'term-sph 'e/sph-zsh)
(defalias 'tsph 'e/sph-zsh)

(defun e/spv-zsh (&optional cmd dir)
  (interactive)
  (if (not dir)
      (setq dir (cwd)))
  (if (not cmd)
      (setq cmd "TMUX= tmux new -n zsh \"CWD= zsh\""))
  (e/spv (lm (term-nsfa cmd nil "zsh" nil nil dir))))
;; (defalias 'spv-term 'e/spv-zsh)
(defalias 'term-spv 'e/spv-zsh)
(defalias 'tspv 'e/spv-zsh)

(defun tmuxify-cmd (cmd &optional dir window-name)
  (let ((slug (slugify cmd)))
    (setq window-name (or window-name slug))
    (setq dir (or dir (e/pwd)))
    (concat "TMUX= tmux new -c " (q dir) " -n " (q window-name) " " (q (concat "CWD= " cmd)))))

(defun e/sps-zsh (&optional cmd dir)
  (interactive)
  (if (not dir)
      (setq dir (cwd)))
  (if (not cmd)
      (progn
        ;; (setq cmd (concat "TMUX= tmux new -c " (q dir) " -n zsh \"CWD= zsh\""))
        (setq cmd "zsh")
        (setq cmd (tmuxify-cmd cmd dir cmd))))
  (e/sps (lm (term-nsfa cmd nil "zsh" nil nil dir))))
(defalias 'term-sps 'e/sps-zsh)
(defalias 'tsps 'e/sps-zsh)

(defun e/nw-zsh (&optional cmd dir)
  (interactive)
  (if (not dir)
      (setq dir (cwd)))
  (if (not cmd)
      (progn
        ;; (setq cmd "TMUX= tmux new -n zsh \"CWD= zsh\"")
        (setq cmd "zsh")
        (setq cmd (tmuxify-cmd cmd dir cmd))))
  (e/nw (lm (term-nsfa cmd nil "zsh" nil nil dir))))
(defalias 'nw-term 'e/nw-zsh)
(defalias 'term-nw 'e/nw-zsh)

;; (define-key my-mode-map (kbd "M-m T c") #'toggle-chrome)

(defun kill-buffer-if-not-current (name)
  (ignore-errors
    (if (not (string-equal name (buffer-name)))
        (if (buffer-exists name)
            (progn
              (ignore-errors (kill-buffer name))
              (message (concat "killed buffer " name " because it's slow")))))))

;; This is being called by org-brain. Fix this
(defun toggle-chrome ()
  (interactive)
  (ignore-errors
    (kill-buffer-if-not-current "*aws-instances*")
    (kill-buffer-if-not-current "*docker-containers*")
    (kill-buffer-if-not-current "*docker-images*")
    (kill-buffer-if-not-current "*docker-machines*")
    (if (minor-mode-p global-display-line-numbers-mode)
        (progn
          (if lsp-mode
              (lsp-headerline-breadcrumb-mode -1))
          (global-display-line-numbers-mode -1)
          (if (sor header-line-format)
              (setq header-line-format
                    (s-replace-regexp "^    " "" header-line-format)))
          (global-hide-mode-line-mode 1)
          ;; (imenu-list-minor-mode -1)
          (visual-line-mode -1)
          ;; (if (>= (prefix-numeric-value current-prefix-arg) 4)
          ;;     (toggle-script "toggle-tmux-status" "0" t))
          )
      (progn
        (if lsp-mode
            (lsp-headerline-breadcrumb-mode 1))
        (global-display-line-numbers-mode 1)
        (if (sor header-line-format)
            (setq header-line-format (concat "    " header-line-format)))
        (global-hide-mode-line-mode -1)
        ;; (imenu-list-minor-mode 1)
        (visual-line-mode 1)
        ;; (if (>= (prefix-numeric-value current-prefix-arg) 4)
        ;;     (toggle-script "toggle-tmux-status" "1" t))
        ))))

;; This used to be linum mode
(global-set-key (kbd "<S-f2>") 'toggle-chrome)
(global-set-key (kbd "<S-f4>") 'toggle-chrome)
(global-set-key (kbd "<f16>") 'toggle-chrome)
(global-set-key (kbd "<S-f5>") 'global-display-line-numbers-mode)
(global-set-key (kbd "<S-f7>") 'global-hide-mode-line-mode)
(global-set-key (kbd "<f17>") 'global-display-line-numbers-mode) ;Terminal

;; global-set-key expects an interactive command
;; for some reason, when called like this, these functions dont toggle
;;(global-set-key (kbd "<f21>") (lambda () (interactive) (visual-line-mode) (linum-mode)))
;; but called individually, they do
(global-set-key (kbd "<S-f9>") 'visual-line-mode)
(global-set-key (kbd "<f21>") 'visual-line-mode) ;Terminal

(defun sph-new-buffer ()
  (interactive)
  (with-current-buffer (esph 'new-buffer-from-string)
    (defset-local kill-window-when-done t)))

(defun spv-new-buffer ()
  (interactive)
  (with-current-buffer (espv 'new-buffer-from-string)
    (defset-local kill-window-when-done t)))

(if (cl-search "SPACEMACS" my-daemon-name)
    (progn
      (remove-hook 'dired-mode-hook 'drupal-mode-bootstrap)
      (remove-hook 'python-mode-hook 'spacemacs//init-eldoc-python-mode)))

(if (cl-search "SPACEMACS" my-daemon-name)
    (defun spacemacs-buffer//insert-footer ()
  "Insert the footer of the home buffer."
  (save-excursion
    (let* ((badge-path spacemacs-badge-official-png)
           (badge nil ;; (when (and (display-graphic-p)
                  ;;            (image-type-available-p
                  ;;             (intern (file-name-extension badge-path))))
                  ;;   (create-image badge-path))
                  )
           (badge-size (when badge (car (image-size badge))))
           (heart-path spacemacs-purple-heart-png)
           (heart nil ;; (when (and (display-graphic-p)
                  ;;            (image-type-available-p
                  ;;             (intern (file-name-extension badge-path))))
                  ;;   (create-image heart-path))
            )
           (heart-size (when heart (car (image-size heart))))
           (build-lhs "Made with ")
           (build-rhs " by the community")
           (buffer-read-only nil))

      (when (or badge heart)
        (goto-char (point-max))
        (spacemacs-buffer/insert-page-break)
        (insert "\n")
        (when badge
          (insert-image badge)
          (spacemacs-buffer//center-line badge-size))
        (when heart
          (when badge (insert "\n\n"))
          (insert build-lhs)
          (insert-image heart)
          (insert build-rhs)
          (spacemacs-buffer//center-line (+ (length build-lhs)
                                            heart-size
                                            (length build-rhs)))
          (insert "\n")))))))


;; Not sure what sets this
;; mc/edit-lines
(define-key global-map (kbd "C-c m c") nil)

(defun spacemacs/check-large-file ()
  ;; (let* ((filename (buffer-file-name))
  ;;        (size (nth 7 (file-attributes filename))))
  ;;   (when (and
  ;;          (not (memq major-mode spacemacs-large-file-modes-list))
  ;;          size (> size (* 1024 1024 dotspacemacs-large-file-size))
  ;;          (y-or-n-p (format (concat "%s is a large file, open literally to "
  ;;                                    "avoid performance issues?")
  ;;                            filename)))
  ;;     (setq buffer-read-only t)
  ;;     (buffer-disable-undo)
  ;;     (fundamental-mode)))
  )

(setq large-file-warning-threshold nil)

(global-vi-tilde-fringe-mode -1)

(setq spacemacs-buffer-name "*scratch*")

(define-key global-map (kbd "C-x C-f") 'find-file-at-point)

(provide 'my-spacemacs)