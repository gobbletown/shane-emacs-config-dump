(require 'clojure-mode)
(require 'cider)
(require 'ob-clojure)

(require 'clomacs)

;; This is broken for spacemacs
(my/with 'cider
         ;; Fixes super annoying message
         (setq cider-allow-jack-in-without-project t))

;; Need this to run babel sh blocks

(defun my/4clojure-check-and-proceed ()
  "Check the answer and show the next question if it worked."
  (interactive)
  (let ((result (4clojure-check-answers)))
    (unless (string-match "failed." result)
       (4clojure-next-question))))

;; (define-key clojure-mode-map (kbd "C-c C-c") 'my/4clojure-check-and-proceed)
(define-key clojure-mode-map (kbd "C-c C-c") nil)

(define-key cider-mode-map (kbd "C-c 4") 'my/4clojure-check-and-proceed)

;; This binding should be used to run the entire script, if anything (like the playground)
;;(define-key cider-hydra-map (kbd "C-c C-c") nil)
(define-key cider-mode-map (kbd "C-c C-c") nil)


(require 'monroe)
(add-hook 'clojure-mode-hook 'clojure-enable-monroe)

(define-key monroe-interaction-mode-map (kbd "M-.") nil)
(define-key cider-mode-map (kbd "M-.") nil)

(defun my-cider-macroexpand-1 ()
  (interactive)
  (save-excursion
    (special-lispy-different)
    (cider-macroexpand-1)
    (special-lispy-different)))

;; Like my-elisp-expand-macro-or-copy
(defun my-cider-macroexpand-1-or-copy ()
  (interactive)
  (if (selected-p)
      (my/copy)
    (call-interactively 'my-cider-macroexpand-1)))

(define-key clojure-mode-map (kbd "M-w") #'my-cider-macroexpand-1-or-copy)



(defmacro my-cider-eval-return-handler (&rest code)
  "Make a handler for the result."
  `(nrepl-make-response-handler (or buffer (current-buffer))
                                (lambda (buffer value)
                                  (with-current-buffer buffer
                                    (insert
                                     (if (derived-mode-p 'cider-clojure-interaction-mode)
                                         (format "\n%s\n" value)
                                       value))))
                                (lambda (_buffer out)
                                  (cider-emit-interactive-eval-output out))
                                (lambda (_buffer err)
                                  (cider-emit-interactive-eval-err-output err))
                                '()))


(defun my-cider-eval-last-sexp ()
  "Evaluate the expression preceding point.
If invoked with OUTPUT-TO-CURRENT-BUFFER, print the result in the current
buffer."
  (interactive)
  (cider-interactive-eval nil
                          (cider-eval-print-handler)
                          (cider-last-sexp 'bounds)
                          (cider--nrepl-pr-request-map)))


(defun clojure-select-copy-dependency ()
  (interactive)
  (my/copy (fz (snc "cd $NOTES; oci clojure-list-deps"))))


;; idiomize this
(defun clojure-find-deps (use-google &rest query)
  (interactive (list (or
                      (>= (prefix-numeric-value current-prefix-arg) 4)
                      (yn "Use google?"))
                     (read-string-hist "clojure-find-deps query: ")))

  (if (>= (prefix-numeric-value current-prefix-arg) 4)
      (setq use-google t))

  ;; (tv query)
  (my/copy (fz (snc (apply 'cmd "clojure-find-deps"
                           (if use-google
                               "-gl")
                           (-flatten (mapcar (lambda (e) (s-split " " e)) query)))))))



(require 'clj-refactor)

(defun my-clojure-mode-hook ()
  (clj-refactor-mode 1)
  (yas-minor-mode 1)
  ;; for adding require/use/import statements
  (define-key clojure-mode-map (kbd "H-*") nil)
  ;; This choice of keybinding leaves cider-macroexpand-1 unbound
  (cljr-add-keybindings-with-prefix "H-*"))

(add-hook 'clojure-mode-hook #'my-clojure-mode-hook)

;; This only prevents the buffer from being selected (which was SUPER annoying)
;; What about preventing it from being shown altogether?
;; It's appearing even when I switch terminals and are not working in clojure
(setq cider-auto-select-error-buffer nil)
;; This was supremely annoying until I found the option to turn it off
;; (setq cider-show-error-buffer 'only-in-repl)
(setq cider-show-error-buffer nil)

(defvar my-do-cider-auto-jack-in t)

(defun cider-auto-jack-in ()
  (interactive)

  ;; Make sure to be more precise. jack in with cljs too if it should
  ;; j:cider-jack-in-clj
  ;; j:cider-jack-in-cljs
  ;; j:cider-jack-in-clj&cljs

  (if (and
       (major-mode-p 'clojure-mode)
       (not (major-mode-p 'clojerl-mode)))
      (progn
        ;; (ns "running timer")
        (run-with-idle-timer 3 nil
                             (lm
                              (try
                               (if ;; my-do-cider-auto-jack-in
                                   (myrc-test "cider")
                                   (progn
                                     ;; (message "Jacking in")
                                     (with-current-buffer (current-buffer)
                                       (cond
                                        ((major-mode-p 'clojure-mode)
                                         (auto-no
                                          ;; (call-interactively
                                          ;;  'cider-jack-in)
                                          (cider-jack-in nil)))
                                        ((major-mode-p 'clojurescript-mode)
                                         (auto-no
                                          ;; (call-interactively
                                          ;;  'cider-jack-in)
                                          (cider-jack-in-cljs nil)))))
                                     ;; (message "Jacked in?")
                                     )))))

        (enable-helm-cider-mode)))
  ;; (try
  ;;  (if ;; my-do-cider-auto-jack-in
  ;;      (myrc-test "cider")
  ;;      (progn
  ;;        (auto-no
  ;;         (call-interactively
  ;;          'cider-jack-in))
  ;;        (message "Jacked in?"))))

  t)

;; This may be breaking the clojure hook when it's disabled for some reason, so I put it last
;; It's still making it so it fails to open the clojure file on first attempt
;; I have to hook it somewhere else. After the file is fully opened

(require 'helm-cider)
(defun enable-helm-cider-mode ()
  (interactive)
  (helm-cider-mode 1))

(add-hook-last 'clojure-mode-hook 'cider-auto-jack-in)
;; (add-hook-last 'clojure-mode-hook 'enable-helm-cider-mode)
;; (remove-hook 'clojure-mode-hook 'enable-helm-cider-mode)
(add-hook-last 'clojurescript-mode-hook 'cider-auto-jack-in)
;; (remove-hook 'clojure-mode-hook 'cider-auto-jack-in)

(defun cider--check-existing-session (params)
  "Ask for confirmation if a session with similar PARAMS already exists.
If no session exists or user chose to proceed, return PARAMS.  If the user
canceled the action, signal quit."
  (let* ((proj-dir (plist-get params :project-dir))
         (host (plist-get params :host))
         ;; (port (plist-get params :port))
         (session (seq-find (lambda (ses)
                              (let ((ses-params (cider--gather-session-params ses)))
                                (and (equal proj-dir (plist-get ses-params :project-dir))
                                     ;; (or (null port)
                                     ;;     (equal port (plist-get ses-params :port)))
                                     (or (null host)
                                         (equal host (plist-get ses-params :host))))))
                            (sesman-current-sessions 'CIDER '(project)))))
    (when session
      (unless (y-or-n-p
               (concat
                "A CIDER session with the same connection parameters already exists (" (car session) ").  "
                "Are you sure you want to create a new session instead of using `cider-connect-sibling-clj(s)'?  "))
        (let ((debug-on-quit nil))
          (signal 'quit nil)))))
  params)


(defun cider-switch-to-errors ()
  (interactive)
  (if (buffer-exists "*cider-error*")
      (switch-to-buffer "*cider-error*")
    (message "*cider-error* doesn't exist")))

(defun my-clojure-switch-to-errors ()
  (interactive)
  (if (and
       (>= (prefix-numeric-value current-prefix-arg) 4)
       (buffer-exists "*cider-error*"))
      (call-interactively 'flycheck-list-errors)
    (call-interactively 'cider-switch-to-errors)))

(defun my-clojure-lein-run ()
  (interactive)
  (sps (concat "cd " (q (my/pwd)) "; " "is-git && cd \"$(vc get-top-level)\"; nvc -E 'lein run; pak'")))

(require 'my-net)

;; Remember, the nrepl port is also recorded 
;; $MYGIT/gigasquid/libpython-clj-examples/.nrepl-port

(defun cider-jack-in-params (project-type)
  "Determine the commands params for `cider-jack-in' for the PROJECT-TYPE."
  ;; The format of these command-line strings must consider different shells,
  ;; different values of IFS, and the possibility that they'll be run remotely
  ;; (e.g. with TRAMP). Using `", "` causes problems with TRAMP, for example.
  ;; Please be careful when changing them.
  ;; (tv project-type)
  (pcase project-type
    ('lein        (concat cider-lein-parameters " :port " (n-get-free-port "40500" "40800")))
    ('boot        cider-boot-parameters)
    ('clojure-cli nil)
    ('shadow-cljs cider-shadow-cljs-parameters)
    ('gradle      cider-gradle-parameters)
    (_            (user-error "Unsupported project type `%S'" project-type))))

;; This allows me to remote connect
;; I should probably make it select a random port
(setq cider-lein-parameters "repl :headless :host localhost")


;; TODO cd to where the =project.clj= file is
(defun cider-jack-in-around-advice (proc &rest args)
  (never
   (let ((res (apply proc args)))
     res))
  (let ((gdir (sor
               (locate-dominating-file default-directory ".git")
               (projectile-acquire-root)))
        (pdir (locate-dominating-file default-directory "project.clj")))
    (save-window-excursion
      (let ((b (switch-to-buffer "*cd-project-clj*")))
        (ignore-errors
          (with-current-buffer b
            (cond
             ((string-equal gdir pdir)
              (progn
                (message (concat "starting cider in " gdir))
                (insert (concat "starting cider in " gdir))
                (insert "\n")
                (cd gdir)))
             ((sor pdir)
              (progn
                (message (concat "starting cider in " pdir))
                (insert (concat "starting cider in " pdir))
                (insert "\n")
                (cd pdir))))
            (let ((res (apply proc args)))
              (bury-buffer b)
              res)))))))
(advice-add 'cider-restart :around #'cider-jack-in-around-advice)
(advice-add 'cider-jack-in :around #'cider-jack-in-around-advice)
;; (advice-remove 'cider-jack-in #'cider-jack-in-around-advice)
(advice-add 'cider-jack-in-clj :around #'cider-jack-in-around-advice)
(advice-add 'cider-jack-in-cljs :around #'cider-jack-in-around-advice)


(define-key cider-repl-mode-map (kbd "C-c h f") 'my/cider-docfun)

(defun my/cider-docfun (symbol-string)
  (interactive (list (let ((s (symbol-at-point)))
                       (if s
                           (s-replace-regexp "^[a-z]+/" "" (sym2str s))
                         ""))))
  ;; special-form
  ;; macro
  ;; function

  (let* ((cs (cider-complete ""))
         (prompt
          (cond
           ((>= (prefix-numeric-value current-prefix-arg) (expt 4 4))
            "function: ")
           ((>= (prefix-numeric-value current-prefix-arg) (expt 4 3))
            "special form: ")
           ((>= (prefix-numeric-value current-prefix-arg) (expt 4 2))
            "macro: ")
           (t
            "func/macro/special: ")))

         ;; (type (get-text-property 0 'type csa))
         )
    ;; (tv (str cs))
    ;; (tv symtype)
    (if (= (prefix-numeric-value current-prefix-arg) 4)
        (call-interactively 'helpful-function)
      (let ((r (fz
                (-filter
                 (cond
                  ((>= (prefix-numeric-value current-prefix-arg) (expt 4 4))
                   (lambda (e)
                     (string-equal "function" (get-text-property 0 'type e))))
                  ((>= (prefix-numeric-value current-prefix-arg) (expt 4 3))
                   (lambda (e)
                     (string-equal "special-form" (get-text-property 0 'type e))))
                  ((>= (prefix-numeric-value current-prefix-arg) (expt 4 2))
                   (lambda (e)
                     (string-equal "macro" (get-text-property 0 'type e))))
                  (t
                   (lambda (e)
                     (or (string-equal "function" (get-text-property 0 'type e))
                         (string-equal "macro" (get-text-property 0 'type e))
                         (string-equal "special-form" (get-text-property 0 'type e))))))

                 cs)
                symbol-string
                nil
                prompt)))
        ;; (tv (type r))
        (if (sor r)
            (try (cider-doc-lookup r)
                 (egr (cmd "clojure" symbol-string))
                 ;; (message "not resolved")
                 )))))
  ;; (mapcar (lambda (e)) (cider-company-unfiltered-candidates ""))
  ;; (tv (cider-company-unfiltered-candidates ""))
  )




;; Annoyingly, I actually sometimes want this to be nil
;; Because often deps.edn is not kept up-to-date with project.clj
(setq cider-preferred-build-tool "lein")
;; (setq cider-preferred-build-tool nil)



(defun cljr--insert-into-leiningen-dependencies (artifact version)
  (try
   (progn
     (re-search-forward ":dependencies")
     (paredit-forward)
     (paredit-backward-down)
     (newline-and-indent)
     (insert "[" artifact " \"" version "\"]"))
   (progn
     (re-search-forward "^ *:")
     (backward-char)
     (newline)
     (backward-char)
     (insert ":dependencies []")
     (paredit-backward-down)
     (insert "[" artifact " \"" version "\"]"))))

(defun my-clojure-project-file ()
  (interactive)
  (let ((pfp (cljr--project-file)))
    (if (interactive-p)
        (e pfp)
      pfp)))


(define-key cider-mode-map (kbd "C-c C-o") nil)


(define-key cider-mode-map (kbd "C-M-i") nil)

(defun my-cider-backwards-search ()
  (interactive)
  (if (>= (prefix-numeric-value current-prefix-arg) 4)
      (call-interactively 'cider-repl-previous-matching-input)
    (call-interactively 'isearch-backward)))

;; cider-repl-previous-matching-input
(define-key cider-repl-mode-map (kbd "M-r") nil)
(define-key cider-repl-mode-map (kbd "C-r") 'my-cider-backwards-search)

;; (define-key map (kbd "M-r") #'cider-repl-previous-matching-input)

;; Clomacs isn't a very close interop, but it works fairly wellish
;; RPC over an http server

(setq clomacs-httpd-default-port 8680)

;; Ensure first that this runs without errors. I can't put it in emacs startup until I am sure of this
;; (clomacs-httpd-start)

(defun my-clomacs-connect ()
  (interactive)
  (message "connect to clomacs"))

(provide 'my-clojure)