(require 'my-utils)

(defun my/show256colors ()
  (interactive)
  (sph "256-color-test.sh; pak"))

(defun list-executables ()
  ;; There is probably an emacs-lisp function for this
  (str2list (sn "list-executables")))

;; (cmd2lines "hi yo \"hi homie\"")
(defun cmd2lines (cmd)
  "(cmd2lines \"hi yo \\\"hi homie\\\"\")"
  (str2list (cl-sn "cmd2lines" :stdin cmd :chomp t)))

;; TODO Make an elisp function which uses =cmd= and =q -l= to create a list of arguments from a command string

;; Create an interactive way of generating commands from shell commands
;; (str2lines (cl-sn (concat "cmd2lines hi yo \"hi homie\"") :chomp t))

;; (gen-command-from-shell-command "change-mac-address" "testing" "a" "b plus")

(defun join-args-for-command (args &optional forcequotes)
  (s-join " " (mapcar (if forcequotes 'q 's/q) args)))

(defun gen-command-from-shell-command (command &rest arguments-defaults)
  "Generates an interactive command from a list of argument names of an external command"
  (interactive (let* ((exe (fz (list-executables) nil nil "gen-command-from-shell-command: "))
                      (args-defaults-string (read-string-hist (concat "gencom: " exe " ")))
                      (args-defaults-list-string (str2list (cl-sn (concat "cmd2lines " args-defaults-string) :chomp t))))
                 `(,exe ,@args-defaults-list-string)))

  (let* (
         ;; Construct/Reconstruct args-string
         (args-defaults-string (join-args-for-command arguments-defaults))
         (args-defaults-list-tuples (mapcar (lambda (s)
                                              (let ((ss (s-split "=" s)))
                                                (cons (first ss)
                                                      (second ss)))) arguments-defaults))
         (args-list (mapcar 'car args-defaults-list-tuples))
         (defaults-list (mapcar 'cdr args-defaults-list-tuples))
         (slug-list (mapcar 'slugify args-list))
         (slug-defaults-tuples-list (mapcar* 'cons slug-list defaults-list))
         ;; These are defaults for an interactive invocation, not for a normal function invocation
         (defaults-list (cl-loop
                         for s in slug-defaults-tuples-list
                         collect (cons
                                  (car s)
                                  (or
                                   (cdr s)
                                   (read-string-hist (concat "gencom: " command "." (car s) "= "))))))
         (interactive-list (cl-loop for a in defaults-list collect
                                    (if (string-equal (cdr a) "-")
                                        `(read-string-hist ,(concat command "." (car a) ": "))
                                      ;; `(read-string ,(concat command "." (car a) ": "))
                                      (cdr a))))
         (new-args-list (mapcar 'str2sym slug-list))
         ;; Do not factor in the chosen defaults for the name because all arguments are available from normal invocation
         ;; (new-command-name (slugify (replace-regexp-in-string
         ;;                             "\s+"
         ;;                             ""
         ;;                             (if interactive-list
         ;;                                 (concat command " " (mapconcat 'cdr defaults-list " "))
         ;;                               command))))
         (new-command-name (slugify command))

         (funcdef `(cl-defun ,(str2sym new-command-name) ,(append new-args-list '(&key stdin))
                     ,(concat "Runs the shell command " (q command) " and interactively asks for parameters. Collects stdout.")
                     (interactive (list ,@interactive-list))
                     (let ((result (sn (join-args-for-command (list ,command ,@new-args-list) t) stdin)))
                       (if (called-interactively-p 'interactive)
                           (new-buffer-from-string result)
                         result)))))
    (save-window-excursion
      (with-current-buffer (find-file "/home/shane/var/smulliga/source/git/config/emacs/config/my-programs.el")
        (end-of-buffer)
        (newline)
        (insert (pp funcdef))
        (save-buffer)))
    (eval funcdef)))

;; (gen-command-from-shell-command "change-mac-address" "mac=-")

(define-key global-map (kbd "H-g") 'gen-command-from-shell-command)

;; (fmakunbound 'change-mac-address)

;; (cl-defun change-mac-address
;;     (mac &key stdin)
;;   "Runs the shell command \"change-mac-address\" and interactively asks for parameters. Collects stdout."
;;   (interactive (list (read-string-hist "change-mac-address.mac: ")))
;;   (tvipe (concat "hi" mac))
;;   ;; (let
;;   ;;     ((result (sn (join-args-for-command (list "change-mac-address" mac) t) stdin)))
;;   ;;   (if
;;   ;;       (called-interactively-p 'any)
;;   ;;       (new-buffer-from-string result)
;;   ;;     result))
;;   )


;; (defun change-mac-address ()
;;   (interactive)
;;   (let ((new-mac-address (cl-sn "random-mac-address" :chomp t)))
;;     (cl-sn "change-mac-address" :chomp t)))

;; change-mac-address

(provide 'my-programs)

(cl-defun spot-price
    (instancetype &key stdin)
  "Runs the shell command \"spot-price\" and interactively asks for parameters. Collects stdout."
  (interactive
   (list
    (read-string-hist "spot-price.instancetype: ")))
  (let
      ((result
        (sn
         (join-args-for-command
          (list "spot-price" instancetype)
          t)
         stdin)))
    (if
        (called-interactively-p 'interactive)
        (new-buffer-from-string result)
      result)))

(cl-defun seq
    (low high &key stdin)
  "Runs the shell command \"seq\" and interactively asks for parameters. Collects stdout."
  (interactive
   (list
    (read-string-hist "seq.low: ")
    (read-string-hist "seq.high: ")))
  (let
      ((result
        (sn
         (join-args-for-command
          (list "seq" low high)
          t)
         stdin)))
    (if
        (called-interactively-p 'interactive)
        (new-buffer-from-string result)
      result)))

(defalias 'eseq 'number-sequence)

(cl-defun change-mac-address
    (mac &key stdin)
  "Runs the shell command \"change-mac-address\" and interactively asks for parameters. Collects stdout."
  (interactive
   (list
    (read-string-hist "change-mac-address.mac: ")))
  (let
      ((result
        (sn
         (join-args-for-command
          (list "change-mac-address" mac)
          t)
         stdin)))
    (if
        (called-interactively-p 'interactive)
        (new-buffer-from-string result)
      result)))
