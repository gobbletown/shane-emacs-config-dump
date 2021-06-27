(require 'my-utils)
(provide 'flymake-racket)

;; (defadvice racket-visit-definition (around no-y-or-n activate)
;;   (flet ((yes-or-no-p (&rest args) nil)
;;          (y-or-n-p (&rest args) nil))
;;     ad-do-it))

(defun racket--do-visit-def-or-mod (cmd sym)
  "CMD must be \"def\" or \"mod\". SYM must be `symbolp`."
  (pcase (racket--repl-command "%s %s" cmd sym)
    (`(,path ,line ,col)
     (racket--push-loc)
     (find-file path)
     (goto-char (point-min))
     (forward-line (1- line))
     (forward-char col)
     (message "%s" "Type M-, to return")
     t)
    (`kernel
     (error "Defined in kernel")
     ;; (message "%s" "`%s' defined in #%%kernel -- source not available." sym)
     )
    (_ (error "Not found")
       ;; (when (y-or-n-p "Not found. Run current buffer and try again? ")
       ;;   (racket-run)
       ;;   (racket--do-visit-def-or-mod cmd sym))
       )))

(require 'flymake-racket)
(defun flymake-racket-setup ()
  "Set up Flymake for Racket."
  (interactive)
  (add-hook 'racket-mode-hook #'flymake-racket-add-hook)
  ;; (add-hook 'scheme-mode-hook #'flymake-racket-add-hook)
  )

(remove-hook 'scheme-mode-hook #'flymake-racket-add-hook)

(defun racket-goto-symbol (&optional arg)
  (interactive)
  ;; DISCARD Not sure what arg is meant to do. It's the symbol at the point.
  ;; (tvipe (str arg))

  (if (string-equal ;; (preceding-sexp-or-element)
       (lispy--current-function) "require")
      (racket-find-collection)
    (try (racket-visit-definition)
         (racket-expand-definition))
    ;; (call-interactively
    ;;  ;; (racket-expand-definition)
    ;;  (racket-visit-definition))
    ;; (ekm "M-9")
    ))

(add-to-list 'lispy-goto-symbol-alist
	           '(racket-mode racket-goto-symbol le-racket))

;;(racket-find-collection
;;preceding-sexp-or-element


(require 'racket-mode)
(define-key racket-mode-map (kbd "C-c C-v") 'racket-view-last-image)
(define-key racket-repl-mode-map (kbd "C-c C-v") 'racket-view-last-image)

;; (setq racket-images-system-viewer "win ie")
(setq racket-images-system-viewer "rifle")


(defun my-racket-expand-macro-or-copy ()
  (interactive)
  (if (selected-p)
      (progn (call-interactively 'kill-ring-save)
             (reselect-region))
                                        ; execute-keyboard-macro still uses the original emacs-lisp-mode-map
    (racket-goto-symbol)))
(define-key racket-mode-map (kbd "M-w") #'my-racket-expand-macro-or-copy)

(defun my-racket-show-doc-url (url)
  (ignore-errors
    (if (buffer-currently-visible "*eww-racket-doc*")
        (with-current-buffer (switch-to-buffer "*eww-racket-doc*")
          (kill-buffer-and-window))
      (kill-buffer "*eww-racket-doc*")))
  (setq url (snc "fix-racket-doc-url" url))
  (espv (lm (with-current-buffer (eww url) (rename-buffer "*eww-racket-doc*")))))


(defun my-racket-lang-doc (thing &optional  winfunc)
  "This is for #lang"
  (interactive (list (my/thing-at-point)))
  ;; (message (cmd "my-racket-lang-doc" thing))
  (if (string-equal (preceding-sexp-or-element) "#lang")
      (progn
        (let ((url (my-racket-get-doc-url (concat "H:" thing))))
          ;; (str (racket--cmd/async (racket--repl-session-id) `(doc ,(concat "H:" (str thing)))))
          (my-racket-show-doc-url url))
        ;; (progn
        ;;   ;; (sleep 0.2)
        ;;   (let ((url (cl/xc)))
        ;;     (my-racket-show-doc-url url)
        ;;     ))
        )))

;; Is local an override or a preference?
;; Depends if it's interactive or not?
;; Don't even use an argument. Rely on preferences
(defun my-racket-get-doc-url (thing)
  "local is "
  (interactive (read-string-hist "my-racket-get-doc-url: "))
  (let ((url
         (cond
          ((and (myrc-test "racket_use_web_or_local_preference")
                (myrc-test "racket_use_local_docs"))
           (progn
             (racket--search-doc-locally thing)
             (sleep 1)
             (cl/xc nil :notify t)))
          (t
           (format racket-documentation-search-location thing)
           ;; This opens eww
           ;; (racket--search-doc thing)
           ))))
    (if (and (interactive-p)
             (sor url))
        (my-racket-show-doc-url url))))

(defun my-racket-doc (&optional winfunc thing)
  (interactive)
  (if (not winfunc)
      (setq winfunc 'sph))
  (if (not thing)
      (setq thing (str (symbol-at-point))))
  (if (string-equal (preceding-sexp-or-element) "#lang")
      ;; (racket--repl-command "doc %s" (concat "#lang" (str (symbol-at-point))))
      ;; (racket--repl-command "doc %s" (concat "H:" (str (symbol-at-point))))
      ;; The new way, still can't get it to work
      ;; (racket--cmd/async (racket--repl-session-id) `(doc ,(concat "H:" (str thing))))
      (my-racket-get-doc-url (concat "H:" thing))
    ;; (racket--cmd/async (racket--repl-session-id) `(doc thing))
    (my-racket-get-doc-url thing))
  (if (interactive-p)
      (my-racket-show-doc-url url))
  ;; (ns "kfdjls")
  ;; (sleep 1)
  ;; (let ((url (cl/xc nil :notify t)))
  ;;   (if immediate
  ;;       (my-racket-show-doc-url url)
  ;;     ;; (esps (lm (eww url)))
  ;;     ;; (kill-buffer "*eww-racket-doc*")
  ;;     ;; (espv (lm (with-current-buffer (eww url)
  ;;     ;;             (rename-buffer "*eww-racket-doc*"))))
  ;;     ;; (if (string-match-p "racket/search/index.html\\?q=" url)
  ;;     ;;     (eval `(,winfunc (concat "ff " (e/q url))))
  ;;     ;;   (eval `(,winfunc (concat "eww " (e/q url)))))
  ;;     )
  ;;   (message "%s" url))
  )

(defun racket-expand-at-point ()
  (interactive)
  (cond ((and (lispy-left-p) (not (selected-p)))
         (save-excursion
           (ekm "m")
           (ic 'racket-expand-region)))
        ((selected-p)
         (my/copy)
         ;; (save-mark-and-excursion
         ;;   (ic 'racket-expand-region))
         )
        (t
         (ic 'racket-expand-definition))))
(define-key racket-mode-map (kbd "M-w") 'racket-expand-at-point)

(defun format-racket-at-point ()
  "Formats racket code, if selected or on a starting parenthesis."
  (interactive)
  (format-sexp-at-point "racket-format"))

(define-key racket-mode-map (kbd "C-M-i") 'racket-format-at-point)
;; Doing this would remove from prog-mode
;; (define-key racket-mode-map (kbd "M-.") nil)

(define-key racket-mode-map (kbd "H-r") nil)

(defun my-racket-setup ()
  ;; it wasn't this that was slow
  ;; (setq indent-line-function nil)

  ;; lsp flycheck was super super laggy
  ;; (flycheck-mode -1)

  ;; Disabled with manage-minor-mode
  ;; That didn't work. Neither does this
  (eldoc-mode -1)

  ;; the racket-langserver is still super laggy.
  ;; There isn't anything I can do about this really.
  ;; After every edit it lags a lot.
  ;; I can change lsp-idle-delay to be much longer

  ;; These don't improve the lsp lag
  ;; after every edit, the lsp server is updated within miliseconds

  ;; (defset-local lsp-idle-delay 5)
  ;; (defset-local lsp-ui-doc-delay 5)
  ;; (defset-local lsp-ui-sideline-delay 5)
  ;; (defset-local lsp-debounce-full-sync-notifications-interval 5)

  ;; Still having problems with eldoc

  ;; I guess, with racket-langserver I should disable it on updating after changes until I have a faster computer
  (remove-hook 'after-change-functions 'lsp-on-change t))

;; (remove-hook 'racket-mode-hook 'my-racket-setup)
;; (setq racket-mode-hook (append racket-mode-hook (list 'my-racket-setup)))
;; (add-hook 'racket-mode-hook 'my-racket-setup)

;; (remove-hook 'racket-mode-hook 'my-racket-setup)

(advice-add 'indent-for-tab-command :around #'ignore-errors-around-advice)
(advice-add 'indent-according-to-mode :around #'ignore-errors-around-advice)

(defun my-racket-run-main (path)
  (interactive (list (get-path)))
  (if (bq racket-main-exists)
      (sps "racket-run-main")))

(provide 'my-racket)
(provide 'le-racket)