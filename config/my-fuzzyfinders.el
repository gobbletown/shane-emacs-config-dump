(defset list-of-config-lists
  (list
   'list-of-config-lists
   'list-of-fuzzyfinders))

(defun fuzzy-lists-of-config-lists ()
  (interactive)
  (let* ((sel (fz list-of-config-lists))
         (sym (str2sym sel)))
    (shut-up (find-variable sym))
    (message (concat "Arrived at " sel))))


(defset list-of-fuzzyfinders
  '(
    run-fs-search-function
    open-main
    helm-info
    my/reload-config-file
    describe-variable
    my-goto-library
    go-to-glossary
    helm-M-x
    my-helm-fzf
    my-counsel-ag
    my-swipe
    fz-find-config))

(defun fuzzy-fuzzy ()
  (interactive)
  (let ((sel (str2sym (fz list-of-fuzzyfinders))))
    (call-interactively sel)))

(defun generate-filesystem-search-functions-from-notes-list ()
  (cl-loop for c in
           (str2list (mu (e/cat "$NOTES/ws/fuzzy/filesystem-search-functions.txt")))
           collect
           (let* ((slug (concat "fs-sf-" (slugify c)))
                  (slugsym (str2sym slug)))
             (eval `(defun ,slugsym nil
                        (interactive)
                        (let ((fp
                               (fz (cl-sn (concat ,c " | sed 's=\\./=='") :chomp t) nil nil nil nil t)))
                          (if (not (string-empty-p fp))
                              (find-file fp))))))))

(defset sh-filesystem-search-functions (generate-filesystem-search-functions-from-notes-list))

(defun run-fs-search-function ()
  (interactive)
  (let ((fun (fz sh-filesystem-search-functions)))
    (if (not (string-empty-p fun))
        (call-interactively (str2sym fun)))))

(define-key global-map (kbd "H-z") 'fuzzy-fuzzy)
(define-key global-map (kbd "H-Z") 'fuzzy-lists-of-config-lists)

(define-key global-map (kbd "M-m f q") 'run-fs-search-function)


(defset my-common-commands
  '(mode-default-google-search))

(defun fz-run-common-command ()
  (interactive)
  (if (>= (prefix-numeric-value current-prefix-arg) 4)
      (j 'my-common-commands)
    (let ((c (fz my-common-commands)))
      (if (sor c)
          (setq c (str2sym c)))
      (if (commandp c)
          (call-interactively c)))))

(define-key my-mode-map (kbd "M-q M-y") 'fz-run-common-command)


(require 'dired)
;; This function is generated in this file
(define-key dired-mode-map (kbd "M-X") 'fs-sf-find-exe)


(provide 'my-fuzzyfinders)