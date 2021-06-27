(defun my-font-lock-restart ()
  (interactive)
  (setq font-lock-mode-major-mode nil)
  (font-lock-fontify-buffer))

;; TODO load a list from a text file

(defun enable-custom-syntax-highlighting (m)
  (interactive)
  (set (make-local-variable 'tpb-term-font-lock-keywords)
       ;; '(("\\_<\\(720\\|1080\\|2019\\)\\_>" . font-lock-function-name-face)
       ;;   ("\\_<\\(Magnet\\S[0-9]+E[0-9]+\\)\\_>" . font-lock-constant-face))
       '(
         ;; J 270
         ;; Not sure if works. It does but it's naive
         ;; ("\"[^\"]+?\"" 0 font-lock-string-face keep t)
         ;; This works
         ;; ("([^)]+?)" 0 font-lock-string-face keep t)
         ;; Works
         ;; ("J" 0 font-lock-string-face keep t)
         ;; This works but it doesn't override the existing syntax highlighting
         ("\\(J\\|T\\)" 0 font-lock-string-face keep t)
         ("\\(720\\|1080\\|2019\\)" . font-lock-function-name-face)
         ("\\(Magnet\\|S[0-9]+E[0-9]+\\)" . font-lock-constant-face)))
  (font-lock-add-keywords nil tpb-term-font-lock-keywords)

  (if (fboundp 'font-lock-flush)
      (font-lock-flush)
    (when font-lock-mode
      (with-no-warnings (font-lock-fontify-buffer)))))

(defset python-mode-terms (list
                           'python-version))

(defun major-mode-function (&optional mode)
  (interactive)
  (if (not mode)
      (setq mode major-mode))
  (let* ((mode-list (parent-mode-list mode))
         (funcs

          (flatten-once
           (-filter 'identity
                    (cl-loop for m in mode-list collect
                             (let ((l (str2sym (concat (sym2str m) "-funcs"))))
                               (if (variable-p l)
                                   (eval l))))))))
    ;; (message (apply 'cmd funcs))
    ;; (with-current-buffer
    ;;     (nbfs (pp-to-string funcs) nil 'emacs-lisp-mode)
    ;;   (ekm "M"))
    (call-interactively (str2sym (fz funcs nil nil (concat (sym2str mode) " function: "))))))

(provide 'my-mode-highlighting)