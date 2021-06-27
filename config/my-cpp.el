;; This is one thing that could be a factor in autocomplete not working

;; (require 'company-rtags)
;; (setq company-backends '(company-rtags))
;; (company-mode)
;; (rtags-diagnostics)

;; http://cestlaz.github.io/posts/using-emacs-32-cpp/


;; (require 'cmake-ide)
(require 'rtags) ;; optional, must have rtags installed
(cmake-ide-setup)


(define-key c++-mode-map (kbd "TAB") nil)


;; exordium took this
;; (define-key c++-mode-map (kbd "M-.") nil)
;; But prog-mode would be erased by erasing this too
;; The easiest way to fix this is to probably just redefine here
(define-key c++-mode-map (kbd "M-.") 'handle-godef)


;; from exordium maybe
(defun rtags-go-def (other-window)
  (interactive P)
  (let ((rtags-after-find-file-hook rtags-after-find-file-hook))
    (add-hook
     (quote
      rtags-after-find-file-hook)
     (function
      (lambda nil (recenter))))
    (rtags-find-symbol-at-point
     other-window)))


(df my-cpp-mode-hook-body
    ;; (setq company-backends '(company-lsp))

    ;; Use this to debug c++-mode
    )

(add-hook 'c++-mode-hook #'my-cpp-mode-hook-body)
;; (remove-hook 'c++-mode-hook #'my-cpp-mode-hook-body)

;; (defun company-lsp--on-completion (response prefix)
;;   "Handle completion RESPONSE.

;; PREFIX is a string of the prefix when the completion is requested.

;; Return a list of strings as the completion candidates."
;;   (let* ((incomplete (and (hash-table-p response) (gethash "isIncomplete" response)))
;;          (items (cond ((hash-table-p response) (gethash "items" response))
;;                       ((sequencep response) response)))
;;          (candidates (mapcar (lambda (item)
;;                                (company-lsp--make-candidate item prefix))
;;                              (lsp--sort-completions items)))
;;          (server-id (lsp--client-server-id (lsp--workspace-client lsp--cur-workspace)))
;;          (should-filter (or (eq company-lsp-cache-candidates t)
;;                             (and (null company-lsp-cache-candidates)
;;                                  (company-lsp--get-config company-lsp-filter-candidates server-id)))))
;;     (when (null company-lsp--completion-cache)
;;       (add-hook 'company-completion-cancelled-hook #'company-lsp--cleanup-cache nil t)
;;       (add-hook 'company-completion-finished-hook #'company-lsp--cleanup-cache nil t))
;;     (when (eq company-lsp-cache-candidates 'auto)
;;       ;; Only cache candidates on auto mode. If it's t company caches the
;;       ;; candidates for us.
;;       (company-lsp--cache-put prefix (company-lsp--cache-item-new candidates incomplete)))
;;     (if should-filter
;;         (company-lsp--filter-candidates candidates prefix)
;;       (progn
;;         ;; (tvipe (list2str candidates))
;;         ;; (mapcar (lambda (s) (replace-regexp-in-string "^\s\+" s) candidates))
;;         candidates))))

;; (defun company-lsp (command &optional arg &rest _)
;;   "Define a company backend for lsp-mode.

;; See the documentation of `company-backends' for COMMAND and ARG."
;;   (interactive (list 'interactive))
;;   (cl-case command
;;     (interactive (company-begin-backend #'company-lsp))
;;     (prefix (and
;;              (bound-and-true-p lsp-mode)
;;              (lsp--capability "completionProvider")
;;              (not (company-in-string-or-comment))
;;              (or (company-lsp--completion-prefix) 'stop)))
;;     (candidates
;;      ;; If the completion items in the response have textEdit action populated,
;;      ;; we'll apply them in `company-lsp--post-completion'. However, textEdit
;;      ;; actions only apply to the pre-completion content. We backup the current
;;      ;; prefix and restore it after company completion is done, so the content
;;      ;; is restored and textEdit actions can be applied.
;;      (or (company-lsp--cache-item-candidates (company-lsp--cache-get arg))
;;          (and company-lsp-async
;;               (cons :async (lambda (callback)
;;                              (company-lsp--candidates-async arg callback))))
;;          (company-lsp--candidates-sync arg)))
;;     (sorted t)
;;     (no-cache (not (eq company-lsp-cache-candidates t)))
;;     (annotation (lsp--annotate arg))
;;     (quickhelp-string (company-lsp--documentation arg))
;;     (doc-buffer (company-doc-buffer (company-lsp--documentation arg)))
;;     (match (company-lsp--compute-match arg))
;;     (post-completion (company-lsp--post-completion arg))))


(provide 'my-cpp)