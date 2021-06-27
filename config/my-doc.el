(require 'my-utils)
(require 'my-engine)
(require 'go-mode)

(defun clj-rebel-doc (func)
  (interactive (list (read-string-hist "clj-rebel-doc: " (my/thing-at-point))))
  (sps (cmd "clj-rebel-doc" func)))

(defset my-doc-funcs '(my/doc-thing-at-point-immediate
                       my/type-search-thing-at-point-immediate
                       my/src-thing-at-point
                       my-grep-for-thing-select
                       handle-docs
                       clj-rebel-doc))

(defun fz-run-doc-func ()
  (interactive)
  (let ((f (fz my-doc-funcs nil nil "fz-run-doc-func: ")))
    (if (sor f)
        (call-interactively (str2sym f)))))
(define-key global-map (kbd "M-7") 'fz-run-doc-func)

;; This defines a new engine-mode for documentation on a given language
;; I don't need this
;; (my-def-lang-doc-engine py)
(defmacro my-def-lang-doc-engine (lang)
  ;; Although this setq evaluates the thing passed to the macro, it's still evaluated *within* the macro and may be out of context.
  ;; Therefore, I can call the macro like this: (eval `(my-def-lang-doc-engine ,lang))
  (setq lang (str (eval lang)))
  `(defengine ,(str2sym (concat "google-" lang))
     ,(concat "http://www.google.com/search?ie=utf-8&oe=utf-8&q=" (construct-google-query lang 'lang) "+%s")
     :browser 'eww-browse-url))


(defun search-google-for-doc (&optional symstring lang)
  "Do an I'm feeling lucky lookup for documentation on this thing"
  (interactive (list
                (str (if (selectedp)
                         (selection)
                       (sexp-at-point)))
                (current-lang)))

  ;; (tvipe lang)
  ;; (tvipe symstring)

  ;; These nots are still needed, even with the above interactive. If the function is not run interactively, it doesn't run the interactive defaults.
  (if (not lang)
      (setq lang (current-lang)))

  (if (not symstring)
      (setq symstring (str (sexp-at-point))))

  (if (string-equal lang "fundamental")
      (setq lang (detect-language)))

  (if (string-equal lang "eww")
      (setq lang ""))

  (cond ((string-equal lang "fundamental") (message "%s" symstring))
        (t (progn
             ;; ; The old way
             ;; (eval `(my-def-lang-doc-engine ,lang))
             ;; (eval `(,(string2symbol (concat "engine/search-google-" lang)) symstring))

             (let ((keywords symstring))
               (if (> (length lang) 0)
                   ;; TODO quote each word in keywords here
                   (setq keywords (concat keywords " " (e/q lang))))

               (sph (concat "egr +/" (e/q symstring) " " keywords) "")
               ;; (engine/search-google-lucky keywords)
               (message "%s" (concat "no doc handler for " lang ". searching google")))))))


(defun google-for-docs (&optional lang query)
  (interactive (list (buffer-language)
                     (str (if (selection-p) (selection) (str (sexp-at-point))))))

  ;; Try with the detected language and then with the major mode

  (let* ((lang (or lang (buffer-language)))
         (query (or query (if (selection-p) (selection) (str (sexp-at-point))))))

    (sph (concat "google-for-docs " (q lang) " " (q query)) "")))


;; M-6
(defun doc/lookup-ask (query)
  "docstring"
  (interactive "P")
  )


;; M-7
;; (defun my-lispy-eval-eval ()
;;   "Evaluate sexp at point and then evaluate the result as a function."
;;   (interactive)
;;   (let ((result (str2sym (str (call-interactively 'lispy-eval)))))
;;     (if (commandp result)
;;         (call-interactively result)
;;       (eval `(,result)))))


(defun my/doc (&optional thing winfunc)
  "Show doc for thing given. winfunc = 'spv or 'sph elisp function"
  (interactive (list
                (if (selectedp)
                    (selection)
                  (read-string "query:"))
                t
                "spv"))

  (if (not winfunc)
      (setq winfunc 'sph))

  (if (not thing)
      (setq thing (sexp-at-point)))

  (cond
   ((string-equal (preceding-sexp-or-element) "#lang")
    (my-racket-lang-doc (str thing) winfunc))
   ((derived-mode-p 'haskell-mode)
    ;; (spacemacs/jump-to-definition)
    (progn (hoogle thing t)))
   ((derived-mode-p 'racket-mode)
    (progn (tvipe "hi") (my-racket-doc winfunc thing) (deselect)))
   ((derived-mode-p 'emacs-lisp-mode)
    ;; Unfortunately, because we only have a string, we dont know if it's a function or variable
    (describe-function (str2sym thing)))
   (t (search-google-for-doc thing))))
(defalias 'my/doc-ask 'my/doc)


;; This takes C-u to slightly modify the way it searches
;; This is also used by evil while navigating, so only allow it to do things for specific modes, such as python
(defun my/doc-thing-at-point (arg &optional  winfunc)
  "Show doc for thing under pointl. winfunc = 'spv or 'sph elisp function"
  (interactive "P")

  (if (not winfunc)
      (setq winfunc 'sph))

  (cond
   ((string-equal (preceding-sexp-or-element) "#lang")
    (my-racket-lang-doc (str (sexp-at-point))  winfunc))

   ((derived-mode-p 'racket-mode)
    (progn
      (my-racket-doc winfunc)
      (deselect)))
   ((derived-mode-p 'lisp-mode)
    (call-interactively 'slime-documentation)
    ;; (slime-documentation (symbol-name (intern (format "%s" (thing-at-point 'symbol)))))
    ;; This is docs, not goto definition
    ;; ((derived-mode-p 'go-mode)
    ;;  (progn (spacemacs/jump-to-definition)))
    ((derived-mode-p 'go-mode) (progn (godoc-at-point (point)))))
   ;; ((derived-mode-p 'c-mode) (man (concat "3 " (thing-at-point 'symbol))))
   ;; ((derived-mode-p 'c++-mode) (man (concat "3 " (thing-at-point 'symbol))))
   ((derived-mode-p 'python-mode) (if arg (call-interactively 'pydoc-at-point) (anaconda-mode-show-doc)))
   ;; (spacemacs/jump-to-definition)
   ;; ((derived-mode-p 'haskell-mode) (progn (hoogle (my/thing-at-point) t)))
   ((derived-mode-p 'haskell-mode) (progn (shut-up (my/nil (ns "implement hs-doc")))))
   ;; ((derived-mode-p 'racket-mode) (progn (my-racket-doc  winfunc) (deselect)))

   ;; ((derived-mode-p 'emacs-lisp-mode) (helpful-symbol (symbol-at-point)))
   ;; This is also used by evil while navigating, so only allow it to do things for specific modes, such as python
   ;; ((derived-mode-p 'text-mode) (progn (message "%s" "text mode. probably minibuffer") (describe-thing-at-point)))
   ;; (t (search-google-for-doc))
   ;; (t (message "%s" "unknown mode"))
   ))

(defun my/doc-thing-at-point-list ()
  "Show list of docs for thing under point"
  (interactive)
  (if (string-equal (preceding-sexp-or-element) "#lang")
      ;; (racket--repl-command "doc %s" (concat "H:" (str (sexp-at-point))))
      (str (racket--cmd/async (racket--repl-session-id) `(doc ,(concat "H:" (str (sexp-at-point))))))
    (cond ((derived-mode-p 'clojure-mode 'cider-repl-mode 'inf-clojure)
           ;; (condition-case nil (cider-doc-thing-at-point) (error (message "%s" "You may need to enable the default cider jack-in repl")))
           (cider-doc-thing-at-point))
          ((derived-mode-p 'lisp-mode)
           (call-interactively 'slime-documentation)
           ;; (slime-documentation (symbol-name (intern (format "%s" (thing-at-point 'symbol)))))
           )
          ;; This is docs, not goto definition
          ;; ((derived-mode-p 'go-mode)
          ;;  (progn (spacemacs/jump-to-definition)))
          ((derived-mode-p 'go-mode)
           (progn (godoc-at-point (point))))
          ((derived-mode-p 'haskell-mode)
           ;; (spacemacs/jump-to-definition)
           (progn (hoogle (my/thing-at-point) nil)))
          ((derived-mode-p 'racket-mode)
           (progn (my-racket-doc) (deselect)))
          ((derived-mode-p 'text-mode)
           (progn (message "%s" "text mode. probably minibuffer") (describe-thing-at-point)))
          ((derived-mode-p 'emacs-lisp-mode)
           (describe-thing-at-point))
          ((derived-mode-p 'hy-mode) (hy-describe-thing-at-point))
          (t (search-google-for-doc))
          ;; (t (message "%s" "unknown mode"))
          )))

;; This is not go to def! It displays documentation
(defun my/def-thing-at-point ()
  "Show lisp documentation for the appropriate dialect based on the current mode."
  (interactive)
  (if (string-equal (preceding-sexp-or-element) "#lang")
      (racket--repl-command "doc %s" (concat "H:" (str (sexp-at-point))))
    (cond
     ((derived-mode-p 'go-mode)
      (progn (spacemacs/jump-to-definition)))

     (t (let ((lang (current-lang t))
              (symstring (my/thing-at-point)))
          ;; (tvipe lang)
          (if (string-equal lang "fundamental")
              (setq lang (detect-language)))

          (cond ((string-equal lang "fundamental") (progn
                                                     (message "%s" symstring)))
                (t (progn
                     ;; (eval `(my-def-lang-doc-engine ,lang))
                     (eval `(,(string2symbol (concat "engine/search-google-lucky")) (concat (construct-google-query lang 'lang) (concat "+" (e/q symstring)))))
                     (message "%s" (concat "no doc handler for " lang ". searching google")))))))
     ;; (t (message "%s" "unknown mode"))
     )))

(define-key global-map (kbd "M-0") #'my/doc-thing-at-point-list)
;; Sadly I can't use selected for M-7, M-8 M-9 bindings
;; This is because it needs to work in lisp modes

(defun my/doc-thing-at-point-immediate ()
  (interactive)
  (my/doc-thing-at-point t))

(defun my-intero-get-type ()
  (interactive)
  (my-enable-intero)
  (let ((out (sh-notty "sed -z -e \"s/\\n/ /g\" -e \"s/ \\+/ /g\"" (sed "s/^[^:]\\+ :: //" (intero-get-type-at (beginning-of-thing 'sexp) (end-of-thing 'sexp))))))
    (if (called-interactively-p 'any)
        (my/copy out)
      out)))

(defun hs-install-module-under-cursor (thing)
  (interactive (list (my/thing-at-point)))
  (sps (concat "z-repl stack install " (q (fz (sh-notty (concat "hs-import-to-package " (q thing))))))))

(defun hs-download-packages-with-function-type (type)
  (interactive (list (my-intero-get-type)))
  ;; (term-nsfa "hsqf pg")
  ;; (e/sph-zsh "t new \"rtcmd hs-type-declarative-search-fzf String\"")
  (sph (concat "t new " (q "hs-download-packages-with-function-type " (q type)))))

(defun hs-tds-fzf (type)
  (interactive (list (my-intero-get-type)))
  ;; (term-nsfa "hsqf pg")
  ;; (e/sph-zsh "t new \"rtcmd hs-type-declarative-search-fzf String\"")

  (sph (concat "t new " (q "rtcmd hs-type-declarative-search-fzf " (q type)))))

(defun my/type-search-thing-at-point (&optional  winfunc)
  "Show doc for thing under pointl. winfunc = 'spv or 'sph elisp function"
  (interactive)

  (if (not winfunc)
      (setq winfunc 'sph))

  (cond
   ((derived-mode-p 'haskell-mode)
    ;; (progn (tm/spv (concat "lambdabot-hoogle-query " (e/q (my/thing-at-point)))))
    (progn ;; (tm/spv (concat "lambdabot-hoogle-query " (e/q (sed "s/^[^:]\\+ :: //" (intero-get-type-at (beginning-of-thing 'sexp) (end-of-thing 'sexp))))))
      (call-interactively 'hs-tds-fzf)))
   (t (search-google-for-doc))
   ;; (t (message "%s" "unknown mode"))
   ))

(defun my-doc-override (&optional lang mode query)
  (interactive (list (buffer-language)
                     (str major-mode)
                     (if (selection-p) (selection) (str (sexp-at-point)))))

  ;; Try with the detected language and then with the major mode

  (let* ((lang (or lang (buffer-language)))
         (mode (or mode (str major-mode)))
         (query (or query (if (selection-p) (selection) (str (sexp-at-point)))))
         (docs (sn (cmd "doc-override" query lang mode))))

    ;; (ignore-errors (kill-buffer "*doc-override*"))
    (ignore-errors
      (if (bufferp "doc-overide*")
          (with-current-buffer "*doc-override*"
            (kill-buffer-and-window))))
    (if (string-empty-p docs)
        (error "Doc is empty")
      (new-buffer-from-string docs "*doc-override*"))))

(defun my/src-thing-at-point (&optional  winfunc)
  "Show doc for thing under pointl. winfunc = 'spv or 'sph elisp function"
  (interactive)

  (if (not winfunc)
      (setq winfunc 'sph))

  (cond
   ((derived-mode-p 'haskell-mode)
    (progn (tm/spv (concat "hsdoc " (e/q (sexp-at-point))))))
   (t (search-google-for-doc))))

(defun my/type-search-thing-at-point-immediate ()
  (interactive)
  (my/type-search-thing-at-point t))

(defun my/doc-thing-at-point-immediate-spv ()
  (interactive)
  (my/doc-thing-at-point t 'spv))

;; (define-key global-map (kbd "M-6") #'my/doc)
;; (define-key global-map (kbd "M-6") nil)
;; (define-key global-map (kbd "M-7") #'my/doc-thing-at-point-immediate)
;; (define-key global-map (kbd "M-&") #'my/type-search-thing-at-point-immediate)
;; (define-key global-map (kbd "M-9") #'my/doc-thing-at-point)
;; (define-key global-map (kbd "M-9") nil)

;; (define-key global-map (kbd "M-9") #'helpful-symbol)
;; (define-key global-map (kbd "M-(") #'my/src-thing-at-point)

;; This is old
;; (define-key global-map (kbd "M-8") #'my/def-thing-at-point)

(defun sps-ead-thing-at-point ()
  (interactive)
  (sph (concat "ead " (q (eatify (str (my/thing-at-point)))))))

(defun wgrep-thing-at-point (s)
  (interactive (list (my/thing-at-point)))
  (if (major-mode-p 'grep-mode)
      ;; (call-interactively 'grep-ead-on-results)
      (call-interactively 'grep-eead-on-results)
    (if (>= (prefix-numeric-value current-prefix-arg) 4)
        (let ((current-prefix-arg nil))
          (wgrep (eatify (str s)) (get-top-level)))
      (wgrep (eatify (str s))))))

(defun eatify (pat)
  (if (re-match-p "^[a-zA-Z_]" pat)
      (setq pat (concat "\\b" pat)))
  (if (re-match-p "[a-zA-Z_]$" pat)
      (setq pat (concat pat "\\b")))
  pat
  ;; (concat "\\b" pat "\\b")
  )

;; This is so nice and fast! I should definitely stay within emacs!
(defun eead-thing-at-point (&optional thing paths-string dir)
  (interactive (list (str (my/thing-at-point))
                     nil
                     (get-top-level)))
  (let* ((cmd (concat "ead " (q (eatify thing))))
         (cmdnoeat (if paths-string
                       (concat "umn | uniqnosort | ead " (q thing))
                     (concat "ead " (q thing))))
         (slug (slugify cmdnoeat))
         (bufname (concat "*grep:" slug "*"))
         (results (string-or (sn cmd paths-string)
                             (sn cmdnoeat)))
         ;; (results (sn cmd))
         )

    (with-current-buffer (new-buffer-from-string results
                                                 bufname)
      (cd dir)
      (grep-mode)
      (ivy-wgrep-change-to-wgrep-mode)
      (define-key compilation-button-map (kbd "C-m") 'compile-goto-error)
      (define-key compilation-button-map (kbd "RET") 'compile-goto-error)
      (visual-line-mode -1))))

;; (define-key global-map (kbd "M-3") #'eead-thing-at-point)
;; (define-key global-map (kbd "M-3") #'sps-ead-thing-at-point)


(defun my-grep-for-thing-select ()
  (interactive)
  (let ((action
         (qa
          -g "mygit"
          -s "similar"
          -h "here"
          )))
    (cond
     ((string-equal "mygit" action)
      ;; (call-interactively 'ead-in-similar-projects)
      (call-interactively 'eead-in-similar-projects))
     ((string-equal "similar" action)
      ;; (call-interactively 'ead-in-similar-projects)
      (call-interactively 'eead-in-similar-projects))
     (t
      (call-interactively 'wgrep-thing-at-point)))))

(define-key global-map (kbd "M-3") #'my-grep-for-thing-select)

;; (require 'racket-repl)
;; This was the old way. Older racket-mode
;; (defun racket--repl-command (fmt &rest xs)
;;   "Send command to the Racket process and return the response sexp.
;; Do not prefix the command with a `,'. Not necessary to append \n."
;;   (racket--repl-ensure-buffer-and-process)
;;   (let ((proc racket--repl-command-process))
;;     (unless proc
;;       (error "Command process is nil"))
;;     (with-current-buffer (process-buffer proc)
;;       (delete-region (point-min) (point-max))
;;       (process-send-string proc (concat (apply #'format (cons fmt xs)) "\n"))
;;       (with-timeout (racket-command-timeout
;;                      (error "Command process timeout"))
;;         ;; While command server running and not yet complete sexp
;;         (while (and (memq (process-status proc) '(open run))
;;                     (or (= (point) (point-min))
;;                         (condition-case ()
;;                             (progn (scan-lists (point-min) 1 0) nil)
;;                           (scan-error t))))
;;           (accept-process-output nil 0.1)))
;;       (cond ((not (memq (process-status proc) '(open run)))

;;              (error "Racket command process: died"))
;;             ((= (point-min) (point))
;;              (error "Racket command process: Empty response"))
;;             (t
;;              (let ((result (buffer-substring (point-min) (point-max))))
;;                (delete-region (point-min) (point-max))
;;                (eval (read result))))))))

(defun my/describe-symbol (symbol)
  "A “C-h o” replacement using “helpful”:
   If there's a thing at point, offer that as default search item.

   If a prefix is provided, i.e., “C-u C-h o” then the built-in
   “describe-symbol” command is used.

   ⇨ Pretty docstrings, with links and highlighting.
   ⇨ Source code of symbol.
   ⇨ Callers of function symbol.
   ⇨ Key bindings for function symbol.
   ⇨ Aliases.
   ⇨ Options to enable tracing, dissable, and forget/unbind the symbol!
  "
  (interactive "p")
  (let* ((thing (symbol-at-point))
         (val (completing-read
               (format "Describe symbol (default %s): " thing)
               (vconcat (list thing) obarray)
               (lambda (vv)
                (cl-some (lambda (x) (funcall (nth 1 x) vv))
                         describe-symbol-backends))
               t nil nil))
         (it (intern val)))

    (if current-prefix-arg
        (funcall #'describe-symbol it)
      (cond
       ((or (functionp it) (macrop it) (commandp it)) (helpful-callable it))
       (t (helpful-symbol it))))))

;; Keybindings.
;; (global-set-key (kbd "C-h o") #'my/describe-symbol)
;; (global-set-key (kbd "C-h k") #'helpful-key)


(provide 'my-doc)
