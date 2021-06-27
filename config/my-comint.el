(defun comint-clear-buffer ()
  (interactive)
  (let ((comint-buffer-maximum-size 0))
    (comint-truncate-buffer)))

;; let's bind the new command to a keycombo
;; (define-key comint-mode-map "\C-c\M-o" #'comint-clear-buffer)


(defun comint-copy-output ()
  (interactive)
  (cond ((major-mode-p 'eshell-mode) (progn

                                       (ekm "M->")
                                       (eshell-mark-output)
                                       (ekm "M-w")
                                       (my/nil (ns (xc)))
                                       (ekm "M->")))
        (t (message "Not sure how to copy output for this mode."))))


(define-key comint-mode-map (kbd "C-x C-l") #'comint-copy-output)


;; Annoyingly, eshell-mode-map is a local variable
;; I need to add it to a hook
(add-hook 'eshell-mode-hook
          (lambda () (define-key eshell-mode-map (kbd "C-x C-l") #'comint-copy-output)))

;; ; example
;; (make-comint "x" "/bin/bash" nil "-c" "zsh")


;; Remember that an environment variable is set INSIDE_EMACS, which contains the string "comint"
;; This is default behaviour and very helpful
;; j:comint-exec-1


(defun comint-quick (cmd &optional dir)
  (interactive (list (read-string-hist "comint-quick: ")))
  (let* ((slug (slugify cmd))
         (buf (make-comint slug (nsfa cmd dir))))
    (with-current-buffer buf
      (switch-to-buffer buf)
      (turn-on-comint-history (concat "/home/shane/notes/programs/comint/history/" slug)))))



(require 'exec-path-from-shell)

;; comint persistent history
;; https://emacs.stackexchange.com/questions/9925/persistent-shell-command-history

(exec-path-from-shell-initialize)
(exec-path-from-shell-copy-env "HISTFILE")

;; Then you need to call (turn-on-comint-history) in your appropriate mode hooks, i.e.

(defun turn-on-comint-history (history-file)
  (setq comint-input-ring-file-name history-file)
  (comint-read-input-ring 'silent))

(add-hook 'shell-mode-hook
          (lambda ()
            (turn-on-comint-history (getenv "HISTFILE"))))

(add-hook 'inf-ruby-mode-hook
          (lambda ()
            (turn-on-comint-history ".pry_history")))



(add-hook 'kill-buffer-hook #'comint-write-input-ring)
(add-hook 'kill-emacs-hook
          (lambda ()
            (--each (buffer-list)
              (with-current-buffer it (comint-write-input-ring)))))



(define-key comint-mode-map (kbd "C-j") 'comint-accumulate)


(provide 'my-comint)