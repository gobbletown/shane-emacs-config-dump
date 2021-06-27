(require 'intero)
(require 'memoize)

(setq intero-stack-executable "/home/shane/scripts/stack")

;; (setq intero-stack-executable "stack")
;; (setq intero-extra-ghc-options (list "--color" "never"))
(setq intero-extra-ghc-options nil)

;; (defun intero-make-options-list (with-ghc targets no-build no-load ignore-dot-ghci stack-yaml)
;;   "Make the stack ghci options list.
;; TARGETS are the build targets.  When non-nil, NO-BUILD and
;; NO-LOAD enable the correspondingly-named stack options.  When
;; IGNORE-DOT-GHCI is non-nil, it enables the corresponding GHCI
;; option.  STACK-YAML is the stack config file to use (or stack's
;; default when nil)."
;;   (append (when stack-yaml
;;             (list "--stack-yaml" stack-yaml))
;;           (list "--color" "never")
;;           (list "--with-ghc"
;;                 with-ghc
;;                 "--docker-run-args=--interactive=true --tty=false")
;;           (when no-build
;;             (list "--no-build"))
;;           (when no-load
;;             (list "--no-load"))
;;           (when ignore-dot-ghci
;;             (list "--ghci-options" "-ignore-dot-ghci"))
;;           (cl-mapcan (lambda (x) (list "--ghci-options" x)) intero-extra-ghc-options)
;;           targets))


;; (defun intero-repl-mode-start (backend-buffer targets prompt-options stack-yaml)
;;   "Start the process for the repl in the current buffer.
;; BACKEND-BUFFER is used for options.  TARGETS is the targets to
;; load.  If PROMPT-OPTIONS is non-nil, prompt with an options list.
;; STACK-YAML is the stack yaml config to use.  When nil, tries to
;; use project-wide intero-stack-yaml when nil, otherwise uses
;; stack's default)."
;;   (setq intero-targets targets)
;;   (setq intero-repl-last-loaded nil)
;;   (when stack-yaml
;;     (setq intero-stack-yaml stack-yaml))
;;   (when prompt-options
;;     (intero-repl-options backend-buffer))
;;   (let ((stack-yaml (if stack-yaml
;;                         stack-yaml
;;                       (buffer-local-value 'intero-stack-yaml backend-buffer)))
;;         (arguments (intero-make-options-list
;;                     "ghci"
;;                     (or targets
;;                         (let ((package-name (buffer-local-value 'intero-package-name
;;                                                                 backend-buffer)))
;;                           (unless (equal "" package-name)
;;                             (list package-name))))
;;                     (buffer-local-value 'intero-repl-no-build backend-buffer)
;;                     (buffer-local-value 'intero-repl-no-load backend-buffer)
;;                     nil
;;                     stack-yaml)))
;;     (insert (propertize
;;              (format "Starting:\n  %s ghci %s\n" intero-stack-executable
;;                      (combine-and-quote-strings arguments))
;;              'face 'font-lock-comment-face))
;;     (let* ((script-buffer
;;             (with-current-buffer (find-file-noselect (intero-make-temp-file "intero-script"))
;;               ;; Commented out this line due to this bug:
;;               ;; https://github.com/chrisdone/intero/issues/569
;;               ;; GHC 8.4.3 has some bug causing a panic on GHCi.
;;               ;; :set -fdefer-type-errors
;;               (insert ":set prompt \"\"
;; :set -fbyte-code
;; :set -fdiagnostics-color=never
;; :set prompt \"\\4 \"
;; ")
;;               (basic-save-buffer)
;;               (current-buffer)))
;;            (script
;;             (with-current-buffer script-buffer
;;               (intero-localize-path (intero-buffer-file-name)))))
;;       (let ((process
;;              (get-buffer-process
;;               (apply #'make-comint-in-buffer "intero" (current-buffer) intero-stack-executable nil "--color never" "ghci"
;;                      (append arguments
;;                              (list "--verbosity" "silent")
;;                              (list "--ghci-options"
;;                                    (concat "-ghci-script=" script))
;;                              (cl-mapcan (lambda (x) (list "--ghci-options" x)) intero-extra-ghci-options))))))
;;         (when (process-live-p process)
;;           (set-process-query-on-exit-flag process nil)
;;           (message "Started Intero process for REPL.")
;;           (kill-buffer script-buffer))))))

;; intero isn't always slow
;; (memoize 'intero-async-network-call)
;; (memoize-restore 'intero-async-network-call)

(define-key intero-mode-map (kbd "M-?") nil)

(provide 'my-intero)