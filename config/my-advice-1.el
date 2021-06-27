(provide 'my-advice-1)

;; Every time I kill a line, say ouch

;; (defadvice kill-line (after say-ouch activate)
;;   (message "ouch"))


;; these prevent emacs asking for permission to kill buffers
(defadvice save-buffers-kill-emacs (around no-y-or-n activate)
  (flet ((yes-or-no-p (&rest args) t)
         (y-or-n-p (&rest args) t))
    ad-do-it))

(defadvice shell-command (around no-y-or-n activate)
  (flet ((yes-or-no-p (&rest args) t)
         (y-or-n-p (&rest args) t))
    ad-do-it))

(defmacro always-yes (&rest body)
  "Instead of asking y or n, always choose y."
  `(flet ((yes-or-no-p (&rest args) t)
          (y-or-n-p (&rest args) t))
     ,@body))

(defmacro always-no (&rest body)
  "Instead of asking y or n, always choose y."
  `(flet ((yes-or-no-p (&rest args) nil)
          (y-or-n-p (&rest args) nil))
     ,@body))

(defadvice kill-buffer-and-window (around no-y-or-n activate)
  (flet ((yes-or-no-p (&rest args) t)
         (y-or-n-p (&rest args) t))
    ad-do-it))


(defun advice-unadvice (sym)
  "Remove all advices from symbol SYM."
  (interactive "aFunction symbol: ")
  (advice-mapc (lambda (advice _props) (advice-remove sym advice)) sym))

;; Remove advice from shell-command
;; (advice-unadvice 'shell-command)



;; This makes the shell-command-function not say anything
;; (defadvice shell-command (around my-shell-command-around activate)
;;   (interactive)
;;   (if (interactive-p)
;;       (shut-up (call-interactively (ad-get-orig-definition 'shell-command)))
;;     (shut-up ad-do-it)))
;; (advice-unadvice 'shell-command)

;; (defadvice shell-command-on-region (around my-shell-command-around activate)
;;   (interactive)
;;   (if (interactive-p)
;;       (shut-up (call-interactively (ad-get-orig-definition 'shell-command-on-region)))
;;     (shut-up ad-do-it)))
;; (advice-unadvice 'shell-command-on-region)


;;(defun my/advice-print-arguments (old-function &rest arguments)
;;  "Print the argument list every time the advised function is called."
;;  ;; (print (sym2str old-function))
;;  ;; (print (sym2str arguments))
;;  (print arguments)
;;  ;; this doesn't work. how to get it to work?
;;  ;; (message (format "run: (%s %S)" old-function arguments))
;;  ;; Send to messages, actually
;;  ;; (print '(old-function arguments))
;;  (apply old-function arguments))
;;
;;(advice-add #'shell-command :around #'my/advice-print-arguments)

(defun invert-prefix-advice (proc &rest args)
  (cond
   ((equal current-prefix-arg (list 4)) (setq current-prefix-arg nil))
   ((not current-prefix-arg) (setq current-prefix-arg (list 4))))
  (let ((res (apply proc args)))
    res))

(advice-add 'counsel-ag :around #'invert-prefix-advice)
;; (advice-remove :around #'counsel-ag-invert-prefix)


;; yn yes-or-no-p advice
(defun yn-around-advice (proc &rest args)
  (sn "play-bottle-pop" nil nil nil t)
  (let ((res (apply proc args)))
    res))
(advice-add 'yn :around #'yn-around-advice)