(require 'org-brain)
(require 'my-lists)

(defalias 'org-brain-entry-to-string 'org-brain-entry-name)

;; To fix a dependency
(require 'org-indent)

;; To fix a dependency
(require 'org-capture)

;; TODO Make this
;; org-brain-mind-map-child-level
;; (defcustom org-brain-category-icon-width 2
;;   "The character width of icons."
;;   :group 'org-brain
;;   :type '(integer))

(use-package org-brain :ensure t
  :init
  (setq org-brain-path "~/org-brains/billboard")
  ;; For Evil users
  ;;(with-eval-after-load 'evil
  ;;  (evil-set-initial-state 'org-brain-visualize-mode 'emacs))
  :config
  (setq org-id-track-globally t)
  (setq org-id-locations-file "~/.emacs.d/.org-id-locations")
  (push '("b" "Brain" plain (function org-brain-goto-end)
          "* %i%?" :empty-lines 1)
        org-capture-templates)
  (setq org-brain-visualize-default-choices 'all)
  ;; (setq org-brain-title-max-length 12)

  ;; This is far more reasonable
  (setq org-brain-title-max-length 30))


(defsetface org-brain-title
  '((t :foreground "#999999"
       ;; :background "#2e2e2e"
       :weight bold
       :underline nil))
  "Face for org-brain-title (not a button).")

(defsetface org-brain-parent
  '((t :foreground "#dd4444"
       :background "#2e2e2e"
       :weight bold
       :underline t))
  "Face for org-brain-parent buttons.")

(defsetface org-brain-history-list
  '((t :foreground "#dd4400"
       ;; It's better for the glossary buttons to have no background, so normal syntax things, such as LSP highlighting can still be visible
       ;; underline is enough
       :background "#2e2e2e"
       :weight bold
       :underline t))
  "Face for org-brain-child buttons.")

(defsetface org-brain-child
  '((t :foreground "#dd4400"
       ;; It's better for the glossary buttons to have no background, so normal syntax things, such as LSP highlighting can still be visible
       ;; underline is enough
       :background "#2e2e2e"
       :weight bold
       :underline t))
  "Face for org-brain-child buttons.")

(defsetface org-brain-local-child
  '((t :foreground "#4444dd"
       ;; It's better for the glossary buttons to have no background, so normal syntax things, such as LSP highlighting can still be visible
       ;; underline is enough
       ;; :background "#2e2e2e"
       :weight bold
       :underline t))
  "Face for org-brain-local-child buttons.")

