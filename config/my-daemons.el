(require 'daemons)
(require 'daemons-sysvinit)
(require 'daemons-systemd)

;; I had to modify this function because shackled didn't work
(defun daemons ()
  "Open the list of system daemons (services) for user management.

This opens a ‘daemons-mode’ list buffer.  Move the cursor to a daemon line and
execute one of the commands in `describe-mode' to show status and manage the
state of the daemon."
  (interactive)
  (when daemons-always-sudo (daemons--sudo))
  (let* ((hostname (daemons--get-user-and-hostname default-directory))
         (list-buffer (get-buffer-create (daemons--get-list-buffer-name hostname))))
    (with-current-buffer list-buffer
      ;; (display-buffer-pop-up-window list-buffer nil)
      ;; (switch-to-buffer-other-window list-buffer)
      (switch-to-buffer list-buffer)
      (daemons-mode)
      (daemons--refresh-list)
      (tabulated-list-print t t))
    (when daemons-list-fill-frame (delete-other-windows))))


;; I had to make a script init-status because apache2 wasn't showing'
;; v init-status
(defun daemons-systemd--list ()
  "Return a list of daemons on a systemd system."
  (thread-last  "init-status"
    (daemons--shell-command-to-string)
    (daemons--split-lines)
    (seq-map 'daemons-systemd--parse-list-item)
    (seq-filter 'daemons-systemd--item-is-simple-service-p)))


(defun daemons-log-at-point (name)
  "Show the log of the daemon NAME at point in the daemons buffer."
  (interactive (list (daemons--daemon-at-point)))
  (daemons--run-with-output-buffer 'log name))


(defun daemons-follow-log-at-point (name)
  "Show the log of the daemon NAME at point in the daemons buffer."
  (interactive (list (daemons--daemon-at-point)))
  ;; (daemons--run-with-output-buffer 'log name)
  ;; (compile (format "journalctl --no-pager -f -u %s | strip-ansi" name))
  (let* ((bn (concat "daemons-log-" name))
         (b (process-buffer
             (start-process-shell-command "log" bn (format "journalctl --no-pager -f -u %s | strip-ansi" name))
             ;; (start-process-shell-command "log" bn "echo hi")))))
             ;; (start-process "log" "log" (format "journalctl --no-pager -f -u %s | strip-ansi" name))
             )))
    (run-with-timer
     0.2
     nil
     (eval
      `(lambda ()
         (save-window-excursion
           (switch-to-buffer ,b)
           (beginning-of-buffer)
           (end-of-buffer))
         (display-buffer ,b 'display-buffer-in-side-window))))
    ;; This doesn't work    ;; (switch-to-buffer b)
    ;; (display-buffer b 'display-buffer-in-side-window)
    ))

(daemons-define-submodule daemons-systemd
  "Daemons submodule for systemd."

  :test (and (eq system-type 'gnu/linux)
             (equal 0 (daemons--shell-command "which systemctl")))
  :commands
  '((status . (lambda (name) (format "systemctl status %s" name)))
    (start . (lambda (name) (format "systemctl start %s" name)))
    (stop . (lambda (name) (format "systemctl stop %s" name)))
    (restart . (lambda (name) (format "systemctl restart %s" name)))
    (reload . (lambda (name) (format "systemctl reload %s" name)))
    (enable . (lambda (name) (format "systemctl enable %s" name)))
    (disable . (lambda (name) (format "systemctl disable %s" name)))
    ;; (log . (lambda (name) (format "journalctl --no-pager -f -u %s" name)))
    (log . (lambda (name) (format "journalctl --no-pager -u %s | strip-ansi" name))))

  :list (daemons-systemd--list)

  :headers [("Daemon (service)" 60 t) ("Enabled" 40 t)])

(defset daemons-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "RET") 'daemons-status-at-point)
    (define-key map (kbd "s") 'daemons-start-at-point)
    (define-key map (kbd "S") 'daemons-stop-at-point)
    (define-key map (kbd "R") 'daemons-restart-at-point)
    (define-key map (kbd "r") 'daemons-reload-at-point)
    (define-key map (kbd "e") 'daemons-enable-at-point)
    (define-key map (kbd "d") 'daemons-disable-at-point)
    (define-key map (kbd "l") 'daemons-log-at-point)
    (define-key map (kbd "f") 'daemons-follow-log-at-point)
    (define-key map (kbd "L") 'daemons-follow-log-at-point)
    map)
  "Keymap for daemons mode.")


;; This is more reliable
;; shell-command-to-string has strange behaviour because of how it manages the basic file descriptors
(setq daemons--shell-command-to-string-fun (lambda (c) (sn (concat c " | strip-ansi"))))
;; init-status will break with shell-command-to-string


;; (setq daemons--shell-command-fun (lambda (c &optional o e) (shell-command (concat c " | strip-ansi") o e)))

;; All this for the sake of being able to strip the ansi reliably
(defun my-shell-command (c &optional o e)
  (cond
   ((or (stringp o)
        (bufferp o))
    (with-current-buffer o
      (insert (sn (concat c " | strip-ansi"))))
    tf_exit_code)
   (o
    ;; (or (stringp o)
    ;;     (bufferp o))
    ;; (message "oh")
    (insert (sn (concat c " | strip-ansi")))
    tf_exit_code)
   (t
    (shell-command c o e))))

(setq daemons--shell-command-fun 'my-shell-command)
(setq daemons--shell-command-fun 'shell-command)

(provide 'my-daemons)