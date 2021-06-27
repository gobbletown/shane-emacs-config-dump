; https://vxlabs.com/2018/06/08/python-language-server-with-emacs-and-lsp-mode/

;; ;; This really helps with lsp-mode
;; ;; But I have enabled it only for certain modes
;; (electric-pair-mode 1)

;; gopls is the official go language server

;; (defvar my-disable-lsp nil)

(custom-set-variables
 ;; debug
 '(lsp-print-io t)
 '(lsp-trace t)
 '(lsp-print-performance t)

 ;; general
 '(lsp-auto-guess-root t)
 '(lsp-document-sync-method 'incremental) ;; none, full, incremental, or nil
 '(lsp-response-timeout 10)

 ;; (lsp-prefer-flymake t)
 '(lsp-prefer-flymake nil) ;; t(flymake), nil(lsp-ui), or :none
 ;; flymake is shit. do not use it

 ;; go-client
 ;; '(lsp-clients-go-server-args '("--cache-style=always" "--diagnostics-style=onsave" "--format-style=goimports"))

 '(company-lsp-cache-candidates t) ;; auto, t(always using a cache), or nil
 '(company-lsp-async t)
 '(company-lsp-enable-recompletion t)
 '(company-lsp-enable-snippet t)
 ;; '(lsp-clients-go-server-args '("--cache-style=always" "--diagnostics-style=onsave" "--format-style=goimports"))
 '(lsp-document-sync-method (quote incremental))

                                        ;top right docs
 '(lsp-ui-doc-enable t)
 '(lsp-ui-doc-header t)
 '(lsp-ui-doc-include-signature t)
 '(lsp-ui-doc-max-height 30)
 '(lsp-ui-doc-max-width 120)
 '(lsp-ui-doc-position (quote at-point))

 ;; If this is true then you can't see the docs in terminal
 '(lsp-ui-doc-use-webkit nil)
 '(lsp-ui-flycheck-enable t)

 '(lsp-ui-imenu-enable t)
 '(lsp-ui-imenu-kind-position (quote top))
 '(lsp-ui-peek-enable t)

 '(lsp-ui-peek-fontify 'on-demand) ;; never, on-demand, or always
 '(lsp-ui-peek-list-width 50)
 '(lsp-ui-peek-peek-height 20)
 '(lsp-ui-sideline-code-actions-prefix "" t)

                                        ;inline right flush docs
 '(lsp-ui-sideline-enable t)

 '(lsp-ui-sideline-ignore-duplicate t)
 '(lsp-ui-sideline-show-code-actions t)
 '(lsp-ui-sideline-show-diagnostics t)
 '(lsp-ui-sideline-show-hover t)
 '(lsp-ui-sideline-show-symbol t))



;; one of these breaks
(setq lsp-completion-no-cache t)
(setq lsp-display-inline-image nil)
;; (setq lsp-document-sync-method 'incremental)
(setq lsp-document-sync-method nil)
;; (setq lsp-document-sync-method 'full)
;; This makes bash look bad with an entire
(setq lsp-eldoc-render-all nil)
;; (setq lsp-eldoc-render-all nil)
(setq lsp-enable-dap-auto-configure t)
;; (setq lsp-enable-file-watchers t)
(setq lsp-enable-file-watchers nil)
(setq lsp-enable-folding t)
(setq lsp-enable-imenu t)
;; (setq lsp-enable-indentation nil)
(setq lsp-enable-indentation t)
(setq lsp-enable-links t)
;; (setq lsp-enable-on-type-formatting nil)
(setq lsp-enable-on-type-formatting t)
;; (setq lsp-enable-semantic-highlighting nil)
(setq lsp-enable-semantic-highlighting t)
(setq lsp-enable-snippet t)
;; lsp-restart can be anything which isn't handled to disable it, no, off, etc.
(setq lsp-restart 'no)
(setq lsp-enable-symbol-highlighting t)
(setq lsp-enable-text-document-color t)
(setq lsp-enable-xref t)
(setq lsp-folding-line-folding-only t)
;; nil no limit
(setq lsp-lens-debounce-interval 0.2)
(setq lsp-folding-range-limit nil)
;; (setq lsp-lens-enable nil)
(setq lsp-lens-enable t)
;; (setq lsp-log-io t)
(setq lsp-log-io nil)
;; (setq lsp-server-trace t)
(setq lsp-server-trace nil)
;; (setq lsp-print-performance t)
(setq lsp-print-performance nil)

(setq lsp-modeline-code-actions-enable t)

(setq lsp-modeline-code-actions-segments '(count name))
(setq lsp-headerline-breadcrumb-enable t)
;; Even in GUI emacs, do not use a child frame
(setq lsp-ui-doc-use-childframe nil)
(setq lsp-headerline-breadcrumb-segments '(path-up-to-project file))


(provide 'my-lsp-custom)