(define-key org-brain-visualize-mode-map (kbd "=") #'org-brain-visualize-add-grandchild)

;; (-uniq-u '(a b c d a))
;; child files
(defun org-brain-list-child-nodes ()
  "child files"
  (interactive)
  (let ((l
          (-uniq
           (append
            (org-brain-children org-brain--vis-entry)
            (org-brain-local-children org-brain--vis-entry)))))
    (if (interactive-p)
        (etv l)
      l)))

;; local-child / heading
(defun org-brain-list-child-headings ()
  "local-child / heading"
  (interactive)
  (etv (-uniq
        (-uniq-d
         (append
          (org-brain-children org-brain--vis-entry)
          (org-brain-local-children org-brain--vis-entry))))))

(defun org-brain-headline-at-point ()
  (let ((b (button-at-point))
        (p org-brain--vis-entry))
    (if (and b (button-face-p-here 'org-brain-local-child))
        (progn
          ;; Find the one that matches
          ;; (org-brain-headline-entries)
          (car (-filter
                (lambda (e)
                  (and (equal (car e) org-brain--vis-entry))
                  (equal (second e) (str (button-get-text b))))
                (org-brain-headline-entries)))
          ;; (concat (org-brain-entry-at-pt) "::" (str (button-get-text b)))
          ;; b
          ))))

(defun org-brain-file-at-point ()
  (let ((b (button-at-point))
        (p org-brain--vis-entry))
    (and b (button-face-p-here 'org-brain-child))))

(defun org-brain-this-headline-to-file ()
  (let ((h (org-brain-headline-at-point)))
    (if h
        (progn
          (org-brain-headline-to-file h)
          (revert-buffer)

          ;; This may be necessary here
          (org-brain-update-id-locations)))))

;; TODO Make these
;; org-brain-delete-this-entry

(defun org-brain-visualize-goto (&optional entry)
  ""
  (interactive)
  (org-brain-stop-wandering)
  (unless entry (setq entry (org-brain-choose-entry "Goto entry: " 'all)))
  (org-brain-visualize entry))

(defun org-brain-associates (entry)
  "Get children of ENTRY."
  (delete-dups
   (append (org-brain--linked-property-entries entry org-brain-children-property-name)
           (org-brain-local-children entry)
           (org-brain-friends entry)
           (org-brain-parents entry))))

;; TODO Make his also able to take me to friends
(defun org-brain-visualize-goto-associate (entry)
  ""
  (interactive (list ;; (org-brain-entry-at-pt)
                org-brain--vis-entry))
  ;; (let* ((entries (org-brain--linked-property-entries
  ;;                  entry org-brain-children-property-name))
  ;;        (child (cond
  ;;                ((equal 1 (length entries)) (car-safe entries))
  ;;                ((not entries) (error (concat entry " has no children")))
  ;;                (t (org-brain-choose-entry "Goto child: " entries nil t)))))
  ;;   (org-brain-visualize-goto child))

  (let* ((entries ;; (org-brain-children org-brain--vis-entry)
          (org-brain-associates org-brain--vis-entry))
         (child (cond
                 ((equal 1 (length entries)) (car-safe entries))
                 ((not entries) (error (concat (str entry) " has no children")))
                 (t (org-brain-choose-entry "Goto associate: " entries nil t)))))
    (org-brain-visualize-goto child)))

(defun org-brain-visualize-top (&optional entry)
  "Go up the tree to the top"
  (interactive)

  (if entry
      (org-brain-visualize entry))

  (let ((parent t))
    (while parent
      (setq entry (org-brain-entry-at-pt))
      (setq parent (car (or (org-brain-local-parent entry)
                            (org-brain-parents entry))))
      (if parent
          (org-brain-visualize parent)
        (message "Arrived at top")))))


(defun org-brain-recursive-children-flat (entry max-level &optional func)
  "Return a tree of ENTRY and its (grand)children up to MAX-LEVEL.
Apply FUNC to each tree member. FUNC is a function which takes an
entry as the only argument. If FUNC is nil or omitted, get the
raw entry data."
  (cons
   (funcall (or func #'identity) entry)
   (when (> max-level 0)
     (flatten-once
      (mapcar (lambda (x) (org-brain-recursive-children-flat x (1- max-level) func))
              (org-brain-children entry))))))


(defun org-brain-visualize-goto-recursive-children-flat (entry &optional max-level)
  ""
  (interactive (list ;; (org-brain-entry-at-pt)
                org-brain--vis-entry))
  (setq max-level (or max-level 10))
  (let* ((entries
          (-uniq (org-brain-recursive-children-flat org-brain--vis-entry max-level)))
         (child (cond
                 ((equal 1 (length entries)) (car-safe entries))
                 ((not entries) (error (concat (str entry) " has no children")))
                 (t (org-brain-choose-entry "Goto child: " entries nil t)))))
    (org-brain-visualize-goto child)))


(defun org-brain-goto-child-recursively (entry &optional max-level)
  "Goto a child of ENTRY.
If run interactively, get ENTRY from context.
If ALL is nil, choose only between externally linked children."
  (interactive (list (org-brain-entry-at-pt)))
  (setq max-level (or max-level 10))
  (let* ((entries (org-brain-recursive-children-flat entry max-level))
         (child (cond
                 ((equal 1 (length entries)) (car-safe entries))
                 ((not entries) (error (concat entry " has no children")))
                 (t (org-brain-choose-entry "Goto child: " entries nil t)))))
    (org-brain-goto child)))


;; org-brain-set-title
;; org-brain-open-resource



(define-key org-brain-visualize-mode-map (kbd "t") 'org-brain-visualize-top)
(define-key org-brain-visualize-mode-map (kbd "O") 'org-brain-goto-current)
(define-key org-brain-visualize-mode-map (kbd "o") 'org-brain-visualize-goto)
(define-key org-brain-visualize-mode-map (kbd "y") 'org-brain-goto-child)
(define-key org-brain-visualize-mode-map (kbd "i") (dff (obvrm "index")))
(define-key org-brain-visualize-mode-map (kbd "r") 'org-brain-visualize-goto-recursive-children-flat)
(define-key org-brain-visualize-mode-map (kbd "j") 'org-brain-visualize-goto-associate)
(define-key org-brain-visualize-mode-map (kbd "H") 'org-brain-visualize-goto-associate)
(define-key org-brain-visualize-mode-map (kbd "k") 'org-brain-toggle-maybefictional)
(define-key org-brain-visualize-mode-map (kbd "Y") 'my-org-brain-switch-brain)
(define-key my-mode-map (kbd "H-q") 'my-org-brain-switch-brain)
(define-key my-mode-map (kbd "H-Q") 'my-fz-org-brain-shortcut-select)

(never
 (define-key org-brain-visualize-mode-map (kbd "U") 'org-brain-visualize-top)
 (define-key org-brain-visualize-mode-map (kbd "E") 'org-brain-goto)
 (define-key org-brain-visualize-mode-map (kbd "G") 'org-brain-visualize-goto)
 (define-key org-brain-visualize-mode-map (kbd "B") 'org-brain-goto-child)
 )

;; (define-key org-brain-visualize-mode-map (kbd "R") 'org-brain-goto-child-recursively)

(defun org-brain-add-entry (title)
  "Add a new entry named TITLE."
  (interactive "sNew entry: ")
  (message "Added new entry: '%s'"
           (org-brain-entry-name (org-brain-get-entry-from-title title)))
  (org-brain-visualize-reset-map title))

(define-key org-brain-visualize-mode-map (kbd "N") 'org-brain-add-entry)

(defun org-brain-visualize-reset-map (entry)
  (interactive)

  ;; This is worth doing every now and then
  ;; when something breaks
  ;; This is probably a good place to put it.
  ;; Though perhaps the best place is when I do something like convert a heading into a file
  ;; (org-brain-update-id-locations)

  (with-current-buffer (org-brain-visualize entry)
    (when (eq major-mode 'org-brain-visualize-mode)
      (setq org-brain-visualizing-mind-map nil))
    (revert-buffer)))

(defun my-fz-org-brain-shortcut-select ()
  (interactive)

  (let ((f (fz my-org-brain-shortcut-list)))
    (if (sor f)
        (call-interactively (str2sym f)))))

(defun my-fz-org-brain-select ()
  (interactive)

  (let ((f (fz my-org-brain-list)))
    (if (sor f)
        (call-interactively (str2sym f))))

  ;; (let ((e (fz '(
  ;;                "index"
  ;;                "fungible"
  ;;                "NLP"
  ;;                "haskell"
  ;;                "infogetics"
  ;;                "nlp tasks"
  ;;                "Information Retrieval"
  ;;                "Programming"
  ;;                "emacs"
  ;;                "ideation"
  ;;                "infrastructure"
  ;;                "nlp disciplines"
  ;;                "organisations"
  ;;                "Coding tests"))))
  ;;   (if (sor e)
  ;;       (org-brain-visualize-reset-map e)))
  )

(defun my-org-brain-switch-brain (dir-or-name)
  (interactive (list (fz (mapcar 'f-base (glob "/home/shane/org-brains/*"))
                         nil nil "switch brain: ")) "D")
  (if (and (not (f-directory-p dir-or-name))
           (f-directory-p (concat "/home/shane/org-brains/" dir-or-name)))
      (setq dir-or-name (concat "/home/shane/org-brains/" dir-or-name)))
  (org-brain-switch-brain dir-or-name)
  (org-brain-add-entry "index")
  (org-brain-visualize-reset-map "index"))




(defun org-brain-entry-from-text (text)
  (interactive (list (read-string-hist "org-brain-entry: ")))
  (my-org-brain-switch-brain (chomp (cut text :d "/" :f 1)))
  (let* ((name (chomp (cut text :d "/" :f 2)))
         (entry
          (org-brain-choose-entry "Goto entry: " 'all nil t name)))
    (org-brain-visualize entry)))
(defalias 'obeft 'org-brain-entry-from-text)


(defalias 'obvrm 'org-brain-visualize-reset-map)
(defalias 'obsb 'my-org-brain-switch-brain)

;; TODO Turn this into a fuzzy list too


(defset my-org-brain-list '())
(defset my-org-brain-shortcut-list '())
(defset my-org-brain-local-shortcut-list '())

(defun defswitchbrain (prefix brainname)
  (interactive (list (read-string "new brain prefix: ")
                     (read-string "new brain name: ")))

  (let ((fun (eval `(dff (obsb ,brainname)))))
    (add-to-list 'my-org-brain-list fun)
    (define-key org-brain-visualize-mode-map (kbd (concat "SPC " (esed "\\(.\\)" "\\1 " prefix))) fun)))

(defun defswitchbrainentry (prefix entry)
  (let ((fun (eval `(dff (obeft ,entry)))))
    (add-to-list 'my-org-brain-shortcut-list fun)
    (define-key org-brain-visualize-mode-map (kbd (concat "D " (esed "\\(.\\)" "\\1 " prefix))) fun)))

(defun defswitchbrainlocalshortcut (prefix entry)
  (let ((fun (eval `(dff (obvrm ,entry)))))
    (add-to-list 'my-org-brain-local-shortcut-list fun)
    (define-key org-brain-visualize-mode-map (kbd (concat "I " (esed "\\(.\\)" "\\1 " prefix))) fun)))
(defalias 'dsbls 'defswitchbrainlocalshortcut)

(defun brain-shortcuts () (interactive) (j 'brain-shortcuts))
(define-key org-brain-visualize-mode-map (kbd ".") 'brain-shortcuts)
;; (define-key org-brain-visualize-mode-map (kbd ">") 'brain-shortcuts)
(define-key org-brain-visualize-mode-map (kbd ">") 'my-fz-org-brain-shortcut-select)
(define-key org-brain-visualize-mode-map (kbd "Z") 'my-fz-org-brain-select)

(defvar brainkeys
  '(
    ;; Prefix Q
    ("b" "billboard")
    ;; exploratory learning
    ("e" "exploratory")
    ("t" "tooling")
    ("c" "national-security")
    ("s" "studies")
    ("gl" "geology")
    ("gg" "geography")
    ("h" "thoughts")
    ;; (define-key org-brain-visualize-mode-map (kbd (concat "Q " (esed "\\(.\\)" "\\1 " "Y"))) nil)
    ("yb" "biocommunication")
    ("yy" "philosophy")
    ("m" "sensorium")
    ("u" "ubuntu")
    ("7" "science-fiction")
    ("r" "reference")
    ("l" "learning")
    ("f" "fungible")
    ("d" "ideation")
    ("o" "open-source-alternatives")
    ("i" "infogetics")
    ("n" "neuralink")
    ;; (define-key org-brain-visualize-mode-map (kbd (concat "Q " (esed "\\(.\\)" "\\1 " "P"))) nil)
    ("c" "clojure")
    ("pc" "clojure")
    ("pp" "python")
    ("pl" "programming-languages")
    ;; (define-key org-brain-visualize-mode-map (kbd (concat "Q " (esed "\\(.\\)" "\\1 " "PL"))) nil)
    ("w" "welfare-organisations")))

(loop for tp in brainkeys
      do
      (apply 'defswitchbrain tp))


;; TODO Find a comparator
(never
 (eval
  (cons 'qa
        (flatten-once
         (mapcar
          (lambda (tp)
            (list
             (str2sym (concat "-"
                              ;; get the first letter of the first element
                              (car tp)))
             (cadr tp)))
          (-filter
           (lambda (tp)
             (equal 1 (length (car tp))))
           brainkeys))))))


(defun qa-select-brain ()
  (interactive)

  (let ((br
         (qa
          -b "billboard"
          -i "ideation"
          )))
    (my-org-brain-switch-brain br)))

;; These shortcuts should really just be fuzzy searchable. They are lol
;; Prefix D
(defswitchbrainentry "N" "neuralink/index")
(defswitchbrainentry "I" "infogetics/index")
(defswitchbrainentry "T" "infogetics/text->text")

;; Prefix I
;; (dsbls "i" "index")
(dsbls "I" "index")
(dsbls "B" "fungible")
(dsbls "N" "NLP")
(dsbls "H" "haskell")
(dsbls "K" "haskell")
(dsbls "T" "nlp tasks")
(dsbls "F" "Information Retrieval")
(dsbls "P" "Programming")
(dsbls "E" "emacs")
;; (dsbls "U" "ubuntu")
(dsbls "A" "infrastructure")
(dsbls "O" "studies")
(dsbls "G" "organisations")
(dsbls "D" "nlp disciplines")
(dsbls "M" "models")
(dsbls "C" "Coding tests")

;; (defun org-brain-visualize-around-advice (proc &rest args)
;;   (when (eq major-mode 'org-brain-visualize-mode)
;;     (setq org-brain-visualizing-mind-map nil))

;;   (let ((res (apply proc args)))
;;     res))
;; (advice-add 'org-brain-visualize :around #'org-brain-visualize-around-advice)
;; (advice-remove 'org-brain-visualize #'org-brain-visualize-around-advice)

;; This is for babel
(define-key org-brain-visualize-mode-map (kbd "C-c C-c") #'org-ctrl-c-ctrl-c)
(define-key org-brain-visualize-mode-map (kbd "C-c C-o") 'org-open-at-point)


;; This actually *doesn't* turn the headings into local children
;; So it's pretty useless
(defun org-brain-visualize-this-org ()
  (interactive)

  (let* ((fp (get-path))
         (bn (basename fp))
         (dn (f-dirname fp))
         (ext (file-name-extension bn))
         (mant (file-name-sans-extension bn))
         (slug (slugify (concat dn "/" mant))))

    ;; Open the org and add all the headlines by navigating to each ^* and then running this
    ;; (org-brain-get-id)
    ;; Save
    ;; Then optionally, run this -- probably not necessary
    ;; (org-brain-update-id-locations)
    ;; Then navigate to it, below

    ;; (etv slug)
    ;; (etv (cmd "ln" "-s" p "--" (etv slug)))
    (sn (cmd "ln" "-s" fp "--" (concat slug ".org")) nil "/home/shane/org-brain")
    (org-brain-visualize slug)

    ;; Then revert -- may not be necessary
    ))


(advice-add 'org-brain-get-id :around #'ignore-errors-around-advice)

(defun idify-org-files-here (dirpath)
  (interactive (list (read-directory-name "idify-org-files dir: ")))
  (loop for fp in
        (-filter 'sor (str2list (snc (cmd "find" dirpath "-type" "f" "-name" "*.org"))))
        do
        (idify-org-file fp t)))

(defun unidify-org-files-here (dirpath)
  (interactive (list (read-directory-name "unidify-org-files dir: ")))
  (loop for fp in
        (-filter 'sor (str2list (snc (cmd "find" dirpath "-type" "f" "-name" "*.org"))))
        do
        (unidify-org-file fp t)))

(defun idify-org-file (path &optional save)
  "Add IDs to all the headers in an org file"
  (interactive (list (read-file-name "org file:" nil nil t
                                     (if
                                         (and (ignore-errors (file-exists-p (buffer-file-name)))

                                              (string-match "\\.org$" (buffer-file-name)))
                                         (buffer-file-name))
                                     (lambda (fp)
                                       (and (file-exists-p fp)

                                            (string-match "\\.org$" fp))))))

  (if (string-match "\\.org$" path)
      (with-current-buffer
          (find-file path)
        ;; (beginning-of-buffer)
        ;; (org-map-entries 'org-id-get-create "LEVEL=1")
        (org-map-entries 'org-brain-get-id t)
        (if save
            (my-save-buffer)))))

(defun org-id-remove-entry (&optional do-not-update-map)
"Remove/delete the ID entry and update the databases.
Update the `org-id-locations' global hash-table, and update the
`org-id-locations-file'.  `org-id-track-globally' must be `t`."
(interactive)
  (save-excursion
    (org-back-to-heading t)
    (when (org-entry-delete (point) "ID")
      (unless do-not-update-map
        (org-id-update-id-locations nil 'silent)))))

(defun unidify-org-file (path &optional save)
  "Remove IDs from all the headers in an org file"
  (interactive (list (read-file-name "org file:" nil nil t
                                     (if
                                         (and (ignore-errors (file-exists-p (buffer-file-name)))

                                              (string-match "\\.org$" (buffer-file-name)))
                                         (buffer-file-name))
                                     (lambda (fp)
                                       (and (file-exists-p fp)

                                            (string-match "\\.org$" fp))))))

  (if (string-match "\\.org$" path)
      (with-current-buffer
          (find-file path)
        ;; (beginning-of-buffer)
        (org-map-entries (lambda () (org-id-remove-entry t)) t)
        (org-id-update-id-locations nil 'silent)
        (if save
            (my-save-buffer)))))

(defun org-brain-name-from-list-maybe (l)
  (if (and (listp l)
           (> (length l) 1))
      (second l)
    l))

(defun org-brain-remove-irrelevant-names-from-path (path)
  (-filter
   (lambda (e)
     (not (or
           (string-equal "infogetics" e)
           (string-equal "fungible" e))))
   (mapcar (lambda (e)
             (if (string-equal "infogetics" e)
                 "deep learning"
               e))
           path)))

(defun org-brain-parent-name ()
  (snc "s join"
    (list2str
           (org-brain-remove-irrelevant-names-from-path
            (mapcar
             'org-brain-name-from-list-maybe
             (org-brain-parents org-brain--vis-entry))))))

(defun org-brain-current-name (&optional unslugify)
  (let ((cn
         (car
          (org-brain-remove-irrelevant-names-from-path
           (mapcar
            'org-brain-name-from-list-maybe
            (list org-brain--vis-entry))))))
    (if unslugify
        (unslugify cn)
      cn)))

(defun org-brain-current-topic (&optional for-external-searching)
  (interactive)
  (let ((path
         (mapcar
          'org-brain-name-from-list-maybe
          (append (org-brain-parents org-brain--vis-entry) (list org-brain--vis-entry)))))

    (setq path
          (if for-external-searching
              (org-brain-remove-irrelevant-names-from-path path)
            path))

    (let ((topic (chomp (apply 'cmd path))))
      (if (not (sor topic))
          (setq topic "general knowledge"))

      (if (interactive-p)
          (etv topic)
        topic))))


(defun org-brain-google-here (query)
  (interactive (list (read-string-hist
                      "egr: "
                      (if (sor (org-brain-current-topic t))
                          (concat
                           (org-brain-current-topic t)
                           " ")
                        (org-brain-current-topic t)))))
  (if (not (interactive-p))
      (setq query (concat query " " (org-brain-current-topic t))))
  (egr query))

(defun org-brain-pf-topic (&optional short)
  "Topic used for pen functions"
  (let ((cn (org-brain-current-name t)))
    (if (and (org-brain-is-index-name cn)
             (not (sor (org-brain-parent-name))))
        (if (org-brain-is-index-name (org-brain-current-brain))
            "general knowledge"
          (org-brain-current-brain))
      (let ((p (org-brain-parent-name)))
        (if (and (sor p)
                 (not short)
                 (not (org-brain-is-index-name p)))
            (concat cn " (" cn " is a subtopic of " p ")")
          cn)))))

(defun org-brain-existing-subtopics ()
  (mapcar (lambda (s) (s-replace-regexp ".*::" "" s))
          (mapcar 'org-brain-entry-name
                  (org-brain-list-child-nodes))))

(defun org-brain-existing-subtopics-stringlist (&optional add-dash)
  ;; output a multiline dashed string
  (awk1
   (list2str
    (if add-dash
        (mapcar
         (lambda (s) (concat "- " s))
         (org-brain-existing-subtopics))
      (org-brain-existing-subtopics)))))

;; Also, take into consideration existing subtopic-candidates
(defun org-brain-suggest-subtopics (&optional update do-not-incorportate-existing suggest-full-list edit-full-list)
  "
update will update the cache
do-not-incorportate-existing will not incorporate existing subtopics into the prompt, so they do not influence suggestions
edit-full-list allows you to edit the list before proceeding
suggest-full-list will ask if you want to add the entire list as subtopics to the current entry
"
  (interactive)

  (let ((inhibit-quit t))
    (unless (with-local-quit
              (progn
                (qa
                 -u (setq update t)
                 -n (setq do-not-incorporate-existing t)
                 -i (setq do-not-incorporate-existing nil)
                 -e (setq edit-full-list t)
                 -f (setq suggest-full-list t)
                 -F (setq suggest-full-list t update t))

                (message "Using pen.el to suggest subtopics...")

                (let ((subtopic-candidates
                       ;; (pen-pf-keyword-extraction (org-brain-current-topic t))
                       (let ((sh-update (or sh-update
                                            update
                                            (eq (prefix-numeric-value current-prefix-arg) 4)))
                             (existing-subtopics-string (if do-not-incorportate-existing
                                                            ""
                                                          (org-brain-existing-subtopics-stringlist t))))
                         (let ((s (pen-pf-subtopic-generation
                                   (pen-topic)
                                   existing-subtopics-string)))
                           (if (not (sor s))
                               (progn
                                 (message "Empty generation 1/3. Trying again.")
                                 (setq s (upd (pen-pf-subtopic-generation
                                               (pen-topic)
                                               existing-subtopics-string)))
                                 (if (not (sor s))
                                     (progn
                                       (message "Empty generation 2/3. Trying again.")
                                       (setq s (upd (pen-pf-subtopic-generation
                                                     (pen-topic)
                                                     existing-subtopics-string)))
                                       (if (not (sor s))
                                           (progn
                                             (message "Empty generation 3/3. Giving up.")
                                             (error "Empty generation 3/3. Giving up."))
                                         s))
                                   s)
                                 s)
                             s)))))

                  (setq subtopic-candidates
                        (-filter-not-empty-string
                         (-uniq-u
                          (str2list
                           (concat
                            (awk1 subtopic-candidates)
                            (org-brain-existing-subtopics-stringlist))))))

                  ;; (tv subtopic-candidates)

                  ;; The prompt does "- " removal on its own now
                  ;; (setq subtopic-candidates
                  ;;       (str2list
                  ;;        (cl-sn
                  ;;         "sed 's/^- //'"
                  ;;         :stdin
                  ;;         (chomp
                  ;;          (snc
                  ;;           (cmd "scrape" "^- [a-zA-Z -]+$")
                  ;;           (concat "- " subtopic-candidates))) :chomp t)))

                  ;; (ns current-prefix-arg)

                  (if (interactive-p)
                      (progn
                        (let ((subtopic-selected
                               (try
                                (cond
                                 (edit-full-list
                                  (nbfs (list2str subtopic-candidates)))
                                 (suggest-full-list
                                  (let ((b (nbfs (list2str subtopic-candidates))))
                                    (with-current-buffer b
                                      (let ((r (if (yn "Add all?")
                                                   subtopic-candidates)))
                                        (kill-buffer b)
                                        r))))
                                 (t
                                  ;; Select one, do not refresh cache
                                  (list (fz subtopic-candidates)))))))

                          (if subtopic-selected
                              (cl-loop for st in subtopic-selected do
                                       (org-brain-add-child-headline org-brain--vis-entry st)))))
                    subtopic-candidates)))
              t)
      (progn
        (message "Cancelled")
        (setq quit-flag nil)))))

;; This breaks interactive, and it doesn't work anyway
;; (advice-add 'org-brain-suggest-subtopics :around #'cgify-around-advice)
;; (advice-remove 'org-brain-suggest-subtopics #'cgify-around-advice)

;; org-brain-add-child-headline


;; Abstract this out so I can use the pen functions on anything
(defun org-brain-asktutor (question)
  (interactive (list (read-string-hist (concat "asktutor about " (pen-topic) ": "))))
  (let ((cname (org-brain-current-name))
        (pname (org-brain-parent-name)))

    (if (org-brain-at-top-index)
        (setq cname "general knowledge"))

    (if (org-brain-at-child-of-index)
        (setq pname cname))

    (let ((answer
           (eval
            `(ci (snc "ttp" (pen-pf-generic-tutor-for-any-topic ,cname ,pname ,question))))))
      (if (interactive-p)
          (etv answer)
        answer))
    ;; (mu
    ;;  (etv
    ;;   (snc
    ;;    (concat
    ;;     (cmd
    ;;      "oci" "-E"
    ;;      (concat
    ;;       (cmd
    ;;        "oci"
    ;;        "openai-complete"
    ;;        "$MYGIT/semiosis/prompts/prompts/tutor.prompt"
    ;;        cname
    ;;        pname
    ;;        question)
    ;;       " | ttp"))))))
    ))

(defun my-org-brain-goto-header ()
  (interactive)
  ;; Actually, I don't want to create newlines
  (never (try
          (progn
            ;; This is if you clicked on a brain local child
            (org-back-to-heading)
            (org-end-of-meta-data t)
            ;; (forward-line)
            (newline)
            (previous-line))
          (progn
            ;; This must add new lines AFTER the BRAIN_PARENTS and BRAIN_CHILDREN lines
            ;; So I must go to the first heading (if there is one) then go back
            ;; (call-interactively 'end-of-buffer)
            (call-interactively 'beginning-of-buffer)
            (if (re-match-p "^\\*" (buffer-string))
                (progn (call-interactively 'org-next-visible-heading)
                       (previous-line)))
            (call-interactively 'mwim-end-of-line-or-code)
            (newline)
            (newline)
            (newline)
            (previous-line)
            (previous-line)
            (message "Couldn't find heading"))))
  (try
   (progn
     ;; This is if you clicked on a brain local child
     (org-back-to-heading)
     (org-end-of-meta-data t)
     ;; (forward-line)
     ;; (newline)
     ;; (previous-line)
     )
   (progn
     ;; This must add new lines AFTER the BRAIN_PARENTS and BRAIN_CHILDREN lines
     ;; So I must go to the first heading (if there is one) then go back
     ;; (call-interactively 'end-of-buffer)
     (call-interactively 'beginning-of-buffer)
     (if (re-match-p "^\\*" (buffer-string))
         (progn (call-interactively 'org-next-visible-heading)
                (previous-line)))
     (call-interactively 'mwim-end-of-line-or-code)
     ;; (newline)
     ;; (newline)
     ;; (newline)
     ;; (previous-line)
     ;; (previous-line)
     (message "Couldn't find heading"))))

(defun my-org-brain-goto-current ()
  (interactive)
  (call-interactively 'org-brain-goto-current)
  (call-interactively 'my-org-brain-goto-header))

(define-key org-brain-visualize-mode-map (kbd "RET") 'my-org-brain-goto-current)

(defun org-link-open-from-string (s &optional arg)
  "Open a link in the string S, as if it was in Org mode.
Optional argument is passed to `org-open-file' when S is
a \"file\" link."
  (interactive "sLink: \nP")
  (pcase (with-temp-buffer
	         (let ((org-inhibit-startup nil))
	           (insert s)
             ;; Switching to org-mode kinda breaks it
	           ;; (org-mode)
	           (goto-char (point-min))
             ;; (call-interactively 'tm-edit-v-in-nw)
	           (org-element-link-parser)))
    (`nil (user-error "No valid link in %S" s))
    (link (org-link-open link arg))))

(define-key org-brain-visualize-mode-map (kbd "w") 'get-path)
(define-key org-brain-visualize-mode-map (kbd "H-w") 'get-path)

(define-key org-brain-visualize-mode-map (kbd "^") 'org-brain-visualize-parent)
(define-key org-brain-visualize-mode-map (kbd "u") 'org-brain-visualize-parent)

(define-key org-brain-visualize-mode-map (kbd "i") 'my-org-brain-goto-current)

(define-key org-brain-visualize-mode-map (kbd "M-TAB") 'org-brain-suggest-subtopics)


;; If it doesn't exist, automatically create a description for the topic
;; (upd (call-interactively 'org-brain-describe-topic))

(defun my-org-brain-add-child (entry children verbose)
  (interactive (list (if current-prefix-arg
                         (car (org-brain-button-at-point))
                       (org-brain-entry-at-pt t))
                     (org-brain-choose-entries "Add child: " 'all)
                     t))
  (if children
      (progn
        (org-brain-add-child entry children verbose)
        ;; (tv (pps children))
        (org-brain-visualize (car (last children))))))
(define-key org-brain-visualize-mode-map (kbd "c") 'my-org-brain-add-child)


;; TODO Make it so this topic description is also enhanced with
;; properties of the topic.
;; Add to the pretext
(defun org-brain-describe-topic ()
  (interactive)

  (require 'pen)
  (let* ((p (sor (org-brain-parent-name)))
         (pretext
          ;; (if (and p (not (org-brain-at-child-of-index)))
          ;;     (concat "I know " (org-brain-current-name) " is a subtopic of " p "."))
          )
         ;; (question (concat "Could you please explain what " (pen-topic t) " is and why it is important?"))
         (question (if (and p (not (org-brain-at-child-of-index)))
                       (concat "Could you please explain what " (pen-topic t) " is in the context of " p " and why it is important?")
                     (concat "Could you please explain what " (pen-topic t) " is and why it is important?")))
         (final-question
          (if (sor pretext)
              (concat pretext " " question)
            question)))

    ;; (etv final-question)
    (let ((description (org-brain-asktutor final-question)))
      (if (sor description)
          (progn
            (let ((cb (current-buffer)))
              (my-org-brain-goto-current)
              (let ((block-name (concat (org-brain-current-name) "-description")))
                (if (not (org-babel-find-named-block block-name))
                    (progn
                      (insert
                       (snc (cmd "org-template-gen" "brain-description" block-name) description))
                      (call-interactively 'save-buffer)
                      (call-interactively 'my/revert-kill-buffer-and-window))
                  ;; (progn
                  ;;   (ekm "< t")
                  ;;   ;; (ekm "C-c '")
                  ;;   (with-current-buffer (org-edit-special)
                  ;;     (insert description)
                  ;;     ;; (ekm "C-c '")
                  ;;     (call-interactively 'org-edit-src-exit))
                  ;;   ;; (ekm "C-c N")
                  ;;   (call-interactively 'org-babel-add-name)
                  ;;   (insert block-name))
                  ))
              (with-current-buffer cb
                (revert-buffer))))))

    ;; (if (org-babel-find-named-block "geology-description"))
    ))

(defun org-brain-show-topic ()
  (interactive)
  (require 'pen)
  (call-interactively 'pen-topic))


(defun org-brain-current-entry ()
  org-brain--vis-entry)

(defun org-brain-headline-to-file-this ()
  (interactive)
  (if (listp org-brain--vis-entry)
      (org-brain-headline-to-file org-brain--vis-entry)))

(defun org-brain-current-depth ()
  (org-brain-tree-depth (org-brain-recursive-parents org-brain--vis-entry 100)))


(defun org-brain-go-index ()
  (interactive)
  ;; (org-brain-visualize-reset-map "index")
  (obsb "billboard")
  ;; (org-brain-visualize-reset-map "billboard")
  )

(defun org-brain-at-top ()
  (eq 1 (org-brain-current-depth)))

;; The following are slightly redundant now
;; If it is a specialised brain, such as philosophy, the topic, when suggested, needs to be the brain name
;; Therefore, such brains do not count themselves among this list.
(defun org-brain-is-index-name (s)
  (or (string-equal s "index")
      (string-equal s "infogetics")
      (string-equal s "billboard")
      (string-equal s "exploratory")
      (string-equal s "reference")))

(defun org-brain-at-child-of-index ()
  (let ((p (sor (org-brain-parent-name))))
    (and (org-brain-is-index-name p)
         (eq 2 (org-brain-current-depth)))))

(defun org-brain-at-top-index ()
  (let ((c (sor (org-brain-current-name))))
    (and (org-brain-is-index-name c)
         (eq 1 (org-brain-current-depth)))))

(defun org-brain-visualize (entry &optional nofocus nohistory wander)
  "View a concept map with ENTRY at the center.

When run interactively, prompt for ENTRY and suggest
`org-brain-entry-at-pt'.  By default, the choices presented is
determined by `org-brain-visualize-default-choices': 'all will
show all entries, 'files will only show file entries and 'root
will only show files in the root of `org-brain-path'.

You can override `org-brain-visualize-default-choices':
  `\\[universal-argument]' will use 'all.
  `\\[universal-argument] \\[universal-argument]' will use 'files.
  `\\[universal-argument] \\[universal-argument] \\[universal-argument]' will use 'root.

Unless NOFOCUS is non-nil, the `org-brain-visualize' buffer will gain focus.
Unless NOHISTORY is non-nil, add the entry to `org-brain--vis-history'.
Setting NOFOCUS to t implies also having NOHISTORY as t.
Unless WANDER is t, `org-brain-stop-wandering' will be run."
  (interactive
   (progn
     (org-brain-maybe-switch-brain)
     (let ((choices (cond ((equal current-prefix-arg '(4)) 'all)
                          ((equal current-prefix-arg '(16)) 'files)
                          ((equal current-prefix-arg '(64)) 'root)
                          (t org-brain-visualize-default-choices)))
           (def-choice (unless (eq major-mode 'org-brain-visualize-mode)
                         (ignore-errors (org-brain-entry-name (org-brain-entry-at-pt))))))
       (org-brain-stop-wandering)
       (list
        (org-brain-choose-entry
         "Entry: "
         (cond ((equal choices 'all)
                'all)
               ((equal choices 'files)
                (org-brain-files t))
               ((equal choices 'root)
                (make-directory org-brain-path t)
                (mapcar #'org-brain-path-entry-name
                        (directory-files org-brain-path t (format "\\.%s$" org-brain-files-extension)))))
         nil nil def-choice)))))
  (unless wander (org-brain-stop-wandering))
  (with-current-buffer (get-buffer-create "*org-brain*")
    (setq-local indent-tabs-mode nil)
    (read-only-mode 1)
    (setq-local default-directory (file-name-directory (org-brain-entry-path entry)))
    (org-brain-maybe-switch-brain)
    (unless (eq org-brain--vis-entry entry)
      (setq org-brain--vis-entry entry)
      (setq org-brain-mind-map-parent-level (default-value 'org-brain-mind-map-parent-level))
      (setq org-brain-mind-map-child-level (default-value 'org-brain-mind-map-child-level)))
    (setq org-brain--vis-entry-keywords (when (org-brain-filep entry)
                                          (org-brain-keywords entry)))
    (let ((inhibit-read-only t)
          (entry-pos))
      (delete-region (point-min) (point-max))
      (org-brain--vis-brain)
      (org-brain--vis-pinned)
      (org-brain--vis-selected)
      (when (not nohistory)
        (setq org-brain--vis-history
              (seq-filter (lambda (elt) (not (equal elt entry))) org-brain--vis-history))
        (setq org-brain--vis-history (seq-take org-brain--vis-history 15))
        (push entry org-brain--vis-history))
      (when org-brain-show-history (org-brain--vis-history))
      (if org-brain-visualizing-mind-map
          (setq entry-pos (org-brain-mind-map org-brain--vis-entry org-brain-mind-map-parent-level org-brain-mind-map-child-level))
        (setq-local org-brain--visualize-header-end-pos (point))
        (insert "\n\n")
        (org-brain--vis-parents-siblings entry)
        ;; Insert entry title
        (let ((title (org-brain-vis-title entry)))
          (let ((half-title-length (/ (string-width title) 2)))
            (if (>= half-title-length (current-column))
                (delete-char (- (current-column)))
              (ignore-errors (delete-char (- half-title-length)))))
          (setq entry-pos (point))
          (insert (propertize title
                              'face (org-brain-display-face entry 'org-brain-title)
                              'aa2u-text t))
          (org-brain--vis-friends entry)
          (org-brain--vis-children entry)))
      (when (and org-brain-show-resources)
        (org-brain--vis-resources (org-brain-resources entry)))
      (if org-brain-show-text
          (org-brain--vis-text entry)
        (run-hooks 'org-brain-after-visualize-hook))
      (unless (eq major-mode 'org-brain-visualize-mode)
        (org-brain-visualize-mode))
      (goto-char entry-pos)
      (set-buffer-modified-p nil))
    (unless nofocus
      (when org-brain--visualize-follow
        (org-brain-goto-current)
        (run-hooks 'org-brain-visualize-follow-hook))
      (if (or org-brain--visualize-follow org-brain-open-same-window)
          (pop-to-buffer "*org-brain*")
        (pop-to-buffer-same-window "*org-brain*")))))

(defun org-brain-current-brain ()
  (f-base org-brain-path))

(defun org-brain--vis-brain ()
  "Insert pinned entries.
Helper function for `org-brain-visualize'."
  ;; (insert (concat "BRAIN: " (mnm org-brain-path)))
  (insert (concat "BRAIN: " (org-brain-current-brain)))
  (insert "\n"))


(defun org-brain-get-path-for-child-name (child-name &optional semantic-path)
  "This gets the path for the entry given the name of a child, current brain and current entry."
  (interactive)
  (let ((p (if semantic-path
               (org-brain-pf-topic)
             ;; (org-brain-current-topic t)
             (concat
              "[[brain:"
              (org-brain-current-brain)
              "/"
              child-name
              "]]"))))
    (if (interactive-p)
        (my/copy p)
      p)))

;; This is more accurate than org-brain-get-path-for-child-name
(defun org-brain-get-path-for-entry (entry &optional semantic-path)
  "This gets the path for the entry given, current brain and current entry."
  (interactive)
  (let ((p (if semantic-path
               (org-brain-pf-topic)
             ;; (org-brain-current-topic t)
             (concat
              "[[brain:"
              (org-brain-current-brain)
              "/"
              (org-brain-entry-name entry)
              "]]"))))
    (if (interactive-p)
        (my/copy p)
      p)))


(defun org-brain-toggle-maybefictional (entry)
  "ENTRY gets a new NICKNAME.
If run interactively use `org-brain-entry-at-pt' and prompt for NICKNAME."
  (interactive (list (org-brain-entry-at-pt)))
  (if (org-brain-filep entry)
      (org-with-point-at (org-brain-entry-marker entry)
        (goto-char (point-min))
        (if (re-search-forward "^#\\+MAYBE_FICTIONAL:.*$" nil t)
            (insert (concat " t"))
          (insert "#+MAYBE_FICTIONAL: t\n"))
        (save-buffer))
    (org-entry-add-to-multivalued-property
     (org-brain-entry-marker entry) "MAYBE_FICTIONAL" nickname)
    (org-save-all-org-buffers)))

(defun org-brain-show-recursive-children ()
  (interactive)
  (nbfs (pp-to-string (org-brain-recursive-children (org-brain-current-entry) 100)) nil 'emacs-lisp-mode))

(defun org-brain-show-recursive-children-names ()
  (interactive)
  (nbfs (pp-to-string (org-brain-recursive-children (org-brain-current-entry) 100 'org-brain-entry-name)) nil 'emacs-lisp-mode))

;; This will have to be a tree of hash tables

;; Be careful. This does work recursively, but doesn't know currently if a node has already appeared
;; Factor that in
;; Also list the friends for each entry
;; This is generating a dot graph, so I don't need to care about double up
(defun pp-org-brain-tree (tre &optional parent)
  (interactive (list (org-brain-recursive-children
                      (org-brain-current-entry) 100
                      (lambda (e)
                        (cons (org-brain-entry-name e)
                              (let* ((f (org-brain-friends e)))
                                (if f
                                    (let ((ht (make-hash-table)))
                                      (puthash :friends f ht)
                                      ht))))
                        ;; (list (org-brain-entry-name e)
                        ;;       (org-brain-friends e))
                        ))))

  (nbfs (pp-to-string tre) nil 'emacs-lisp-mode)

  ;; (etv (pp-to-string (org-brain-recursive-children (org-brain-current-entry) 10 'org-brain-entry-name)))

  ;; (loop for c in t)
  )

(defun org-brain-recursive-children-visited (entry max-level visited &optional func)
  "Return a tree of ENTRY and its (grand)children up to MAX-LEVEL.
Apply FUNC to each tree member. FUNC is a function which takes an
entry as the only argument. If FUNC is nil or omitted, get the
raw entry data.
Also stop descending if a node has been visited before.
"
  (let ((en (org-brain-entry-name entry)))
    (if (not (and (ht-contains? org-brain-visited-ht (sxhash-equal en))))
        (cons (funcall (or func #'identity) entry)
              (when (> max-level 0)
                (ht-set org-brain-visited-ht (sxhash-equal en) t)
                (mapcar (lambda (x) (org-brain-recursive-children-visited x (1- max-level) visited func))
                        (org-brain-children entry)))))))

(defvar org-brain-visited-ht)
;; (setq ht-str-testfun (define-hash-table-test 'contents-hash ht-str-testfun 'sxhash-equal))

(defun org-brain-recursive-associates-visited (entry max-level &optional func)
  "Return a tree of ENTRY and its (grand)associates up to MAX-LEVEL.
Apply FUNC to each tree member. FUNC is a function which takes an
entry as the only argument. If FUNC is nil or omitted, get the
raw entry data.
Also stop descending if a node has been visited before.
"
  (let ((en (org-brain-entry-name entry)))
    (if (not (and (ht-contains? org-brain-visited-ht (sxhash-equal en))))
        (cons (funcall (or func #'identity) entry)
              (when (> max-level 0)
                (ht-set org-brain-visited-ht (sxhash-equal en) t)
                (mapcar (lambda (x) (org-brain-recursive-associates-visited x (1- max-level) func))
                        (org-brain-associates entry)))))))

;; (defun org-brain-to-dot (&optional depth recurfun)
;;   (interactive (list (string-to-int (read-string-hist "depth: " "5" nil 5))
;;                      (str2sym (fz '("org-brain-recursive-associates-visited"
;;                                     "org-brain-recursive-children-visited")
;;                                   "org-brain-recursive-associates-visited"
;;                                   nil "recurfun: "))))

;;   (if (not depth)
;;       (setq depth 5))

;;   (if (not recurfun)
;;       (setq recurfun 'org-brain-recursive-associates-visited))

;;   (let ((tre
;;          (-flatten
;;           (progn
;;             (setq org-brain-visited-ht (make-hash-table))
;;             (funcall recurfun
;;                      (org-brain-current-entry) depth
;;                      (lambda (e)
;;                        (let* ((n (org-brain-entry-name e))
;;                               (fs (mapcar 'org-brain-entry-name (org-brain-friends e)))
;;                               (cs (mapcar 'org-brain-entry-name (org-brain-children e))))
;;                          (list
;;                           ;; (concat "[" n "]")
;;                           (if fs
;;                               (loop for f in fs
;;                                     collect
;;                                     (list (concat (e/q n) " -> " (e/q f))
;;                                           (concat (e/q f) " -> " (e/q n))))
;;                             ;; "FRIENDS"
;;                             )
;;                           (if cs
;;                               (loop for c in cs
;;                                     collect
;;                                     (concat (e/q n) " -> " (e/q c)))
;;                             ;; "CHILDREN"
;;                             )))
;;                        ;; (list (org-brain-entry-name e)
;;                        ;;       (org-brain-friends e))
;;                        ))))))

;;     (nbfs (snc "uniqnosort" (list2str tre)) nil 'graphviz-dot-mode))

;;   ;; (etv (pp-to-string (org-brain-recursive-children (org-brain-current-entry) 10 'org-brain-entry-name)))

;;   ;; (loop for c in t)
;;   )

(defun org-brain-to-dot-associates (&optional depth)
  (interactive (list
                (qa
                 -a 0 -s 1 -d 2 -f 3 -g 4
                 -r (string-to-int (read-string-hist "depth: " "5" nil 5)))))

  (if (not depth)
      (setq depth 5))

  (let* ((recurfun 'org-brain-recursive-associates-visited)
         (tre
          (-flatten
           (progn
             (setq org-brain-visited-ht (make-hash-table))
             (funcall recurfun
                      (org-brain-current-entry) depth
                      (lambda (e)
                        (let* ((n (org-brain-entry-name e))
                               (fs (mapcar 'org-brain-entry-name (org-brain-friends e)))
                               (cs (mapcar 'org-brain-entry-name (org-brain-children e))))
                          (list
                           ;; (concat "[" n "]")
                           (if fs
                               (loop for f in fs
                                     collect
                                     (list (concat (e/q n) " -> " (e/q f))
                                           (concat (e/q f) " -> " (e/q n))))
                             ;; "FRIENDS"
                             )
                           (if cs
                               (loop for c in cs
                                     collect
                                     (concat (e/q n) " -> " (e/q c)))
                             ;; "CHILDREN"
                             )))
                        ;; (list (org-brain-entry-name e)
                        ;;       (org-brain-friends e))
                        ))))))

    (nbfs (snc "uniqnosort" (list2str tre)) nil 'graphviz-dot-mode))

  ;; (etv (pp-to-string (org-brain-recursive-children (org-brain-current-entry) 10 'org-brain-entry-name)))

  ;; (loop for c in t)
  )

(defun org-brain-to-dot-children (&optional depth)
  (interactive (list (string-to-int (read-string-hist "depth: " "5" nil 5))))

  (if (not depth)
      (setq depth 5))

  (let* ((recurfun 'org-brain-recursive-children-visited)
         (tre
          (-flatten
           (progn
             (setq org-brain-visited-ht (make-hash-table))
             (funcall recurfun
                      (org-brain-current-entry) depth
                      (lambda (e)
                        (let* ((n (org-brain-entry-name e))
                               (cs (mapcar 'org-brain-entry-name (org-brain-children e))))
                          (list
                           ;; (concat "[" n "]")
                           (if cs
                               (loop for c in cs
                                     collect
                                     (concat (e/q n) " -> " (e/q c)))
                             ;; "CHILDREN"
                             )))
                        ;; (list (org-brain-entry-name e)
                        ;;       (org-brain-friends e))
                        ))))))

    (nbfs (snc "uniqnosort" (list2str tre)) nil 'graphviz-dot-mode))

  ;; (etv (pp-to-string (org-brain-recursive-children (org-brain-current-entry) 10 'org-brain-entry-name)))

  ;; (loop for c in t)
  )

(define-key org-brain-visualize-mode-map (kbd "C-c C-d") 'org-brain-to-dot-associates)


(define-key org-brain-visualize-mode-map (kbd "R") 'org-brain-rename-file)

(provide 'my-org-brain)