(require 'lsp-mode)
(require 'my-lsp-clients)


(load (concat emacsdir "/config/my-lsp-custom.el"))
(require 'my-lsp-custom)


(require 'el-patch)
(el-patch-feature lsp-mode)
(el-patch-defun lsp (&optional arg)
  "Entry point for the server startup.
When ARG is t the lsp mode will start new language server even if
there is language server which can handle current language. When
ARG is nil current file will be opened in multi folder language
server if there is such. When `lsp' is called with prefix
argument ask the user to select which language server to start."
  (interactive "P")

  (lsp--require-packages)

  (when (buffer-file-name)
    (let (clients
          (matching-clients (lsp--filter-clients
                             (-andfn #'lsp--matching-clients?
                                     #'lsp--server-binary-present?))))
      (cond
       (matching-clients
        (when (setq lsp--buffer-workspaces
                    (or (and
                         ;; Don't open as library file if file is part of a project.
                         (not (lsp-find-session-folder (lsp-session) (buffer-file-name)))
                         (lsp--try-open-in-library-workspace))
                        (lsp--try-project-root-workspaces (equal arg '(4))
                                                          (and arg (not (equal arg 1))))))
          (lsp-mode 1)
          (when lsp-auto-configure (lsp--auto-configure))
          (setq lsp-buffer-uri (lsp--buffer-uri))
          (lsp--info "Connected to %s."
                     (apply 'concat (--map (format "[%s]" (lsp--workspace-print it))
                                           lsp--buffer-workspaces)))))
       ;; look for servers which are currently being downloaded.
       ((setq clients (lsp--filter-clients (-andfn #'lsp--matching-clients?
                                                   #'lsp--client-download-in-progress?)))
        (lsp--info "There are language server(%s) installation in progress.
The server(s) will be started in the buffer when it has finished."
                   (-map #'lsp--client-server-id clients))
        (seq-do (lambda (client)
                  (cl-pushnew (current-buffer) (lsp--client-buffers client)))
                clients))
       ;; look for servers to install
       ((setq clients (lsp--filter-clients (-andfn #'lsp--matching-clients?
                                                   #'lsp--client-download-server-fn
                                                   (-not #'lsp--client-download-in-progress?))))
        (let ((client (lsp--completing-read
                       (concat "Unable to find installed server supporting this file. "
                               "The following servers could be installed automatically: ")
                       clients
                       (-compose #'symbol-name #'lsp--client-server-id)
                       nil
                       t)))
          (cl-pushnew (current-buffer) (lsp--client-buffers client))
          (lsp--install-server-internal client)))
       ;; no clients present
       ((setq clients (unless matching-clients
                        (lsp--filter-clients (-andfn #'lsp--matching-clients?
                                                     (-not #'lsp--server-binary-present?)))))
        (lsp--warn "The following servers support current file but do not have automatic installation configuration: %s
You may find the installation instructions at https://emacs-lsp.github.io/lsp-mode/page/languages.
(If you have already installed the server check *lsp-log*)."
                   (mapconcat (lambda (client)
                                (symbol-name (lsp--client-server-id client)))
                              clients
                              " ")))
       ;; no matches
       ((-> #'lsp--matching-clients? lsp--filter-clients not)
        (lsp--error
         (el-patch-swap
           "There are no language servers supporting current mode `%s' registered with `lsp-mode'.
This issue might be caused by:
1. The language you are trying to use does not have built-in support in `lsp-mode'. You must install the required support manually. Examples of this are `lsp-java' or `lsp-metals'.
2. The language server that you expect to run is not configured to run for major mode `%s'. You may check that by checking the `:major-modes' that are passed to `lsp-register-client'.
3. `lsp-mode' doesn't have any integration for the language behind `%s'. Refer to https://emacs-lsp.github.io/lsp-mode/page/languages and https://langserver.org/ ."
           "No LSP server for current mode")
         major-mode major-mode major-mode))))))



