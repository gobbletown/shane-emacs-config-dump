;; Why can't I require this instead of forcefully loading it?
;; Perhaps I can do a library-load instead
;; (load "/var/smulliga/source/git/config/emacs/packages27/yasnippet-20200604.246/yasnippet.el")
(load-library "yasnippet")

(require 'help)
(require 'yasnippet)


(advice-add 'yas-describe-tables
            :after '(lambda (&rest args)
                      "Give the buffer a unique name and recenter to the top"
                      (with-current-buffer "*YASnippet Tables*"
                        (ignore-errors (rename-buffer (concat "*YASnippet Tables-" (myuuidshort)) "*") t))))


(defun yas-load-snippet-buffer-and-close-after-advice (&rest args)
  (yas-reload-all)
  )

;; Reload all snippets so if I visit the same snippet again, it wont display in a temporary buffer
;; Must have a proper advice function (can't simply put yas-reload-all here) or it will break yasnippet
(advice-add 'yas-load-snippet-buffer-and-close :after 'yas-load-snippet-buffer-and-close-after-advice)


;; (defadvice yas-describe-tables (around my-ada-yas-descibre-tables activate)
;;   (interactive)
;;   ad-do-it
;;   (ignore-errors (rename-buffer (concat "*YASnippet Tables-" (myuuidshort)) "*") t))


;; TODO Fix the bug where selecting text and creating new snippet from selected text, duplicates the text
(setq yas-new-snippet-default "\
# -*- mode: snippet -*-
# name: $1
# group: 
# key: ${2:${1:$(yas--key-from-desc yas-text)}}
# --
$0`(yas-escape-text yas-selected-text)`")

;; This needs to be set to nil manually, to fix spacemacs
;; Perhaps it's in the customisation variables
(setq yas-wrap-around-region nil)

;; # expand-env: ((yas-indent-line 'auto) (yas-also-auto-indent-first-line t) (yas-wrap-around-region nil))


;; Just ensure they exist. Somewhere above they have been deleted?
;; Otherwise, I could remove them from the list if they no longer exist
(bp grep / | xargs -l mkdir -p (list2lines yas-snippet-dirs))


;; (add-to-list 'yas-snippet-dirs "/var/smulliga/source/git/AndreaCrotti/yasnippet-snippets/")

;; (setq yas-snippet-dirs
;;       '(
;;         "/var/smulliga/home/.emacs.d/elpa/yasnippet-20170418.351/snippets/"
;;         "/var/smulliga/home/.emacs.d/snippets/")
;;       )

;; enable yasnippet globally
;;(yas-global-mode t)

;;(eval-after-load 'yasnippet
;;  '(progn
;;     (define-key yas-keymap (kbd "TAB") nil)
;;     (define-key yas-keymap (kbd "C-o") 'yas-next-field-or-maybe-expand)))



;; reenable this later. it's breaking spacemacs
;;(load "/var/smulliga/source/git/config/emacs/company-and-yasnippet.el")



(defun my/yas-complete ()
  "This just makes yas-complete a whole lot more reliable."
  (interactive)
  (yas-minor-mode 1)
  ;; (keyboard-quit)
  (company-abort)
  (try
   (call-interactively
    (company-yasnippet
     'interactive))
   nil)
  (yas-expand))


(defun show-yas-for-ext (ext)
  (with-temp-buffer
    (yas-describe-tables)))


;; Allow fundamental-mode to be the place to put global snippets.
;; This enables me to put a hash at the top of a file and for that to expand to an interpreter
;;(add-hook 'yas-minor-mode-hook
;;          (lambda ()
;;            (yas-activate-extra-mode 'fundamental-mode)))
(add-hook 'yas-minor-mode-hook
          (lambda ()
            (yas-activate-extra-mode '_)))


(defun activate-yas-python-interpreter ()
  (yas-minor-mode 1)
  (yas-activate-extra-mode 'python-mode))

(add-hook 'inferior-python-mode-hook #'activate-yas-python-interpreter)



(defun activate-yas-sql-interpreter ()
  (yas-minor-mode 1)
  (yas-activate-extra-mode 'sql-mode))

(add-hook 'sql-interactive-mode-hook #'activate-yas-sql-interpreter)


;; (add-hook 'inferior-python-mode-hook
;;           #'(lambda ()
;;               (yas-activate-extra-mode 'python-mode)))
;; (remove-hook 'inferior-python-mode-hook
;;           #'(lambda ()
;;               (yas-activate-extra-mode 'python-mode)))


;;;; This doesn't work until a the mode has already been started
;;(defun yas-describe-tables-for (mode &optional with-nonactive)
;;  "Display snippets for each table."
;;  (interactive "P")
;;  (let ((original-buffer (current-buffer))
;;        (tables (yas--get-snippet-tables mode)))
;;    (with-current-buffer (get-buffer-create "*YASnippet Tables*")
;;     (let ((inhibit-read-only t))
;;       (when with-nonactive
;;         (maphash #'(lambda (_k v)
;;                      (cl-pushnew v tables))
;;                  yas--tables))
;;       (erase-buffer)
;;       (insert "YASnippet tables:\n")
;;       (dolist (table tables)
;;         (yas--describe-pretty-table table original-buffer))
;;       (yas--create-snippet-xrefs))
;;     (help-mode)
;;     (goto-char 1)
;;     (display-buffer (current-buffer)))))


(cl-defun yasnew (ext &key contents &key name &key shortcut)
  (interactive)
  (if ext
      (let ((fp (concat "/tmp/" ext)))
        (find-file fp)
        (yas-new-snippet)
        (kill-buffer-immediately fp)
        (if name
            (insert contents))
        (if key
            (progn (search-forward-regexp "key: ")
                   (insert key)))
        (if contents
            (progn (end-of-buffer)
                   (insert contents))))))

;; This also starts yas minor mode if it's not already enabled
(defun my-yas-reload-all ()
  (interactive)
  (yas-minor-mode 1)
  (call-interactively 'yas/reload-all))

;; Fix the issue with selecting code and creating a new snippet
;; Would duplicate the code
(defun yas-new-snippet (&optional no-template)
  "Pops a new buffer for writing a snippet.

Expands a snippet-writing snippet, unless the optional prefix arg
NO-TEMPLATE is non-nil."
  (interactive "P")

  (let ((guessed-directories (yas--guess-snippet-directories))
        (yas-selected-text (or yas-selected-text
                               (and (region-active-p)
                                    (buffer-substring-no-properties
                                     (region-beginning) (region-end))))))

    ;; (tvd "hi" :dir "/")
    (switch-to-buffer yas-new-snippet-buffer-name)
    (erase-buffer)
    (kill-all-local-variables)
    (snippet-mode)
    (yas-minor-mode 1)
    (set (make-local-variable 'yas--guessed-modes)
         (mapcar (lambda (d) (yas--table-mode (car d)))
                 guessed-directories))
    (set (make-local-variable 'default-directory)
         (car (cdr (car guessed-directories))))
    ;; (sh-notty (concat "ns mkdir -p " (e/q default-directory)) nil "/")
    ;; Ensure the directory exists
    ;; (ns default-directory)
    (sh-notty (concat "mkdir -p " (e/q default-directory)) nil "/")
    ;; (tvd default-directory :dir "/")
    ;; (tvd "h")
    (if (and (not no-template) yas-new-snippet-default)
        (yas-expand-snippet yas-new-snippet-default))))

(defun yas-expand-snippet (snippet &optional start end expand-env)
  "Expand SNIPPET at current point.

Text between START and END will be deleted before inserting
template.  EXPAND-ENV is a list of (SYM VALUE) let-style dynamic
bindings considered when expanding the snippet.  If omitted, use
SNIPPET's expand-env field.

SNIPPET may be a snippet structure (e.g., as returned by
`yas-lookup-snippet'), or just a snippet body (which is a string
for normal snippets, and a list for command snippets)."
  (cl-assert (and yas-minor-mode
                  (memq 'yas--post-command-handler post-command-hook))
             nil
             "[yas] `yas-expand-snippet' needs properly setup `yas-minor-mode'")
  (run-hooks 'yas-before-expand-snippet-hook)

  (let* ((clear-field
          (let ((field (and yas--active-field-overlay
                            (overlay-buffer yas--active-field-overlay)
                            (overlay-get yas--active-field-overlay 'yas--field))))
            (and field (yas--skip-and-clear-field-p
                        field (point) (point) 0)
                 field)))
         (start (cond (start)
                      ((region-active-p)
                       (region-beginning))
                      (clear-field
                       (yas--field-start clear-field))
                      (t (point))))
         (end (cond (end)
                    ((region-active-p)
                     (region-end))
                    (clear-field
                     (yas--field-end clear-field))
                    (t (point))))
         (to-delete (and (> end start)
                         (buffer-substring-no-properties start end)))
         (yas-selected-text
          (cond (yas-selected-text)
                ((and (region-active-p)
                      (not clear-field))
                 to-delete))))
    (goto-char start)
    (setq yas--indent-original-column (current-column))
    ;; Delete the region to delete, this *does* get undo-recorded.
    (when to-delete
      (delete-region start end))

    (let ((content (if (yas--template-p snippet)
                       (yas--template-content snippet)
                     snippet)))

      ;; (tvd content)
      ;; (tvd "hi")
      (when (and (not expand-env) (yas--template-p snippet))
        (setq expand-env (yas--template-expand-env snippet)))
      (cond ((listp content)
             ;; x) This is a snippet-command.
             (yas--eval-for-effect content))
            (t
             ;; x) This is a snippet-snippet :-)
             (setq yas--start-column (current-column))
             ;; Stacked expansion: also shoosh the overlay modification hooks.
             (let ((yas--inhibit-overlay-hooks t))
               (setq snippet
                     (yas--snippet-create content expand-env start (point)))
               ;; (tvd (str snippet))
               )

             ;; Stacked-expansion: This checks for stacked expansion, save the
             ;; `yas--previous-active-field' and advance its boundary.
             (let ((existing-field (and yas--active-field-overlay
                                        (overlay-buffer yas--active-field-overlay)
                                        (overlay-get yas--active-field-overlay 'yas--field))))
               (when existing-field
                 (setf (yas--snippet-previous-active-field snippet) existing-field)
                 (yas--advance-end-maybe existing-field (overlay-end yas--active-field-overlay))))

             ;; Exit the snippet immediately if no fields.
             (unless (yas--snippet-fields snippet)
               (yas-exit-snippet snippet))

             ;; Now, schedule a move to the first field.
             (let ((first-field (car (yas--snippet-fields snippet))))
               (when first-field
                 (sit-for 0) ;; fix issue 125
                 (yas--letenv (yas--snippet-expand-env snippet)
                   (yas--move-to-field snippet first-field))
                 (when (and (eq (yas--field-number first-field) 0)
                            (> (length (yas--field-text-for-display
                                        first-field))
                               0))
                   ;; Keep region for ${0:exit text}.
                   (setq deactivate-mark nil))))
             (yas--message 4 "snippet %d expanded." (yas--snippet-id snippet))
             t)))))

(defun my-yas-preview-snippet-under-cursor ()
  "Preview the snippet under the cursor"
  (interactive)
  (apply
   (lambda (template) (yas--visit-snippet-file-1 template))
   (button-get (button-at (point)) (quote help-args)))
  ;; (view-mode 1)
  (other-window 1)
  nil)

(define-key help-mode-map (kbd "C-h") 'my-yas-preview-snippet-under-cursor)

;; Unbind all of these
;; (define-key yas-minor-mode-map (kbd "C-c & C-n") nil)
;; (define-key yas-minor-mode-map (kbd "C-c & C-s") nil)
;; (define-key yas-minor-mode-map (kbd "C-c & C-v") nil)
;; Unbind the prefix keys too
;; (define-key yas-minor-mode-map (kbd "C-c &") nil)
;; This is enough
(define-key yas-minor-mode-map (kbd "C-c") nil)

(define-key yas-minor-mode-map (kbd "TAB") nil)

(defun get-interpreter-for-file (fp)
  (e/chomp (bp xargs get-interpreter-for-file fp)))

(defun get-interpreter-for-buffer ()
  (let ((tf (or (if (and (not (eq major-mode 'org-mode))
                         (string-match-p "\.org$" (get-path)))
                    (concat "x\." (get-ext-for-mode)))
                (if (eq major-mode 'fundamental-mode)
                    "x\.sh")
                (get-path))))

    (concat "#!" (e/chomp (bp xargs get-shebang-for-file tf)))))


(defun yas--snippet-parse-create (snippet)
  "Parse a recently inserted snippet template, creating all
necessary fields, mirrors and exit points.

Meant to be called in a narrowed buffer, does various passes"
  (let ((saved-quotes nil)
        (parse-start (point)))
    ;; Avoid major-mode's syntax propertizing function, since we
    ;; change the syntax-table while calling `scan-sexps'.
    (let ((syntax-propertize-function nil))
      (setq yas--dollar-regions nil)  ; Reset the yas--dollar-regions.
      (yas--protect-escapes nil '(?`))  ; Protect just the backquotes.
      (goto-char parse-start)
      (setq saved-quotes (yas--save-backquotes)) ; `expressions`.
      (yas--protect-escapes)            ; Protect escaped characters.
      (goto-char parse-start)
      (yas--indent-parse-create)        ; Parse indent markers: `$>'.
      (goto-char parse-start)
      (yas--field-parse-create snippet) ; Parse fields with {}.
      (goto-char parse-start)
      (yas--simple-fom-create snippet) ; Parse simple mirrors & fields.
      (goto-char parse-start)
      (yas--transform-mirror-parse-create snippet) ; Parse mirror transforms.
      ;; Invalidate any syntax-propertizing done while
      ;; `syntax-propertize-function' was nil.
      (syntax-ppss-flush-cache parse-start))
    ;; Set "next" links of fields & mirrors.
    (yas--calculate-adjacencies snippet)
    (yas--save-restriction-and-widen    ; Delete $-constructs.
      (yas--delete-regions yas--dollar-regions))
    ;; Make sure to do this insertion *after* deleting the dollar
    ;; regions, otherwise we invalidate the calculated positions of
    ;; all the fields following $0.
    (let ((exit (yas--snippet-exit snippet)))
      (goto-char (if exit (yas--exit-marker exit) (point-max))))
    (when (eq yas-wrap-around-region 'cua)
      (setq yas-wrap-around-region ?0))
    (cond ((and yas-wrap-around-region yas-selected-text)
           (insert yas-selected-text))
          ((and (characterp yas-wrap-around-region)
                (get-register yas-wrap-around-region))
           (insert (prog1 (get-register yas-wrap-around-region)
                     (set-register yas-wrap-around-region nil)))))
    (yas--restore-backquotes saved-quotes)  ; Restore `expression` values.
    (goto-char parse-start)
    (yas--restore-escapes)        ; Restore escapes.
    (yas--update-mirrors snippet) ; Update mirrors for the first time.
    (goto-char parse-start)))

(define-key global-map (kbd "M-5") 'company-yasnippet)


(defun yas-insert-snippet-around-advice (proc &rest args)
  (yas-minor-mode 1)
  (let ((res (apply proc args)))
    res))
(advice-add 'yas-insert-snippet :around #'yas-insert-snippet-around-advice)



(defun my-yas-insert-snippet ()
  (interactive)
  (cond
   ((major-mode-p 'term-mode)
    (yas-insert-snippet-term))
   ((major-mode-p 'vterm-mode)
    (yas-insert-snippet-vterm))
   (t
    (yas-insert-snippet))))


(defun yas-insert-snippet-term ()
  (interactive)
  ;; Firstly, get off the current term window. It will go haywire with fz
  (let ((s))
    (save-window-excursion
      (switch-to-buffer "*scratch*")
      (let ((b (new-buffer-from-string "" "yastemp" (str2sym (fz (chomp (sn "find /home/shane/source/git/mullikine/yas-snippets -maxdepth 1 -mindepth 1 -type d | sed '/\\.git/d' | sed 's=^.*/=='"))
                                                                 nil nil "yas-insert-snippet-term: ")))))
        (save-window-excursion
          (save-excursion
            (with-current-buffer b
              (switch-to-buffer b)
              (yas-insert-snippet))))
        (setq s (buffer-to-string b))
        (kill-buffer b)))
    (term-send-raw-string s)))

(defun yas-insert-snippet-vterm ()
  (interactive)
  ;; Firstly, get off the current term window. It will go haywire with fz
  (let ((s))
    (save-window-excursion
      (switch-to-buffer "*scratch*")
      (let ((b (new-buffer-from-string "" "yastemp" (str2sym (fz (chomp (sn "find /home/shane/source/git/mullikine/yas-snippets -maxdepth 1 -mindepth 1 -type d | sed '/\\.git/d' | sed 's=^.*/=='"))
                                                                 nil nil "yas-insert-snippet-term: ")))))
        (save-window-excursion
          (save-excursion
            (with-current-buffer b
              (switch-to-buffer b)
              (yas-insert-snippet))))
        (setq s (buffer-to-string b))
        (kill-buffer b)))
    (vterm-insert s)))


;; (define-key term-mode (kbd "M-l M-s M-i") 'yas-insert-snippet-term)
;; (define-key term-raw-map (kbd "M-l M-s M-i") 'yas-insert-snippet-term)

(provide 'my-yasnippet)