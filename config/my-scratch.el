(require 'cl)

(defun count-unique-windows-in-frame ()
  (length (cl-delete-duplicates (mapcar #'window-buffer (window-list)))))



;; The "*scratch*" buffer must never be killed or emacsclient can't open
;; (add-hook 'kill-buffer-query-functions
;;           (lambda() (not (equal (buffer-name) "*scratch*"))))
;; (remove-hook 'kill-buffer-query-functions
;;           (lambda() (not (equal (buffer-name) "*scratch*"))))

(add-hook 'kill-buffer-query-functions #'my/dont-kill-scratch)
(defun my/dont-kill-scratch ()
  (if (not (equal (buffer-name) "*scratch*"))
      t
    (message "Not allowed to kill %s, burying instead" (buffer-name))
    (bury-buffer)
    nil))

;; (switch-to-buffer "*scratch*")

(defun create-scratch-buffer ()
  "create a scratch buffer"
  (interactive)
  (switch-to-buffer (get-buffer-create "*scratch*"))
  (lisp-interaction-mode))

(create-scratch-buffer)

;; If the *scratch* buffer is killed, recreate it automatically
;; FROM: Morten Welind
;;http://www.geocrawler.com/archives/3/338/1994/6/0/1877802/
(save-excursion
  (set-buffer (get-buffer-create "*scratch*"))
  (lisp-interaction-mode)
  (make-local-variable 'kill-buffer-query-functions)
  (add-hook 'kill-buffer-query-functions 'kill-scratch-buffer))

(defun kill-scratch-buffer ()
  ;; The next line is just in case someone calls this manually
  (set-buffer (get-buffer-create "*scratch*"))
  ;; Kill the current (*scratch*) buffer
  (remove-hook 'kill-buffer-query-functions 'kill-scratch-buffer)
  (kill-buffer (current-buffer))
  ;; Make a brand new *scratch* buffer
  (set-buffer (get-buffer-create "*scratch*"))
  (lisp-interaction-mode)
  (make-local-variable 'kill-buffer-query-functions)
  (add-hook 'kill-buffer-query-functions 'kill-scratch-buffer)
  ;; Since we killed it, don't let caller do that.
  nil)


;; (add-hook 'post-command-hook 'scratch-background)
;; (remove-hook 'post-command-hook 'scratch-background)
;; (add-hook 'change-major-mode-hook 'scratch-background)
;; (remove-hook 'change-major-mode-hook 'scratch-background)

;; (add-hook 'window-configuration-change-hook 'scratch-background)
(remove-hook 'window-configuration-change-hook 'scratch-background)
(defun scratch-background ()
  ;; This actually breaks <f11>
  ;; It's more trouble than it's worth and also really slows down emacs'

  ;; (cond
  ;;  ((and
  ;;    ;; (eq major-mode 'text-mode)
  ;;    (string-equal "*scratch*" (buffer-name)))
  ;;   (set-background-color "#222222"))
  ;;   (t
  ;;    (set-background-color "#151515")))
  )

(provide 'my-scratch)