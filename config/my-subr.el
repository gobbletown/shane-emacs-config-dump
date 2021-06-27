;; Adding :sentinel #'ignore here did not remove the 'finished' message.
;; (defun start-process (name buffer program &rest program-args)
;;   "Start a program in a subprocess.  Return the process object for it.
;; NAME is name for process.  It is modified if necessary to make it unique.
;; BUFFER is the buffer (or buffer name) to associate with the process.

;; Process output (both standard output and standard error streams)
;; goes at end of BUFFER, unless you specify a filter function to
;; handle the output.  BUFFER may also be nil, meaning that this
;; process is not associated with any buffer.

;; PROGRAM is the program file name.  It is searched for in `exec-path'
;; \(which see).  If nil, just associate a pty with the buffer.  Remaining
;; arguments PROGRAM-ARGS are strings to give program as arguments.

;; If you want to separate standard output from standard error, use
;; `make-process' or invoke the command through a shell and redirect
;; one of them using the shell syntax.

;; The process runs in `default-directory' if that is local (as
;; determined by `unhandled-file-name-directory'), or \"~\"
;; otherwise.  If you want to run a process in a remote directory
;; use `start-file-process'."
;;   (unless (fboundp 'make-process)
;;     (error "Emacs was compiled without subprocess support"))
;;   (apply #'make-process
;;        (append (list :name name :buffer buffer :sentinel #'ignore)
;;                (if program
;;                    (list :command (cons program program-args))))))











;; But it worked here.
;; I have disabled the 'ignore for the sentinel
;; This means the following is no longer needed

;; (defun shell-command (command &optional output-buffer error-buffer)
;;   "Execute string COMMAND in inferior shell; display output, if any."

;;   (interactive
;;    (list
;;     (read-shell-command "Shell command: " nil nil
;; 			                  (let ((filename
;; 			                         (cond
;; 				                        (buffer-file-name)
;; 				                        ((eq major-mode 'dired-mode)
;; 				                         (dired-get-filename nil t)))))
;; 			                    (and filename (file-relative-name filename))))
;;     current-prefix-arg
;;     shell-command-default-error-buffer))
;;   ;; Look for a handler in case default-directory is a remote file name.
;;   (let ((handler
;; 	       (find-file-name-handler (directory-file-name default-directory)
;; 				                         'shell-command)))
;;     (if handler
;; 	      (funcall handler 'shell-command command output-buffer error-buffer)
;;       (if (and output-buffer
;; 	             (not (or (bufferp output-buffer)  (stringp output-buffer))))
;; 	        ;; Output goes in current buffer.
;; 	        (let ((error-file
;; 		             (if error-buffer
;; 		                 (make-temp-file
;; 		                  (expand-file-name "scor"
;; 					                              (or small-temporary-file-directory
;; 					                                  temporary-file-directory)))
;; 		               nil)))
;; 	          (barf-if-buffer-read-only)
;; 	          (push-mark nil t)
;; 	          ;; We do not use -f for csh; we will not support broken use of
;; 	          ;; .cshrcs.  Even the BSD csh manual says to use
;; 	          ;; "if ($?prompt) exit" before things which are not useful
;; 	          ;; non-interactively.  Besides, if someone wants their other
;; 	          ;; aliases for shell commands then they can still have them.
;; 	          (call-process shell-file-name nil
;; 			                    (if error-file
;; 			                        (list t error-file)
;; 			                      t)
;; 			                    nil shell-command-switch command)
;; 	          (when (and error-file (file-exists-p error-file))
;; 	            (if (< 0 (nth 7 (file-attributes error-file)))
;; 		              (with-current-buffer (get-buffer-create error-buffer)
;; 		                (let ((pos-from-end (- (point-max) (point))))
;; 		                  (or (bobp)
;; 			                    (insert "\f\n"))
;; 		                  ;; Do no formatting while reading error file,
;; 		                  ;; because that can run a shell command, and we
;; 		                  ;; don't want that to cause an infinite recursion.
;; 		                  (format-insert-file error-file nil)
;; 		                  ;; Put point after the inserted errors.
;; 		                  (goto-char (- (point-max) pos-from-end)))
;; 		                (display-buffer (current-buffer))))
;; 	            (delete-file error-file))
;; 	          ;; This is like exchange-point-and-mark, but doesn't
;; 	          ;; activate the mark.  It is cleaner to avoid activation,
;; 	          ;; even though the command loop would deactivate the mark
;; 	          ;; because we inserted text.
;; 	          (goto-char (prog1 (mark t)
;; 			                   (set-marker (mark-marker) (point)
;; 				                             (current-buffer)))))
;; 	      ;; Output goes in a separate buffer.
;; 	      ;; Preserve the match data in case called from a program.
;;         ;; FIXME: It'd be ridiculous for an Elisp function to call
;;         ;; shell-command and assume that it won't mess the match-data!
;; 	      (save-match-data
;; 	        (if (string-match "[ \t]*&[ \t]*\\'" command)
;; 	            ;; Command ending with ampersand means asynchronous.
;;               (let* ((buffer (get-buffer-create
;;                               (or output-buffer "*Async Shell Command*")))
;;                      (bname (buffer-name buffer))
;;                      (directory default-directory)
;;                      proc)
;; 		            ;; Remove the ampersand.
;; 		            (setq command (substring command 0 (match-beginning 0)))
;; 		            ;; Ask the user what to do with already running process.
;; 		            (setq proc (get-buffer-process buffer))
;; 		            (when proc
;; 		              (cond
;; 		               ((eq async-shell-command-buffer 'confirm-kill-process)
;; 		                ;; If will kill a process, query first.
;; 		                (if (yes-or-no-p "A command is running in the default buffer.  Kill it? ")
;; 			                  (kill-process proc)
;; 		                  (error "Shell command in progress")))
;; 		               ((eq async-shell-command-buffer 'confirm-new-buffer)
;; 		                ;; If will create a new buffer, query first.
;; 		                (if (yes-or-no-p "A command is running in the default buffer.  Use a new buffer? ")
;;                         (setq buffer (generate-new-buffer bname))
;; 		                  (error "Shell command in progress")))
;; 		               ((eq async-shell-command-buffer 'new-buffer)
;; 		                ;; It will create a new buffer.
;;                     (setq buffer (generate-new-buffer bname)))
;; 		               ((eq async-shell-command-buffer 'confirm-rename-buffer)
;; 		                ;; If will rename the buffer, query first.
;; 		                (if (yes-or-no-p "A command is running in the default buffer.  Rename it? ")
;; 			                  (progn
;; 			                    (with-current-buffer buffer
;; 			                      (rename-uniquely))
;;                           (setq buffer (get-buffer-create bname)))
;; 		                  (error "Shell command in progress")))
;; 		               ((eq async-shell-command-buffer 'rename-buffer)
;; 		                ;; It will rename the buffer.
;; 		                (with-current-buffer buffer
;; 		                  (rename-uniquely))
;;                     (setq buffer (get-buffer-create bname)))))
;; 		            (with-current-buffer buffer
;;                   (shell-command--save-pos-or-erase)
;; 		              (setq default-directory directory)
;; 		              (setq proc (start-process "Shell" buffer shell-file-name
;; 					                                  shell-command-switch command))
;; 		              (setq mode-line-process '(":%s"))
;; 		              (require 'shell) (shell-mode)
;; 		              (set-process-sentinel proc 'shell-command-sentinel)
;; 		              ;; (set-process-sentinel proc 'ignore) ; This removes the "finished." message which is good for most processes but bad for term.
;; 		              ;; Use the comint filter for proper handling of
;; 		              ;; carriage motion (see comint-inhibit-carriage-motion).
;; 		              (set-process-filter proc 'comint-output-filter)
;;                   (if async-shell-command-display-buffer
;;                       ;; Display buffer immediately.
;;                       (display-buffer buffer '(nil (allow-no-window . t)))
;;                     ;; Defer displaying buffer until first process output.
;;                     ;; Use disposable named advice so that the buffer is
;;                     ;; displayed at most once per process lifetime.
;;                     (let ((nonce (make-symbol "nonce")))
;;                       (add-function :before (process-filter proc)
;;                                     (lambda (proc _string)
;;                                       (let ((buf (process-buffer proc)))
;;                                         (when (buffer-live-p buf)
;;                                           (remove-function (process-filter proc)
;;                                                            nonce)
;;                                           (display-buffer buf))))
;;                                     `((name . ,nonce)))))))
;; 	          ;; Otherwise, command is executed synchronously.
;; 	          (shell-command-on-region (point) (point) command
;; 				                             output-buffer nil error-buffer)))))))

