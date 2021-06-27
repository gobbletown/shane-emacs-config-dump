(require 'my-hydra)

;; vim +/"(defun search-all-buffers (regexp)" "$EMACSD/config/my-buffers.el"

;; TODO Make it so selectrum can see the function docstrings when selecting from this list
;; Selectrum does it already
(defset search-functions '() "list of search functions that would usually sit under M-8")
;; TODO Make this also show engine-mode functions


(defun my-search ()
  (interactive)
  (let ((f (str2sym (fz search-functions))))
    (if (commandp f)
        (call-interactively f))))
;; (define-key my-mode-map (kbd "M-8 M-8") 'my-search)


(defun guess-lang-for-search (&optional prompt)
  (if (not prompt)
      (setq prompt "lang: "))
  (let ((lang (cond
               ((major-mode-p 'sx-question-mode) nil)
               ((major-mode-p 'term-mode) (buffer-language t t))
               ((major-mode-p 'org-mode) (get-src-block-language))
               ((major-mode-p 'eww-mode) (read-string-hist prompt))
               (t (buffer-language)))))
    (cond
     ((string-equal "fundamental" lang) "")
     ((string-equal "text" lang) "")
     (t lang))))
(add-to-list 'search-functions 'guess-lang-for-search)

(defun alphabetize (input)
  (chomp (sh-notty "alphabetize" input)))

(defun googleize (input)
  (chomp (sh-notty "googleize" input)))

(defun eegr (query)
  (interactive (list (read-string-hist "egr: " (if (selected-p) (concat (q (my/thing-at-point)) " ")))))
  ;; (sps (concat "egr " query))
  (engine/search-google query))
(add-to-list 'search-functions 'eegr)

(defun eegh (query)
  (interactive (list (read-string-hist "egh: " (if (selected-p) (concat (q (my/thing-at-point)) " ")))))
  ;; (sps (concat "egr " query))
  (engine/search-github-advanced query))
(add-to-list 'search-functions 'eegh)

(defun egr-thing-at-point (query)
  (interactive (list (read-string-hist "egr (quoted): " (concat (q (my/thing-at-point)) " "))))
  (nw (concat "egr " query)))
(add-to-list 'search-functions 'egr-thing-at-point)

(defun egr-thing-at-point-imediately (query)
  (interactive (list (q (s-replace "\n" " " (my/thing-at-point)))))
  (egr-thing-at-point query))
(add-to-list 'search-functions 'egr-thing-at-point-imediately)

(defun egr-thing-at-point-lang (query)
  ;; (interactive (list (q (s-replace "\n" " " (my/thing-at-point)))))
  (interactive (list (read-string-hist "egr (quoted): " (concat (q (my/thing-at-point)) " " (cond
                                                                                             ((major-mode-p 'org-mode) (get-src-block-language))
                                                                                             ((major-mode-p 'markdown-mode) (get-src-block-language))
                                                                                             ((major-mode-p 'eww-mode) (completing-read "lang:" nil nil nil))
                                                                                             (t (buffer-language)))
                                                                " "))))
  (egr-thing-at-point query))
(add-to-list 'search-functions 'egr-thing-at-point-imediately)


(defun egr-docs (tool query)
  (interactive (list (read-string-hist "egr-docs tool: ")
                     (read-string-hist "egr-docs query: ")))
  (sps (cmd "egr-docs" tool query)))
(add-to-list 'search-functions 'egr-docs)


(defun egr-thing-at-point-lang-imediately (query)
  (interactive (list (q (s-replace "\n" " " (my/thing-at-point)))))
  (let ((lang (guess-lang-for-search "egr lang: ")))
    (engine/search-google (concat lang " " query))))
(add-to-list 'search-functions 'egr-thing-at-point-lang-imediately)

(defun eegr-thing-at-point-lang (query)
  (interactive
   (let ((lang
          (guess-lang-for-search "egr lang: ")))
     (list (read-string-hist "egr query: " (concat lang " " (q (s-replace "\n" " " (my/thing-at-point))) " ")))))
  (engine/search-google query))
(defalias 'eegr-thing-at-point 'eegr-thing-at-point-lang)
(add-to-list 'search-functions 'eegr-thing-at-point-lang)

(defun eegr-maybeselected (query)
  (interactive (let
                   ((s (if (selectionp)
                           (q (s-replace "\n" " " (selection))) 
                         "")))
                 (list (read-string-hist "egr query: " s))))
  (engine/search-google query))
(add-to-list 'search-functions 'eegr-maybeselected)

(defun eegr-thing-at-point-lang-imediately (query)
  (interactive (list (q (s-replace "\n" " " (my/thing-at-point)))))
  (let ((lang
         (cond
          ((major-mode-p 'org-mode) (get-src-block-language))
          ((major-mode-p 'markdown-mode) (get-src-block-language))
          ((major-mode-p 'eww-mode) (read-string-hist (concat "egr " query " lang: ")))
          ((major-mode-p 'sx-question-mode) (read-string-hist (concat "egr " query " lang: ")))
          (t (buffer-language)))))
    (engine/search-google (concat lang " " query))))
(add-to-list 'search-functions 'eegr-thing-at-point-lang-imediately)

(defun eegr-thing-at-point-imediately (query)
  (interactive (list (q (s-replace "\n" " " (my/thing-at-point)))))
  (engine/search-google query))
(add-to-list 'search-functions 'eegr-thing-at-point-imediately)

(defun ead-thing-at-point (query)
  (interactive (list (read-string-hist "ead " (concat (q (my/thing-at-point)) " "))))
  (nw (concat "ead " query)))
(add-to-list 'search-functions 'ead-thing-at-point)

(defun glimpse-thing-at-point (path query)
  (interactive (list (read-string-hist "gli path: " (file-name-extension (get-path)))
                     (read-string-hist "gli: " (concat (q (my/thing-at-point)) " "))))
  (if (str-or path)
      (nw (concat "gli -F " (q (concat (unregexify (concat "." path)) "$")) " " query))
    (nw (concat "gli " query))))
(add-to-list 'search-functions 'glimpse-thing-at-point)

(defun glimpse-thing-at-point-immediate (path query)
  (interactive (list (file-name-extension (get-path))
                     (concat (q (my/thing-at-point)) " ")))
  (if (str-or path)
      (nw (concat "gli -F " (q (concat (unregexify (concat "." path)) "$")) " " query))
    (nw (concat "gli " query))))
(add-to-list 'search-functions 'glimpse-thing-at-point-immediate)

(defun egr-thing-at-point-noquotes (query)
  (interactive (list (read-string-hist "egr (not quoted): " (concat (googleize (my/thing-at-point)) " "))))
  (sps (concat "egr " query)))
(add-to-list 'search-functions 'egr-thing-at-point-noquotes)


;; counsel-search uses my updated helm google

(define-key global-map (kbd "M-8") nil)
(define-key my-mode-map (kbd "M-8") nil)
(convert-hydra-to-sslk "8"
                       (defhydra hydra-search-thing-at-point (:color blue)
                         "Search"
                         ("1" 'define-it-at-point "define word")
                         ("1" 'define-it-at-point "define word")
                         ;; ("g" engine/search-google "google")
                         ;; ("e" eegr "google")
                         ("e" 'eegr-maybeselected "eegr-maybeselected")
                         ("g" 'eegr "google")
                         ("G" 'egr "google")
                         ("s" 'eegr "google")
                         ("S" 'counsel-gl "google-gl")
                         ("w" 'counsel-gl "google-gl")
                         ("d" 'my/def-thing-at-point "doc")
                         ("t" 'eegr-thing-at-point "egr thing")
                         ("t" 'eegr-thing-at-point "egr thing")
                         ("T" 'egr-thing-at-point "egr thing (split)")
                         ;; ("e" (call-interactively 'egr) "egr")
                         ("e" 'eegr-maybeselected "eegr-maybeselected")
                         ;; ("E" (call-interactively 'egr-maybeselected) "egr-maybeselected")
                         ("E" 'eegr-maybeselected "eegr-maybeselected")
                         ("i" 'eegr-thing-at-point-imediately "gr thing immediate")
                         ("I" 'egr-thing-at-point-imediately "gr thing immediate (split)")
                         ("8" 'eegr-thing-at-point-lang-imediately "ifl + lang")
                         ;; ("h" 'helm-google-suggest "helm-google-suggest")
                         ("h" 'counsel-google "counsel-google")
                         ("l" 'eegr-thing-at-point-lang "ifl + lang")
                         ("d" 'my-search "fz")
                         ("L" 'egr-thing-at-point-lang-imediately "ifl + lang")
                         ;; ("g" (call-interactively 'engine/search-grep-app) "grep.app")
                         ("g" 'grep-app "grep.app")
                         ("u" 'egr-thing-at-point-lang "gr + lang ")
                         ("r" 'engine/search-rosindex "rosindex")
                         ;; ("8" 'egr-thing-at-point-lang "egr")
                         ("6" 'ead-thing-at-point "ead")
                         ("7" 'egr-thing-at-point-noquotes "egr")
                         ("9" 'glimpse-thing-at-point "gli")
                         ("0" 'glimpse-thing-at-point-immediate "gli immediately")))
(define-key my-mode-map (kbd "8") nil)


;; (defun search-thing-at-point ()
;;   (interactive)
;;   (call-interactively 'hydra-apropos/body)
;;   ;; It should simply use google, but it should give me some options

;;   ;; engine/search-google
;;   ;; my/def-thing-at-point
;;   )

;; (define-key global-map (kbd "M-8") #'search-thing-at-point)

;; (define-key global-map (kbd "M-8") #'hydra-search-thing-at-point/body)
;; (define-key global-map (kbd "M-8") nil)


(defun gh-path-search (path contents)
  (interactive (list (read-string-hist "github path: ")
                     (read-string-hist "contents: ")))
  (sps (concat "ff " (q (concat "https://github.com/search?q=" contents "+path%3A" path "&type=Code"))))
  ;; (sps (concat "gh-path-search " path))
  )
(add-to-list 'search-functions 'gh-path-search)

(defun sps-gh-topic-project (topic)
  (interactive (list (read-string-hist "github topic: ")))
  (sps (concat "gh-topic-project " topic))
  ;;(sps (concat "gh-search-topics " topic " | fzf | xa gh-list-top-repos-for-topic | fzf | sed 's=^=http://github.com/=' | xa gc"))
  )
(defalias 'sps-github-topic-project-search 'sps-gh-topic-project)
(add-to-list 'search-functions 'sps-github-topic-project-search)

(defun urlencode (url)
  (sh-notty "urlencode | s chomp" url))

(defun urldecode (url)
  (sh-notty "urldecode | s chomp" url))

(defun google-code-search (pattern &optional path lang)
  (interactive (list (read-string-hist "google code pattern:")
                     (read-string-hist "google code path:")
                     (read-string-hist "google code lang:")))
  (setq pattern (urlencode pattern))
  (setq path (urlencode path))
  (setq lang (urlencode lang))

  (let ((url "https://cs.opensource.google/search?q="))
    (if (not (string-empty-p path)) (setq url (concat url "file:" (urlencode (concat " " path " ")))))
    (if (not (string-empty-p lang)) (setq url (concat url "lang:" (urlencode (concat " " lang " ")))))
    (if (not (string-empty-p pattern)) (setq url (concat url (urlencode (concat " " pattern)))))
    (sps (concat "ff " (q url)))))
(add-to-list 'search-functions 'google-code-search)


;; Instead of escaping re, do a literal search
;; (defun escape-re-special ()
;;   (sn "bs '.?^$*'"))

(defun grep-app (pattern &optional path repo)
  (interactive (if (selected)
                   (list (selection)
                         (let ((path (get-path-nocreate)))
                           (if path
                               (file-name-extension path)
                             (read-string-hist "grep.app path:")))
                         nil)
                 (list (read-string-hist "grep.app pattern:" (my/thing-at-point))
                       (read-string-hist "grep.app path:" ;; (concat (unregexify (concat "." (concat (file-name-extension (buffer-file-name))))) "$")
                                         (concat "." (file-name-extension (get-path-nocreate))))
                       (read-string-hist "grep.app repo:"))))

  (let ((do-literal (selected)))

    (if (and (selected) (s-matches-p "^[a-z0-9]+$" pattern))
        (progn
          (setq do-literal nil)
          (setq pattern (concat "\\b" pattern "\\b"))))

    (if (not pattern)
        (ns "pattern should not be empty"))

    (setq pattern (urlencode pattern))
    (setq path (urlencode path))
    (setq repo (urlencode repo))

    (let ((url "https://grep.app/search?"))
      (if (not (string-empty-p pattern))
          (if do-literal
              (setq url (concat url "q=" pattern "&case=true"))
            (setq url (concat url "q=" pattern "&regexp=true&case=true"))))
      (if (not (string-empty-p path))
          (progn
            (if (not (string-empty-p pattern))
                (setq url (concat url "&")))
            (setq url (concat url "filter[path.pattern][0]=" path))))
      (if (not (string-empty-p repo))
          (progn
            (if (or (not (string-empty-p pattern))
                    (not (string-empty-p path)))
                (setq url (concat url "&")))
            (setq url (concat url "filter[repo.pattern][0]=" repo))))
      ;; (if repo (setq url (concat url "repo:" (urlencode (concat " " repo " ")))))
      ;; (sps (concat "ff " url))
      ;; (sps (concat "ff " (q url)))

      ;; TODO Make a browse-url function which uses chrome dom or caching depending on URL
      (browse-url-generic url))))
(add-to-list 'search-functions 'grep-app)


;; gh-topic-project ansible

(defun gh-find-repo-by-topic (topic-query)
  (interactive (list (read-string-hist "github topic:")))
  (let* ((topics (sh-notty (concat "gh-search-topics " (q topic-query) " | cat")))
         (topic (fz topics))
         (repos (sh-notty (concat "gh-list-top-repos-for-topic " (q topic) " | cat")))
         (repo (fz repos))
         (url (sed "s=^=http://github.com/=" repo)))
    (my-copy url)))
(add-to-list 'search-functions 'gh-find-repo-by-topic)

(defun ieee-search (query)
  (interactive (list (read-string-hist "ieee:")))
  (eww
   (first
    (s-lines (sh-notty (concat "ieee-search " (q query)))))))
(add-to-list 'search-functions 'ieee-search)

(defun protocol-search (query)
  (interactive (list (read-string-hist "protocol:")))
  (eww    ;; (fz (sh-notty (concat "protocol-search " (q query))))
   (first ;; (str2lines (sh-notty (concat "protocol-search " (q query))))
    (s-lines (sh-notty (concat "protocol-search " (q query)))))))
(add-to-list 'search-functions 'protocol-search)

(define-key global-map (kbd "H-G") 'grep-app)
(define-key global-map (kbd "H-M") 'glimpse-thing-at-point-immediate)

(define-key global-map (kbd "M-s e") 'eegr)

(defun eead-in-similar-projects (s)
  "Look for a string in similar projects"
  (interactive (list (read-string-hist (concat "ead-in-similar-projects (" (sym2str major-mode) "): ") (my/thing-at-point))))
  (mu
   (cond ((major-mode-p 'sh-mode)
          (let ((d "$SCRIPTS"))
              ;; (wgrep (eatify s) d)
              (eead s d)))
         (t (let ((d "$MYGIT/mullikine")
                  (e (f-ext (get-path))))
              ;; (wgrep (eatify s) d)
              (eead (eatify s) d (concat "\\." e "$"))
              ;; (nw (concat
              ;;      (cmd "cd" d)
              ;;      "; "
              ;;      (cmd "ead" "-p" (concat "\\." e "$") s)))
              )))))

(defun ead-in-similar-projects (s)
  "Look for a string in similar projects"
  (interactive (list (read-string-hist (concat "ead-in-similar-projects (" (sym2str major-mode) "): ") (my/thing-at-point))))
  (mu
   (cond ((major-mode-p 'sh-mode)
          (let ((d "$SCRIPTS"))
              ;; (wgrep (eatify s) d)
              (nw (concat
                   (cmd "cd" d)
                   "; "
                   (cmd "ead" s)))))
         (t (let ((d "$MYGIT/mullikine")
                  (e (f-ext (get-path))))
              ;; (wgrep (eatify s) d)
              (nw (concat
                   (cmd "cd" d)
                   "; "
                   (cmd "ead" "-p" (concat "\\." e "$") s))))))))

(provide 'my-search)