(defun fz-insert-function ()
  "Insert a function from my favorite functions."
  (interactive)
  (insert
   (concat "(" (fz-namespaces-func) ")"))
  (backward-char)
  ;; (insert " ")
  ;; (ekm " ")
  (tsl " "))

(defun list-namespaces ()
  (interactive)
  (fz _namespaces nil nil "ns:" t))

(defun fz-namespaces-func ()
  (interactive)
  (fz (str2sym (fz _namespaces nil nil "ns:" t)) nil nil "ns/func:" t))

(defvar list-of-thing-lookups
  '(wiki-summary))

(defvar list-of-fuzzy-search-engines
  '(helm-hoogle helm-google))

(defun go-to-glossary ()
  "Go to one of the glossaries in my notes"
  (interactive)
  (let ((fp (umn (fz (mnm ;; (b find $HOME/notes/ws/glossaries -type f -o -type l)
                      (b find $MYGIT/mullikine/glossaries -type f -o -type l))
                     nil
                     nil
                     "go-to-glossary: "))))
    (find-file fp)))

(defun go-to-todo-list ()
  (interactive)
  (let ((fp (umn (fz (mnm
                      (b find $NOTES -type f -name todo.org))
                     nil
                     nil
                     "go-to-todo-list: "))))
    (find-file fp)))

(defun go-to-remember-file ()
  (interactive)
  (let ((fp (umn (fz (mnm
                      (b find $NOTES -type f -name remember.org))
                     nil
                     nil
                     "go-to-remember-file: "))))
    (find-file fp)))


;; It might be nice to make this into an org file
;; That's probably better, actually
;; Make a heading with a name being the thing I am adding
;; When I go to add, it should show a fuzzy list of existing things
;; (org-imenu-get-tree)
;; (mapcar 'str (mapcar 'car (org-imenu-get-tree)))
;; This gets the top level headings
;; (fz (mapcar 'str (mapcar 'car (org-imenu-get-tree))))
;; my-org-list-top-level-headings
(defun add-to-fuzzy-list-txt (&optional sym lst)
  "Adds the symbol under cursor to the fuzzy list selected"
  (interactive (list
                (read-string-hist "add-to-fuzzy-list-txt: "
                                  (if (selected)
                                      (selection)
                                    ;; (sed-s "^\\*/" (str (thing-at-point 'sexp)))
                                    (esed "^\\*" "" (or (str (thing-at-point 'sexp))
                                                        ""))))
                (cond
                 ((major-mode-p 'prog-mode)
                  (concat "functions/" (detect-language))
                  ;; (concat "$HOME/notes/ws/lists/functions/" (detect-language) ".txt")
                  )
                 (t (fz
                     ;; (b find $HOME/notes/ws/lists -type f | path-lasttwo | sed "s/\\..*//")
                     (snc (concat (cmd "find" "$HOME/notes/ws/lists" "-type" "f") "| path-lasttwo | sed \"s/\\\\..*//\""))
                     nil
                     nil
                     "add-to-fuzzy-list: ")))))

  (let ((fp (umn (concat "$HOME/notes/ws/lists/" lst ".txt"))))
    (if (and sym lst)
        ;; (eval `(bp append-uniq ,fp ,sym))
        (snc (cmd "append-uniq" fp) sym))

    (e fp)))

(defun add-to-fuzzy-list-org (&optional sym lst)
  "Adds the symbol under cursor to the fuzzy list selected"
  (interactive (list
                (if (selected)
                    (selection)
                  ;; (sed-s "^\\*/" (str (thing-at-point 'sexp)))
                  (esed "^\\*" "" (or (str (thing-at-point 'sexp))
                                      "")))
                (cond
                 ((major-mode-p 'prog-mode)
                  (concat "functions/" (detect-language))
                  ;; (concat "$HOME/notes/ws/lists/functions/" (detect-language) ".org")
                  )
                 (t (fz
                     ;; (b find $HOME/notes/ws/lists -type f | path-lasttwo | sed "s/\\..*//")
                     (snc (concat (cmd "find" "$HOME/notes/ws/lists" "-type" "f" "-name" "*.org") "| path-lasttwo | sed \"s/\\\\..*//\""))
                     nil
                     nil
                     "add-to-fuzzy-list: ")))))

  (if (not lst)
      (setq lst
            (fz
             ;; (b find $HOME/notes/ws/lists -type f | path-lasttwo | sed "s/\\..*//")
             (snc (concat (cmd "find" "$HOME/notes/ws/lists" "-type" "f" "-name" "*.org") "| path-lasttwo | sed \"s/\\\\..*//\""))
             nil
             nil
             "add-to-fuzzy-list: ")))

  (let ((fp (umn (concat "$HOME/notes/ws/lists/" lst ".org")))
        (hn (concat "=" sym "=")))
    (with-current-buffer (e fp)
      (if (and sym lst)
          (if (-contains? (my-org-list-top-level-headings) hn)
              (my-org-select-heading hn)
            (progn
              (beginning-of-buffer)
              (newline)
              (backward-char)
              (insert (concat "* " hn))
              (save-buffer)))))))

(defun add-to-fuzzy-list-org-enter (&optional sym lst)
  "Adds the symbol under cursor to the fuzzy list selected"
  (interactive (list
                (read-string-hist "add-to-fuzzy-list-txt: "
                                  (if (selected)
                                      (selection)
                                    ;; (sed-s "^\\*/" (str (thing-at-point 'sexp)))
                                    (esed "^\\*" "" (or (str (thing-at-point 'sexp))
                                                        ""))))
                (cond
                 ((major-mode-p 'prog-mode)
                  (concat "functions/" (detect-language))
                  ;; (concat "$HOME/notes/ws/lists/functions/" (detect-language) ".org")
                  )
                 (t (fz
                     ;; (b find $HOME/notes/ws/lists -type f | path-lasttwo | sed "s/\\..*//")
                     (snc (concat (cmd "find" "$HOME/notes/ws/lists" "-type" "f" "-name" "*.org") "| path-lasttwo | sed \"s/\\\\..*//\""))
                     nil
                     nil
                     "add-to-fuzzy-list: ")))))

  (add-to-fuzzy-list-org sym lst))

(defun fuzzy-list-enter ()
  (interactive)
  (if (>= (prefix-numeric-value current-prefix-arg) 4)
      (call-interactively 'add-to-fuzzy-list-org-enter)
    (call-interactively 'go-to-fuzzy-list-org)))

(defun go-to-fuzzy-list-org (&optional sym lst)
  ""
  (interactive (list
                (if (selected)
                    (selection)
                  ;; (sed-s "^\\*/" (str (thing-at-point 'sexp)))
                  (esed "^\\*" "" (str (or (str (thing-at-point 'sexp))
                                           ""))))
                (cond
                 ((major-mode-p 'prog-mode)
                  (concat "functions/" (detect-language))
                  ;; (concat "$HOME/notes/ws/lists/functions/" (detect-language) ".org")
                  )
                 (t (fz
                     ;; (b find $HOME/notes/ws/lists -type f | path-lasttwo | sed "s/\\..*//")
                     (snc (concat (cmd "find" "$HOME/notes/ws/lists" "-type" "f" "-name" "*.org") "| path-lasttwo | sed \"s/\\\\..*//\""))
                     nil
                     nil
                     "add-to-fuzzy-list: ")))))

  (let ((fp (umn (concat "$HOME/notes/ws/lists/" lst ".org")))
        (hn (concat "=" sym "="))
        )
    (with-current-buffer (e fp)
      (let ((hs (my-org-list-top-level-headings)))
        (if (and sym lst)
            (if (-contains? hs hn)
                (my-org-select-heading hn)
              (if (and hs (> 1 (length hs)))
                  (call-interactively 'helm-imenu))))))))
(defalias 'go-to-fuzzy-list 'go-to-fuzzy-list-org)
(defalias 'add-to-fuzzy-list 'add-to-fuzzy-list-org)

(define-key global-map (kbd "M-4 M-l") #'add-to-fuzzy-list)
;; (define-key global-map (kbd "M-4") nil)


(define-key selected-keymap (kbd "F") 'add-to-fuzzy-list)
(define-key global-map (kbd "H-f") 'fuzzy-list-enter)
(define-key selected-keymap (kbd "G") 'go-to-fuzzy-list-org)

(provide 'my-fuzzy-lists)