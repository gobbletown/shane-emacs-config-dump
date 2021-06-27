(require 'swiper)
(require 'helm-swoop)

;; not sure which I prefer
;; (defvar swipecmd 'swiper)
(defvar swipecmd 'swiper)
;;(defvar swipecmd 'helm-swoop)

;; Not sure if this bug still exists. Dont use or you'll run swiper twice
(defun my-swiper (&optional initial-input)
  "Fixes the initial Lisp nesting exceeds ‘max-lisp-eval-depth’ error after opening a file and running swiper for the first time."
  (interactive)
  (swiper initial-input)
  (swiper initial-input)
  ;; (try (call-interactively swipecmd)
  ;;      (call-interactively swipecmd))
  ;; (if initial-input
  ;;     (ekml initial-input))
  )

(defun my-swipe ()
  (interactive)
  (let ((s (selection))
        (x visual-line-mode))

    (if (selectedp)
        (deselect))

    (setf visual-line-mode -1)
    ;; Annoyingly, counsel is buggy outside of spacemacs
    ;; (if (cl-search "SPACEMACS" my-daemon-name)
    ;;     ;; Need to make my own counsel-grep-or-swiper command
    ;;     ;; (call-interactively 'counsel-grep-or-swiper)
    ;;     ;; (call-interactively 'my/swiper)
    ;;     (swiper s)
    ;;   (swiper s))
    ;; (swiper s)
    (consult-line s)
    (setf visual-line-mode x)))

;; ;; Can I make this include newline in the .* ?
;; (defun swiper--re-builder (str)
;;   "Transform STR into a swiper regex.
;; This is the regex used in the minibuffer where candidates have
;; line numbers.  For the buffer, use `ivy--regex' instead."
;;   (let* ((re-builder (ivy-alist-setting ivy-re-builders-alist))
;;          (re (cond
;;                ((equal str "")
;;                 "")
;;                ((equal str "^")
;;                 (setq ivy--subexps 0)
;;                 ".")
;;                ((= (aref str 0) ?^)
;;                 (let* ((re (funcall re-builder (substring str 1)))
;;                        (re (if (listp re)
;;                                (mapconcat (lambda (x)
;;                                             (format "\\(%s\\)" (car x)))
;;                                           (cl-remove-if-not #'cdr re)
;;                                           ".*?")
;;                              re)))
;;                   (if (zerop ivy--subexps)
;;                       (prog1 (format "^ ?\\(%s\\)" re)
;;                         (setq ivy--subexps 1))
;;                     (format "^ %s" re))))
;;                ((eq (bound-and-true-p search-default-mode) 'char-fold-to-regexp)
;;                 (mapconcat #'char-fold-to-regexp (ivy--split str) ".*"))
;;                (t
;;                 (funcall re-builder str)))))
;;     re))

;; Because I am using C-M-s for the search engine, use C-M-z for regex
;; search in emacs
;;(define-key my-mode-map (kbd "C-M-z") #'isearch-forward-regexp)
;;;;(define-key my-mode-map (kbd "C-M-z") 'isearch-forward-regexp)
;;(define-key isearch-mode-map "\C-\M-z" 'isearch-repeat-forward)

;;(define-key my-mode-map (kbd "C-M-z") 'isearch-forward-regexp)


(defun stribb/isearch-region (&optional not-regexp no-recursive-edit)
  "If a region is active, make this the isearch default search pattern."
  (interactive "P\np")
  (when (use-region-p)
    (let ((search (buffer-substring-no-properties
                   (region-beginning)
                   (region-end))))
      ;; (message "stribb/ir: %s %d %d" search (region-beginning) (region-end))
      (setq deactivate-mark t)
      (isearch-yank-string search))))

(advice-add 'isearch-forward-regexp :after 'stribb/isearch-region)
(advice-add 'isearch-forward :after 'stribb/isearch-region)


;; (ekm "C-s C-s")
;; (isearch-forward-regexp)
;; (ekm "C-s")

(require 'helm-org-rifle)
(defun my-isearch-forward ()
  (interactive)
  (cond
   ;; Single C-u is already used by isearch-forward-regexp to make it non-regex
   ;; ((>= (prefix-numeric-value current-prefix-arg) 4) (let ((current-prefix-arg nil))
   ;;                                                     (call-interactively 'helm-org-rifle)))
   ((>= (prefix-numeric-value current-prefix-arg) 8) (let ((current-prefix-arg nil))
                                                       (call-interactively 'helm-org-rifle)))
   (t (call-interactively 'isearch-forward-regexp))))

;; (define-key global-map (kbd "C-s") #'isearch-forward-regexp)
;; (define-key global-map (kbd "C-s") #'my-isearch-forward)

;; This is replaced by M-l C-s
;; (define-key global-map (kbd "C-s") 'my-swipe)

(define-key isearch-mode-map "\C-s" 'isearch-repeat-forward)


(defun swiper-dir (&optional dir)
  (interactive (list (read-string-hist "swiper dir:")))
  (with-current-buffer
    (dired dir)
    (call-interactively 'swiper)))

(provide 'my-swipe)