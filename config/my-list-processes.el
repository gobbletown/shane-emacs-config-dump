(defun list-processes--refresh ()
  "Recompute the list of processes for the Process List buffer.
Also, delete any process that is exited or signaled."
  (setq tabulated-list-entries nil)
  (dolist (p (process-list))
    (cond ((memq (process-status p) '(exit signal closed))
	   (delete-process p))
	  ((or (not process-menu-query-only)
	       (process-query-on-exit-flag p))
	   (let* ((buf (process-buffer p))
		  (type (process-type p))
		  (pid  (if (process-id p) (format "%d" (process-id p)) "--"))
		  (name (process-name p))
		  (status (symbol-name (process-status p)))
		  (buf-label (if (buffer-live-p buf)
				 `(,(buffer-name buf)
				   face link
				   help-echo ,(format-message
					       "Visit buffer `%s'"
					       (buffer-name buf))
				   follow-link t
				   process-buffer ,buf
				   action process-menu-visit-buffer)
			       "--"))
		  (tty (or (process-tty-name p) "--"))
		  (thread
                   (cond
                    ((or
                      (null (process-thread p))
                      (not (fboundp 'thread-name))) "--")
                    ((eq (process-thread p) main-thread) "Main")
		    ((thread-name (process-thread p)))
		    (t "--")))
		  (cmd
		   (if (memq type '(network serial))
		       (let ((contact (process-contact p t t)))
			 (if (eq type 'network)
			     (format "(%s %s)"
				     (if (plist-get contact :type)
					 "datagram"
				       "network")
				     (if (plist-get contact :server)
					 (format
                                          "server on %s"
					  (if (plist-get contact :host)
                                              (format "%s:%s"
						      (plist-get contact :host)
                                                      (plist-get
                                                       contact :service))
					    (plist-get contact :local)))
				       (format "connection to %s:%s"
					       (plist-get contact :host)
					       (plist-get contact :service))))
			   (format "(serial port %s%s)"
				   (or (plist-get contact :port) "?")
				   (let ((speed (plist-get contact :speed)))
				     (if speed
					 (format " at %s b/s" speed)
				       "")))))

				       (let* ((fullcmd (mapconcat 'e/q (process-command p) " "))
                (oneliner (replace-regexp-in-string "\n" "\\n" fullcmd t t))
                ;; This works but instead of trimming i want to turn everything into one line
                ;; (fullcmdlen (length fullcmd))
                ;; (shortcmd (substring fullcmd 0 (min fullcmdlen (window-total-width))))
                )
           (concat "{" oneliner "}")
           ;; shortcmd
           )
		     ;; (mapconcat 'identity (process-command p) " ")
		           )))

	     (push (list p (vector name pid status buf-label tty thread cmd))
		         tabulated-list-entries)))))
  (tabulated-list-init-header))

(defun my-process-menu-new-json-buffer ()
  (interactive)
  ;; (json--plist-to-alist (process-plist (tabulated-list-get-id)))
  (let* ((p (tabulated-list-get-id))
         (props (process-plist p)))
    (if (not props)
        (message (concat "No properties for process " (str p)))
      (new-buffer-from-string-detect-lang (sh-notty "jq ." (json-encode-alist (force-alist (json--plist-to-alist props)))))))
  ;; (json-encode-alist (json--plist-to-alist (process-plist (tabulated-list-get-id))))
  ;; (json-encode-plist (process-plist (tabulated-list-get-id)))
  )

;; (define-key process-menu-mode-map (kbd "v"))

(define-key process-menu-mode-map (kbd "M-c") #'my-process-menu-new-json-buffer)

(defun process-list-music ()
  (interactive)
  (call-interactively 'list-processes)
  ;; (ekm "C-e")
  (tablist-push-regexp-filter "Command" "\\(play-song\\|mpv\\)"))
(define-key process-menu-mode-map (kbd "M") 'process-list-music)

(defun my-start-process (cmd)
  (interactive (list (read-string "command:")))
  (let* ((procname (slugify cmd))
         (buf (uniqify-buffer
               (process-buffer
                (start-process
                 procname
                 procname
                 "bash"
                 "-c"
                 cmd)))))
    (with-current-buffer buf
      (switch-to-buffer buf)
      ;; Not sure why this is needed
      ;; (sleep-for 0 50)
      (sleep-for 0 50)
      (beginning-of-buffer)
      buf)))

(provide 'my-list-processes)