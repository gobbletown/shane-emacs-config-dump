(require 'my-handle)



(defun record-prog-mode-lang ()
  (interactive)
  (let* ((fn (or (buffer-file-name) ""))
         (bn (try (basename fn)
                  ""))
         (ext (if (and fn (s-match "\\." bn))
                  (s-replace-regexp ".*\." "" bn)
                nil))
         (mms (current-major-mode-string))
         (line (ifn ext (concat mms " " ext) mms)))
    (append-uniq-to-file (awk1 line) "/home/shane/notes/ws/emacs/file-types.txt")))

;; (add-hook 'prog-mode-hook 'record-prog-mode-lang)
;; (remove-hook 'prog-mode-hook 'record-prog-mode-lang)


(defun my-comment-time-stamp ()
  "Insert a timestamp. Designed for comments"
  (interactive)
  (call-interactively 'org-time-stamp)
  (search-backward "<" (pos-at-start-of-line)))


;; Use this only for code-generation, not for creating functions
(defmacro make-next-prev-def-for-mode (&optional m defaultre)
  (if (not m)
      (setq m major-mode))
  (if (not defaultre)
      (setq defaultre "^[^#;/ \t]+ "))
  (let ((prevdefsym (str2sym (concat "my-" (str m) "-prev-def")))
        (nextdefsym (str2sym (concat "my-" (str m) "-next-def"))))
    `(progn
       (defun ,prevdefsym (&optional re)
         (interactive)
         (if (not re)
             (setq re ,defaultre))
         (backward-to-indentation 0)
         (ignore-errors (search-backward-regexp re))
         (backward-to-indentation 0))

       (defun ,nextdefsym (&optional re)
         (interactive)
         (if (not re)
             (setq re ,defaultre))
         (backward-to-indentation 0)
         (if (looking-at-p re)
             (progn
               (forward-char)))
         (try (search-forward-regexp re))
         (backward-to-indentation 0)))))


;; $HOME/.cask/features/eval.feature
(defvar my-feature-mode-def-pattern "^ *[A-Z][a-z]+: ")
(defvar my-Custom-mode-def-pattern "^\\(Show\\|Hide\\) ")


;; DISCARD First check if a mode-specific next-def function exists generated from macro above
;; DONE Check first for a mode-specific pattern before using the default
;; TODO If imenu is available then I should try to use imenu
(defun my-prog-prev-def (&optional re)
  (interactive)
  (if (not re)
      (let ((patternsym (str2sym (concat "my-" (current-major-mode-string) "-def-pattern"))))
        (if (variable-p patternsym)
            (setq re (eval patternsym))
          (setq re "^[^#;/ \t]+ "))))
  (backward-to-indentation 0)
  (search-backward-regexp re)
  (backward-to-indentation 0))


(defun my-prog-next-def (&optional re)
  (interactive)
  (if (not re)
      (let ((patternsym (str2sym (concat "my-" (current-major-mode-string) "-def-pattern"))))
        (if (variable-p patternsym)
            (setq re (eval patternsym))
          (setq re "^[^#;/ \t]+ "))))
  (backward-to-indentation 0)
  (if (looking-at-p re)
      (progn
        (forward-char)))
  (try (search-forward-regexp re))
  (backward-to-indentation 0))


;; This should remove bindings from all derived prog modes so the prog mode bindings should come through
;; (defun prog-set-bindings ()
;;   (interactive)
;;   (if (not (eq major-mode 'prog-mode))
;;       (progn
;;         (message (concat "test:" (sym2str (current-major-mode-map))))
;;         ;; (eval `(define-key ,(current-major-mode-map) (kbd "M-9") nil))
;;         ;; (eval `(define-key ,(current-major-mode-map) (kbd "M-.") nil))
;;         )))

;; (add-hook 'prog-mode-hook 'prog-set-bindings)

;; (defun hook-disable-selected ()
;;   (selected-minor-mode -1))

;; (defun hook-enable-selected ()
;;   (selected-minor-mode t))

;; (add-hook 'fundamental-mode-hook 'hook-disable-selected)
;; (remove-hook 'fundamental-mode-hook 'hook-enable-selected)
;; (add-hook 'prog-mode-hook 'hook-enable-selected)
;; (remove-hook 'prog-mode-hook 'hook-enable-selected)


;; When bindings are inherited they are assigned to the derived mode, not prog-mode
;; Therefore I can't do the above

;; TODO Figure out how to make this work. I may need to do asynchronous stuff
(defun my-handle-repls ()
  (interactive)
  ;; If it changes when I run handle-repls, then stay. If it doesn't change then return

  (let* (
         ;; get-previous-buffer is often incorrect, though it serves as a good indication of a buffer change, which is enough
         (pb (get-previous-buffer))
         (ib (current-buffer))
         ;; This appears to switch the buffer asynchronously
         ;; But i need to find out what the new buffer is
         (ret
          (progn
            ;; Unfortunately, some commands can't be waited for
            ;; Does that mean this entire function must be placed in a separate thread?
            ;; (et-clj-rebel)
            (handle-repls nil)
            ;; (sleep-for 2)
            ))
         (cb (current-buffer)))
    ;; (async-start
    ;;  (lambda () (sleep-for 1))
    ;;  (lambda () (message "hi")))
    (message (str ib))
    (message (str cb))
    (if (eq ib cb)
        nil
      ;; (switch-to-buffer pb)
      ;; (switch-to-previous-buffer)
      ))

  ;; Frustratingly, this wont work.
  ;; Some functions simply wont work in a thread.
  ;; (async-start
  ;;  (lambda ()
  ;;    (handle-repls nil)
  ;;    ;; (let* (
  ;;    ;;        ;; get-previous-buffer is often incorrect, though it serves as a good indication of a buffer change, which is enough
  ;;    ;;        (pb (get-previous-buffer))
  ;;    ;;        (ib (current-buffer))
  ;;    ;;        ;; This appears to switch the buffer asynchronously
  ;;    ;;        ;; But i need to find out what the new buffer is
  ;;    ;;        (ret
  ;;    ;;         (progn
  ;;    ;;           ;; Unfortunately, some commands can't be waited for
  ;;    ;;           ;; Does that mean this entire function must be placed in a separate thread?
  ;;    ;;           (handle-repls nil)
  ;;    ;;           (sleep-for 2)))
  ;;    ;;        (cb (current-buffer)))
  ;;    ;;   ;; (async-start
  ;;    ;;   ;;  (lambda () (sleep-for 1))
  ;;    ;;   ;;  (lambda () (message "hi")))
  ;;    ;;   (message (str ib))
  ;;    ;;   (message (str cb))
  ;;    ;;   (if (eq ib cb)
  ;;    ;;       nil
  ;;    ;;     ;; (switch-to-buffer pb)
  ;;    ;;     ;; (switch-to-previous-buffer)
  ;;    ;;     ))
  ;;    ))
  )

(defun my-handle-repls ()
  (interactive)
  ;; If it changes when I run handle-repls, then stay. If it doesn't change then return
  (if (str-match-p "*" (buffer-name))
      (previous-buffer)
    (handle-repls nil))

  ;; (let* (
  ;;        ;; get-previous-buffer is often incorrect, though it serves as a good indication of a buffer change, which is enough
  ;;        (pb (get-previous-buffer))
  ;;        (ib (current-buffer))
  ;;        ;; This appears to switch the buffer asynchronously
  ;;        ;; But i need to find out what the new buffer is
  ;;        ;; (ret
  ;;        ;;  (progn
  ;;        ;;    (progn
  ;;        ;;      (message
  ;;        ;;       (concat
  ;;        ;;        "b:"
  ;;        ;;        (str (current-buffer))))
  ;;        ;;      (message
  ;;        ;;       (concat
  ;;        ;;        "b2:"
  ;;        ;;        (str (et-clj-rebel))))
  ;;        ;;      (message
  ;;        ;;       (concat
  ;;        ;;        "b3:"
  ;;        ;;        (str (current-buffer)))))
  ;;        ;;    ;; Unfortunately, some commands can't be waited for
  ;;        ;;    ;; Does that mean this entire function must be placed in a separate thread?
  ;;        ;;    ;; (et-clj-rebel)
  ;;        ;;    ;; (handle-repls nil)
  ;;        ;;    ;; (sleep-for 2)
  ;;        ;;    ))
  ;;        (cb (current-buffer)))
  ;;   ;; (async-start
  ;;   ;;  (lambda () (sleep-for 1))
  ;;   ;;  (lambda () (message "hi")))
  ;;   ;; ;; (message (str ib))
  ;;   ;; (message (str cb))
  ;;   ;; (if (eq ib cb)
  ;;   ;;     nil
  ;;   ;;   ;; (switch-to-buffer pb)
  ;;   ;;   ;; (switch-to-previous-buffer)
  ;;   ;;   )
  ;;   )

  ;; Frustratingly, this wont work.
  ;; Some functions simply wont work in a thread.
  ;; (async-start
  ;;  (lambda ()
  ;;    (handle-repls nil)
  ;;    ;; (let* (
  ;;    ;;        ;; get-previous-buffer is often incorrect, though it serves as a good indication of a buffer change, which is enough
  ;;    ;;        (pb (get-previous-buffer))
  ;;    ;;        (ib (current-buffer))
  ;;    ;;        ;; This appears to switch the buffer asynchronously
  ;;    ;;        ;; But i need to find out what the new buffer is
  ;;    ;;        (ret
  ;;    ;;         (progn
  ;;    ;;           ;; Unfortunately, some commands can't be waited for
  ;;    ;;           ;; Does that mean this entire function must be placed in a separate thread?
  ;;    ;;           (handle-repls nil)
  ;;    ;;           (sleep-for 2)))
  ;;    ;;        (cb (current-buffer)))
  ;;    ;;   ;; (async-start
  ;;    ;;   ;;  (lambda () (sleep-for 1))
  ;;    ;;   ;;  (lambda () (message "hi")))
  ;;    ;;   (message (str ib))
  ;;    ;;   (message (str cb))
  ;;    ;;   (if (eq ib cb)
  ;;    ;;       nil
  ;;    ;;     ;; (switch-to-buffer pb)
  ;;    ;;     ;; (switch-to-previous-buffer)
  ;;    ;;     ))
  ;;    ))
  )

;; you can set default/global handlers by targeting modes like prog-mode and text-mode.
;; (define-key prog-mode-map (kbd "M-=") 'handle-repls)
(define-key prog-mode-map (kbd "M-=") 'my-handle-repls)
(define-key dired-mode-map (kbd "M-=") 'my-handle-repls)
(define-key global-map (kbd "M-=") 'my-handle-repls)
;; Keep it on global map. If it fails then it should go to the previous buffer

(define-key prog-mode-map (kbd "M-C") 'handle-debug)
(define-key global-map (kbd "H-RET") 'handle-run)

(define-key prog-mode-map (kbd "M-\"") 'my-helm-fzf)
(define-key prog-mode-map (kbd "M-@") 'handle-testall)
(define-key prog-mode-map (kbd "M-)") 'handle-assignments)
(define-key prog-mode-map (kbd "M-*") 'handle-references)
(define-key prog-mode-map (kbd "M-%") 'handle-formatters)
(define-key prog-mode-map (kbd "M-$") 'handle-errors)
(define-key global-map (kbd "M-$") 'handle-errors)
;; async-shell-command
(define-key global-map (kbd "M-&") 'handle-navtree)
;; This is reserved
(define-key prog-mode-map (kbd "M-+") nil)
(define-key prog-mode-map (kbd "M-_") nil)

;; nadvice - proc is the original function, passed in. do not modify
(defun handle-docs-around-advice (proc &rest args)
  (let ((res (apply proc args)))
    (deselect)
    res))
(advice-add 'handle-docs :around #'handle-docs-around-advice)

(define-key prog-mode-map (kbd "M-9") 'handle-docs)

(defun my-godef-or-global-references ()
  (interactive)
  (if (>= (prefix-numeric-value current-prefix-arg) 4)
      (call-interactively 'handle-global-references)
    (call-interactively 'handle-godef)))
(define-key prog-mode-map (kbd "M-.") 'my-godef-or-global-references)

;; (define-key prog-mode-map (kbd "H-w") 'handle-path)
;; (define-key prog-mode-map (kbd "H-w") nil)

(define-key prog-mode-map (kbd "M-p") 'handle-prevdef)
(define-key prog-mode-map (kbd "M-n") 'handle-nextdef)

(define-key prog-mode-map (kbd "M-P") 'handle-preverr)
(define-key prog-mode-map (kbd "M-N") 'handle-nexterr)

(define-key text-mode-map (kbd "M-P") 'handle-preverr)
(define-key text-mode-map (kbd "M-N") 'handle-nexterr)

(define-key markdown-mode-map (kbd "M-P") 'handle-preverr)
(define-key markdown-mode-map (kbd "M-N") 'handle-nexterr)

(defun new-line-and-indent ()
  (interactive)

  ;; Can't do this. It starts evil
  ;; (call-interactively 'evil-open-below)

  ;; This worked fine but the evil command is better
  (call-interactively 'move-end-of-line)
  (newline-and-indent)

  ;; This worked but was very simplistic
  ;; (call-interactively 'move-end-of-line)
  ;; (newline)
  ;; (indent-for-tab-command)
  )
(define-key prog-mode-map (kbd "M-RET") 'new-line-and-indent)

(define-key prog-mode-map (kbd "M-l M-j M-w") 'handle-spellcorrect)

(define-key prog-mode-map (kbd "C-x C-o") 'ff-find-other-file)

(define-key prog-mode-map (kbd "H-{") 'handle-callees)
(define-key prog-mode-map (kbd "H-}") 'handle-callers)

;; (define-key prog-mode-map (kbd "H-u") 'handle-showuml)
(define-key prog-mode-map (kbd "H-u") nil)

(define-key prog-mode-map (kbd "H-*") 'handle-refactor)

(define-key prog-mode-map (kbd "H-v") 'handlenav/body)

(dk prog-mode-map "M-J" 'evil-join)

(define-key prog-mode-map (kbd "C-c C-o") 'org-open-at-point)
(define-key prog-mode-map (kbd "C-c h f") 'handle-docfun)


(defun run-file-with-interpreter (fp)
  (interactive (list (read-file-name "File: ")))
  (nw (cmd "run" fp) "-pak"))

(provide 'my-prog)
