;; https://emacs.stackexchange.com/questions/32150/how-to-add-a-timestamp-to-each-entry-in-emacs-messages-buffer

(defun last-pressed-key ()
  (edmacro-format-keys (vector last-input-event))
  ;; (key-binding (kbd (edmacro-format-keys (vector last-input-event))))
  )

(defun sh/current-time-microseconds ()
  "Return the current time formatted to include microseconds."
  (let* ((nowtime (current-time))
         (now-ms (nth 2 nowtime)))
    (concat (format-time-string "[%Y-%m-%dT%T" nowtime) (format ".%d]" now-ms))))

(defun sh/ad-timestamp-message (FORMAT-STRING &rest args)
  "Advice to run before `message' that prepends a timestamp to each message.

Activate this advice with:
(advice-add 'message :before 'sh/ad-timestamp-message)"
  (unless (string-equal FORMAT-STRING "%s%s")
    (let ((deactivate-mark nil)
          (inhibit-read-only t))
      (with-current-buffer "*Messages*"
        (save-mark-and-excursion
          (goto-char (point-max))
          (if (not (bolp))
              (newline))
          ;; (ignore-errors (message (concat "LPK: " (last-pressed-key))))
          (insert (sh/current-time-microseconds) " "))))))

(advice-add 'message :before 'sh/ad-timestamp-message)
;; (advice-remove 'message 'sh/ad-timestamp-message)

(provide 'my-messages)