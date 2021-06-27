;; This must come before require to generate the functions

;; This may not have been good enough. I have added to the package source instead
;; (add-to-list 'handle-keywords :godef)
;; (add-to-list 'handle-keywords :docsearch)
;; (add-to-list 'handle-keywords :nextdef)
;; (add-to-list 'handle-keywords :prevdef)
;; (add-to-list 'handle-keywords :jumpto)
(require 'handle)

;; :nexterr

;; Handle comes before my-term, so that's why this is here

(defmacro gen-term-command (cmd &optional reuse)
  "Generate an interactive emacs command for a term command"
  (let* ((cmdslug (concat "et-" (slugify cmd)))
         (fsym (str2sym cmdslug))
         (bufname (concat "*" cmdslug "*")))
    `(defun ,fsym ()
       (interactive)
       (et ,cmd nil nil ,bufname ,reuse))))
(defalias 'etc 'gen-term-command)

;; I don't think we need to actually have the definitions to create handlers
;; (require 'haskell-mode)

;; docsearch allows you to enter the symbol to search for

;; I need a default mode handler for handle
;; If non exists then I should not actually call handle-docs by default but call my own thing which tests
;; Perhaps I can put a prog-mode handler

(df xref-find-definitions-immediately
    ;; (setq current-prefix-arg '(4))
    ;; (call-interactively 'xref-find-definitions)
    (xref-find-definitions (my/thing-at-point))
    ;; (xref-find-definitions)
    )

(handle '(python-mode inferior-python-mode)
        :repls '(python-start-or-switch-repl
                 run-python)
        :formatters '(lsp-format-buffer)
        :debug '(dap-python-debug-and-hydra)
        :docs '(
                my-doc-override
                my-lsp-get-hover-docs
                lsp-describe-thing-at-point
                anaconda-mode-show-doc
                python-help-for-region-or-symbol
                python-eldoc-for-region-or-symbol
                python-shell-print-region-or-symbol)
        :godef '(
                 ;; anaconda-mode-find-definitions ; when fail, without error :(
                 lsp-find-definition
                 fz-cq-symbols
                 xref-find-definitions-immediately
                 helm-gtags-dwim)
        :showuml '(show-uml)
        :testall '(python-pytest-popup
                   nosetests-all)
        :docsearch '(my/doc)
        :complete '(anaconda-mode-complete)
        :assignments '(anaconda-mode-find-assignments)
        :references '(lsp-ui-peek-find-references anaconda-mode-find-references my-counsel-ag-thing-at-point)
        :nextdef '(python-nav-forward-block)
        :prevdef '(python-nav-backward-block))



;; Add functions from
;; - cider-hydra-doc/body
(handle '(clojure-mode clojurescript-mode cider-repl-mode inf-clojure)
        ;; Re-using may not be good, actually, if I'm working with multiple projects
        :repls (list
                'cider-switch-to-repl-buffer
                (etc "clj-rebel" t)
                (etc "lein repl" t))
        :formatters '(lsp-format-buffer)
        :docs '(my-doc-override
                lsp-describe-thing-at-point
                cider-doc-thing-at-point)
        :godef '(lsp-find-definition
                 cider-find-var
                 xref-find-definitions-immediately
                 helm-gtags-dwim)
        :errors '(my-clojure-switch-to-errors)
        :docsearch '(my/doc)
        :docfun '(my/cider-docfun)

        ;; For clj-refactor, see:
        ;; ;; j:my-clojure-mode-hook
        :refactor '()
        :projectfile '(my-clojure-project-file)
        :nextdef '(my-prog-next-def
                   lispy-flow))

(handle '(haskell-mode)
        ;; This is for running the program
        :run '(compile-run)
        :repls '(haskell-repl
                 haskell-intero/pop-to-repl
                 run-haskell)
        :formatters '(lsp-format-buffer)
        :docs '(my-doc-override
                ;; my-intero-get-type
                hoogle-thing-at-point)
        :godef '(haskell-mode-jump-to-def
                 haskell-mode-jump-to-def-or-tag
                 lsp-find-definition
                 (df xref-find-definitions-immediately-immediately (xref-find-definitions))
                 helm-gtags-dwim)
        :nextdef '(haskell-cabal-next-section)
        :prevdef '(haskell-cabal-previous-section)
        :docsearch '(my/doc)
        :spellcorrect '())


(handle '(scheme-mode)
        ;; This is for running the program
        :run '(compile-run)
        :repls '(my-start-scheme-repl)
        :formatters '()
        :docs '(my-doc-override)
        :godef '()
        :nextdef '()
        :prevdef '()
        :docsearch '(my/doc)
        :spellcorrect '())


(handle '(lisp-mode)
        :repls '(my-slime)
        :formatters '()
        :docs '()
        :godef '()
        :jumpto '()
        :docsearch '()
        :nextdef '()
        :prevdef '()
        :nextdef '(my-prog-next-def
                   lispy-flow))

(handle '(org-brain-visualize-mode)
        :repls '()
        :formatters '()
        :docs '()
        :path '(get-path)
        :godef '()
        :jumpto '()
        :docsearch '()
        :nextdef '()
        :prevdef '()
        :nextdef '())

(handle '(matlab-mode)
        :repls '(matlab-shell)
        :formatters '()
        :docs '()
        :path '(get-path)
        :godef '()
        :jumpto '()
        :docsearch '()
        :nextdef '()
        :prevdef '()
        :nextdef '())

(handle '(emacs-lisp-mode)
        :repls '(ielm)
        :formatters '(lsp-format-buffer)
        :global-references '(my-helpful--all-references-sym)
        :docs '(my-doc-override
                describe-thing-at-point
                helpful-symbol-at-point)
        :godef '(lispy-goto-symbol
                 elisp-slime-nav-find-elisp-thing-at-point
                 lsp-find-definition
                 xref-find-definitions-immediately
                 helm-gtags-dwim)
        :jumpto '(lispy-goto)
        :docsearch '(my/doc)
        :docfun '(helpful-symbol)
        :nextdef '(my-prog-next-def
                   lispy-flow)
        :prevdef '(my-prog-prev-def))

(handle '(go-mode)
        :repls '(go-playground)
        :playground '(go-playground)
        :formatters '(gofmt
                      lsp-format-buffer)
        :docs '(my-doc-override
                lsp-describe-thing-at-point
                godoc-at-point)
        :godef '(lsp-find-definition
                 go-guru-definition
                 ;; xref-find-definitions-immediately
                 ;; helm-gtags-dwim
                 )
        :docsearch '(my/doc)
        :nextdef '(my-prog-next-def)
        :prevdef '(my-prog-prev-def))

(handle '(Custom-mode)
        :repls '()
        :playground '()
        :formatters '()
        :docs '()
        :godef '()
        :docsearch '()
        :nextdef '(my-prog-next-def)
        :prevdef '(my-prog-prev-def))

(handle '(lsp-ui-imenu-mode)
        :repls '()
        :playground '()
        :formatters '()
        :docs '()
        :godef '()
        :docsearch '()
        :nextdef '(next-line)
        :prevdef '(previous-line))

(handle '(js-mode)
        :repls (list (etc "node"))
        :playground '()
        :formatters '()
        :docs '(my-doc-override
                )
        :godef '(lsp-find-definition
                 js-find-symbol
                 )
        :docsearch '()
        :nextdef '()
        :prevdef '())

(handle '(ruby-mode)
        :repls (list 'inf-ruby)
        :playground '()
        :formatters '()
        :docs '(my-doc-override
                )
        :godef '(lsp-find-definition)
        :docsearch '()
        :nextdef '()
        :prevdef '())

(handle '(java-mode)
        :repls '()
        :playground '()
        :debug '(dap-java-debug-and-hydra)
        :formatters '(lsp-format-buffer)
        :docs '(my-doc-override)
        :godef '(lsp-find-definition
                 xref-find-definitions-immediately
                 helm-gtags-dwim)
        :docsearch '(my/doc)
        :nextdef '(my-prog-next-def)
        :prevdef '(my-prog-prev-def))

(handle '(rust-mode rustic-mode)
        :repls '(rust-playground)
        :playground '(rust-playground)
        :formatters '(lsp-format-buffer)
        :docs '(my-doc-override)
        :godef '(lsp-find-definition
                 xref-find-definitions-immediately
                 helm-gtags-dwim)
        :docsearch '(my/doc)
        :nextdef '(my-prog-next-def)
        :prevdef '(my-prog-prev-def))

(handle '(racket-mode)
        :repls '(racket-run
                 racket-repl)
        ;; This is for running the program
        :run '(my-racket-run-main)
        :formatters '(lsp-format-buffer)
        :docs '(my-doc-override
                my/doc-thing-at-point)
        :docsearch '(my/doc-ask)
        :godef '(racket-visit-definition
                 lsp-find-definition
                 xref-find-definitions-immediately
                 helm-gtags-dwim)
        :docsearch '(my/doc)
        :nextdef '(my-prog-next-def
                   lispy-flow))

(handle '(hy-mode)
        :repls '(run-hy)
        :formatters '(lsp-format-buffer)
        :docs '(my-doc-override
                hy-describe-thing-at-point)
        :godef '(helm-gtags-dwim)
        :docsearch '(my/doc)
        :nextdef '(my-prog-next-def
                   lispy-flow))

(handle '(php-mode)
        :repls '(psysh)
        :formatters '()
        :docs '()
        :godef '()
        :docsearch '()
        :nextdef '())

(handle '(ccls-tree-mode)
        :repls '()
        :formatters '()
        :docs '()
        :godef '()
        :docsearch '()
        :nextdef '(ccls-tree-next-line next-line)
        :prevdef '(ccls-tree-prev-line previous-line))

(handle '(biblio-selection-mode)
        :repls '()
        :formatters '()
        :docs '()
        :godef '()
        :docsearch '()
        :nextdef '(biblio--selection-next)
        :prevdef '(biblio--selection-previous))

(handle '(flycheck-error-list-mode)
        :repls '()
        :formatters '()
        :docs '()
        :godef '()
        :docsearch '()
        :nextdef '(flycheck-error-list-next-error)
        :prevdef '(flycheck-error-list-previous-error))

(defun man-page-p (args)
  (sh-notty-true (concat "/usr/bin/man " args)))

(defun man-thing-at-point ()
  (interactive)
  (let ((query ;; (concat "3 " (my/thing-at-point))
         (concat (my/thing-at-point))))
    (deselect)
    (if (man-page-p query)
        (man query)
      (error "page does not exist"))))

(defun man-thing-at-point-cpp ()
  (interactive)
  (let ((query (concat "3 " (my/thing-at-point))))
    (deselect)
    (if (man-page-p query)
        (man query)
      (error "page does not exist"))))

(handle '(c-mode c++-mode)
        :complete '()
        :repls '(cc-playground)
        :formatters '(clang-format)
        :docs '(my-doc-override
                man-thing-at-point-cpp
                lsp-describe-thing-at-point)
        :docsearch '()
        :godec '()
        :godef '()
        :nextdef '()
        :prevdef '()
        :nexterr '()
        :preverr '()
        :showuml '(show-uml)
        :navleft (list (lk (ccls-navigate "L")))
        :navright (list (lk (ccls-navigate "R")))
        :navup (list (lk (ccls-navigate "U")))
        :navdown (list (lk (ccls-navigate "D")))
        :callees (list (lk (ccls-call-hierarchy t)))
        :callers (list (lk (ccls-call-hierarchy nil)))
        :errors '()
        :assignments '()
        :references '(lsp-ui-peek-find-references my-counsel-ag-thing-at-point)
        :definitions '()
        :implementations '())

;; Strangely, this is a prog-mode
(handle '(ein:notebook-multilang-mode)
        :repls '()
        :formatters '()
        :docs '()
        :godef '()
        :docsearch '()
        :nextdef '(spacemacs/ipython-notebook-transient-state/ein:worksheet-goto-next-input)
        :prevdef '(spacemacs/ipython-notebook-transient-state/ein:worksheet-goto-prev-input)
        :nexterr '()
        :preverr '())

(defun flycheck-compile-tflint ()
  (interactive)
  (flycheck-compile 'tflint))

(handle '(terraform-mode)
        :repls '()
        :formatters '()
        :docs '()
        :godef '()
        :docsearch '()
        :nextdef '()
        :prevdef '()
        :nexterr '()
        :preverr '()
        :errors '()
        ;; :errors '(flycheck-compile-tflint)
        )

;; ein:worksheet-move-cell-down
;; ein:worksheet-move-cell-up

;; This works for prog-derived modes which do not have a handle defined
(handle '(prog-mode)
        :complete '(indent-for-tab-command)
        ;; This is for running the program
        :run '(compile-run)
        :repls '(rtog/toggle-repl
                 term-pg-for-mode-or-lang
                 ;; v +/"(defun rtog\/toggle-repl (&optional passAlong? &rest ignored)" "$MYGIT/bbatsov/prelude/elpa/repl-toggle-20190426.817/repl-toggle.el"
                 )
        :formatters '(lsp-format)
        :refactor '()
        :debug '(dap-debug-and-hydra)
        :docfun '(helpful-symbol)
        :docs '(
                my-doc-override
                ;; lsp-ui-doc-show
                my-lsp-get-hover-docs
                my/doc-thing-at-point)
        :docsearch '(my/doc-ask)
        :godec '(lsp-find-declaration
                 google-for-docs
                 )
        :godef '(lsp-find-definition
                 helm-gtags-dwim
                 xref-find-definitions-immediately
                 fz-cq-symbols
                 google-for-def)
        :showuml (list 'show-uml)
        :nextdef '(my-prog-next-def)
        :prevdef '(my-prog-prev-def)
        :nexterr '(fly-next-error)
        :preverr '(fly-prev-error)
        :rc '(my-goto-rc)
        ;; select from multiple
        :errors '(lsp-ui-flycheck-list flycheck-buffer)
        :assignments '()
        :references '(lsp-ui-peek-find-references my-counsel-ag-thing-at-point
                                                  ;; my-counsel-ag
                                                  )
        :definitions '(lsp-ui-peek-find-definitions)
        :implementations '(lsp-ui-peek-find-implementation))


;; This is also what toml-mode is derived from
;; Not a prog-mode mode
;; feature-mode is not prog mode or conf-mode
(handle '(conf-mode feature-mode)
        :run '(compile-run)
        :repls '()
        :formatters '()
        :docs '()
        :godef '()
        :docsearch '()
        :nextdef '(my-prog-next-def)
        :prevdef '(my-prog-prev-def)
        :nexterr '()
        :preverr '())

(handle '(org-mode)
        :navtree '(org-sidebar-tree-toggle)
        :run '(compile-run)
        :nexterr '(fly-next-error)
        :preverr '(fly-prev-error)
        :complete '(company-ispell)
        :rc '(my-goto-rc))

(handle '(text-mode)
        :nexterr '(fly-next-error)
        :preverr '(fly-prev-error))

(handle '(eww-mode)
        :nexterr '(fly-next-error)
        :preverr '(fly-prev-error))

(handle '(markdown-mode)
        :nexterr '(fly-next-error)
        :preverr '(fly-prev-error))

(handle '(twittering-mode)
        :repls '()
        :formatters '()
        :docs '()
        :godef '()
        :nextdef '(twittering-goto-next-status)
        :prevdef '(twittering-goto-previous-status)
        :nexterr '()
        :preverr '()
        :docsearch '()
        :spellcorrect '())

(handle '(dired-mode)
        :repls '(dired-guess-repl-for-here)
        :formatters '()
        :docs '()
        :godef '()
        :nextdef '(dired-next-line)
        :prevdef '(dired-previous-line)
        :nexterr '()
        :preverr '()
        :docsearch '()
        :spellcorrect '())

(handle '(kubernetes-overview-mode)
        :repls '()
        :formatters '()
        :docs '()
        :godef '()
        :rc '(my-goto-rc)
        :nexterr '()
        :preverr '()
        :docsearch '()
        :spellcorrect '())

(handle '(tabulated-list-mode)
        :repls '()
        :formatters '()
        :docs '()
        :godef '()
        :rc '(my-goto-rc)
        :nextdef '(next-line-nonvisual)
        :prevdef '(previous-line-nonvisual)
        :nexterr '()
        :preverr '()
        :docsearch '()
        :spellcorrect '())

;; Fundamental mode doesn't handle everything
;; This is because the topmost class is =prog-mode=
;; (derived-mode-class (derived-mode-class 'emacs-lisp-mode))
;; (handle '(fundamental-mode)
;;         :rc '(my-goto-rc))

;; Runs the interpreter
;; (handle-repls)

;; Runs the docs for thing at point
;; (handle-docs)


(defun handle-setup-keybindings ()
  )

(provide 'my-handle)
