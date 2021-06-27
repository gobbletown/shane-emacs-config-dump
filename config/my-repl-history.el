(require 'ob-shell)

(provide 'my-repl-history)

;; [[https://oleksandrmanzyuk.wordpress.com/2011/10/23/a-persistent-command-history-in-emacs/][A persistent command history in Emacs | Oleksandr Manzyuk's Blog]]

(defun comint-write-history-on-exit (process event)
  (comint-write-input-ring)
  (let ((buf (process-buffer process)))
    (when (buffer-live-p buf)
      (with-current-buffer buf
        (insert (format "\nProcess %s %s" process event))))))

(defun turn-on-comint-history ()
  (let ((process (get-buffer-process (current-buffer))))
    (when process
      (setq comint-input-ring-file-name
            (format "~/.emacs.d/inferior-%s-history"
                    (replace-regexp-in-string "/" "%" (process-name process))
                    ))
      (comint-read-input-ring)
      (set-process-sentinel process
                            #'comint-write-history-on-exit))))

;; (defun turn-on-comint-history ()
;;   (let ((process (get-buffer-process (current-buffer))))
;;     (when process
;;       (setq comint-input-ring-file-name
;;             (format "~/.emacs.d/inferior-%s-history"
;;                     (process-name process)))
;;       (comint-read-input-ring)
;;       (set-process-sentinel process
;;                             #'comint-write-history-on-exit))))

(defun mapc-buffers (fn)
  (mapc (lambda (buffer)
          (with-current-buffer buffer
            (funcall fn)))
        (buffer-list)))

(defun comint-write-input-ring-all-buffers ()
  (mapc-buffers 'comint-write-input-ring))

(add-hook 'kill-emacs-hook 'comint-write-input-ring-all-buffers)

(add-hook 'inferior-haskell-mode-hook 'turn-on-comint-history)
(add-hook 'inferior-python-mode-hook 'turn-on-comint-history)
(add-hook 'inferior-lisp-mode-hook 'turn-on-comint-history)