;; This is a better way to silence the default shell finished message instead of using 'ignore
(defun shell-command-sentinel (process signal)
  (when (memq (process-status process) '(exit signal))
    (shell-command-set-point-after-cmd (process-buffer process))
    ;; (message "%s: %s."
    ;;          (car (cdr (cdr (process-command process))))
    ;;          (substring signal 0 -1))
    ))


;; -------


(defun run-hooks-ignore (hooks)
  "Not yet any noticeable difference"
  (dolist (hook hooks)
    (dolist (fun (eval hook))
      (ignore (funcall fun)))))


;; (run-mode-hooks 'clojure-mode-hook)
(defun run-mode-hooks (&rest hooks)
  "Run mode hooks `delayed-mode-hooks' and HOOKS, or delay HOOKS.
Call `hack-local-variables' to set up file local and directory local
variables.

If the variable `delay-mode-hooks' is non-nil, does not do anything,
just adds the HOOKS to the list `delayed-mode-hooks'.
Otherwise, runs hooks in the sequence: `change-major-mode-after-body-hook',
`delayed-mode-hooks' (in reverse order), HOOKS, then runs
`hack-local-variables', runs the hook `after-change-major-mode-hook', and
finally evaluates the functions in `delayed-after-hook-functions' (see
`define-derived-mode').

Major mode functions should use this instead of `run-hooks' when
running their FOO-mode-hook."
  (if delay-mode-hooks
      ;; Delaying case.
      (dolist (hook hooks)
        (push hook delayed-mode-hooks))
    ;; Normal case, just run the hook as before plus any delayed hooks.
    (setq hooks (nconc (nreverse delayed-mode-hooks) hooks))
    (and (bound-and-true-p syntax-propertize-function)
         (not (local-variable-p 'parse-sexp-lookup-properties))
         ;; `syntax-propertize' sets `parse-sexp-lookup-properties' for us, but
         ;; in order for the sexp primitives to automatically call
         ;; `syntax-propertize' we need `parse-sexp-lookup-properties' to be
         ;; set first.
         (setq-local parse-sexp-lookup-properties t))
    (setq delayed-mode-hooks nil)
    ;; run-hooks
    ;; Sadly, this didn't make it so the following worked (auto jack in)
    ;; cd "$HOME/source/gist/ragnard/4468291"; sp redis.clj
    ;; (run-hooks-ignore (cons 'change-major-mode-after-body-hook hooks))
    (apply #'run-hooks (cons 'change-major-mode-after-body-hook hooks))
    (if (buffer-file-name)
        (with-demoted-errors "File local-variables error: %s"
          (hack-local-variables 'no-mode)))
    (run-hooks 'after-change-major-mode-hook)
    (dolist (fun (prog1 (nreverse delayed-after-hook-functions)
                   (setq delayed-after-hook-functions nil)))
      (funcall fun))))


(provide 'my-subr)