(defun maybe-lsp ()
  (interactive)
  (cond
   ;; ((major-mode-p 'haskell-mode)
   ;;  (message "Disabled lsp because it's too slow to edit haskell"))
   ((major-mode-p 'c-mode)
    (call-interactively 'lsp)
    (setq imenu-create-index-function 'imenu-default-create-index-function)
    ;; (message "Disabled lsp because it's too slow to edit emacs c")
    )
   ((major-mode-p 'prompt-description-mode)
    (message "Disabled lsp for prompts"))
   ((and org-src-mode (major-mode-p 'haskell-mode))
    (message "Disabled lsp because i want haskell babel blocks to be fast"))
   ;; ((and org-src-mode (major-mode-p 'c-mode))
   ;;  (message "Disabled lsp because I need to set up ccls again"))
   ;; ((string-match "/emacs-mirror/.*\\.c$" (or (get-path-nocreate) ""))
   ;;  (message "Disabled lsp because i haven't got it going for emacs source C code yet"))
   (t (call-interactively 'lsp))))



(defun lsp--get-document-symbols-around-advice (proc &rest args)
  ;; This greatly speeds up lsp-mode.
  ;; e:$MYGIT/emacs-mirror/emacs/src/process.c

  ;; (cc-imenu-init cc-imenu-c-generic-expression 'imenu-default-create-index-function)
  ;; e:$HOME/local/emacs28/share/emacs/28.0.50/lisp/progmodes/cc-menus.el.gz
  ;; (setq imenu-create-index-function 'imenu-default-create-index-function)
  (if (not (major-mode-p 'c-mode))
      (let ((res (apply proc args)))
        res)))
(advice-add 'lsp--get-document-symbols :around #'lsp--get-document-symbols-around-advice)

;; It only memoizes if it works.
;; It appears to not work with c-mode, and on top of that be incredibly slow
;; (memoize 'lsp--get-document-symbols)
;; (memoize-restore 'lsp--get-document-symbols)

(use-package lsp-mode
  :ensure t
  :commands lsp-register-client
  :init (setq lsp-gopls-server-args '("--debug=localhost:6060"))
  :config
  (setq lsp-prefer-flymake :none)
  (lsp-register-custom-settings
   '(("gopls.completeUnimported" t t))))

                                        ;(use-package lsp-mode
                                        ; has to not fail when emacs 24
(my/with 'lsp-mode
         ;; Definitely do not want this -- it's very outdated
         ;; I blacklisted it
         ;; /home/shane/var/smulliga/source/git/config/emacs/config/my-package-blacklist.el
         ;; lsp-mode now provides lsp-go so I can't blacklist it like this
         ;; anymore.
         ;; (require 'lsp-go)

         (setq lsp-gopls-staticcheck t)
         (setq lsp-eldoc-render-all t)
         (setq lsp-gopls-complete-unimported t)

         ;; (setq lsp-gopls-staticcheck t)

         ;; Make this nil so I don't get duplication on the ui-doc
         ;; This was a problem especially in python
         ;; (setq lsp-eldoc-render-all nil)

         ;; (setq lsp-gopls-complete-unimported t)

         (use-package lsp-ui
           :ensure t
           ;; :demand t
           :config
           (setq lsp-ui-sideline-ignore-duplicate t)
           (add-hook 'lsp-mode-hook 'lsp-ui-mode)
           (require 'lsp-ui-imenu))

         (add-hook 'lsp-after-open-hook 'lsp-enable-imenu)
         ;; get lsp-python-enable defined
         ;; NB: use either projectile-project-root or ffip-get-project-root-directory
         ;;     or any other function that can be used to find the root directory of a project

         ;; deprecated
         ;; (lsp-define-stdio-client lsp-python "python"
         ;;                          #'projectile-project-root
         ;;                          '("pyls"))
         ;; this is the new way. but it's automatic now
         ;;(lsp-register-client
         ;; (make-lsp-client :new-connection (lsp-stdio-connection "pyls")
         ;;                  :major-modes '(python-mode)
         ;;                  :server-id 'pyls))

         ;; make sure this is activated when python-mode is activated
         ;; lsp-python-enable is created by macro above

         ;; ;; Is it built-in now?
         ;; (add-hook 'python-mode-hook
         ;;           (lambda ()
         ;;             (lsp-python-enable)))

         (use-package lsp-mode
           :ensure t
           :commands (lsp lsp-deferred)
           :hook (go-mode . lsp-deferred))


         (remove-hook 'before-save-hook 'gofmt-before-save)
         (defun lsp-go-install-save-hooks ()
           (add-hook 'before-save-hook #'lsp-format-buffer t t)
           (add-hook 'before-save-hook #'lsp-organize-imports t t))
         (add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

         (require 'lsp-haskell)


                                        ; (setq lsp-haskell-process-path-hie "hie-wrapper")

         (use-package lsp-haskell
           :ensure t
           :config
           (setq lsp-haskell-process-path-hie "haskell-language-server-wrapper")
           ;; Comment/uncomment this line to see interactions between lsp client/server.
           ;;(setq lsp-log-io t)
           )


         (progn
           (require 'julia-mode)
           ;; (push "/path/to/lsp-julia" load-path)
           (require 'lsp-julia)
           (require 'lsp-mode)
           ;; Configure lsp + julia
           (add-hook 'julia-mode-hook #'lsp-mode)
           (add-hook 'julia-mode-hook #'lsp))



         (require 'lsp-racket)
         ;; (add-hook 'racket-mode-hook #'lsp-racket-enable)


         (use-package lsp-mode
           ;; :demand t
           :config
           (add-hook 'c++-mode-hook #'lsp)
           ;; I can't keep it on because when projects dont work, its super annoying
           ;; (remove-hook 'c++-mode-hook #'lsp)

           ;; ccls is uninstallable on ubuntu16
           ;; https://repology.org/project/ccls/versions
           ;; I have tried. I need ubuntu20
           ;; (remove-hook 'c-mode-hook #'lsp)
           ;; I did it
           ;; (add-hook 'c-mode-hook #'lsp)
           (add-hook 'c-mode-hook #'maybe-lsp)
           (add-hook 'python-mode-hook #'lsp)
           ;; Just install this manually and then it will work
           ;; https://github.com/richterger/Perl-LanguageServer
           ;; Or:
           ;; plf Perl::LanguageServer
           ;; (add-hook 'perl-mode-hook #'lsp)
           ;; (remove-hook 'perl-mode-hook #'lsp)
           ;; I got the perl language server going, but it doesn't do anything
           (add-hook 'dockerfile-mode-hook #'lsp)
           (add-hook 'java-mode-hook #'lsp)
           (add-hook 'kotlin-mode-hook #'lsp)
           ;; (remove-hook 'yaml-mode-hook #'lsp)
           (add-hook 'yaml-mode-hook #'maybe-lsp)
           (add-hook 'sql-mode-hook #'lsp)
           (add-hook 'php-mode-hook #'lsp)
           (add-hook 'clojure-mode-hook #'lsp)
           (add-hook 'clojurescript-mode-hook #'lsp)
           ;; (remove-hook 'clojure-mode-hook #'lsp)
           (add-hook 'julia-mode-hook #'lsp)
           (add-hook 'ess-julia-mode-hook #'lsp)
           (add-hook 'go-mode-hook #'lsp)
           (add-hook 'cmake-mode-hook #'lsp)
           (add-hook 'ruby-mode-hook #'lsp)
           (add-hook 'gitlab-ci-mode-hook #'lsp)

           ;; this seems to be broken
           ;; (add-hook 'dockerfile-mode-hook #'lsp)

           (add-hook 'sh-mode-hook #'lsp)
           (add-hook 'rust-mode-hook #'lsp)
           (add-hook 'vimrc-mode-hook #'lsp)
           (add-hook 'racket-mode-hook #'lsp)
           ;; (remove-hook 'racket-mode-hook #'lsp)
           (add-hook 'rustic-mode-hook #'lsp)
           (add-hook 'nix-mode-hook #'lsp)
;;;  prolog-pack-install lsp_server
           ;; build-swi-ls
           (add-hook 'prolog-mode-hook #'lsp)
           (add-hook 'js-mode-hook #'lsp)
           (add-hook 'typescript-mode-hook #'lsp)
           ;; (add-hook 'haskell-mode-hook #'lsp)
           (add-hook 'haskell-mode-hook #'maybe-lsp)
           ;; (remove-hook 'haskell-mode-hook #'lsp)
           (add-hook 'purescript-mode-hook #'lsp)
           ;; (remove-hook 'haskell-mode-hook #'lsp)
           )

         ;; (use-package lsp-mode
         ;;   :ensure t
         ;;   :hook ((clojure-mode . lsp)
         ;;          (clojurec-mode . lsp)
         ;;          (clojurescript-mode . lsp))
         ;;   :config
         ;;   ;; add paths to your local installation of project mgmt tools, like lein
         ;;   (setenv "PATH" (concat
         ;;                   "/usr/local/bin" path-separator
         ;;                   (getenv "PATH")))
         ;;   (dolist (m '(clojure-mode
         ;;                clojurec-mode
         ;;                clojurescript-mode
         ;;                clojurex-mode))
         ;;     (add-to-list 'lsp-language-id-configuration `(,m . "clojure")))
         ;;   (setq lsp-enable-indentation nil
         ;;         lsp-clojure-server-command '("bash" "-c" "clojure-lsp")))


         ;; These modes are "clojure"
         (dolist (m '(clojure-mode
                      clojurec-mode
                      clojurescript-mode
                      clojurex-mode))
           (add-to-list 'lsp-language-id-configuration `(,m . "clojure")))

         (require 'lsp-clojure)
         (setq lsp-enable-indentation nil
               lsp-clojure-server-command '("bash" "-c" "clojure-lsp"))

         (require 'ccls)
         ;; (setq ccls-executable "/usr/local/bin/ccls")
         (setq ccls-executable "/home/shane/scripts/ccls")



         ;; This might be outdated now
         ;; (use-package company-lsp
         ;;   :config
         ;;   (push 'company-lsp company-backends))


         (use-package lsp-ui-peek
           :config)

         ;; NB: only required if you prefer flake8 instead of the default
         ;; send pyls config via lsp-after-initialize-hook -- harmless for
         ;; other servers due to pyls key, but would prefer only sending this
         ;; when pyls gets initialised (:initialize function in
         ;; lsp-define-stdio-client is invoked too early (before server
         ;; start)) -- cpbotha
         (defun lsp-set-cfg ()
           (let ((lsp-cfg `(:pyls (:configurationSources ("flake8")))))
             ;; TODO: check lsp--cur-workspace here to decide per server / project
             (lsp--set-configuration lsp-cfg)))

         ;; (add-hook 'lsp-after-initialize-hook 'lsp-set-cfg)
         ;; (remove-hook 'lsp-after-initialize-hook 'lsp-set-cfg)


         ;; https://www.mortens.dev/blog/emacs-and-the-language-server-protocol/
         (use-package lsp-mode
           :config
           ;; `-background-index' requires clangd v8+!
           (setq lsp-clients-clangd-args '("-j=4" "-background-index" "-log=error"))

           ;; ..
           )

         ;; (defun lsp-ui-doc--callback (hover bounds buffer)
         ;;            "Process the received documentation.
         ;; HOVER is the doc returned by the LS.
         ;; BOUNDS are points of the symbol that have been requested.
         ;; BUFFER is the buffer where the request has been made.")
         )

;; rust
;; This solved all rust lsp problems
(progn

  (require 'lsp-mode) ;; language server protocol
  (with-eval-after-load 'lsp-mode
    (add-hook 'rust-mode-hook #'lsp))
  ;; (add-hook 'rust-mode-hook #'flycheck-mode))

  ;; excessive UI feedback for light reading between coding
  (require 'lsp-ui)
  (with-eval-after-load 'lsp-ui
    (add-hook 'lsp-mode-hook 'lsp-ui-mode))

  ;; autocompletions for lsp (available with melpa enabled)
  ;; (require 'company-lsp)
  ;; (push 'company-lsp company-backends)

  ;; tell company to complete on tabs instead of sitting there like a moron
  (require 'rust-mode)
  (define-key rust-mode-map (kbd "TAB") #'company-indent-or-complete-common))

  (use-package lsp-mode
    :hook
    ((go-mode c-mode c++-mode) . lsp)
    :bind
    (:map lsp-mode-map
          ("C-c r" . lsp-rename))
    :config

    ;; (require 'lsp-clients)

    ;; LSP UI tools
    (use-package lsp-ui
      :preface
      (defun ladicle/toggle-lsp-ui-doc ()
        (interactive)
        (if lsp-ui-doc-mode
            (progn
              (lsp-ui-doc-mode -1)
              (lsp-ui-doc--hide-frame))
          (lsp-ui-doc-mode 1)))
      :bind
      (:map lsp-mode-map
            ("C-c C-r" . lsp-ui-peek-find-references)
            ("C-c C-j" . lsp-ui-peek-find-definitions)
            ("C-c i" . lsp-ui-peek-find-implementation)
            ("C-c m" . lsp-ui-imenu)
            ("C-c s" . lsp-ui-sideline-mode)
            ("C-c d" . ladicle/toggle-lsp-ui-doc))
      :hook
      (lsp-mode . lsp-ui-mode))

    ;; (lsp-register-client
    ;;  (make-lsp-client :new-connection (lsp-stdio-connection
    ;;                                    (lambda () (cons "bingo"
    ;;                                                     lsp-clients-go-server-args)))
    ;;                   :major-modes '(go-mode)
    ;;                   :priority 2
    ;;                   :initialization-options 'lsp-clients-go--make-init-options
    ;;                   :server-id 'go-bingo
    ;;                   :library-folders-fn (lambda (_workspace)
    ;;                                         lsp-clients-go-library-directories)))

    ;; DAP
    (use-package dap-mode
      :custom
      (dap-go-debug-program `("node" "~/.extensions/go/out/src/debugAdapter/goDebug.js"))
      :config
      (dap-mode 1)
      (require 'dap-hydra)
      (require 'dap-gdb-lldb) ; download and expand lldb-vscode to the =~/.extensions/webfreak.debug=
      (require 'dap-go) ; download and expand vscode-go-extenstion to the =~/.extensions/go=
      (use-package dap-ui
        :ensure nil
        :config
        (dap-ui-mode 1)))

    ;; Lsp completion
    ;; (use-package company-lsp)
    )

  ;; FAQ -- [[https://github.com/emacs-lsp/lsp-java][GitHub - emacs-lsp/lsp-java]]
  ;; LSP Java is showing to many debug messages, how to stop that? Add the
  ;; following configuration.
  (setq lsp-inhibit-message t)


  ;; (lsp--on-self-insert t)

(defun my-lsp--managed-mode-hook-body ()
  (interactive)
  (remove-hook 'post-self-insert-hook 'lsp--on-self-insert t)
  (setq-local indent-region-function (function handle-formatters)))


;; But how do I remove it for all lsp buffers?
;; (remove-hook 'post-self-insert-hook 'lsp--on-self-insert)
;; (remove-hook 'post-self-insert-hook 'lsp--on-self-insert t)
(add-hook 'lsp--managed-mode-hook #'my-lsp--managed-mode-hook-body)

  ;; (remove-hook 'lsp--managed-mode-hook (lm (remove-hook 'post-self-insert-hook 'lsp--on-self-insert t)))


(defun lsp-ui-flycheck-list ()
  "List all the diagnostics in the whole workspace."
  (interactive)
  (let ((buffer (get-buffer-create "*lsp-diagnostics*"))
        (workspace lsp--cur-workspace)
        (window (selected-window)))
    (with-current-buffer buffer
      (lsp-ui-flycheck-list--update window workspace))
    (add-hook 'lsp-after-diagnostics-hook 'lsp-ui-flycheck-list--refresh nil t)
    (setq lsp-ui-flycheck-list--buffer buffer)
    (display-buffer
     buffer)))



(define-key lsp-ui-imenu-mode-map (kbd "<return>") 'lsp-ui-imenu--view)
(define-key lsp-ui-imenu-mode-map (kbd "RET") 'lsp-ui-imenu--view)


(define-key lsp-ui-flycheck-list-mode-map (kbd "<M-RET>") 'lsp-ui-flycheck-list--visit)
(define-key lsp-ui-flycheck-list-mode-map (kbd "RET") 'lsp-ui-flycheck-list--view)


(define-key lsp-ui-peek-mode-map (kbd "<prior>") #'lsp-ui-peek--select-prev-file)
(define-key lsp-ui-peek-mode-map (kbd "<next>") #'lsp-ui-peek--select-next-file)

(require 'helm-lsp)


;; This is extremely slow.
;; It may be quite nice, but it's not nice enough. I can't do any programming with it
;; I have broken python-language-server (pyls) now, so I have to use this
;; pyls wasnt even broken. lsp-mode is broken, i think

;; the microsoft server a) doesn't free resources
;; b)  breaks after reopening a file'
;; (use-package lsp-python-ms
;;   :ensure t
;;   :init (progn (setq lsp-python-ms-auto-install-server t)
;;                (setq lsp-python-ms-executable
;;                      "/home/shane/scripts/ms-pyls"))
;;   :hook (python-mode . (lambda ()
;;                          (require 'lsp-python-ms)
;;                          (lsp))))
                                        ; or lsp-deferred





;; For some reason this variable doesnt change when I set it
;; It only updates when i redefine =dap-python-debug-and-hydra=
(setq dap-python-executable "python-for-lsp")


;; This must be out of date
(defun dap-python-debug-and-hydra (&optional cmd pyver)
  (interactive)
  (if cmd
      (progn
        (if pyver
            (sh-notty (concat "cd /home/shane/scripts; ln -sf `which " pyver "` python-for-lsp-sym")))

        (let* ((cmdwords (s-split " " cmd))
               (scriptname (car cmdwords))
               (args (umn (s-join " " (cdr cmdwords)))))
          (with-current-buffer (find-file (umn scriptname))
            (save-excursion
              (dap-debug `(:type "python" :args ,args :cwd OBnil :target-module nil :request "launch" :name "Python :: Run Configuration")))
            (find-file (umn scriptname)))))
    (progn
      (let ((cbuf (current-buffer)))
        ;; (message "hi")
        (dap-debug `(:type "python" :args "" :cwd nil :target-module nil :request "launch" :name "Python :: Run Configuration"))
        (switch-to-buffer cbuf)))))


(define-key lsp-ui-peek-mode-map "j" (kbd "<down>"))
(define-key lsp-ui-peek-mode-map "k" (kbd "<up>"))

(define-key lsp-ui-peek-mode-map "h" (kbd "<left>"))
(define-key lsp-ui-peek-mode-map "l" (kbd "<right>"))

;; my-mode-map overrides this
(define-key lsp-ui-peek-mode-map (kbd "M-p") (kbd "<left>"))
(define-key lsp-ui-peek-mode-map (kbd "M-n") (kbd "<right>"))

;; (defun lsp:marked-string-value
;;       (object)
;;     (when
;;         (ht\? object)
;;       (gethash "value" object)))
;; (defun lsp:set-marked-string-value
;;     (object value)
;;   (puthash "value" value object)
;;   object)



;; This minimises the doc string
(defun lsp-ui-doc--extract-marked-string (marked-string &optional language)
  "Render the MARKED-STRING with LANGUAGE."
  (string-trim-right
   (let* ((string (if (stringp marked-string)
                      (mnm marked-string)
                    (lsp:markup-content-value marked-string)))
          (with-lang (lsp-marked-string? marked-string))
          (language (or (and with-lang
                             (or (lsp:marked-string-language marked-string)
                                 (lsp:markup-content-kind marked-string)))
                        language))
          (markdown-hr-display-char nil))
     (cond
      (lsp-ui-doc-use-webkit
       (if (and language (not (string= "text" language)))
           (format "```%s\n%s\n```" language string)
         string))
      (t (lsp--render-element (lsp-ui-doc--inline-formatted-string string)))))))


;; This minimises the sideline strings
(defun lsp-ui-sideline--extract-info (contents)
  "Extract the line to print from CONTENTS.
CONTENTS can be differents type of values:
MarkedString | MarkedString[] | MarkupContent (as defined in the LSP).
We prioritize string with a language (which is probably a type or a
function signature)."
  (when contents
    (cond
     ((lsp-marked-string? contents)
      (lsp:set-marked-string-value contents (mnm (lsp:marked-string-value contents)))
      contents)
     ((vectorp contents)
      (seq-find (lambda (it) (and (lsp-marked-string? it)
                                  (lsp-get-renderer (lsp:marked-string-language it))))
                contents))
     ((lsp-markup-content? contents)
      ;; This successfully minimises haskell sideline strings
      (lsp:set-markup-content-value contents (mnm (lsp:markup-content-value contents)))
      contents))))


;; nadvice - proc is the original function, passed in. do not modify
;; (defun lsp-ui-peek-find-references-around-advice (proc &rest args)
;;   (let ((res (apply proc args)
;;              (tvipe "hi")))
;;     res)

;;   ;; (cl-letf (((symbol-function 'sexp-at-point) #'my/thing-at-point))
;;   ;;   (let ((res (apply proc args)))
;;   ;;     res))
;;   )
;; (advice-add 'lsp-ui-peek-find-references :around #'lsp-ui-peek-find-references-around-advice)
;; (advice-remove 'lsp-ui-peek-find-references #'lsp-ui-peek-find-references-around-advice)

(advice-remove-all-from 'lsp-ui-peek-find-references)


(defun lsp-ui-peek--find-xrefs (input method param)
  "Find INPUT references.
METHOD is ‘references’, ‘definitions’, `implementation` or a custom kind.
PARAM is the request params."
  (setq lsp-ui-peek--method method)
  (let ((xrefs (lsp-ui-peek--get-references method param)))
    (unless xrefs
      (user-error "Not found for: %s"  input))
    (xref-push-marker-stack)
    (when (featurep 'evil-jumps)
      (lsp-ui-peek--with-evil-jumps (evil-set-jump)))
    (if (and (not lsp-ui-peek-always-show)
             (not (cdr xrefs))
             (= (length (plist-get (car xrefs) :xrefs)) 1))
        (error "Here is the only instance.")
        ;; (let ((x (car (plist-get (car xrefs) :xrefs))))
        ;;   (-if-let (uri (lsp:location-uri x))
        ;;       (-let (((&Range :start (&Position :line :character)) (lsp:location-range x)))
        ;;         (lsp-ui-peek--goto-xref `(:file ,(lsp--uri-to-path uri) :line ,line :column ,character)))
        ;;     (-let (((&Range :start (&Position :line :character)) (or (lsp:location-link-target-selection-range x)
        ;;                                                              (lsp:location-link-target-range x))))
        ;;       (lsp-ui-peek--goto-xref `(:file ,(lsp--uri-to-path (lsp:location-link-target-uri x)) :line ,line :column ,character)))))
        (lsp-ui-peek-mode)
        (lsp-ui-peek--show xrefs))))


;; The threshold didn't work, so I've disabled them
(setq lsp-enable-file-watchers nil)
(setq lsp-file-watch-threshold 10)


(lsp-defun lsp-ui-doc--callback ((hover &as &Hover? :contents) bounds buffer)
  "Process the received documentation.
HOVER is the doc returned by the LS.
BOUNDS are points of the symbol that have been requested.
BUFFER is the buffer where the request has been made."
  (if
      (not (and
            hover
            (>= (point) (car bounds)) (<= (point) (cdr bounds))
            (eq buffer (current-buffer))))
      (setq contents "-")
    (setq contents (or (-some->>
                        ;; "shane"
                        contents
                        lsp-ui-doc--extract
                        (replace-regexp-in-string "\r" ""))
                       ;; (replace-regexp-in-string "\r" "" (lsp-ui-doc--extract contents))
                       "Cant extract or docs are empty")))

  (progn
    (setq lsp-ui-doc--bounds bounds)
    (lsp-ui-doc--display
     (thing-at-point 'symbol t)
     contents))
  ;; (lsp-ui-doc--hide-frame)
  )


(defun lsp-ui-doc--extract (contents)
  "Extract the documentation from CONTENTS.
CONTENTS can be differents type of values:
MarkedString | MarkedString[] | MarkupContent (as defined in the LSP).
We don't extract the string that `lps-line' is already displaying."
  ;; (tvipe contents)
  (cond
   ((vectorp contents) ;; MarkedString[]
    (mapconcat 'lsp-ui-doc--extract-marked-string
               (lsp-ui-doc--filter-marked-string (seq-filter #'identity contents))
               "\n\n"
               ;; (propertize "\n\n" 'face '(:height 0.4))
               ))
   ;; when we get markdown contents, render using emacs gfm-view-mode / markdown-mode
   ((and (lsp-marked-string? contents)
         (lsp:marked-string-language contents))
    (lsp-ui-doc--extract-marked-string (lsp:marked-string-value contents)
                                       (lsp:marked-string-language contents)))
   ((lsp-marked-string? contents) (lsp-ui-doc--extract-marked-string contents))
   ((and (lsp-markup-content? contents)
         (string= (lsp:markup-content-kind contents) lsp/markup-kind-markdown))
    (lsp-ui-doc--extract-marked-string (lsp:markup-content-value contents) lsp/markup-kind-markdown))
   ((and (lsp-markup-content? contents)
         (string= (lsp:markup-content-kind contents) lsp/markup-kind-plain-text))
    (lsp:markup-content-value contents))
   (t
    ;; This makes python work
    contents)))


;; lsp-ui-doc--extract
;; TODO Keep markdown
(defun my-lsp-get-hover-docs ()
  (interactive)
  (let* ((ht (lsp-request "textDocument/hover" (lsp--text-document-position-params)))
         (docs
          (if (hash-table-p ht)
              (lsp-ui-doc--extract (gethash "contents" ht))
            "")))
    (if (and docs (not (string-empty-p docs))) (if (called-interactively-p 'interactive)
                                                   ;; (tvd docs)
                                                   (new-buffer-from-string
                                                    docs
                                                    nil 'text-mode)
                                                 docs)
      (error "No docs"))))

(define-key lsp-mode-map (kbd "s-l 9") 'my-lsp-get-hover-docs)
(define-key lsp-mode-map (kbd "s-9") 'my-lsp-get-hover-docs)
(define-key global-map (kbd "s-i") 'lsp-install-server)


(setq lsp-enable-on-type-formatting nil)


;; (define-key lsp-ui-imenu-mode-map (kbd "M-n") (kbd "<down>"))

(advice-add 'lsp--document-highlight :around #'ignore-errors-around-advice)

;; (advice-add 'lsp--build-workspace-configuration-response :around #'ignore-errors-around-advice)
;; (advice-remove 'lsp--build-workspace-configuration-response #'ignore-errors-around-advice)


(defun lsp-list-servers (&optional update)
  (mapcar 'car (--map (cons (funcall
                             (-compose #'symbol-name #'lsp--client-server-id) it) it)
                      (or (->> lsp-clients
                               (ht-values)
                               (-filter (-andfn
                                         (-orfn (-not #'lsp--server-binary-present?)
                                                (-const update))
                                         (-not #'lsp--client-download-in-progress?)
                                         #'lsp--client-download-server-fn)))
                          (user-error "There are no servers with automatic installation")))))

(defun lsp-list-all-servers ()
  (lsp-list-servers t))


(defun lsp-get-server-for-install (name)
  (interactive (list (fz (lsp-list-all-servers))))
  (cdr (car (-filter (lambda (sv) (string-equal (car sv) name))
                     (--map (cons (funcall
                                   (-compose #'symbol-name #'lsp--client-server-id) it) it)
                            (or (->> lsp-clients
                                     (ht-values)
                                     (-filter (-andfn
                                               (-orfn (-not #'lsp--server-binary-present?)
                                                      (-const t))
                                               (-not #'lsp--client-download-in-progress?)
                                               #'lsp--client-download-server-fn)))
                                (user-error "There are no servers with automatic installation")))))))

(defun lsp-install-server-by-name (name)
  (interactive (list (fz (lsp-list-all-servers))))
  (lsp--install-server-internal (lsp-get-server-for-install name)))


(defun lsp--sort-completions (completions)
  (lsp-completion--sort-completions completions))

(defun lsp--annotate (item)
  (lsp-completion--annotate item))

(defun lsp--resolve-completion (item)
  (lsp-completion--resolve item))

(defun lsp-install-server-update-advice (proc update)
  (cond
   (update (setq update nil))
   ((not update) (setq update t)))
  (let ((res (apply proc (list update))))
    res))
(advice-add 'lsp-install-server :around #'lsp-install-server-update-advice)
;; (advice-remove 'lsp-install-server #'lsp-install-server-update-advice)

;; (advice-add 'lsp-install-server :around #'invert-prefix-advice)
;; (advice-remove 'lsp-install-server #'invert-prefix-advice)


;; These commands should only be run when lsp is running
;; But I may want them here just to look them up
(define-key global-map (kbd lsp-keymap-prefix) lsp-command-map)






(defun lsp-on-change-around-advice (proc &rest args)
  (message "lsp-on-change called with args %S" args)
  (let ((res (apply proc args)))
    (message "lsp-on-change returned %S" res)
    res))
;; (advice-add 'lsp-on-change :around #'lsp-on-change-around-advice)
(advice-remove 'lsp-on-change #'lsp-on-change-around-advice)


(require 'lsp-headerline)
(defun lsp-headerline--arrow-icon ()
  "Build the arrow icon for headerline breadcrumb."
  ;; (if (require 'all-the-icons nil t)
  ;;     (all-the-icons-material "chevron_right"
  ;;                             :face 'lsp-headerline-breadcrumb-separator-face)
  ;;   (propertize "›" 'face 'lsp-headerline-breadcrumb-separator-face))
  (propertize "›" 'face 'lsp-headerline-breadcrumb-separator-face))

;; I'm not sure why, but it wont overload normally, so do this
;; (defun ... (defun does actually work
;; (add-hook 'lsp-mode-hook 'define-my-lsp-overridden)


(defun dired-lsp-binaries ()
  (interactive)
  (dired lsp-server-install-dir))


(defun lsp-ui-peek-find-references (&optional include-declaration extra)
  "Find references to the IDENTIFIER at point."
  (interactive)

  ;; (try-deselected-and-maybe-reselect
  ;;  (let ((thing (str2sym (my/thing-at-point))
  ;;               ;; (symbol-at-point)
  ;;               ))
  ;;    (lsp-ui-peek--find-xrefs thing
  ;;                             "textDocument/references"
  ;;                             (append extra (lsp--make-reference-params nil include-declaration)))))

  (let ((thing (str2sym (my/thing-at-point)))
        (p (point))
        (m (mark))
        (s (selected-p)))
    (deselect)
    (eval
     `(try
       ;; Try this, otherwise, reselect
       (lsp-ui-peek--find-xrefs ',thing
                                "textDocument/references"
                                (append ,extra (lsp--make-reference-params nil ,include-declaration)))
       (progn
         (set-mark ,m)
         (goto-char ,p)
         ,(if s
              '(progn
                 (activate-mark))
            '(progn
               (deactivate-mark)))
         (error "lsp-ui-peek-find-references failed"))))))



;; (defcustom lsp-racket-langserver-command '("racket" "--lib" "racket-langserver")
;;   "Command to start the server."
;;   :type 'string
;;   :package-version '(lsp-mode . "7.1"))
(defcustom lsp-racket-langserver-command '("racket-langserver")
  "Command to start the server."
  :type 'string
  :package-version '(lsp-mode . "7.1"))
(setq lsp-racket-langserver-command "racket-langserver")



;; This didn't work
;; These modes are yaml
;; (dolist (m '(yaml-mode
;;              gitlab-ci-mode))
;;   (add-to-list 'lsp-language-id-configuration `(,m . "yaml")))


;; I needed this
;; Yaml
;; vim +/"(lsp-register-client" "$EMACSD/packages26/lsp-mode-20200925.18/lsp-yaml.el"
;; Added gitlab-ci-mode
(lsp-register-client
 (make-lsp-client :new-connection (lsp-stdio-connection
                                   (lambda ()
                                     `(,(or (executable-find (cl-first lsp-yaml-server-command))
                                            (lsp-package-path 'yaml-language-server))
                                       ,@(cl-rest lsp-yaml-server-command))))
                  :major-modes '(yaml-mode
                                 gitlab-ci-mode)
                  :priority 0
                  :server-id 'yamlls
                  :initialized-fn (lambda (workspace)
                                    (with-lsp-workspace workspace
                                      (lsp--set-configuration
                                       (lsp-configuration-section "yaml"))))
                  :download-server-fn (lambda (_client callback error-callback _update?)
                                        (lsp-package-ensure 'yaml-language-server
                                                            callback error-callback))))



(defun lsp--create-default-error-handler-around-advice (proc &rest args)
  (lambda (e) nil)
  ;; (let ((res (apply proc args)))
  ;;   res)
  )
(advice-add 'lsp--create-default-error-handler :around #'lsp--create-default-error-handler-around-advice)


(defun lsp--error-string-around-advice (proc &rest args)
  nil
  ;; (let ((res (apply proc args)))
  ;;   (if res
  ;;       (progn
  ;;         ;; (message res)
  ;;         "error"))
  ;;   ;; res
  ;;   )
  )
(advice-add 'lsp--error-string :around #'lsp--error-string-around-advice)


(defun lsp-around-advice (proc &rest args)
  (if (myrc-test "lsp" ;; my-disable-lsp
                 )
      (let ((res (apply proc args)))
        res)))
(advice-add 'lsp :around #'lsp-around-advice)

(defun lsp-lens-refresh-around-advice (proc &rest args)
  (if (myrc-test "lsp_lens")
      (let ((res (apply proc args)))
        res)))
(advice-add 'lsp-lens-refresh :around #'lsp-lens-refresh-around-advice)


(define-key lsp-browser-mode-map (kbd "TAB") 'widget-forward)
(define-key lsp-browser-mode-map (kbd "<backtab>") 'widget-backward)
(define-key tree-widget-button-keymap (kbd "SPC") 'widget-button-press)
(define-key lsp-browser-mode-map (kbd "SPC") 'widget-button-press)


;; (-union '("a" "b") '("a"))
(defun ensure-language-servers-installed ()
  (interactive)
  (let* ((ensure-these '("pursls"
                         "jdtls"))
         (servers-not-installed (lsp-list-servers))
         (install-these (-intersection ensure-these servers-not-installed)))
    (dolist (s install-these)
      (lsp-install-server-by-name s))))


(ensure-language-servers-installed)


(provide 'my-lsp)