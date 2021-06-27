(require 'ranger)
(require 'dired-git-info)

(setq dgi-auto-hide-details-p nil)


;; Default switches
(setq dired-listing-switches "-alh")

;; require ranger so deer-from-dired binding works


;; Use steve purcell's dired pretty mode
(use-package dired
  :hook (dired-mode . dired-hide-details-mode)
  :config
  ;; Colourful columns.
  (use-package diredfl
    :ensure t
    :config
    (diredfl-global-mode 1)))

;; ) for toggling git info in dired
(use-package dired-git-info
  :ensure t
  :bind (:map dired-mode-map
              (")" . dired-git-info-mode)))


;; See "my-openwith.el"

(define-key dired-mode-map (kbd "C-j") (kbd "C-m"))

(add-hook 'dired-mode-hook (df enable-dired-hide-details () (dired-hide-details-mode 1)))


(setq wdired-allow-to-change-permissions t)


(setq dired-dwim-target t)

(use-package dired-narrow
:ensure t
:config
(bind-key "C-c C-n" #'dired-narrow)
(bind-key "C-c C-f" #'dired-narrow-fuzzy)
(bind-key "C-x C-N" #'dired-narrow-regexp)
)

(use-package dired-subtree :ensure t
  :after dired
  :config
  (bind-key "<tab>" #'dired-subtree-toggle dired-mode-map)
  (bind-key "<backtab>" #'dired-subtree-cycle dired-mode-map))


;; Faster dired operations
(require 'async)
(require 'dired-async)
(dired-async-mode 1)


(defun dired-sort-dirs-first ()
  (interactive)
  (dired-sort-other "-alXGh --group-directories-first"))


;;;; I don't like other windows
;;;; consider making this into something that opens in the same window
;;(defun dired-other-window (dirname &optional switches)
;;  "\"Edit\" directory DIRNAME.  Like `dired' but selects in another window."
;;  (interactive (dired-read-dir-and-switches "in other window "))
;;  (switch-to-buffer-other-window (dired-noselect dirname switches)))

(require 'dired)
(setq insert-directory-program "dired-ls")

(define-key dired-mode-map (kbd "z d") 'dired-sort-dirs-first)

(define-key dired-mode-map (kbd "M-N") 'dired-next-subdir)
(define-key dired-mode-map (kbd "M-P") 'dired-prev-subdir)

;; (define-key dired-mode-map (kbd "<up>") nil)
;; (define-key dired-mode-map (kbd "<down>") nil)
(define-key dired-mode-map [remap next-line] nil)
(define-key dired-mode-map [remap previous-line] nil)

(defun dired-top ()
  (interactive)
  (dired (vc-get-top-level) "-alXGh --group-directories-first"))

(define-key dired-mode-map (kbd "M-~") 'dired-top)
(define-key global-map (kbd "M-l M-^") 'dired-top)


(defun dired-cmd (cmd dirname &optional switches)
  (interactive (cons (read-string "cmd:") (dired-read-dir-and-switches "")))
  (ignore-errors (kill-buffer dirname))
  (let ((insert-directory-program cmd))
    (dired dirname switches)))


(defun ev (&optional path)
  (interactive)
  (term-nsfa (concat "v " (q path))))

(defun evim (&optional path)
  (interactive)
  (term-nsfa (concat "vim " (q path))))

(defun evs (&optional path)
  (interactive)
  (term-nsfa (concat "vs " (q path))))

(defun dired-all-info (path &optional switches)
  (if (not switches)
      (setq switches "-I -g -alR -XGh --group-directories-first"))
  (dired path switches)
  (dired-git-info-mode 1)
  (dired-hide-details-mode 0))

(defun dired-view-file-scope ()
  (interactive)
  (let ((file (dired-get-file-for-visit)))
    (if (f-directory-p file)
        (dired-all-info file)
      (let ((output (sh-notty (concat "scope.sh " (q file)))))
        (if (not (string-empty-p output))
            (new-buffer-from-string output)
          (error "No preview data"))))))

(defun dired-view-file-v (&optional arg)
  (interactive "P")
  (let ((file (dired-get-file-for-visit)))
    (if (or arg (string-equal (current-major-mode) "ranger-mode"))
        (sps (concat "v " (q file)))
      (ev file))))

(defun dired-view-file-vs (&optional arg)
  (interactive "P")
  (let ((file (dired-get-file-for-visit)))
    (if (or arg (string-equal (current-major-mode) "ranger-mode"))
        (sps (concat "vs " (q file)))
      (evs file))))


;; DISCARD Can't do this because it will break C-p (scrolling)
;; (define-key dired-mode-map (kbd "M-v") 'dired-view-file-v)
;; I've solved the M-v problem
;; M-v for scrolling up is terrible anyway.
;; TODO I should stop using both C-v and M-v for scrolling.
(define-key dired-mode-map (kbd "M-v") 'dired-view-file-v)

;; (define-key dired-mode-map (kbd "M-v") nil)
(define-key dired-mode-map (kbd "M-1") 'dired-view-file-scope)
(define-key dired-mode-map (kbd "M-V") 'dired-view-file-vs)
;; (define-key dired-mode-map (kbd "M-q") 'my-helm-fzf)
;; (define-key dired-mode-map (kbd "M-q") 'nil)



(defalias 'dired-filter 'dired-narrow)


(defun my-ranger ()
  (interactive)
  (if (>= (prefix-numeric-value current-prefix-arg) 4)
      (call-interactively 'sps-ranger)
    (call-interactively 'ranger)))

(define-key dired-mode-map (kbd "r") 'my-ranger)
(define-key dired-mode-map (kbd "M-r") 'sps-ranger)
(define-key dired-mode-map (kbd "[") 'peep-dired)
(define-key dired-mode-map (kbd "f") 'dired-narrow)
(define-key dired-mode-map (kbd "/") 'dired-narrow-fuzzy)

;; This is bound by default
;; (define-key dired-mode-map (kbd "q") 'quit-window)


(define-key global-map (kbd "C-M-_") #'my-helm-find-files)

(define-key dired-mode-map (kbd "TAB") 'dired-subtree-toggle)

(define-key dired-mode-map (kbd "C-M-i") (dff ;; (et "cr")
                                          ;; (sps "cr")
                                          (tsps "cr")))
(define-key ranger-mode-map (kbd "C-M-i") (dff ;; (sps "cr")
                                           (tsps "cr")))

(define-key dired-mode-map (kbd "M-^") 'vc-cd-top-level)


(defun dired-open-externally-with-rifle (&optional arg)
  (interactive "P")
  (let ((file (dired-get-file-for-visit)))
    (sps (concat "r " (q file)))))

(define-key dired-mode-map (kbd "O") 'dired-open-externally-with-rifle)
(define-key dired-mode-map (kbd "o") 'dired-do-chown)


;; (define-key my-mode-map (kbd "M-U") 'dired-here-columnate)
(define-key my-mode-map (kbd "M-U") 'dired-here)

;; TODO Turn this into a fuzzy finder
(defun find-here-symlink (substring)
  (interactive (list (read-string "symlink substring: ")))
  (let* ((query (concat "*" substring "*"))
         (result (sn (concat "tp find-here-symlink " (q query)) nil (my/pwd))))
    ;; (etv (concat "unbuffer tp find-here-symlink " query))
    ;; result
    (if (not (string-empty-p result))
        (with-current-buffer (nbfs result)
          ;; (call-interactively 'my-swipe)
          ))))

(define-key dired-mode-map (kbd "M-A") 'find-here-symlink)


;; (define-key dired-mode-map (kbd "M-X") )

(require 'image-dired)
(require 'image-dired+)
(eval-after-load 'image-dired '(require 'image-dired+))
(eval-after-load 'image-dired+ '(image-diredx-async-mode 1))
(eval-after-load 'image-dired+ '(image-diredx-adjust-mode 1))

(define-key image-dired-thumbnail-mode-map "\C-n" 'image-diredx-next-line)
(define-key image-dired-thumbnail-mode-map "\C-p" 'image-diredx-previous-line)
(setq image-dired-track-movement nil)


(defun dired-eranger-up ()
  (interactive)
  (ranger (f-dirname (get-path))))
(define-key dired-mode-map (kbd "h") 'dired-eranger-up)

(define-key dired-mode-map (kbd "l") 'dired-find-file)
(define-key dired-mode-map (kbd "k") 'previous-line)
(define-key dired-mode-map (kbd "j") 'next-line)
(define-key dired-mode-map (kbd "J") 'spacemacs/helm-find-files)

;; (define-key dired-mode-map (kbd "<mouse-2>") 'dired-mouse-find-file-other-window)
(define-key dired-mode-map (kbd "<mouse-2>") 'dired-mouse-find-file)

(defun dired-guess-repl-for-here ()
  (interactive)
  (let ((f
         (cond
          ((f-exists-p "project.clj") 'cider-switch-to-repl-buffer))))
    (if f
        (call-interactively f)
      (message "could infer repl"))))

(provide 'my-dired)