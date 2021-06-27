(defun emacspeak-wizards-execute-asynchronously (key)
  "Read key-sequence, then execute its command on a new thread."
  (interactive (list (read-key-sequence "Key Sequence: ")))
  (let ((l  (local-key-binding key))
        (g (global-key-binding key)))
    (cond
     ( (commandp l)
       (make-thread l)
       (message "Running %s on a new thread." l))
     ((commandp g)
      (make-thread g)
      (message "Running %s on a new thread." g))
     (t (error "%s is not bound to a command." key)))))


;; (global-set-key (kbd "C-' a") 'emacspeak-wizards-execute-asynchronously)

(provide 'my-threading)
