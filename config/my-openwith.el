(require 'openwith)

(setq openwith-associations '(;; ("\\.pdf\\'" "z" (file))
                              ("\\.mp4\\'" "sps win vp" (file))
                              ("\\.webm\\'" "sps win vp" (file))
                              ;; ("\\.png\\'" "feh" (file))
                              ;; ("\\.png\\'" "win ie" (file))

                              ;; Reinstated
                              ;; This was good, but I want to do it in term
                              ;; v +/";; This is cool, but term just isnt able to render images well" "$EMACSD/config/my-pdfs.el"
                              ("\\.png\\'" "sps win ie" (file))
                              ;; ("\\.gif\\'" "eog" (file))
                              ("\\.gif\\'" "sps open-gif" (file))
                              ("\\.jpe?g\\'" "sps win ie" (file))
                              ("\\.mp3\\'" "win music" (file))
                              ("\\.m4a\\'" "win music" (file))))

;; (defun openwith-file-handler (operation &rest args)
;;   "Open file with external program, if an association is configured."
;;   (when (and openwith-mode (not (buffer-modified-p)) (zerop (buffer-size)))
;;     (let ((assocs openwith-associations)
;;           (file (car args))
;;           oa)
;;       ;; (message (concat "FILE: "(car args)))
;;       ;; do not use `dolist' here, since some packages (like cl)
;;       ;; temporarily unbind it
;;       (while assocs
;;         (setq oa (car assocs)
;;               assocs (cdr assocs))
;;         (when (save-match-data (string-match (car oa) file))
;;           (let ((params (mapcar (lambda (x) (if (eq x 'file) file x))
;;                                 (nth 2 oa))))
;;             (when (or (not openwith-confirm-invocation)
;;                       (y-or-n-p (format "%s %s? " (cadr oa)
;;                                         (mapconcat #'identity params " "))))
;;               (if (eq system-type 'windows-nt)
;;                   (openwith-open-windows file)
;;                 (openwith-open-unix (cadr oa) params))
;;               (kill-buffer nil)
;;               (when (featurep 'recentf)
;;                 (recentf-add-file file))
;;               ;; inhibit further actions
;;               (error "Opened %s in external program"
;;                      (file-name-nondirectory file))))))))
;;   ;; when no association was found, relay the operation to other handlers
;;   (let ((inhibit-file-name-handlers
;;          (cons 'openwith-file-handler
;;                (and (eq inhibit-file-name-operation operation)
;;                     inhibit-file-name-handlers)))
;;         (inhibit-file-name-operation operation))
;;     (apply operation args)))

;; (remove-from-list 'openwith-associations '("\\.pdf\\'" "z" (file)))

(openwith-mode t)

;; nadvice - proc is the original function, passed in. do not modify
(defun openwith-mode-around-advice (proc &rest args)
  (let ((res (apply proc args)))
    res))
(advice-add 'openwith-mode :around #'openwith-mode-around-advice)


;; This is the handler alist
;; file-name-handler-alist
;; I still haven't learned how to make handler functions

;; (defun png-file-run-real-handler (operation &rest args)
;;   (message (concat "operation: " (str operation) " args: " (list2str args))))

;; (defun png-file-run-real-handler (operation &rest args)
;;   (message (concat "operation: " (str operation) " args: " (list2str args)))
;;   (if (eq 'load operation)
;;       nil
;;     nil
;;     ;; (apply 'openwith-file-handler (cons operation args))
;;     )
;;   (apply operation args))

;; (defun png-file-run-real-handler (operation &rest args)
;;   (message (concat "operation: " (str operation) " args: " (list2str args))))

;; (add-to-list 'file-name-handler-alist '("\\(\\.png\\)\\'" . png-file-run-real-handler))
;; (remove-from-list 'file-name-handler-alist '("\\(\\.png\\)\\'" . png-file-run-real-handler))
;; (add-to-list 'file-name-handler-alist '("\\(\\.png\\)\\'" . openwith-file-handler))
;; (remove-from-list 'file-name-handler-alist '("\\(\\.png\\)\\'" . openwith-file-handler))


;; This works with = find-file-at-point =

;; sp +/"(defun browse-url-default-browser (url &rest args)" "$HOME/local/emacs26/share/emacs/26.2/lisp/net/browse-url.el.gz"

(provide 'my-openwith)