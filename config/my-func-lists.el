(require 'my-nix)
(require 'my-syntax-extensions)

(defun eww-open-this-file ()
  (interactive)
  (eww-open-file (buffer-file-path)))

(defun elinks-dump-open-this-file ()
  (interactive)
  (new-buffer-from-string (sn (concat "elinks-dump " (q (buffer-file-path))))))

;; (cfilter "extract-yaml-from-clql")

;; ** TODO Learn how alists work -- I should use that instead of creating lots of lists
;; Do it without an alist in the meantime.



(defset prog-mode-funcs '(my-lsp-get-hover-docs
                          run-file-with-interpreter
                          handle-projectfile))
(defset yaml-mode-funcs
  (list
   'yaml-get-value-from-this-file
   'lsp-yaml-select-buffer-schema
   'lsp-yaml-download-schema-store-db
   (df yaml-multiline-chrome (chrome "https://yaml-multiline.info/"))
   (dff (chrome "https://lzone.de/cheat-sheet/YAML"))))
(defset dired-mode-funcs '(dired-narrow
                           dired-narrow-fuzzy
                           open-main
                           dired-toggle-read-only
                           show-extensions-below
                           run-fs-search-function
                           dired-toggle-dumpd-dir
                           sps-ranger))
(defset ranger-mode-funcs '(open-main
                            sps-ranger))

(defset proced-mode-funcs '(proced-get-pwd))

(defset Info-mode-funcs '(info-buttons-imenu))

(defset csv-mode-funcs '(csv-open
                         csv-open-in-numpy
                         csv-open-in-pandas
                         csv-open-in-fpvd))

(defset tabulated-list-mode-funcs '(tablist-export-csv
                                    tablist-open-in-fpvd))

