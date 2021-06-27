(require 'anaconda-mode)

(defset anaconda-mode-server-command-scriptname "emacs-anaconda-server-command")

;; unbind it
(define-key anaconda-mode-map (kbd "M-r") nil)

(define-key anaconda-mode-map (kbd "M-.") nil)
(define-key anaconda-mode-map (kbd "M-=") nil)

;; anaconda-mode-show-doc
(define-key anaconda-mode-map (kbd "M-?") nil)

;; unbind M-Tab autocomplete
(define-key anaconda-mode-map (kbd "M-C-i") nil)

;; Erase keymap
(erase-keymap 'anaconda-mode-map)

;; Don't call pop-to-buffer. Use display-buffer instead because it doesn't select
(defun anaconda-mode-show-doc-callback (result)
  "Process view doc RESULT."
  (if (> (length result) 0)
      (display-buffer
       (anaconda-mode-documentation-view result))
    (message "No documentation available")))

;; I'm setting markdown-mode here but so far I've only seen Keras as having markdown documentation
;; If I can't stand the incorrect formatting then I can just use regular docs C-u M-9
(defun anaconda-mode-documentation-view (result)
  "Show documentation view for rpc RESULT, and return buffer."
  (let ((buf (get-buffer-create "*Anaconda*")))
    (with-current-buffer buf
      (markdown-mode)
      (view-mode -1)
      (erase-buffer)
      (mapc
       (lambda (it)
         (insert (propertize (aref it 0) 'face 'bold))
         (insert "\n")
         (insert (s-trim-right (aref it 1)))
         (insert "\n\n"))
       result)
      (view-mode 1)
      (goto-char (point-min))
      buf)))

;; See $MYGIT/config/emacs/config/my-anaconda-bak.el

; (defset anaconda-shell-interpreter "conda-ipython")
; python-shell-interpreter


;; I copy the exact function here. If I source from here it breaks
;; I'm overloading the anaconda-mode-bootstrap function here.
;; If I source the function from here, autocompletion does not work. No
;; output appears inside the *anaconda- mode* buffer.


;; ;; This works but because of lexical scope in anaconda-mode.el I have to define it in anaconda-mode.el itself for this to work
;; ;; Therefore, I fixed list-processes instead, here $EMACSD/config/my-list-processes.el
;; (defun anaconda-mode-bootstrap (&optional callback)
;;   "Run `anaconda-mode' server.
;; CALLBACK function will be called when `anaconda-mode-port' will
;; be bound."
;;   (setq anaconda-mode-process
;;         (pythonic-start-process :process anaconda-mode-process-name
;;                                 :buffer (get-buffer-create anaconda-mode-process-buffer)
;;                                 :query-on-exit nil
;;                                 :filter (lambda (process output)
;;                                           (anaconda-mode-bootstrap-filter process output callback))
;;                                 :sentinel (lambda (_process _event))
;;                                 :args `(
;;                                         ;; This did not fix it
;;                                         "/home/shane/scripts/emacs-anaconda-server-command"
;;                                         ,(e/chomp (sh-notty (concat "which " anaconda-mode-server-command-scriptname)))
;;                                         ;; "-c"
;;                                         ;; ,anaconda-mode-server-command
;;                                         ,(anaconda-mode-server-directory)
;;                                         ,(if (pythonic-remote-p)
;;                                              "0.0.0.0"
;;                                            anaconda-mode-localhost-address)
;;                                         ,(or python-shell-virtualenv-root ""))))
;;   (process-put anaconda-mode-process 'interpreter python-shell-interpreter)
;;   (process-put anaconda-mode-process 'virtualenv python-shell-virtualenv-root)
;;   (process-put anaconda-mode-process 'port nil)
;;   (when (pythonic-remote-p)
;;     (process-put anaconda-mode-process 'remote-p t)
;;     (process-put anaconda-mode-process 'remote-method (pythonic-remote-method))
;;     (process-put anaconda-mode-process 'remote-user (pythonic-remote-user))
;;     (process-put anaconda-mode-process 'remote-host (pythonic-remote-host))
;;     (process-put anaconda-mode-process 'remote-port (pythonic-remote-port))))


;; This is here because anaconda-mode-find-references does not error when there is only 1 reference
(defun anaconda-mode-find-references-around-advice (proc &rest args)
  (let* ((init-id (concat (buffer-name) (str (point))))
         (res (apply proc args))
         (post-id (concat (buffer-name) (str (point)))))
    (if (string-equal init-id post-id)
        (error "Havent moved"))
    res))
(advice-add 'anaconda-mode-find-references :around #'anaconda-mode-find-references-around-advice)


(provide 'my-anaconda)