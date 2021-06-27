(require 'counsel)
(require 'helm)
(require 'grep)

;; vim +/"(defvar compilation-mode-map" "$HOME/local/emacs26/share/emacs/26.0.91/lisp/progmodes/compile.el.gz"

;; unmap key
;; (uk grep-mode-map "g")
(uk grep-mode-map "g")


(cl-defun my-counsel-ag (&optional initsearch extra-args prompt &key histvar &key basecmd)
  (interactive)

  (if (not basecmd)
      (setq basecmd "counsel-ag-cmd %s"))

  (setq counsel-ag-base-command basecmd)

  (let ((dir (if (equalp current-prefix-arg '(4))
                 (vc-get-top-level)
               (my/pwd)))
        ;; (extra-args (car body))
        ;; (prompt (second body))
        )

    (if (region-active-p)
        (setq initsearch (selection)))

    ;; (eval `(counsel-ag initsearch ,@body))
    (if (or (region-active-p)
            iedit-mode
            (>= (prefix-numeric-value current-prefix-arg) 16))
        (let ((current-prefix-arg nil))
          (deselect)
          (eval `(counsel-ag (or
                              initsearch
                              (default-search-string))
                             dir extra-args prompt
                             ;; ,@body
                             :histvar ,histvar)))
      ;; initsearch is usually nil
      (eval `(counsel-ag initsearch dir extra-args prompt :histvar ,histvar)))))


;; DONE Make this
(defun my-counsel-ag-generic (cmd &optional initsearch extra-args prompt)
  (interactive (list (read-string-hist "base grep cmd: ")))

  (let ((histvar (str2sym (slugify (concat "histvar-" cmd))))
        (basecmd (if (not (re-match-p "%s" cmd))
                     (concat cmd " %s"))))
    (eval `(defvar ,histvar '()))
    (my-counsel-ag initsearch extra-args prompt :histvar histvar :basecmd basecmd)
    ;; (my-counsel-ag initsearch extra-args prompt)
    ))
(defun my-counsel-ag-generic-e (cmd &optional initsearch extra-args prompt)
  (interactive (list (read-string-hist "base grep cmd: ")))
  (my-counsel-ag-generic cmd initsearch extra-args prompt))
(define-key global-map (kbd "H-H") 'my-counsel-ag-generic)
(define-key global-map (kbd "H-0") 'my-counsel-ag-generic)


(defun my-counsel-ag-thing-at-point (&optional initsearch &rest body)
  (interactive)
  ;; (eval `(try-deselected-and-maybe-reselect
  ;;         (my-counsel-ag (or initsearch
  ;;                            ,(my/thing-at-point)) ,body)))

  (let ((thing (my/thing-at-point))
        (p (point))
        (m (mark))
        (s (selected-p)))
    (deselect)
    (eval
     `(try
       ;; Try this, otherwise, reselect
       (my-counsel-ag (or ,initsearch
                          (eatify ,thing)))
       (progn
         (set-mark ,m)
         (goto-char ,p)
         ,(if s
              '(activate-mark)
            '(deactivate-mark))
         (error "lsp-ui-peek-find-references failed"))))))

(defun grep-mode-hook-run ()
  (ignore-errors
    ;; This saves the keymap so it can be restored
    (ivy-wgrep-change-to-wgrep-mode)
    (wgrep-setup)

    (define-key compilation-button-map (kbd "C-m") 'compile-goto-error)
    (define-key compilation-button-map (kbd "RET") 'compile-goto-error)
    (define-key grep-mode-map (kbd "C-m") 'compile-goto-error)
    (visual-line-mode -1))
  ;; (message "Ran grep hooks")
  ;; (define-key grep-mode-map (kbd "C-c C-p") #'wgrep-change-to-wgrep-mode)
  )


(defun ag-dir (&optional dir)
  (interactive (list (read-string-hist "ag dir:")))
  ;; (message "RUNNING AG DIR")
  ;; (with-current-buffer
  ;;   (try (switch-to-buffer "*dashboard*")
  ;;        (switch-to-buffer "*scratch*")
  ;;        (current-buffer))
  ;;   (ignore-errors
  ;;     (if dir
  ;;         (cd dir)))
  ;;   ;; (read-string "hiyo")
  ;;   (call-interactively 'my-counsel-ag))
  (with-current-buffer
    (dired dir)
    (call-interactively 'my-counsel-ag)))
(add-hook 'grep-mode-hook 'grep-mode-hook-run t)


; (define-key grep-mode-map (kbd "C-c C-p") #'wgrep-change-to-wgrep-mode)
(define-key grep-mode-map (kbd "C-c C-p") #'ivy-wgrep-change-to-wgrep-mode)



;; If I use the counsel-ag method, I don't need to do this
;; https://sam217pa.github.io/2016/09/11/nuclear-power-editing-via-ivy-and-ag/

;; nadvice - proc is the original function, passed in. do not modify
;; (defun wgrep-to-original-mode-around-advice (proc &rest args)
;;   (let ((res (apply proc args)))
;;     (define-key grep-mode-map (kbd "C-c C-p") #'wgrep-change-to-wgrep-mode)
;;     res))
;; (advice-add 'wgrep-to-original-mode :around #'wgrep-to-original-mode-around-advice)



;; (if (not (cl-search "PURCELL" my-daemon-name))
;;     (define-key global-map (kbd "M-?") #'my-counsel-ag))

(define-key global-map (kbd "M-?") #'my-counsel-ag)
(define-key global-map (kbd "M-\"") #'my-helm-fzf)

;; (define-key global-map (kbd "M-\"") #'counsel-file-jump)
;; (define-key global-map (kbd "M-\"") #'helm-find)

(define-key grep-mode-map (kbd "h") nil)
;; (define-key global-map (kbd "RET") nil)
(define-key global-map (kbd "RET") 'newline)
(define-key grep-mode-map (kbd "RET") 'compile-goto-error)


(define-key grep-mode-map (kbd "C-x C-q") #'ivy-wgrep-change-to-wgrep-mode)
;; (define-key grep-mode-map (kbd "C-x C-q") #'ivy-wgrep-change-to-wgrep-mode)


;; I've modified this to unminimise
;; So I can minimise the grep input
;; vim +/"mnm | or e sp -noonly -e \"\$ecmd\"" "$SCRIPTS/ead"
(defun compilation-find-file (marker filename directory &rest formats)
  "Find a buffer for file FILENAME.
If FILENAME is not found at all, ask the user where to find it.
Pop up the buffer containing MARKER and scroll to MARKER if we ask
the user where to find the file.
Search the directories in `compilation-search-path'.
A nil in `compilation-search-path' means to try the
\"current\" directory, which is passed in DIRECTORY.
If DIRECTORY is relative, it is combined with `default-directory'.
If DIRECTORY is nil, that means use `default-directory'.
FORMATS, if given, is a list of formats to reformat FILENAME when
looking for it: for each element FMT in FORMATS, this function
attempts to find a file whose name is produced by (format FMT FILENAME)."
  (setq filename (umn filename))
  (or formats (setq formats '("%s")))
  (let ((dirs compilation-search-path)
        (spec-dir (if directory
                      (expand-file-name directory)
                    default-directory))
        buffer thisdir fmts name)
    (if (file-name-absolute-p filename)
        ;; The file name is absolute.  Use its explicit directory as
        ;; the first in the search path, and strip it from FILENAME.
        (setq filename (abbreviate-file-name (expand-file-name filename))
              dirs (cons (file-name-directory filename) dirs)
              filename (file-name-nondirectory filename)))
    ;; Now search the path.
    (while (and dirs (null buffer))
      (setq thisdir (or (car dirs) spec-dir)
            fmts formats)
      ;; For each directory, try each format string.
      (while (and fmts (null buffer))
        (setq name (expand-file-name (format (car fmts) filename) thisdir)
              buffer (and (file-exists-p name)
                          (find-file-noselect name))
              fmts (cdr fmts)))
      (setq dirs (cdr dirs)))
    (while (null buffer)        ;Repeat until the user selects an existing file.
      ;; The file doesn't exist.  Ask the user where to find it.
      (save-excursion                   ;This save-excursion is probably not right.
        (let ((w (let ((pop-up-windows t))
                   (display-buffer (marker-buffer marker)
                                   '(nil (allow-no-window . t))))))
          (with-current-buffer (marker-buffer marker)
            (goto-char marker)
            (and w (compilation-set-window w marker)))
          (let* ((name (read-file-name
                        (format "Find this %s in (default %s): "
                                compilation-error filename)
                        spec-dir filename t nil
                        ;; The predicate below is fine when called from
                        ;; minibuffer-complete-and-exit, but it's too
                        ;; restrictive otherwise, since it also prevents the
                        ;; user from completing "fo" to "foo/" when she
                        ;; wants to enter "foo/bar".
                        ;;
                        ;; Try to make sure the user can only select
                        ;; a valid answer.  This predicate may be ignored,
                        ;; tho, so we still have to double-check afterwards.
                        ;; TODO: We should probably fix read-file-name so
                        ;; that it never ignores this predicate, even when
                        ;; using popup dialog boxes.
                        ;; (lambda (name)
                        ;;   (if (file-directory-p name)
                        ;;       (setq name (expand-file-name filename name)))
                        ;;   (file-exists-p name))
                        ))
                 (origname name))
            (cond
             ((not (file-exists-p name))
              (message "Cannot find file `%s'" name)
              (ding) (sit-for 2))
             ((and (file-directory-p name)
                   (not (file-exists-p
                         (setq name (expand-file-name filename name)))))
              (message "No `%s' in directory %s" filename origname)
              (ding) (sit-for 2))
             (t
              (setq buffer (find-file-noselect name))))))))
    ;; Make intangible overlays tangible.
    ;; This is weird: it's not even clear which is the current buffer,
    ;; so the code below can't be expected to DTRT here.  -- Stef
    (dolist (ov (overlays-in (point-min) (point-max)))
      (when (overlay-get ov 'intangible)
        (overlay-put ov 'intangible nil)))
    buffer))

(defun grep-get-paths ()
  (if (major-mode-p 'grep-mode)
      (sn "grep-output-get-paths" (selection-or-buffer-string))))

(defun grep-ead-on-results (paths query)
  (interactive (list
                (grep-get-paths)
                (read-string "ead:")))
  (sps (concat "umn | uniqnosort | ead " query) "" paths)
  ;; (sps (concat "ead " query) "" (sn "sed -n '/:[0-9]/s/^\\([^:]*\\):.*/\\1/p' | uniqnosort" paths))
  )

(defun grep-eead-on-results (paths query)
  (interactive (list
                (grep-get-paths)
                (read-string "ead:")))
  (eead-thing-at-point query paths)
  ;; (sps (concat "ead " query) "" (sn "sed -n '/:[0-9]/s/^\\([^:]*\\):.*/\\1/p' | uniqnosort" paths))
  )

;; (define-key grep-mode-map (kbd "M-3") 'grep-ead-on-results)
(define-key grep-mode-map (kbd "M-3") 'grep-eead-on-results)

(defun grep-output-get-paths (paths)
  (interactive (list (selection-or-buffer-string)))
  (sps "v" "" (sn "grep-output-get-paths" paths)))



(defun counsel--format-ag-command (extra-args needle)
  "Construct a complete `counsel-ag-command' as a string.
EXTRA-ARGS is a string of the additional arguments.
NEEDLE is the search string."
  (counsel--format counsel-ag-command
                   (if (listp counsel-ag-command)
                       (if (string-match " \\(--\\) " extra-args)
                           (counsel--format
                            (split-string (replace-match "%s" t t extra-args 1))
                            needle)
                         (nconc (split-string extra-args) needle))
                     (if (string-match " \\(--\\) " extra-args)
                         (replace-match needle t t extra-args 1)
                       (concat extra-args " " needle)))))



(provide 'my-grep)