(defset subed-mode-funcs '(show-clean-subs))

(defset context-functions '(org-in-src-block-p org-babel-change-block-type))

(defset grep-mode-funcs (list 'grep-ead-on-results 'grep-output-get-paths))
;; (defset grep-mode-funcs '(grep-ead-on-results))

(defset Custom-mode-funcs (list
                           'configure-chrome-permissions))

(defset racket-mode-funcs (list ))
(defset org-mode-funcs ;; (list 'org-latex-export-to-pdf 'tvipe-org-table-export)
  (list
   'org-ascii-convert-region-to-utf8
   'poly-org-mode
   'idify-org-file
   'unidify-org-file
   'idify-org-files-here
   'unidify-org-files-here
   'generate-glossary-buttons-over-buffer-force-on
   'org-latex-export-to-pdf
   'org-latex-export-to-pdf
   'org-sidebar-tree-toggle
   'org-ql-search
   'helm-org-rifle
   'tvipe-org-table-export-tsv
   'etv-org-table-export-tsv
   'fpvd-org-table-export
   'efpvd-org-table-export))

(defset kubernetes-overview-mode-funcs
  (list
   (df kube-get-pods
       (term-nsfa "kubectl -n kube-system get pods"))
   (df kube-get-pods-buffer
       (new-buffer-from-string (sh-notty "kubectl -n kube-system get pods")))))

;; (defun new-buffer-from-string-filter (s))

(defset python-mode-funcs (append '(python-version
                                    python-pytest-popup
                                    py-detect-libraries
                                    importmagic-fix-imports
                                    pyimport-insert-missing
                                    pyimport-remove-unused)
                                  (list ;; (df ag-init (my-counsel-ag "__init__"))
                                   (lk (my-counsel-ag "__init__"))
                                   (lk (lint "py-mypy")))))

(defset c++-mode-funcs (append '()
                               (list
                                (lk (lint "cpplint"))
                                (lk (lint "d-thompsonja-cpplint-1-4-5")))))

;; Any way to combine these?
(defset rust-mode-funcs (list
                         'rust-test
                         'rustic-cargo-current-test))

;; TODO Add
;; fiximports
(defset go-mode-funcs '())
(defset clojure-mode-filters (list
                              (defshellfilter cljfmt)
                              (defshellfilter-new-buffer clojure2json)))
(defset clojure-mode-funcs (list
                            'clj-rebel-doc
                            'cider-jack-in
                            'clojure-find-deps
                            'my-clojure-lein-run
                            'clojure-select-copy-dependency
                            'helm-cider-spec
                            'helm-cider-spec-ns
                            'helm-cider-history
                            'helm-cider-apropos
                            'helm-cider-cheatsheet
                            'helm-cider-apropos-ns
                            'helm-cider-spec-symbol
                            'helm-cider-repl-history
                            'helm-cider-apropos-symbol
                            'helm-cider-apropos-symbol-doc))
(defset clojurec-mode-funcs '(cider-jack-in))

(defset web-mode-funcs '(eww-open-this-file elinks-dump-open-this-file))

;; TODO Add
;; fix-imports -v --debug >(cat) < /home/shane/notes/ws/haskell/examples/repline/cowsay.hs | v
;; fix-imports -v --debug >(cat)
(defset haskell-mode-funcs '(ghcid
                             ghcd-info
                             my-intero-get-type
                             haskell-extend-language
                             hs-install-module-under-cursor
                             hs-download-packages-with-function-type))
(defset eww-mode-funcs '(eww-open-in-chrome
                         eww-add-domain-to-chrome-dom-matches
                         toggle-cached-version
                         eww-select-wayback-for-url
                         toggle-use-chrome-locally
                         eww-reader
                         eww-reload-cache-for-page
                         eww-open-browsh
                         eww-summarize-this-page
                         google-this-url-in-this-domain
                         my-eww-save-image
                         my-eww-save-image-auto))
(defset magit-mode-funcs '(magit-eww-releases))
(defset crontab-mode-funcs '(crontab-guru))

(defun org-brain-edit-hist ()
  (interactive)
  (edit-var-elisp 'org-brain--vis-history))

(defset graphviz-dot-mode-funcs
  '(dot-digraph
    neato-digraph))

(defset org-brain-visualize-mode-funcs
  (list
   ;; 'org-brain-to-dot
   'org-brain-to-dot-associates
   'org-brain-to-dot-children
   'pp-org-brain-tree
   'org-brain-show-recursive-children
   'org-brain-show-recursive-children-names
   'org-brain-describe-topic
   'org-brain-headline-to-file
   'org-brain-headline-to-file-this
   'org-brain-asktutor
   'org-brain-current-topic
   'org-brain-google-here
   'org-brain-suggest-subtopics
   'org-brain-edit-hist
   'org-brain-set-title
   'org-brain-open-resource
   'org-id-update-id-locations
   'revert-buffer
   'org-brain-switch-brain
   (dff (edit-var-elisp 'org-brain-mind-map-child-level))
   (dff (edit-var-elisp 'org-brain-mind-map-parent-level))))

(defset magit-status-mode-funcs '(magit-eww-releases))
(defset magit-log-mode-funcs '(magit-eww-releases))
(defset mermaid-mode-funcs '(mermaid-compile))

;; mermaid-show
(defset markdown-mode-funcs '(markdown-get-mode-here
                              markdown-preview
                              md-org-export-to-org
                              ;; md-glow
                              md-glow-vs
                              markdown-get-lang-here
                              poly-markdown-mode))

(defset lisp-mode-funcs '(sly))

(defset Man-mode-funcs '(Man-follow-manual-reference
                         Man-goto-section))

(defset rustic-mode-funcs (list
                           'rust-test
                           'rustic-cargo-current-test))

;; TODO Make a macro to generate these functions
(defset docker-image-mode-funcs '(docker-image-copy-entrypoint-and-cmd docker-image-copy-cmd docker-image-copy-entrypoint ff-dockerhub ff-dockerfile))
(defset docker-container-mode-funcs (list
                                     (defun docker-container-copy-cmd ()
                                       (interactive)
                                       (let ((sel (docker-select-one)))
                                         (my-copy (sh-notty (concat "docker-get-cmd " sel)))))
                                     (defun docker-container-export-nspawn ()
                                       (interactive)
                                       (let ((sel (docker-select-one)))
                                         (sh-notty (concat "docker-export-nspawn -r  " sel))))))
(defset docker-machine-mode-funcs (list
                                     (defun regen-cert ()
                                       (interactive)
                                       (let ((sel (docker-select-one)))
                                         (term-nsfa (concat "set -xv; docker-machine regenerate-certs " sel " ; pak"))))))

(defun emacs-which (cmd)
  (str2list (chomp (sh-notty (concat "PATH=" (q (getenv "PATH")) " which -a " cmd)))))

;; (emacs-which "grex")

(defset graphviz-dot-mode-filters (list (defshellfilter gen-qdot)))

(defset hcl-mode-filters (list
                                (defshellfilter-new-buffer hcl2json)))
(defset terraform-mode-filters (list
                                (defshellfilter-new-buffer hcl2json)))
(defset terraform-mode-funcs (list
                              (lk (lint "tflint"))))
(defset text-mode-filters (list
                           ;; I had to modify sh-notty to add scripts to the start of PATH
                           ;; (defshellfilter /home/shane/scripts/grex)
                           (defshellfilter grex)
                           (defshellfilter-new-buffer-mode 'text-mode ner)
                           (defshellfilter-new-buffer-mode 'text-mode extract-keyphrases)
                           (defshellfilter-new-buffer-mode 'text-mode deplacy)
                           (defshellfilter split-commas-multiline)))
(defset eww-mode-filters (list
                           (defshellfilter-new-buffer-mode 'text-mode ner)
                           (defshellfilter-new-buffer-mode 'text-mode extract-keyphrases)
                           (defshellfilter-new-buffer-mode 'text-mode deplacy)))
(defset csv-mode-filters (list
                          (defshellfilter-new-buffer csv2org-table)
                          (defshellfilter-new-buffer tsv2org-table)))

(defset dockerfile-mode-filters (list
                                 (defshellfilter docker-listify-arguments)))

(defset sh-mode-filters (list (defshellfilter split-pipe-multiline)
                              (defshellfilter dvate)
                              (defshellfilter python-listify-arguments)
                              (defshellfilter join-cmd-args)
                              (defshellfilter bash-onelinerise-line-continuations)
                              (defshellfilter split-options-multiline)
                              (defshellfilter sh-split-statement-multiline)
                              (defshellfilter split-args-multiline)))
(defset clql-mode-filters (list (defshellfilter extract-yaml-from-clql)))
(defset snippet-mode-filters (list (defshellfilter escape-for-yasnippet)))
(defset yaml-mode-filters (list
                           ;; Not sure why this runs slowly
                           (defshellfilter compile-yaml)
                           (eval `(defshellfilter ,(str2sym (nsfa "yq ."))))))
(defset hy-mode-filters (list (defshellfilter-new-buffer hy2py)
                         ;; (defun my-hy2py (s) (sh-notty "hy2py" s))
                              ))
(defset racket-mode-filters (list))

(defset python-mode-filters (list (defshellfilter python2to3)
                                  (defshellfilter autopep8)
                                  ;; (defshellfilter sh -c "scrape \"^(import [a-zA-Z_-]+|from [a-zA-Z_-]+)\" | cut -d ' ' -f2- | sortnouniq")
                                  (defshellfilter-new-buffer python-scrape-imports)
                                  (defshellfilter python-listify-arguments)
                                  (defshellfilter autopep8 --aggressive)
                                  (defshellfilter py-split-array-multiline)
                                  (defshellfilter-new-buffer py2hy)))

(defshellfilter-new-buffer md2org)

(defset markdown-mode-filters (list 'sh/nb/md2org
                                    (defshellfilter-new-buffer md2txt)
                                    (defshellfilter-new-buffer mermaid-show)
                                    (defshellfilter-new-buffer translate-to-english)
                                    (defshellfilter translate-to-english)
                                    (defshellfilter md-checklistify)
                                    (defshellfilter-new-buffer plantuml)))

(defshellfilter-new-buffer org2md)

(defset org-mode-filters (list
                          (defshellfilter-new-buffer translate-to-english)
                          (defshellfilter-new-buffer org2txt)
                          (defshellfilter translate-to-english)
                          (defshellfilter org-listify)
                          (defshellfilter org-reformat)
                          (defshellfilter org-checklistify)
                          (defshellfilter mnm-presentation)
                          (defshellfilter-new-buffer-mode 'text-mode ner)
                          (defshellfilter-new-buffer-mode 'text-mode deplacy)
                          ;; (defshellfilter /home/shane/scripts/grex)
                          (defshellfilter grex)
                          'sh/nb/org2md
                          (defshellfilter python-listify-arguments)
                          (defshellfilter split-commas-multiline)
                          (defshellfilter spaces-to-org-table)
                          (defshellfilter tsv2org-table)
                          (defshellfilter space-to-org-table)
                          (defshellfilter org-capitalise-headings)
                          (defshellfilter-new-buffer mermaid-show)
                          (defshellfilter-new-buffer plantuml)))



(defun major-mode-function (&optional mode)
  (interactive)
  (if (not mode)
      (setq mode major-mode))
  (let* ((lsym (str2sym (concat (sym2str mode) "-funcs")))
         (progsym (str2sym "prog-mode-funcs"))
         (l (if (variable-p lsym)
                (symbol-value lsym)
              nil))
         (pl (if (variable-p progsym)
                 (symbol-value progsym)
               nil))
         (finallist (if (and (major-mode-p 'prog-mode)
                             pl)
                        (append '() l pl)
                      l)))
    (if finallist
        (call-interactively (str2sym (fz finallist)))
      (message (concat (sym2str finallist) " is empty")))))

(defun major-mode-filter (&optional mode)
  (interactive)
  (if (not mode)
      (setq mode major-mode))
  (let ((l (str2sym (concat (sym2str mode) "-filters"))))
    (if (variable-p l)
        (let* ((funname (fz (eval l)))
               (f (str2sym funname)))
          (if (not (string-empty-p funname))
            (filter-selected-region-through-function (str2sym funname))
              ;; (save-buffer-state
              ;;  (filter-selected-region-through-function (str2sym funname)))
              ;;(progn
              ;;  (ignore-errors (kill-buffer "filter-indirect"))
              ;;  (make-indirect-buffer (current-buffer) "filter-indirect" t)
              ;;  (switch-to-buffer "filter-indirect")
              ;;  (insert "hi")
              ;;  ;; (sleep 1)
              ;;  ;; (with-current-buffer "filter-indirect"
              ;;  ;;   (insert "hi")
              ;;  ;;   ;; (filter-selected-region-through-function f)
              ;;  ;;   (kill-buffer "filter-indirect"))
              ;;  )
            ))
      (message (concat (sym2str l) " is not defined")))))

;; (fz org-mode-filters)

;; (define-key my-mode-map (kbd "M-l") )

(provide 'my-func-lists)