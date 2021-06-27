(require 'iedit)

(define-key iedit-mode-occurrence-keymap (kbd "M-#") #'iedit-number-occurrences)
(define-key iedit-mode-occurrence-keymap (kbd "M-N") nil)

;; This is the same as what DEL is mapped to
(define-key iedit-mode-keymap (kbd "C-h") 'hungry-delete-backward)
;; (define-key iedit-mode-keymap (kbd "C-h") nil)


;; (defun iedit-regexp-quote (exp)
;;   "Return a regexp string."
;;   (cl-case iedit-occurrence-type-local
;;     ('symbol (concat "\\_<" (regexp-quote exp) "\\_>"))
;;     ('word   (concat "\\<" (regexp-quote exp) "\\>"))
;;     ('regexp exp)
;;     ( t      (regexp-quote exp))))

;; This may not be the problem. The problem may be restrictions
(defun iedit-regexp-quote (exp)
  "Return a regexp string."
  (cl-case iedit-occurrence-type-local
    ('symbol (concat "\\_<" (regexp-quote exp) "\\_>"))
    ('word   (concat "\\<" (regexp-quote exp) "\\>"))
    ('regexp exp)
    ;; ( t      (regexp-quote exp))
    ( t      (concat "\\<" (regexp-quote exp) "\\>"))))



;; DONE Fix iedit
;; Subsequent M-i should quit iedit.
;; Default should be entire buffer
;; (define-key iedit-mode-occurrence-keymap (kbd "M-i") 'iedit-quit)
(define-key iedit-mode-occurrence-keymap (kbd "M-i") 'iedit--quit)
;; (define-key iedit-mode-keymap (kbd "M-i") 'iedit-quit)
(define-key iedit-mode-keymap (kbd "M-i") 'iedit--quit)


;; Lispy-iedit was a little out of date. this fixed it
(defun lispy-iedit (&optional arg)
  "Wrap around `iedit'."
  (interactive "P")
  (require 'iedit)
  (if iedit-mode
      (progn
        ;; (iedit-mode nil)
        (iedit--quit)
        ;; (my/lisp-mode 1)
        )
    (progn
      ;; (my/lisp-mode -1)
      (when (lispy-left-p)
        (forward-char 1))
      (if arg
          (progn
            (setq current-prefix-arg arg)
            (iedit-mode))
        (iedit-mode)))))


;; This inverts the prefix arg
(defun iedit-mode-around-advice (proc &rest args)
  (cond
   ((equal current-prefix-arg (list 4)) (setq current-prefix-arg nil))
   ((not current-prefix-arg) (setq current-prefix-arg (list 4))))

  (let ((res (apply proc args)))
    res))
(advice-add 'iedit-mode :around #'iedit-mode-around-advice)



(define-key iedit-mode-occurrence-keymap (kbd "H-'") 'iedit-show/hide-unmatched-lines)
(define-key iedit-mode-keymap (kbd "H-'") 'iedit-show/hide-unmatched-lines)
(define-key global-map (kbd "H-'") 'iedit-enter-and-show-all)



;; (defvar search-ring nil
;; "List of search string sequences.")
;; (defvar regexp-search-ring nil
;;   "List of regular expression search string sequences.")
;; (defun isearch-update-ring (string &optional regexp)
;;   "Add STRING to the beginning of the search ring.
;; REGEXP if non-nil says use the regexp search ring."
;;   (let ((history-delete-duplicates t))
;;     (add-to-history
;;      (if regexp 'regexp-search-ring 'search-ring)
;;      (isearch-string-propertize string)
;;      (if regexp regexp-search-ring-max search-ring-max)
;;      t)))


;; Consider using my-select-regex-at-point
;; This sometimes is broken, but it does work
;; Expected behaviour: After getting blue text selection in iedit, press M-*, this should select the text again in green
(defun iedit-stop-and-isearch ()
  (interactive)
  (let ((edit t)
        (pat (iedit-current-occurrence-string)))
    (iedit--quit)
    ;; (isearch-abort)
    (isearch-exit)
    (isearch-update-ring pat)
    (isearch-update-ring pat t)
    (let ((isearch-mode-end-hook-quit (not edit)))
      (run-hooks 'isearch-mode-end-hook))

    ;; If there was movement, mark the starting position.
    ;; Maybe should test difference between and set mark only if > threshold.
    (if (/= (point) isearch-opoint)
        (or (and transient-mark-mode mark-active)
	          (progn
	            (push-mark isearch-opoint t)
	            (or executing-kbd-macro (> (minibuffer-depth) 0) edit
		              (message "Mark saved where search started")))))

    (and (not edit) isearch-recursive-edit (exit-recursive-edit))

    ;; Instead of running a search, select the thing
    ;; [[egr:select search pattern emacs]]
    ;; (call-interactively 'isearch-forward-regexp)
    ;; (call-interactively 'isearch-repeat-forward)

    (while (not (looking-at-p pat))
      (backward-char 1))
    (set-mark (point))
    ;; This assumes pat is a literal string
    (forward-char (length pat))))
(define-key iedit-mode-keymap (kbd "M-*") 'iedit-stop-and-isearch)



(defun iedit-enter-and-show-all ()
  (interactive)
  (if (not iedit-mode)
      (call-interactively 'iedit-mode))
  (iedit-show/hide-unmatched-lines))


(defun iedit-regexp-quote (exp)
  "Return a regexp string."
  (cl-case iedit-occurrence-type-local
    ('symbol (concat "\\_<" (regexp-quote exp) "\\_>"))
    ('word (concat "\\<" (regexp-quote exp) "\\>"))
    ('regexp exp)
    (t (regexp-quote exp))))


(provide 'my-iedit)