(require 'command-log-mode)

(setq command-log-mode-window-size 40)

(setq global-command-log-mode nil)

;; (defun clm/open-command-log-buffer (&optional arg)
;;   "Opens (and creates, if non-existant) a buffer used for logging keyboard commands.
;; If ARG is Non-nil, the existing command log buffer is cleared."
;;   (interactive "P")
;;   (with-current-buffer 
;;       (setq clm/command-log-buffer
;;             (get-buffer-create " *command-log*"))
;;     (text-scale-set 1))
;;   (when arg
;;     (with-current-buffer clm/command-log-buffer
;;       (erase-buffer)))
;;   (let ((new-win (split-window-horizontally
;;                   (- 0 command-log-mode-window-size))))
;;     (set-window-buffer new-win clm/command-log-buffer)
;;     (set-window-dedicated-p new-win t)))

(provide 'my-command-log-mode)