;;; describe this point lisp only
;; Use helpful-symbol instead
(defun describe-foo-at-point ()
  "Show the documentation of the Elisp function and variable near point.
	This checks in turn:
	-- for a function name where point is
	-- for a variable name where point is
	-- for a surrounding function call
	"
	(interactive)
	(let (sym)
	  ;; sigh, function-at-point is too clever.  we want only the first half.
	  (cond ((setq sym (ignore-errors
                       (with-syntax-table emacs-lisp-mode-syntax-table
                         (save-excursion
                           (or (not (zerop (skip-syntax-backward "_w")))
                               (eq (char-syntax (char-after (point))) ?w)
                               (eq (char-syntax (char-after (point))) ?_)
                               (forward-sexp -1))
                           (skip-chars-forward "`'")
        	                 (let ((obj (read (current-buffer))))
                             (and (symbolp obj) (fboundp obj) obj))))))
           (describe-function sym))
          ((setq sym (variable-at-point)) (describe-variable sym))
          ;; now let it operate fully -- i.e. also check the
          ;; surrounding sexp for a function call.
          ((setq sym (function-at-point)) (describe-function sym)))))

;; (defalias 'describe-thing-at-point 'describe-foo-at-point)

(require 'my-hash)
(defun helpful-thing-at-point (&optional args)
  (interactive "P")
  (if (not args) (setq args (symbol-at-point)))
  (if args
      (cond ((hash-table-p (eval args)) (describe-hash args))
            (t (helpful-symbol args)))))

(defalias 'describe-thing-at-point 'helpful-thing-at-point)

;; (with-help-window (help-buffer))
;; (with-temp-buffer-window (help-buffer) nil nil)

;; This prevents the help window from being selected
(setq help-window-select nil)


;; (defun goto-function-from-binding ()
;;   "Go to the function name associated with a key binding after entering it"
;;   (interactive)
;;   (let* ((sequence (uq (format "%S" (key-description (read-key-sequence-vector "Key: "))))))
;;     (find-function (key-binding (kbd sequence)))))


(defun goto-function-from-binding (sequence)
  "Go to the function name associated with a key binding after entering it"
  (interactive (list (format "%s" (key-description (read-key-sequence-vector "Key: ")))))
  (find-function (key-binding (kbd sequence))))

(defun get-map-for-key-binding (sequence)
  "This works"
  (interactive (list (format "%s" (key-description (read-key-sequence-vector "Key: ")))))
  ;; (my/copy sequence)
  (my/copy (sym2str (help--binding-locus (kbd sequence) nil))))


(define-key global-map (kbd "<help> <left>") #'view-hello-file)
(define-key global-map (kbd "<help> M-RET") #'describe-mode)
(define-key global-map (kbd "<help> <deletechar>") (lm (show-map)))
(define-key global-map (kbd "<help> M") #'show-map)
(define-key global-map (kbd "<help> <up>") #'helpful-key)
(define-key global-map (kbd "<help> <end>") #'describe-bindings)

;; (define-key global-map (kbd "C-H-h") (df ead-show-hyper-key (with-current-buffer
;;                                                                 (new-buffer-from-string (sn "cd \"/home/shane/var/smulliga/source/git/config/emacs/config\"; ead \"\\\"H-\" | cat"))
;;                                                               (grep-mode))))


;; TODO I should put under =read-string...= all the functions I want to use that ask for things interactively from the user
;; (mu (eead ":require" "$MYGIT/mullikine" "\\.clj$"))
(defun my/wgrep (pattern &optional wd path-re)
  (interactive (list (read-string-hist "ead pattern: ")
                     (read-directory-name "ead dir: ")))

  ;; (ns pattern)

  (if (>= (prefix-numeric-value current-prefix-arg) 4)
      (sh/wgrep pattern wd)
    (progn
      (if (not wd)
          (setq wd (my/pwd)))
      (setq wd (umn wd))
      (with-current-buffer
          ;; How can I use mnm but only on the file paths? -- I want to be able to filter on a column only
          (let ((globstr (if (sor path-re)
                             (concat "-p " (e/q path-re) " "))))
            (new-buffer-from-string (ignore-errors (sn (concat "ead " globstr (q pattern) " | mnm | cat") nil wd))))
        ;; (tv (current-buffer-name))
        (grep-mode)))))
(defalias 'wgrep 'my/wgrep)
(defalias 'eead 'my/wgrep)

(defun sh/wgrep (pattern &optional wd)
  (interactive (list (read-string-hist "ead pattern: ")
                     (read-directory-name "ead dir: ")))
  (nw (concat "set -x; cd " (q wd) "; ead " (q (concat "\\b" pattern "\\b")) " || pak")))


(defun ead-show-super-key ()
  (interactive)
  (wgrep "\"s-" "$EMACSD/config"))
(define-key global-map (kbd "C-s-h") 'ead-show-super-key)

(defun ead-show-hyper-key ()
  (interactive)
  (wgrep "\"H-" "$EMACSD/config"))
(define-key global-map (kbd "C-H-h") 'ead-show-hyper-key)


(define-key global-map (kbd "<help> g") #'widget-browse)

(defun emacshelp (name)
  (try (info name) (progn (kill-buffer "*info*")
                          (let ((fp (locate-library name)))
                            (if fp
                                (find-file fp)
                              (helpful-function (str2sym name))))))
  nil)



(defun toggle-context-help ()
  "Turn on or off the context help.
Note that if ON and you hide the help buffer then you need to
manually reshow it. A double toggle will make it reappear"
  (interactive)
  (with-current-buffer (help-buffer)
    (unless (local-variable-p 'context-help)
      (set (make-local-variable 'context-help) t))
    (if (setq context-help (not context-help))
        (progn
          (if (not (get-buffer-window (help-buffer)))
              (display-buffer (help-buffer)))))
    (message "Context help %s" (if context-help "ON" "OFF"))))

(defun context-help ()
  "Display function or variable at point in *Help* buffer if visible.
Default behaviour can be turned off by setting the buffer local
context-help to false"
  (interactive)
  (let ((rgr-symbol (symbol-at-point))) ; symbol-at-point
                    ; http://www.emacswiki.org/cgi-bin/wiki/thingatpt%2B.el
    (with-current-buffer (help-buffer)
     (unless (local-variable-p 'context-help)
       (set (make-local-variable 'context-help) t))
     (if (and context-help (get-buffer-window (help-buffer))
         rgr-symbol)
       (if (fboundp  rgr-symbol)
           (describe-function rgr-symbol)
         (if (boundp  rgr-symbol) (describe-variable rgr-symbol)))))))


(defun my-goto-library (library-name)
  (interactive (list (fz features)
                     ;; (read-string-hist "library name: ")
                     ))
  (if (not (string-empty-p library-name))
      (let ((path (or (helpful--library-path library-name) "")))
        (if (not (string-empty-p path))
            (e path)
          (progn
            (wgrep (concat "(provide '" library-name ")") "$EMACSD/config"))))))

(global-set-key (kbd "H-r") #'my-goto-library)
(global-set-key (kbd "<help> r") #'my-goto-library)


(provide 'my-help)