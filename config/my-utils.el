(require 'my-syntax-extensions)
(require 'f)
(require 's)
(require 'my-aliases)

;; cl is deprecated as of emacs27. use cl-lib instead
;; (require 'cl)
(require 'cl-lib)

;;(require 'shut-up)
;; Why do I need to forcefully load this?
(load "/home/shane/var/smulliga/source/git/config/emacs/packages28/shut-up-20180628.1830/shut-up.el")

(defun e/chomp (str)
  "Chomp leading and tailing whitespace from STR."
  (while (string-match "\\`\n+\\|^\\s-+\\|\\s-+$\\|\n+\\'"
                       str)
    (setq str (replace-match "" t t str)))
  str)

(defun list2string (list)
  "Convert a list to a newline delimited string."
  (mapconcat 'str list "\n"))

(defun string2list (s)
  "Convert a newline delimited string to list."
  (split-string s "\n"))
(defalias 'str2list 'string2list)


;; The let*..inhibit takes care of the c problem
;; The progn takes care of pp eval output buffer displaying
(defmacro shut-up-c (&rest body)
  "This works for c functions where shut-up does not."
  `(progn (let* ((inhibit-message t))
            ,@body)))

(defmacro shut-up-all (&rest body)
  "This works for c functions where shut-up does not."
  `(progn (let* ((inhibit-message t))
            ,@body) nil))

(defalias 'my/shut-up 'shut-up-all)


(defun markdown-convert-buffer-to-org ()
  "Convert the current buffer's content from markdown to orgmode format and save it with the current buffer's file name but with .org extension."
  (interactive)
  (shell-command-on-region (point-min) (point-max)
                           (format "pandoc -f markdown -t org -o %s"
                                   (my/new-filename-with-extension "org"))))


(defun md-org-export-to-org ()
  (interactive)
  (let ((fn
         (my/new-filename-with-extension "org")))
    (markdown-convert-buffer-to-org)
    (shell-command
     (concat
      "sed '1 s~^~#+HTML_HEAD: <link rel="
      (q "stylesheet")
      " type="
      (q "text/css")
      " href="
      (q
       "http://gongzhitaao.org/orgcss/org.css")
      "/>\\n~' "
      (q fn)
      " | sponge "
      (q fn)))
    (find-file fn)))


(defun new-file-filter-buffer (shellfilter extension)
  (interactive)
  )

(defun html2org ()
  (interactive)

  (shell-command-on-region (point-min) (point-max)
                           (format "pandoc -f markdown -t org -o %s"
                                   (my/new-filename-with-extension "org")))

  (let ((fn
         (my/new-filename-with-extension "org")))
    (markdown-convert-buffer-to-org)
    (shell-command
     (concat
      "sed '1 s~^~#+HTML_HEAD: <link rel="
      (q "stylesheet")
      " type="
      (q "text/css")
      " href="
      (q
       "http://gongzhitaao.org/orgcss/org.css")
      "/>\\n~' "
      (q fn)
      " | sponge "
      (q fn)))
    (find-file fn)))

(defun md-org-export-to-org-b64 ()
  (interactive)
  (let ((fn
         (my/new-filename-with-extension "org")))
    ;; (markdown-convert-buffer-to-org)
    (base64-encode-string (concat "sed '1 s~^~#+HTML_HEAD: <link rel=\" stylesheet \" type=\" text/css \" href=\" http://gongzhitaao.org/orgcss/org.css \"/>\\n~' " fn " | sponge " fn))))


(defun cursor-at-region-start-p ()
  "If the cursor is at the start of the region"
  (and (region-active-p) (= (point) (region-beginning))))


(defun generalized-shell-command (command arg)
  "Unifies `shell-command' and `shell-command-on-region'. If no region is
  selected, run a shell command just like M-x shell-command (M-!).  If
  no region is selected and an argument is a passed, run a shell command
  and place its output after the mark as in C-u M-x `shell-command'
  (C-u M-!).  If a region is selected pass the text of that region to
  the shell and replace the text in that region with the output of the
  shell command as in C-u M-x `shell-command-on-region' (C-u M-|). If
  a region is selected AND an argument is passed (via C-u) send output
  to another buffer instead of replacing the text in region."
  (interactive (list (read-from-minibuffer "Shell command: " nil nil nil 'shell-command-history)
                     current-prefix-arg))
  (let ((p (if mark-active (region-beginning) 0))
        (m (if mark-active (region-end) 0)))
    (if (= p m)
        ;; No active region
        (if (eq arg nil)
            (shell-command command)
          (shell-command command t))
      ;; Active region
      (if (eq arg nil)
          (shell-command-on-region p m command t t)
        (shell-command-on-region p m command)))))

;;(global-set-key [f3] 'generalized-shell-command)
;;(global-set-key [M-q M-r M-f] 'generalized-shell-command)

(defun xah-filter-list (@predicate @sequence)
  "Return a new list such that *predicate is true on all members of *sequence.
URL `http://ergoemacs.org/emacs/elisp_filter_list.html'
Version 2016-07-18"
  (delete
   "e3824ad41f2ec1ed"
   (mapcar
    (lambda ($x)
      (if (funcall @predicate $x)
          $x
        "e3824ad41f2ec1ed"))
    @sequence)))

;; (require 'macro-utils)

;; Macros are so awesome. I am only just beginning to understand what they do
;; [[https://www.gnu.org/software/emacs/manual/html_node/elisp/Backquote.html][Backquote - GNU Emacs Lisp Reference Manual]]

(defmacro defsynonym (old-name new-name)
  "This makes an alias of a macro"
  `(defmacro ,new-name (&rest args)
     `(, ',old-name ,@args)))

;; Example of rest
;; if you had a function that looked like (add &rest numbers), then you could call it like (add 1 2 3 4 5), and within the function the numbers argument would have the value (1 2 3 4 5)
(defun add (&rest numbers)
  ;; This gives the numbers as a list
  numbers)
;; ((lambda (a &rest r) r) 1 2 3)

(_ns math
     (defmacro inc! (var)
       "write (inc! x) and have the effect of (setq x (1+ x))"
       (list 'setq var (list '1+ var)))

     (defmacro 2+ (var)
       (list '+ var 2)))

;; This probably has to be a macro. I need to be able to pass body without the apostrophe
;; (defun my/with (package &rest body)
;;   (when (require package nil 'noerror)
;;     (eval body)))

;; This works perfectly
(defmacro my/with (package &rest body)
  "This attempts to run code dependent on a package and otherwise doesn't run the code."
  `(when (require ,package nil 'noerror)
     ,@body))


;; See how this works and how it is used
;; this creates new advice, uses
(defmacro my/with-advice (adlist &rest body)
  "Execute BODY with temporary advice in ADLIST.

TODO You could also do this with something like the noflet package, if you prefer.

Each element of ADLIST should be a list of the form
  (SYMBOL WHERE FUNCTION [PROPS])
suitable for passing to `advice-add'.  The BODY is wrapped in an
`unwind-protect' form, so the advice will be removed even in the
event of an error or nonlocal exit."
  (declare (debug ((&rest (&rest form)) body))
           (indent 1))
  `(progn
     ,@(mapcar (lambda (adform)
                 (cons 'advice-add adform))
               adlist)
     (unwind-protect (progn ,@body)
       ,@(mapcar (lambda (adform)
                   `(advice-remove ,(car adform) ,(nth 2 adform)))
                 adlist))))

;; (defalias 'with-advice 'my/with-advice)


;; TODO Figure out how to make this happen
;; (my/with-advice '(ignore-errors-around-advice) (error "hi"))
;; This is how
;; (ignore-errors-around-advice (lm (error "hi")))

(defun my/call-logging-hooks (command &optional verbose)
  "Call COMMAND, reporting every hook run in the process.
Interactively, prompt for a command to execute.

Return a list of the hooks run, in the order they were run.
Interactively, or with optional argument VERBOSE, also print a
message listing the hooks.

[[https://emacs.stackexchange.com/questions/19578/list-hooks-that-will-run-after-command][List hooks that will run after command - Emacs Stack Exchange]]

There are some caveats.
"
  (interactive "Command to log hooks: \np")
  (let* ((log     nil)
         (logger (lambda (&rest hooks)
                   (setq log (append log hooks nil)))))
    (my/with-advice
        ((#'run-hooks :before logger))
      (call-interactively command))
    (when verbose
      (message
       (if log "Hooks run during execution of %s:"
         "No hooks run during execution of %s.")
       command)
      (dolist (hook log)
        (message "> %s" hook)))
    log))


(defun get-string-from-file (filePath)
  "Return filePath's file content."
  (with-temp-buffer
    (insert-file-contents filePath)
    (buffer-string)))


;; (require 'cl)

(defun is-useless-buffer (buffer)
  (let ((name (buffer-name buffer)))
    (and (= ?* (aref name 0))
         (not (string-match "^\\*shell\\*" name)))))

(defun kill-useless-buffers ()
  (interactive)
  (loop for buffer being the buffers
        do (and (is-useless-buffer buffer) (kill-buffer buffer))))


(defun is-load-buffer (buffer)
  (let ((name (buffer-name buffer)))
    (and (= ?* (aref name 0))
         (not (string-match "^ \\*load\\*" name)))))


;; TODO finish this function
(defun exit-load-buffers ()
  (interactive)
  (loop for buffer being the buffers
        do (and (is-load-buffer buffer) (kill-buffer buffer))))


;; TODO make this function use exit-load-buffers
(defun exit ()
  "Exit/return early from an elisp file
  How is this not a builtin?"
  (with-current-buffer " *load*"
    (goto-char (point-max))))


(defun log-it (s_message)
  "I want my own function because emacs does not remember messages after init"
  (bash "cat > $NOTES/programs/messages.log" s_message))

;; Use this to print messages when debugging .emacs
;; I can use tmux, but, hide the window
;; I need a command that can use stdin.
;; emacs uses ptys. Therefore, It's hard to separate output. So I should write my own mechanism to collect stdout.
;; If I always use tmux, then it's ok. Always detach tmux.
;; TODO use (bash) to *locate* org files rather than searching for them.


;; (defun helm-regexp-get-line (s e)
;;   (let ((matches (match-data))
;;         (line    (buffer-substring s e)))
;;     (propertize
;;      (cl-loop with ln = (format "%5d: %s" (1- (line-number-at-pos s)) line)
;;            for i from 0 to (1- (/ (length matches) 2))
;;            if (match-string i)
;;            concat (format "\n%s%s'%s'"
;;                           (make-string 10 ? ) (format "Group %d: " i) it)
;;            into ln1
;;            finally return (concat ln ln1))
;;      'helm-realvalue s)))

;; I don't know the correct require statement
;;(require 'helm-config)

;;; Ivy is probably better suited to this.

;;(defun helm-occur-string (input)
;;  (with-temp-buffer
;;    (insert input)
;;    (helm-multi-occur-1 '(" *temp*"))))

;;(defun fzf (input)
;;  (with-temp-buffer
;;    (insert input)
;;    ;; (helm-regexp-get-line (point-min) (point-max))
;;    (helm-multi-occur-1 '(" *temp*"))
;;    helm-saved-selection))

;; It would be nice if I could understand this code
;; [[https://gist.github.com/bling/18655e86918bebd7bc3d][helm-fzf.el  GitHub]]


;; I can use tab key in (fzf) to show the contents of a file.
;; (fzf (scriptnames-string))


(defun nw (&optional cmd nw_args input dir)
  "Runs command in a new window"
  (interactive)
  (if (not cmd)
      (setq cmd "zsh"))
  (if input
      (sh-notty (concat "tm -tout -S nw " nw_args " " (q cmd) " &") input (or dir (get-dir)))
    (shell-command (concat "unbuffer tm -f -d -te nw " nw_args " -c " (q (or dir (get-dir))) " " (q cmd) " &"))))
(defalias 'tm/nw 'nw)



(defun nwp (&optional cmd input nw_args)
  "Runs command in a new window with input"
  (interactive)
  (if (not cmd)
      (setq cmd "zsh"))
  (sh-notty (concat "tm -tout -S nw " nw_args " " (q cmd) " &") input (get-dir)))
(defalias 'tm/nwp 'nwp)

(defun nwpq (&optional cmd input nw_args)
  "Runs command in a new window with input. Output is silenced"
  (interactive)
  (if (not cmd)
      (setq cmd "zsh"))
  (sh-notty (concat "tm -tout -S nw " nw_args " " (q cmd) " &") input (get-dir)))
(defalias 'tm/nwpq 'nwpq)

(defun sps (&optional cmd nw_args input dir)
  "Runs command in a horizontal split"
  (interactive)
  (if (not cmd)
      (setq cmd "zsh"))
  (if input
      (sh-notty (concat "tm -tout -S sps " nw_args " " (q cmd) " &") input (or dir (get-dir)))
    (if (display-graphic-p)
        (e/sps-zsh cmd)
      (progn
        (if (and (variable-p 'sh-update)
                 (eval 'sh-update))
            (setq cmd (concat "upd " cmd)))
        (shell-command (concat "unbuffer tm -f -d -te sps " nw_args " -c " (q (or dir (get-dir))) " " (q cmd) " &"))))))
(defalias 'tm/sps 'sps)

;; (defun sph-or-esph (cmd)
;;   (if (display-graphic-p)
;;       (esph cmd)))

(defun sph (&optional cmd nw_args input dir)
  "Runs command in a horizontal split"
  (interactive)
  (if (not cmd)
      (setq cmd "zsh"))
  (if input
      (sh-notty (concat "tm -tout -S sph " nw_args " " (q cmd) " &") input (or dir (get-dir)))
    (if (display-graphic-p)
        (e/sph-zsh cmd)
        (progn
          (if (and (variable-p 'sh-update)
                   (eval 'sh-update))
              (setq cmd (concat "upd " cmd)))
          (shell-command (concat "unbuffer tm -f -d -te sph " nw_args " -c " (q (or dir (get-dir))) " " (q cmd) " &"))))))
(defalias 'tm/sph 'sph)

(defun spv (&optional cmd nw_args input dir)
  "Runs command in a vertical split"
  (interactive)
  (if (not cmd)
      (setq cmd "zsh"))
  (if input
      (sh-notty (concat "tm -tout -S spv " nw_args " " (q cmd) " &") input (or dir (get-dir)))
    (if (display-graphic-p)
        (e/spv-zsh cmd)
      (progn
        (if (and (variable-p 'sh-update)
                 (eval 'sh-update))
            (setq cmd (concat "upd " cmd)))
        (shell-command (concat "unbuffer tm -f -d -te spv " nw_args " -c " (q (or dir (get-dir))) " " (q cmd) " &"))))))
(defalias 'tm/spv 'spv)

(defun spsp (&optional cmd input nw_args)
  "Runs command in a sensible split with input"
  (interactive)
  (sps cmd nw_args input))

(defun eshell-run-command (cmd)
  (interactive (list (read-string "eshell$ ")))
  (eshell)
  (with-current-buffer "*eshell*"
    (eshell-return-to-prompt)
    (eshell-kill-input)
    ;; (kill-line)
    (insert cmd)
    (eshell-send-input)))

;; (defun eshell-run-command (cmd)
;;   (interactive (list (read-string "eshell$ ")))
;;   (with-current-buffer (eshell)
;;     (eshell-return-to-prompt)
;;     (eshell-kill-input)
;;     ;; (kill-line)
;;     (insert cmd)
;;     (eshell-send-input)))

(defun spvp (&optional cmd input nw_args)
  "Runs command in a vertical split with input"
  (interactive)
  (spv cmd nw_args input))

(defun spvpq (&optional cmd input nw_args)
  "Runs command in a vertical split with input"
  (interactive)
  (if (not cmd)
      (setq cmd "zsh"))
  (sh-notty (concat "tm -tout -S spv -q " nw_args " " (q cmd) " &") input (get-dir)))

(defun sphp (&optional cmd input nw_args)
  "Runs command in a vertical split with input"
  (interactive)
  (if (not cmd)
      (setq cmd "zsh"))
  (sh-notty (concat "tm -tout -S sph " nw_args " " (q cmd) " &") input (get-dir)))

(defun tmux-bash (&optional cmd)
  "Runs command in a new tmux window"
  (interactive)
  (if (not cmd)
      (setq cmd "zsh"))
  (shell-command (concat "unbuffer tm -f -d -te nw -c " (q (get-dir) " &") " " (q cmd))))

     ;; bd works now. nohup needs a tty. use unbuffer
     ;; (bd sleep 10 && unbuffer nohup ns sfkladj); no longer need to do this

(cl-defun cl-sh-notty (cmd &key stdin &key dir &key detach &key b_no_unminimise &key output_buffer &key b_unbuffer &key chomp &key b_output-return-code)
  (interactive)

  (sh-notty cmd stdin dir nil detach b_no_unminimise output_buffer b_unbuffer chomp b_output-return-code))


;; Should I use tuples or a hash table?
;; Just use tuples for the moment
(defun sh-construct-exports (varval-tuples)
  (s-join
   " "
   (cons
    "export"
    (cl-loop for tp in varval-tuples
             collect
             (concat
              (car tp)
              "="
              (q (second tp)))))))

;; (sh-construct-exports '(("a" "value") ("thing" "thingval")))

(defun sh-notty (cmd &optional stdin dir exit_code_var detach b_no_unminimise output_buffer b_unbuffer chomp b_output-return-code)
  "Runs command in shell and return the result.
This appears to strip ansi codes.
\(sh) does not."

  (interactive)
  ;; (message "%s" "before")
  ;; (setq exit_code_var (str2sym exit_code_var))
  ;; (trace (message "%s" exit_code_var))
  ;; (trace (message "%s" (str2sym exit_code_var)))
  ;; (message "%s" "after")
  (if (not cmd)
      (setq cmd "false"))
  ;; (message "%s" (concat "cmd:" cmd))

  (if (not dir)
      (setq dir (get-dir)))

  (let ((default-directory dir))
    (if (not b_no_unminimise)
        (setq cmd (umn cmd)))

    ;; If the program is outputting stdout (which by default is always) and requires unbuffering
    ;; (cl-sh-notty "xc" :b_unbuffer t)
    (if b_unbuffer
        (setq cmd (concat "unbuffer -p " cmd)))

    (if (or
         (and (variable-p 'sh-update)
              (eval 'sh-update))
         (>= (prefix-numeric-value current-global-prefix-arg) 16))
        (setq cmd (concat "upd " cmd)))

    (setq tf (make-temp-file "elisp_bash"))
    (setq tf_exit_code (make-temp-file "elisp_bash_exit_code"))

    (let ((exps
           (sh-construct-exports
            (-filter 'identity
                     (list (list "PATH" (concat "$SCRIPTS:" (getenv "PATH")))
                           (if (and (variable-p 'sh-update) (eval 'sh-update))
                               (list "UPDATE" "y")))))))
      (setq final_cmd (concat exps "; ( cd " (e/q dir) "; " cmd "; echo -n $? > " tf_exit_code " ) > " tf)))

    ;; (if (>= (prefix-numeric-value current-global-prefix-arg) 4)
    ;;     (message "%s" (concat "final_cmd:" final_cmd)))
    ;; (error final_cmd)

    (message-no-echo "%s" (concat "sh-notty: " (mnm final_cmd)))

    (if detach
        ;; Can't have the & at the top level or it will be handled by emacs
        ;; And emacs will create the 'finished' message
        ;; I disabled it in my-subr.el
        ;; I need unbuffer nohup to make everything work
        ;; This makes it unkillable by the process viewer, which is a bad sideeffect
        ;; I only want to trap HUP
        ;; (setq final_cmd (concat "unbuffer nohup bash -c " (e/q final_cmd) " &"))
        (setq final_cmd (concat "trap '' HUP; unbuffer bash -c " (e/q final_cmd) " &")))

    (shut-up-c
     (if (not stdin)
         ;; Annoyingly, this also creates a "finished." message when it ends.
         ;; vim +/"Adding :sentinel #'ignore did not remove the 'finished' message." "$EMACSD/config/my-subr.el"
         ;; (shell-command final_cmd nil)
         (progn
           ;; generate-new-buffer will start numbering the buffers
           ;; (shell-command final_cmd (generate-new-buffer "*Async Shell Command*"))
           ;; The try is necessary. Try first to use "*Async Shell Command*", even if it already exits
           ;; This is allowed because a process may not be connected to the buffer and the buffer can be re-used instead of another one made
           ;; If that fails, then make a brand new buffer (rather than trying the next numbered one)
           ;; (try (always-yes (shell-command final_cmd nil))
           ;;      (shell-command final_cmd (generate-new-buffer "*Async Shell Command*")))
           ;; always-yes advice has been placed around shell-command
           ;; vim +/"(defadvice shell-command (around no-y-or-n activate)" "$EMACSD/config/my-advice-1.el"
           (shell-command final_cmd output_buffer)
           ;; (shell-command final_cmd output_buffer)
           ) ;This creates an async shell command in emacs' process manager. I want to avoid this. Use tmux?
       (with-temp-buffer
         (insert stdin)
         ;; (shell-command-on-region (point-min) (point-max) final_cmd (generate-new-buffer "*Async Shell Command*"))
         ;; (try (shell-command-on-region (point-min) (point-max) final_cmd output_buffer)
         ;;      (shell-command-on-region (point-min) (point-max) final_cmd (generate-new-buffer "*Async Shell Command*")))
         (shell-command-on-region (point-min) (point-max) final_cmd output_buffer))))
    (setq output (get-string-from-file tf))
    (if chomp
        (setq output (chomp output)))

    ;; (trace (message "%s" cmd))
    ;; (trace (message "%s" stdin))
    ;; (trace (message "%s" dir))
    ;; (trace (message "%s" exit_code_var))
    ;; (trace (message "%s" detach))

    ;; (if (my/variable-exists 'exit_code_var)
    ;;     ;; (boundp exit_code_var)
    ;;     (progn
    ;;       ;; (message "%s" exit_code_var)
    ;;       ;; (ns "hi")
    ;;       (defset exit_code_var (e/chomp (get-string-from-file tf_exit_code)))))

    (progn
      ;; (message "%s" exit_code_var)
      ;; (ns "hi")
      ;; (defset b_exit_code (e/chomp (get-string-from-file tf_exit_code)))
      (defset b_exit_code (get-string-from-file tf_exit_code))
      ;; (message "%s" (concat "exit:" (str b_exit_code)))
      )

    (if b_output-return-code
        (setq output (str b_exit_code)))
    output))
(defalias 'sn 'sh-notty)

(defun snd (cmd &optional stdin)
  "sn detach"
  (sn cmd stdin nil nil t))

(defun snc (cmd &optional stdin)
  "sn chomp"
  (chomp (sn cmd stdin)))

(cl-genfuncwrapper sh-notty)
(defalias 'cl-sn 'cl-sh-notty)

;; (cl-sh-notty "random-mac-address" :chomp t)

;; (defun sh-notty-true (&rest body)
;;   "Return true if the exit code is 0. Same parameters as ssh-notty."
;;   (eval `(sh-notty ,@body))
;;   (string-equal b_exit_code "0"))

(defmacro sh-notty-if (cmd then else &rest sh-notty-args)
  "Like an if statement with a first argument which specifies the command to run as the test"
  `(let ((result (sh-notty ,cmd ,@sh-notty-args)))
     (if (string-equal b_exit_code "0")
         ,then
       ,else)))

     (defmacro sh-notty-true (cmd &rest sh-notty-args)
       "Returns t if the shell command exists with 0"
       `(let ((result (sh-notty ,cmd ,@sh-notty-args)))
          (string-equal b_exit_code "0")))

     (defun bash (&optional cmd stdin b_output tm_session b_switch_to tm_wincmd dir b_wait)
       (interactive)
       (sh cmd stdin b_output tm_session "bash" b_switch_to tm_wincmd dir b_wait))

     (defun zsh (&optional cmd stdin b_output tm_session b_switch_to tm_wincmd)
       (interactive)
       (sh cmd stdin b_output tm_session "zsh" b_switch_to tm_wincmd))

(cl-defun cl-sh (&optional cmd &key stdin &key b_output &key tm_session &key shell &key b_switch_to &key tm_wincmd &key dir &key b_wait)
  (interactive)

  (if (not tm_wincmd)
      (setq tm_wincmd "sps"))

  (sh cmd stdin b_output tm_session shell b_switch_to tm_wincmd dir b_wait))

(defun sh (&optional cmd stdin b_output tm_session shell b_switch_to tm_wincmd dir b_wait)
  "Runs command in a new tmux window and optionally returns the output of the command as a string.
b_output is (t/nil) tm_session is the session of the new tmux window"
  (interactive)
  ;; (message "%s" "starting")

  (if (not dir)
      (setq dir (get-dir)))
  ;; (setq dir "/")

  (let ((default-directory dir))

    (if (not shell)
        (setq shell "bash"))

    (if (not tm_wincmd)
        (setq tm_wincmd "nw"))

    ;; (if (not tm_session)
    ;;     (setq tm_session "localhost_current"))

    (if tm_session
        (setq tm_session (concat " -t " tm_session)))

    (setq session-dir-cmd (concat tm_wincmd " -sh " shell tm_session (if b_switch_to "" " -d") " -c " (q dir) " " (q cmd)))
    ;; (message "%s" (concat "session-dir-cmd: " session-dir-cmd))

    (if b_output
        ;; This means bash is recursive. Can't do this.
        ;; (setq tf (bash "ux tf tempfile dat"))
        ;; This gets called far too many times. It fills up /tmp, over the course of a few days, but still
        (setq tf (make-temp-file "elispbash")))

    (if (not cmd)
        (setq cmd "zsh"))

    (if b_output
        ;; unbuffer breaks stdout
        (if stdin
            (setq final_cmd (concat "tm -f -s -sout " session-dir-cmd " > " tf))
          (setq final_cmd (concat "unbuffer tm -f -fout " session-dir-cmd " > " tf)))
      (if stdin
          (if b_wait
              (setq final_cmd (concat "tm -f -S -tout -w " session-dir-cmd))
            (setq final_cmd (concat "tm -f -S -tout " session-dir-cmd)))
        (if b_wait
            (setq final_cmd (concat "unbuffer tm -f -tout -te -w " session-dir-cmd))
          (setq final_cmd (concat "unbuffer tm -f -d -tout -te " session-dir-cmd)))))

    ;; (message "%s" (concat  "bash: " final_cmd))

    ;; It would be cool to send this to messages without displaying
    ;; in the minibuffer
    ;; (message "%s" (concat "final command: " final_cmd))
    (if (not stdin)
        (shell-command final_cmd)
      (with-temp-buffer
        (insert stdin)
        ;; This only returns the exit code. I want stdout

        (shell-command-on-region (point-min) (point-max) final_cmd))

      ;; This does not fix it
      ;; (with-output-to-string
      ;;   (shell-command-on-region (point-min) (point-max) final_cmd)
      ;;   )
      )
    ;; (message "%s" (concat  "bash-done: " final_cmd))

    (if b_output
        ;; (sleep-for 5)
        ;; Cat tf
        (progn
          (setq output (get-string-from-file tf))
          ;; (message "%s" (concat  "output: " output))
          output))))

;;(advice-add 'sh :around 'my/log-args)


(_ns git
     (defun my-git-previous-revision (&optional fp)
       "git dp in tmux."
       (interactive)
       (if (not fp)
           (setq fq))
       (setq fp (qftln fp))
       (tm/sph (concat "git dp " fp)))

     (defun my-git-show-commit (sha1)
       "Show git commit in tmux."
       (interactive)
       (tm/sph (concat "my-git-show-commit " sha1) "-nopakf -noerror"))

     (defun my/add-all-commit ()
       (interactive)
       (bash "git add -A .; git commit \"$(k f8)\"")
       (message "%s" "Added all changes to git and committed.")))


(_ns tmux
     (defun tm/send-keys-literal (keys)
       (interactive "P")
       (sh-notty (concat "tmux send-keys -l " (q keys))))
     (da 'tsl 'tm/send-keys-literal)

     (defun tm/send-keys (keys)
       (interactive "P")
       ;; (sh-notty (concat "tmux send-keys " (q keys)))
       (sh-notty (concat "tmux send-keys " keys)))
     (da 'tsk 'tm/send-keys)

     (defun select-tmux-current ()
       (interactive)
       ;; This doesn't work because it selects itself
       ;; (bash "tm -f -d select-current")
       (shell-command "tm -f -d select-current")))


;; (message "%s" (tvipe "hi"))
(defun sh/tvipe (&optional stdin editor tm_wincmd ft b_nowait b_quiet dir)
  "Converts the parameter to its string representation and pipes it into tmux.
If a region is selected then it replaces that region.
If a region is selected and stdin is provided then stdin is the stdin.
If a region is selected and stdin is nil then the selected region is the stdin.
TODO make it so if I don't have anything selected, it takes me to the same position that I am currently in.

This function doesn't really like it when you put 'sp' as the editor."
  (interactive)
  (if (not editor)
      (setq editor "vim"))

  ;; (if (not dir)
  ;;     (setq dir (get-dir)))

  (if (not tm_wincmd)
      (setq tm_wincmd "sps"))

  (setq editor (concat "EDITOR=" (q editor) " vipe"))

  (if b_quiet (setq editor (concat editor " &>/dev/null")))

  (if (not stdin)
      (if (region-active-p)
          (setq stdin (my/selected-text))
        ;; (setq stdin (my/buffer-text)) ; this was the source of lag for large files and pp
        ))

  (if stdin (setq stdin (str stdin)))

  (if (not (empty-string-p stdin))
      (if (region-active-p)
          (progn
            ;; (select-tmux-current)
            (let ((stdout (bash editor (format "%s" stdin) (not b_nowait) nil t tm_wincmd dir (not b_nowait))))
              (if (not b_nowait)
                  (progn
                    (delete-region (region-beginning) (region-end))
                    (insert stdout)))))
        (bash editor (str stdin) (or (not b_quiet) (not b_nowait)) nil t tm_wincmd dir (not b_nowait))
        ;; (select-tmux-current)
        )
    (ns "tvipe: stdin is empty")))


;; This is more of a vipe
(cl-defun cl-tvipe (&optional stdin &key editor &key tm_wincmd &key b-quiet &key b-nowait &key dir)
  "Setting b-wait to -1 disables waiting."
  (interactive)
  (sh/tvipe stdin editor tm_wincmd nil b-nowait b-quiet dir))
(defalias 'tvipe 'cl-tvipe)


;; This functions like =tv= on the cli
;; It will pass on the stdin verbatim, even if it were a sexp! perfect
(cl-defun cl-tvs (&optional stdin &key tm_wincmd &key dir)
  "Setting b-wait to -1 disables waiting."
  (interactive)
  (sh/tvipe stdin "vs" tm_wincmd nil t t dir)
  stdin)
(defalias 'tvs 'cl-tvs)

;; This functions like =tv= on the cli
;; It will pass on the stdin verbatim, even if it were a sexp! perfect
(cl-defun cl-tv (&optional stdin &key editor &key tm_wincmd &key dir)
  "Setting b-wait to -1 disables waiting."
  (interactive)
  (if stdin
      (progn
        (if (not (stringp stdin))
            (setq stdin (pp-to-string stdin)))
        (sh/tvipe stdin editor tm_wincmd nil t t dir))
    (message "tv: no input"))
  stdin)
(defalias 'tv 'cl-tv)


(defmacro qtv (&rest args)
  "Quiet tv"
  ;; body
  `(my/nil (tv ,@args)))

(defmacro tvd (&rest args)
  "tvipe detached"
  ;; body
  ;; (eval `(my/nil (tvipe ,@args :editor "colvs" :tm_wincmd "sps" :b-quiet t :b-nowait t)))
  `(my/nil (tvipe ,@args :editor "colv" :tm_wincmd "sps" :b-quiet t :b-nowait t)))

(defmacro qtvd (&rest args)
  "Quiet tvd"
  ;; body
  `(my/nil (tvd ,@args)))

;; Now I need an emacs-lisp function to pipe the currently selected text through a selected lisp function
;; Need to be able to fuzzy-select an emacs function from a list to apply to the selected text.
;; How to use helm like fzf.

;; It's something like this
;; (helm :sources (scriptnames-list) :input "yo")

;; (defun helm-clojuredocs-invoke (&optional init-value)
;;   (interactive)
;;   (let ((helm-input-idle-delay 0.38)
;;         (debug-on-error t))
;;     (helm :sources 'helm-source-clojuredocs
;;           :buffer "*helm-clojuredocs*"
;;           :prompt "Doc for: "
;;           :input init-value)))

;; (scriptnames-list)

(require 's)


(defmacro xc-copy (&rest body)
  `(bp-tty xc ,@body))


;; This should be cl/xc
;; xc should be called like (xc -i (input))
(cl-defun cl/xc (&optional stdin &key notify)
  "Wrapper around xc. Copy and get clipboard."
  (interactive)

  (if stdin
      (setq stdin (format "%s" stdin)))

  (if notify
      ;; (progn (cl-sh "xc -i -" :stdin stdin :b_output t :tm_session "localhost_current_programs" :b_wait t)
      ;;        (message "%s" stdin))
      (let ((result (cl-sh-notty "xc" :b_unbuffer t)))
        (message "%s" (concat "xc:" result))
        result)
    ;; (sh "xc -" stdin t "localhost_current_programs")
    ;; (sh-notty "unbuffer -p xc -" stdin)
    (cl-sh-notty "xc" :b_unbuffer t)))


;; Use this when I get the error. Eshell buffer goes into "text is read only", can't type #3565
(defun eshell/clear ()
  "Clear the eshell buffer."
  (interactive)
  (let ((inhibit-read-only t))
    (erase-buffer)))


(defun my/slurp-file (f)
  (with-temp-buffer
    (insert-file-contents f)
    (buffer-substring-no-properties
     (point-min)
     (point-max))))

;; TODO make a 'default' macro which preferably use elisp variants of functions

(defmacro my/nil (body)
  "Do not return anything."
  ;; body
  `(progn (,@body) nil))



(defun my/remove-symbol-prefix (s)
  "Returns the symbol with prefix removed."
  (str2sym (sed "s/^[a-z]\\+\\///" (sym2str s))))

;; (my/add-symbol-prefix 'ho-yo 'my)
(defun my/add-symbol-prefix (s p)
  "s and p are both symbols. resulting symbol is p/s. (my/add-symbol-prefix 'ho-yo 'my)."
  (str2sym (concat (sym2str p) "/" (sym2str s))))



;; functions prefixed with el/ are the emacs lisp versions of functions. They should behave like emacs lisp functions
(defun el/dirname (fp)
  "dirname -- like the bash version"
  (file-name-directory fp))

(defun sh/chomp (s)
  (sh-notty "s chomp" s))

;; functions prefixed with sh should behave like bash functions
;; (sh/dirname "/hi/yo/yo")
;; Here, I put a backslash before the paren because it's on the first column. Then it will not confuse elisp parsers.
(defun sh/dirname (fp)
  "dirname -- like the bash version.
\(sh/dirname \"/hi/yo/yo\")"
  (sh/chomp (sh-notty "xa dirname" fp)))

(defun sh/basename (fp)
  "dirname -- like the bash version.
\(sh/dirname \"/hi/yo/yo\")"
  (sh/chomp (sh-notty "xa basename" fp)))

(defun my/string-to-buffer (string)
  (with-temp-buffer
    (insert string)))

(defalias 'my/slurp 'my-slurp-sh)

(defun my/load-list-file (f)
  "split-string splits the file into a list of strings. mapcar intern turns the list of strings into a list of symbols"
  (mapcar 'intern
          (split-string
           (my/slurp-file f) "\n" t)))

(defun my/load-list-sh (cmd)
  "split-string splits the stdout of command into a list of strings. mapcar intern turns the list of strings into a list of symbols"
  (mapcar 'intern
          (split-string
           (sh cmd nil t) "\n" t)))


(defalias 'my/load-list 'my/load-list-sh)

;; TODO Make a function to save this list to packages.txt
;; package-activated-list

 (defun my/join (list-of-things &optional delim)
  "Joins a list of strings."
  (if (not delim) (setq delim "\n"))
  (mapconcat 'identity (mapcar 'str list-of-things) delim))


;; Doesn't exist for emacs-script. Might need package initialisation
;; (less (my/list-of-packages))
(defun my/list-of-packages ()
  "Returns a list of packages."
  (interactive)
  (my/join (mapcar 'symbol-name package-activated-list) "\n"))


(defmacro my/nil (body)
  "Do not return anything."
  ;; body
  `(progn (,@body) nil))


(defun my/copy-package-list ()
  "Copies the list of packages to the X clipboard."
  (interactive)

  ;; This works but it's inefficient
  (my/nil (xc (my/list-of-packages)))

  ;; This works but doesn't update the X clipboard
  ;; (kill-new (my/list-of-packages))

  ;; (with-temp-buffer
  ;;   ;; (tvipe (my/list-of-packages))
  ;;   (insert (my/list-of-packages))

  ;;   ;; This should work in theory but it doesn't seem to
  ;;   (mark-whole-buffer)
  ;;   (call-interactively 'cua-copy-region)

  ;;   ;; This works but it doesn't change the X clipboard
  ;;   ;; (clipboard-kill-region (point-min) (point-max))
  ;;   )
  )


(defun my-load-all-in-directory (dir)
  "`load' all elisp libraries in directory DIR which are not already loaded."
  (interactive "D")
  (let ((libraries-loaded (mapcar #'file-name-sans-extension
                                  (delq nil (mapcar #'car load-history)))))
    (dolist (file (directory-files dir t ".+\\.elc?$"))
      (let ((library (file-name-sans-extension file)))
        (unless (member library libraries-loaded)
          (load library nil t)
          (push library libraries-loaded))))))


(defun my-find-file (filename)
  (let ((size-in-bytes (nth 7 (file-attributes filename))))
    (if (< size-in-bytes 1e3)
        (find-file filename)
      (vlf filename))))


;; Command filter
;; Use region-pipe instead. Why?
;; (defun cfilter (cmd)
;;   "This pipes the region or entire buffer through a shell command
;; This is kinda outdated now."

;;   ;; Don't chomp...
;;   ;; (setq cmd (concat cmd " | s chomp"))

;;   (if (region-active-p)
;;       (let ((rstart (region-beginning))
;;             (rend (region-end)))
;;         (shell-command-on-region rstart rend cmd nil 1))
;;     (shell-command-on-region (point-min) (point-max) cmd nil 1)
;;     ;; (progn
;;     ;;   (mark-whole-buffer)
;;     ;;   (cfilter cmd))
;;     ))

;; (cfnb "q -ftl")
(defun cfilter-new-buffer (cmd)
  (interactive)
  (let ((c (str (buffer-contents)))
        (b (generate-new-buffer "cfilter")))
    (switch-to-buffer b)
    (insert c)
    (shell-command-on-region (point-min) (point-max) cmd nil 1)
    ;; (cfilter (cmd))
    ))
(defalias 'cfnb 'cfilter-new-buffer)

;; TODO FIX This is piping through a shell command, not an emacs function. it's not doing what it says it's meant to do
(defun efilter (cmd)
  "This pipes the region or entire buffer through an emacs function that takes a string."
  (let ((cmd (concat cmd " | s chomp")))
    (if (region-active-p)
        (let ((rstart (region-beginning))
              (rend (region-end)))
          (shell-command-on-region rstart rend cmd nil 1))
      (progn
        (mark-whole-buffer)
        (cfilter cmd)))))


(defun is-spacemacs-and-in-evil ()
  "True if spacemacs is in evil-mode."
  (and (fboundp 'spacemacs/toggle-holy-mode-p) (spacemacs/toggle-holy-mode-p)))

(defun evil-enabled ()
  "True if in evil mode. Spacemacs agnostic."
  ;; Keep in mind that evil-mode is enabled when emacs is in holy mode. I have to also check if we are spacemacs

  (if (fboundp 'spacemacs/toggle-holy-mode-p)
      (not (spacemacs/toggle-holy-mode-p))
    (minor-mode-enabled evil-mode)))

;; Beep minibuffer
(defmacro do-in-evil (body)
  "This will execute the emacs lisp in evil-mode. It will switch to evil-mode temporarily if it's not enabled."
  ;; (spacemacs/toggle-holy-mode-p)
  ;; Here, both inhibit-quit is needed at the start and with-local-quit to wrap the code which may be escaped with quit
  ;; Anything lexically nested between inhibit-quit and with-local-quit will ignore C-g

  `(let ((inhibit-quit t))
     (try
      (if (not (evil-enabled))
          (progn
            ;; (my/beep-d)
            (enable-evil)
            (try
             (progn
               (cond ((eq evil-state 'visual)
                      nil
                      ;; (my/beep-d)
                      )
                     ((eq evil-state 'normal)
                      (if (selected)
                          (evil-visual-state)))
                     ((eq evil-state 'insert)
                      nil
                      ;; (my/beep-d)
                      ))
               (with-local-quit (,@body)))
             nil)
            ;; (my/beep-d)
            (disable-evil)
            nil)
        (progn (,@body) nil))
      nil)))

(defalias 'progn-evil 'do-in-evil)

(defun toggle-evil ()
  (interactive)
  "Tries Holy Mode + falls back to evil"
  (save-mark-and-excursion
    ;; This will finish, say, a block insert which may cause the region markers to break
    ;; Can't simply check if evil-mode is t, because it always is t
    (if (or (evil-visual-state-p)
            (evil-insert-state-p))
        (call-interactively 'evil-normal-state))
    (if (fboundp 'spacemacs/toggle-holy-mode)
        (spacemacs/toggle-holy-mode)
      (call-interactively #'evil-mode))

    ;; (if (and (or holy-mode
    ;;              evil-mode)
    ;;          mark-active)
    ;;     (progn
    ;;       (evil-force-normal-state)
    ;;       (evil-transient-mark -1)
    ;;       (evil-active-region -1)))

    ;; This is a *massive* hack, but it works
    (fix-region)))

(defun enable-evil ()
  (interactive)
  "Tries Holy Mode + falls back to evil"
  (save-mark-and-excursion
    (if (fboundp 'spacemacs/toggle-holy-mode-off)
        (spacemacs/toggle-holy-mode-off)
      (evil-mode 1))))

(defun disable-evil ()
  (interactive)
  "Tries Holy Mode + falls back to evil"
  (save-mark-and-excursion
    (if (fboundp 'spacemacs/toggle-holy-mode-on)
        (spacemacs/toggle-holy-mode-on)
      (evil-mode -1))))

(defun region-or-string (&optional object)
  "Return string rep of object if given, otherwise, return the string of the selected region"
  (interactive)
  ;; An argument my be prioritised over the region.
  (cond (object (format "%s" object))
        ((region-active-p) (buffer-substring (region-beginning) (region-end)))
        (t nil)))

(defun my/reload-config-file ()
  "Fuzzy selects a selects file to be loaded."
  (interactive)
  (let ((r (umn (fz (sh-notty "list-emacs-config-files.sh") nil nil "reload config: "))))
    (if (not (empty-string-p r))
        (load r))))

;; This is useless. It doesn't fix "(filter-selection 'fzf)"
(defun my/soak (input-string)
  (sh/cat input-string))

;; Should I just put this inside str?
(defun 2str (thing)
  (cond ((listp thing) (list2str thing))
        ((stringp thing) thing)
        (thing (format "%s" thing))
        (t nil)))
(defalias 'maybe-list2str '2str)

(defun fzf-current (string)
  "Pipes argument or region through fzf"
  ;; (interactive)
  (select-tmux-current)
                                        ; This is required on top of (bash _ _ _ _ t)
  ;; (bash "fzf | s chomp" (region-or-string string) t "localhost_current" t)
  ;; (tvipe (e/chomp (bash "fzf" (region-or-string (tvipe string)) t "localhost_current" t))) ;This works, but with tvipe appearing :/ "(filter-selection 'fzf)"
  (e/chomp (bash "/home/shane/scripts/mfz" (region-or-string (2str string)) t "localhost_current" t)))

(defun fzf (string)
  "Pipes argument or region through fzf"
  (e/chomp (bash "/home/shane/scripts/mfz" (region-or-string (2str string)) t nil t "sph")))

(defun fzf-m (string)
  "Pipes argument or region through fzf - multi-select"
  (e/chomp (bash "/home/shane/scripts/mfz -m" (region-or-string (2str string)) t nil t "sph")))
(defalias 'mfz-m 'fzf-m)

(defun fzf-spv (string)
  "Pipes argument or region through fzf"
  (e/chomp (bash "/home/shane/scripts/mfz" (region-or-string (2str string)) t nil t "spv")))

(defun fzf-sps (string)
  "Pipes argument or region through fzf"
  (e/chomp (bash "/home/shane/scripts/mfz" (region-or-string (2str string)) t nil t "sps")))

(defun git-d-cached ()
  "Split tmux and run git d cached for current file."
  (interactive)
  (sph (concat "git d -- " (qftln buffer-file-name))))

;; nmap <silent> <Leader>; ;silent !difftool.sh<CR><C-L>
;; nmap <silent> <Leader>: ;silent !vimgstatus<CR><C-L>
;; "nmap <silent> <Leader>' ;silent !git d -- %<CR><C-L>
;; nmap <silent> <Leader>' ;silent! call TmuxSplitH('git d -- '.expand('%'))<CR>
;; nmap <silent> <Leader>" ;silent !git d --cached -- %<CR><C-L>
;; nmap <silent> <Leader>* ;silent !difftool.sh HEAD\^:<CR><C-L>

(defun compile-run ()
  "This is used to compile and run a source file."
  (interactive)
  (cond ((minor-mode-p go-playground-mode) (call-interactively 'go-playground-exec))
        ;; Unfortunately, cant use ~tm sps~ because the command can't find the LINES and COLUMNS, even with eval resize
        ;; sps works now
        (t ;; (shell-command (concat "unbuffer tm -f -te -d sps -x -pak -args cr " crstr))
         (let ((crstr
                (cond ((major-mode-p 'json-mode) (concat "-ft json " (q (str (buffer-file-name)))))
                      ((major-mode-p 'csv-mode) (concat "-ft csv " (q (str (buffer-file-name)))))
                      (t (q (str (buffer-file-name))))
                      )
                ))
           (if (not (buffer-file-name))
               (sh-notty (concat "tm -f -S -i -tout sps -x -pak -args cr " crstr) (awk1 (buffer-contents)))
             (shell-command (concat "unbuffer tm -f -te -d sps -x -pak -args cr " crstr)))))))

(defun compile-run-term ()
  "This is used to compile and run a source file."
  (interactive)
  (cond ((minor-mode-p go-playground-mode) (call-interactively 'go-playground-exec))
        ;; Unfortunately, cant use ~tm sps~ because the command can't find the LINES and COLUMNS, even with eval resize
        ;; sps works now
        (t ;; (shell-command (concat "unbuffer tm -f -te -d sps -x -pak -args cr " crstr))
         (let ((crstr
                (cond ((major-mode-p 'json-mode) (concat "-ft json " (q (str (buffer-file-name)))))
                      ((major-mode-p 'csv-mode) (concat "-ft csv " (q (str (buffer-file-name)))))
                      (t (q (str (buffer-file-name))))
                      )
                ))
           (if (not (buffer-file-name))
               (term-nsfa (concat "cr " crstr ) (awk1 (buffer-contents)))
             (term-nsfa (concat "cr " crstr )))))))

;; (defun compile-run-term ()
;;   "This is used to compile and run a source file inside term."
;;   (interactive)
;;   (cond ((minor-mode-p go-playground-mode) (call-interactively 'go-playground-exec))
;;         ;; Unfortunately, cant use ~tm sps~ because the command can't find the LINES and COLUMNS, even with eval resize
;;         ;; sps works now
;;         (t (term-nsfa (concat "cr " (q (str (buffer-file-name))) "; pak")))))

(defun compile-run-tm-ecompile ()
  "This is used to compile and run a source file."
  (interactive)
  (cond ((minor-mode-p go-playground-mode) (call-interactively 'go-playground-exec))
        ;; Unfortunately, cant use ~tm sps~ because the command can't find the LINES and COLUMNS, even with eval resize
        ;; sps works now
        (t (shell-command (concat "unbuffer tm -f -te -d sps -x -pak -args compile cr " (q (str (buffer-file-name))))))))

(defun compile-run-compile ()
  "This is used to compile and run a source file inside term."
  (interactive)
  (cond ((minor-mode-p go-playground-mode) (call-interactively 'go-playground-exec))
        ;; Unfortunately, cant use ~tm sps~ because the command can't find the LINES and COLUMNS, even with eval resize
        ;; sps works now
        (t (compile (concat "cr " (q (str (buffer-file-name))) " | cat")))))

(defun schema-run ()
  "This is used to get the paths through file."
  (interactive)
  (cond ((minor-mode-p go-playground-mode) (call-interactively 'go-playground-exec))
        ;; Unfortunately, cant use ~tm sps~ because the command can't find the LINES and COLUMNS, even with eval resize
        ;; sps works now
        (t (shell-command (concat "unbuffer tm -f -te -d sps -x -args zh " (q (str (buffer-file-name))))))))

(defmacro make-wrapper (wrappee wrapper)
  "Create a WRAPPER (a symbol) for WRAPPEE (also a symbol)."
  (let ((arglist (make-symbol "arglist")))
    `(defun ,wrapper (&rest ,arglist)
       ,(concat (documentation wrappee) "\n But I do something more.")
       ,(interactive-form wrappee)
       (prog1 (apply (quote ,wrappee) ,arglist)
         (message "Wrapper %S does something more." (quote ,wrapper))))))

(defun wrappee-interactive (num str)
  "That is the doc string of wrappee-interactive."
  (interactive "nNumber:\nsString:")
  (message "The number is %d.\nThe string is \"%s\"." num str))

(defun wrappee-non-interactive (format &rest arglist)
  "That is the doc string of wrappee-non-interactive."
  (apply 'message format arglist))

(make-wrapper wrappee-interactive wrapper-interactive)
(make-wrapper wrappee-non-interactive wrapper-non-interactive)
;; test of the non-interactive part:

(wrapper-non-interactive "Number: %d, String: %s" 1 "test")

;; This doesnt even work because it uses simpleclip
(defun copy-current-line-position-to-clipboard ()
  "Copy current line in file to clipboard as '</path/to/file>:<line-number>'"
  (interactive)
  (let ((path-with-line-number
         (concat buffer-file-name ":" (number-to-string (line-number-at-pos)))))
    ;;(x-select-text path-with-line-number)
    (simpleclip-set-contents path-with-line-number)
    (message "%s" (concat path-with-line-number " copied to clipboard"))))

(defvar my-terminal-run-history nil)

;; But how to get this to show ansi-colors?
(defun my-terminal-run (command &optional name)
  "Runs COMMAND in a `term' buffer."
  (interactive
   (list (read-from-minibuffer "$ " nil nil nil 'my-terminal-run-history)))
  (let* ((name (or name command))
         (switches (split-string-and-unquote command))
         (command (pop switches))
         (termbuf (apply 'make-term name command nil switches)))
    (set-buffer termbuf)
    (term-mode)
    (term-char-mode)
    (switch-to-buffer termbuf)))

(global-set-key (kbd "C-c s c") 'my-terminal-run)



(defun my/beep-wait ()
  (interactive)
  (let ((inhibit-message t)) (shell-command "tmux run 'a beep warning'")))

(defun my/beep-d ()
  (interactive)
  (let ((inhibit-message t)) (shell-command "tmux run -b 'a beep warning'"))
  nil
  ;; (bd a/beep) ; frustratingly, this method does not work, because of no tty i think
  )
(defalias 'my/beep 'my/beep-d)
(defalias 'a/beep 'my/beep-d)



(defun do-lines (fun &optional start end)
  "Invoke function FUN on the text of each line from START to END."
  (interactive
   (let ((fn (intern (completing-read "Function: " obarray 'functionp t))))
     (if (use-region-p)
         (list fn (region-beginning) (region-end))
       (list fn (point-min) (point-max)))))
  (save-excursion
    (goto-char start)
    (while (< (point) end)
      (funcall fun (buffer-substring (line-beginning-position) (line-end-position)))
      (forward-line 1))))




;; Pure elisp sha512
(defun sha512 (object &optional start end binary)
  "Return the SHA512 of an OBJECT.
OBJECT is either a string or a buffer. Optional arguments START and
END are character positions specifying which portion of OBJECT for
computing the hash.  If BINARY is non-nil, return a string in binary
form."
  ;; md5
  ;; sha1
  ;; sha224
  ;; sha256
  ;; sha384
  ;; sha512
  ;; Emacs has some builtin hash functions, but I should make everything myself to learn it.
  ;; (secure-hash 'sha1 object start end binary)
  (secure-hash 'sha512 object start end binary))


(defun test-virtmic (mp3_path)
  (interactive))

(defun mp42mkv (path_input)
  "Converts an mp4 into an mkv. Use this when streaming to another computer and I need to watch it as it's streaming."
  (interactive)
  ;; I thought about using sed here, but this is probably better because for performance
  (defvar path_output (concat path_input ".mkv"))
  (bash (concat "ffmpeg -i " path_input " -vcodec copy " path_output)))


;; [[https://stackoverflow.com/questions/24565068/emacs-text-is-read-only?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa][lisp - (Emacs) Text is read only? - Stack Overflow]]
;; Useful as temporary hack to fix slime repl.
(defun set-region-writeable (begin end)
  "Removes the read-only text property from the marked region."
  ;; See http://stackoverflow.com/questions/7410125
  (interactive "r")
  (let ((modified (buffer-modified-p))
        (inhibit-read-only t))
    (remove-text-properties begin end '(read-only t))
    (set-buffer-modified-p modified)))


(defun cider-connect-tmux ()
  "Scrapes the port from the tmux window and connects to cider"
  (interactive)
  (let ((port
         (sh-notty "tm cat-pane localhost_current:lein-repl.0 | sed -n '/on port \\([0-9]\\+\\)/ s/.*on port \\([0-9]\\+\\).*/\\1/p' | s chomp")))

    (cider-connect "localhost" port "$HOME/notes2018/ws/clojure/scratch/")))


;; ;; (ignore-errors (kill-buffer "*cider-repl tstprjclj*"))

;; Not using this anymore. Instead, I'm waiting for this to be ready
;; localhost_ws_clojure_scratch:cider-jack-in-default.0
(defun clojure-cheatsheet-boot ()
  "Not using this anymore"
  (interactive)
  (ignore-errors (kill-buffer "*cider-repl localhost*"))
  (cider-connect-tmux)
  (ignore-errors (clojure-cheatsheet)))


(defun py/install-file ()
  "Install a single python file as a module"

  )


(defun switch-to-previous-buffer ()
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))

;; (defun print-elements-of-list (list)
;;   "Print each element of LIST on a line of its own."
;;   (while list
;;     (print (car list))
;;     (setq list (cdr list))))


(_ns convert

     (defun my/list-to-string (list)
       (string-join list "\n")))

;; This non-functional way of doing it is less readable to me
;; (defun scriptnames ()
;;   "Show the scripts loaded by emacs on startup."
;;   (loop for l in load-history
;;         for path = (first l)
;;         when (string-match-p "\.el$" path)
;;         collect path))


(defun te (input)
  (with-output-to-temp-buffer "tvipe" (pp input)))


(defun ns (s_message &optional from_clipboard)
  "This runs notify send."
  ;; (if (not s_message)
  ;;     (setq s_message "nil"))
  (let ((cmd "ns")
        (mess (or s_message
                  "nil")))
    (if from_clipboard
        (setq cmd (concat cmd " -clip")))
    (e/chomp (sh-notty cmd (e/chomp (str mess))))
    s_message))


(defun my/repl-py (args)
  "Switch to the python repl."
  (interactive "P")
  (if (not (buffer-exists "*Python"))
      (progn (run-python)
             ;; (sleep 1)
             ))
  (switch-to-buffer "*Python*")
  ;; (let ((shackle-mode -1))
  ;;   (switch-to-buffer-other-window "*Python*"))
  )


(defun my/repl-common-lisp (args)
  "Switch to the lisp repl."
  (interactive "P")
  ;; (slime)
  ;; (switch-to-buffer-other-window "*slime-repl sbcl*")
  (switch-to-buffer "*slime-repl sbcl*"))


(_ns control-structures
     (defmacro tryelse (thing &optional otherwise)
       "Try to run a thing. Run something else if it fails. expanding this macro, error is not a function. it's an error type pattern"
       `(condition-case nil ,thing (
                                    ;; Error, here is not the function error
                                    error ,otherwise)))
     (defalias 'tryonce 'tryelse)
     ;; (tryelse (error "ho") "foo")
     ;; (tryelse "hi" "foo")

     ;; (if (tryelse nil t) (message "%s" "hi"))
     ;; (if (tryelse t t) (message "%s" "hi"))


     ;; Recursive?
     (defmacro try-cascade-sugar (&rest list-of-alternatives)
       "Try to run a thing. Run something else if it fails."
       `(try-cascade '(,@list-of-alternatives)))


     ;; TODO Ensure that if the last one errors, I still get an error
     ;; This is probably better written as a recursive function
     (defun try-cascade (list-of-alternatives)
       "Try to run a thing. Run something else if it fails."
       ;; (list2str list-of-alternatives)

       (let* ((failed t)
              (result
               (catch 'bbb
                 (dolist (p list-of-alternatives)
                   ;; (message "%s" (list2str p))
                   (let ((result nil))
                     (tryelse
                      (progn
                        (setq result (eval p))
                        (setq failed nil)
                        (throw 'bbb result))
                      result))))))
         (if failed
             (error "Nothing in try succeeded")
           result)))



     ;; (cl-loop for buf in (buffer-list) collect (buffer-file-name buf))
     ;; ;; This loop inserts the phrase “Yowsa” twenty times in the current
     ;; ;; buffer.
     ;; (cl-loop repeat 20 do (insert "Yowsa\n"))
     ;; ;; This loop calls munch-line on every line until the end of the buffer.
     ;; ;; If point is already at the end of the buffer, the loop exits
     ;; ;; immediately.
     ;; (cl-loop until (eobp) do (munch-line) (forward-line 1))
     ;; ;; This loop is similar to the above one, except that munch-line is
     ;; ;; always called at least once.
     ;; (cl-loop for x from 1 to 100
     ;;          for y = (* x x)
     ;;          until (>= y 729)
     ;;          finally return (list x (= y 729)))


     ;; `(condition-case nil ,thing (error ,otherwise))
     ;; (try-cascade (error "a") "b" (error "c") "d")

     ;; (try-cascade (error "ho") (error "cool") "yo")

     (defalias 'try 'try-cascade-sugar)

     ;; I'd like to make this work and fix handle-references
     (defmacro try-deselected-and-maybe-reselect (&rest body)
       `(progn
          (let ((p (point))
                (m (mark))
                (s (selected-p)))
            (deselect)
            (expand-macro `(try
                            ;; Try this, otherwise, reselect
                            (progn
                              ,,@body)
                            (progn
                              (set-mark m)
                              (goto-char p)
                              ,(if s
                                   '(activate-mark)
                                 '(deactivate-mark))
                              (error "try-deselected-and-maybe-reselect failed")))))))

     ;; (try (error "yo") nil "hil")
     ;; (try (error "ho") (error "cool") "yo")
     ;; (try (error "ho") "yo" (error "cool"))
     ;; (try (error "ho") "yo" (error "cool") "dang")
     ;; (try-cascade '((error "ho") (error "cool") "yo"))
     )

(defun my/repl-for-current-mode ()
  "Go to the repl for the appropriate dialect based on the current mode."
  (interactive)
  (cond ((derived-mode-p
          'clojure-mode
          'cider-repl-mode
          'inf-clojure)
         (condition-case nil
             (cider-doc-thing-at-point)
           (error
            (message "%s"
             "You may need to enable the default cider jack-in repl"))))
        ((derived-mode-p 'slime-mode)
         (my/repl-common-lisp))
        ((derived-mode-p 'python-mode)
         (my/repl-py))
        ((derived-mode-p 'hy-mode)
         (hy-shell-start-or-switch-to-shell))
        ((derived-mode-p 'racket-mode)
         ;; (racket-doc)
         (racket-repl))
        ((derived-mode-p
          'emacs-lisp-mode)
         (ielm))
        (t
         (let ((my/lisp-mode nil))
           (execute-kbd-macro
            (kbd "C-c C-z"))))))


;; Not working for me
(defun get-key-combo (key)
  "Just return the key combo entered by the user"
  (interactive "kKey combo: ")
  key)


(defun keymap-unset-key (key keymap)
  "Remove binding of KEY in a keymap
    KEY is a string or vector representing a sequence of keystrokes."
  (interactive
   (list (call-interactively #'get-key-combo)
         (completing-read "Which map: " minor-mode-map-alist nil t)))
  (let ((map (rest (assoc (intern keymap) minor-mode-map-alist))))
    (when map
      (define-key map key nil)
      (message "%s unbound for %s" key keymap))))
;;
;; Then use it interativly
;; Or like this:
;; (keymap-unset-key  (kbd "d[")   "lispy-mode")
;; (keymap-unset-key  '[C-M-left]   "paredit-mode")



(defun go-which-if-selected ()
  (interactive)

  (let ((my/lisp-mode nil))
    (execute-kbd-macro (kbd "e"))))



(defun my/magit-blame-toggle()
  "WORKAROUND https://github.com/magit/magit/issues/1987"
  (interactive)
  (let* ((active (--filter (and (boundp it) (symbol-value it)) minor-mode-list)))
    (if (member 'magit-blame-mode active)
        (magit-blame-quit)
      (magit-blame nil buffer-file-name))))


;; Can't use =ekm= here, but I can use the same technique
(defun my/enter-edit ()
  "Runs 'tvipe' if a region is selected."
  (interactive)
  (if (region-active-p)
      (tvipe (my/selected-text))
    ;; Disabling =my-mode= isnt enough for custom
    (if (derived-mode-p 'Custom-mode)
        (call-interactively 'Custom-newline)
      ;; Custom-newline
      (let ((my-mode nil)
            (fun (key-binding (kbd "C-m"))))
        (if fun
            (call-interactively fun)
          (execute-kbd-macro (kbd "C-m")))))))

;; Can't  use my-load in my-utils.el because glob is not defined yet
;; (my-load "$MYGIT/spacemacs/layers/+emacs/better-defaults/funcs.el")
(load "/home/shane/source/git/spacemacs/layers/+emacs/better-defaults/funcs.el")

(defun my/c-w-cut ()
  "Cuts the word before cursor if a region is not selected, and performs regular C-w instead if there is a region"
  (interactive)
  (if (not (region-active-p))
      (call-interactively 'spacemacs/backward-kill-word-or-region)
    ;; (evil-delete-backward-word)
    (let ((my-mode nil))
      (execute-kbd-macro (kbd "C-w")))))

(defun my/m-w-copy ()
  "Forward word if a region is not selected."
  (interactive)
  (if (not (or (region-active-p) (lispy-left-p)))
      ;; (call-interactively 'my/evil-evil-forward-word-begin-unmark)
      ;; (call-interactively 'evil-forward-WORD-begin)
      (progn-noadvice
       ;; (ad-deactivate 'evil-forward-word-begin) ;Not even this works
       (advice-remove 'evil-forward-word-begin #'my/doc-thing-at-point)
       (call-interactively 'evil-forward-WORD-begin)
       (advice-add 'evil-forward-word-begin :after #'my/doc-thing-at-point))
    (let ((my-mode nil))
      (execute-kbd-macro (kbd "M-w"))))
  (deselect))


(defun symbols2strings (list-of-symbols)
  (mapcar 'symbol2string list-of-symbols))
(defalias 'syms2strs 'symbols2strings)

(defun symbols2string (list-of-symbols)
  (mapconcat 'identity (mapcar 'symbol2string list-of-symbols) "\n"))
(defalias 'syms2str 'symbols2string)

(defun list2strs (mylist)
  (mapcar 'str mylist))

;; This is not recursive. What about a list of lists?
;; Instead of mapping str, map something which tests if it is a list first
;; Also, I need a list2str but one which joins all lines
(defun list2str (&rest mylist)
  (if (equalp 1 (length mylist))
      (setq mylist (car mylist)))
  (mapconcat 'identity (mapcar 'str mylist) "\n"))
(defalias 'list2lines 'list2str)
(defalias 'lines2str 'list2str)
;; (list2str music-extensions)

(defun my-lookup-key (key)
  "Search for KEY in all known keymaps. Returns a list of symbols."
  (mapcar 'string2symbol (split-string (with-output-to-string
                                         (mapatoms (lambda (ob) (when (and (boundp ob) (keymapp (symbol-value ob)))
                                                             (when (functionp (lookup-key (symbol-value ob) key))
                                                               ;; (message "%S" ob)
                                                               (princ (format "%s\n" ob)))))
                                                   obarray))
                                       "\n")))

(defun fun (path)
  (interactive (list (read-string "path:")))
  "docstring"

  (if (string-empty-p path) (setq path "defaultval"))

  (let ((result (e/chomp (sh-notty (concat "ci yt-list-playlist-urls " (e/q path))))))
    (if (called-interactively-p 'any)
        ;; (message "%s" result)
        (new-buffer-from-string result)
      result)))

;; Keep in mind that this narrows the buffer.
;; That means you stay in the same mode.
;; That's not what I want if I am editing a string.
;; It's good for org-mode.
(defun my/enter-edit-emacs (args)
  "Opens region in a new buffer if a region is selected. If an argument is provided then the C-m falls through."
  (interactive "P")
  (if (region-active-p)
      (progn
        ;; (narrow-to-region)
        ;; (ekm "C-x n n")
        (recursive-narrow-or-widen-dwim)

        ;; ;; narrow indrect didnt work
        ;; (ni-narrow-to-region-indirect-other-window
        ;;  (region-beginning)
        ;;  (region-end)
        ;;  (point)
        ;;  "*narrow indirect*"
        ;;  nil
        ;;  'MSGP)

        (deselect))
    ;; (tvipe nil "sp")
    (let ((my-mode nil)
          (global-map org-mode-map))
      (if (eolp)
          (ekm "M-C-m")
        (progn
          (delete-horizontal-space)
          (newline)
          (c-indent-line-or-region)
          ;; (ekm "M-\ C-m TAB")
          )))

    ;; Did not work
    ;; (unwind-protect
    ;;     (progn (define-key my-mode-map (kbd "M-RET") nil)
    ;;            (let ((global-map org-mode-map)
    ;;                  ;; (define-key my-mode-map (kbd "M-RET") nil)
    ;;                  (my-mode -1))
    ;;              (if (is-spacemacs)
    ;;                  (tsk "M-C-m")
    ;;                ;; (execute-kbd-macro (kbd "M-C-m"))
    ;;                (execute-kbd-macro (kbd "M-C-m")))))
    ;;   (progn (define-key my-mode-map (kbd "M-RET") #'my/enter-edit-emacs)
    ;;          (my-mode 1)))

    ;; (let ((my-mode nil))
    ;;   (execute-kbd-macro (kbd "M-C-m"))
    ;;   ;; Neither of these ways will work
    ;;   ;; (execute-kbd-macro (kbd "M-C-m"))
    ;;   ;; (tsk "M-C-m") ; This causes infinite loop because it doesnt wait for the send
    ;;   )
    ))


(_ns go
     (defun GoWhich ()
       (interactive)
       (sh-notty
        "tm -f -tout -S sph open"
        (my/selected-text)))

     (defun go-locate ()
       (interactive)
       (if (region-active-p)
           (let ((rstart (region-beginning))
                 (rend (region-end)))
             (shell-command-on-region rstart rend "tsph \"f locate\""))))

     (defun go-which ()
       (interactive)
       (if (region-active-p)
           (let ((rstart (region-beginning))
                 (rend (region-end)))
             (shell-command-on-region rstart rend "tsph \"f which\""))
         (progn (ekm "M-r M-g M-w") (deselect)))))


(_ns local-variables
     (defun yanked ()
       "Simply return the last string that was copied."

       ;; Use current-kill instead of kill-ring: [[https://stackoverflow.com/questions/22960031/save-yanked-text-to-string-in-emacs][elisp - Save yanked text to string in Emacs - Stack Overflow]]
       (current-kill 0)
       ;; (car kill-ring)
       )
     (defalias 'my/clipboard-string 'yanked)

     (defun my/print-current-line ()
       "Print current line."
       (interactive)
       (message "%s" (thing-at-point 'symbol)))

     (defun region-or-buffer-string ()
       (interactive)
       (if (or (region-active-p) (eq evil-state 'visual))
           (str (buffer-substring (region-beginning) (region-end)))
         (str (buffer-substring (point-min) (point-max)))))
     (defalias 'selection-or-buffer-string 'region-or-buffer-string)

     (defun my/selected-text ()
       "Just give me the selected text as a string. If it's empty, then nothing was selected. region-active-p does not work for evil selection."
       (interactive)
       (cond
        ((or (region-active-p) (eq evil-state 'visual))
         (str (buffer-substring (region-beginning) (region-end))))
        (iedit-mode
         (iedit-current-occurrence-string))))
     (defalias 'get-selection 'my/selected-text)
     (defalias 'selection 'my/selected-text)
     (defalias 'selected-text 'my/selected-text)

     (defun my/delete-selected-text ()
       (interactive)
       (delete-region (region-beginning) (region-end))
       (deactivate-mark))
     (defalias 'delete-selected-text 'my/delete-selected-text)

     (defun my/buffer-text ()
       "Just give me the buffer's text as a string."
       (interactive)
       (str (buffer-substring (point-min) (point-max))))

     ;; This is different to (my/pwd)
     (defun cwd ()
       "Gets the current working directory"
       (interactive)
       ;; (cd (get-dir))
       ;; This must be fast
       (substring (shut-up-c (pwd)) 10)
       ;; (try
       ;;  (substring (shut-up-c (pwd)) 10)
       ;;  (f-full "."))
       )

     (defun get-current-path ()
       "Gets the current path name."
       (interactive)
       buffer-file-name)

     (defalias 'current-path 'get-current-path))


(defun kill-buffer-and-reopen ()
  (interactive)
  ;; I need goto-point because save-excursion doesn't work with .gz files
  (let ((p (point)))
    (ignore-errors
      (save-mark-and-excursion
        (remove-overlays (point-min) (point-max))
        ;; When it reverts, it may rebuttonize
        (revert-buffer nil t)))
    (goto-char p))

  ;; (let ((pos (point)))
  ;;   (save-excursion
  ;;     (with-current-buffer
  ;;         (revert-buffer nil t)))
  ;;   (goto-char pos))

  ;; The following worked when undo-tree was on
  (never
   (if (not (current-path))
       (save-temp-if-no-file))
   (let ((pos (point))
         (path (current-path))
         (b (current-buffer)))
     (if (f-exists-p path)
         (progn
           (kill-buffer b)
           ;; (let ((bb (find-file path)))
           ;;   (etv bb))
           ;; (with-current-buffer
           ;;     (find-file path))
           (with-current-buffer
               (find-file path)
             (goto-char pos)
             ;; (eval '(generate-glossary-buttons-over-buffer nil nil t))

             ;; This is actually necessary
             ;; (eval '(redraw-glossary-buttons-when-window-scrolls-or-file-is-opened))
             (run-buttonize-hooks)

             (message "%s" (concat "killed + reloaded: " (mnm path)))
             ;; (recenter-top-bottom)

             ;; (ekm "C-l C-l")

             ;; This was ok, but it's more seamless to not have it, particularly when I have that position resuming package working
             ;; (recenter-top)
             ))))))


(_ns local-variable-derivatives
     (defun my/new-filename-with-extension (ext)
       "Generates a new filename based on the current filename but with a different extension"
       (concat (file-name-sans-extension (buffer-file-name)) "." ext)))



(setq global-variables-list
      '(system-name))

(_ns global-variables
     (defun scriptnames ()
       "Show the scripts loaded by emacs on startup."
       (interactive)
       (my/list-to-string (scriptnames-list))
       ;; (tvipe (mnm (my/list-to-string (scriptnames-list))))
       )

     (defun scriptnames-goto ()
       ""
       (e (fz (mnm (scriptnames))))
       )

     (defun scriptnames-string ()
       "Show the scripts loaded by emacs on startup."
       (interactive)
       (mnm (my/list-to-string (scriptnames-list))))


     (defun scriptnames-list ()
       "Show the scripts loaded by emacs on startup."
       (remove '() (mapcar
                    (lambda (string)
                      (if (string-match-p "\.el$" string) string))
                    (mapcar 'car load-history))))

     (defun scriptnames-all ()
       "Show the scripts and symbols loaded by emacs on startup."
       load-history)

     ;; This doesn't do what I want
     ;; (defalias 'scriptnames 'load-history)

     (defun my/screenwidth ()
       "Gets the screen width."
       (sh-notty "op screenwidth"))

     (defun my/tvipe-package-list ()
       "Show the list of packages in vim."
       (interactive)
       (tvipe (my/list-of-packages))))



(_ns utils
     (defun my/pwgen ()
       "Generates a password."
       (interactive)
       (message "%s" (concat "Copied: " (sed "s/./\*/g" (xc (b pwgen 20 1 | s chomp)))))))



(defun get-dir ()
  "Gets the directory of the current buffer's file. But this could be different from emacs' working directory.
Takes into account the current file name."
  ;; When thits works, replace all these in this flie
  ;; (file-name-directory buffer-file-name)

  ;; Need a try catch on file-name-directory

  ;; Can't do this because of infinite loop
  ;; (be u dn buffer-file-name)
  ;; (let* ((inhibit-message t)
  ;;        (filedir (if buffer-file-name
  ;;                     (file-name-directory buffer-file-name)
  ;;                   (file-name-directory (my/pwd)))))
  ;;        (if (s-blank? filedir)
  ;;            (my/pwd)
  ;;          filedir))
  (shut-up-c
   (let ((filedir (if buffer-file-name
                      (file-name-directory buffer-file-name)
                    (file-name-directory (cwd)))))
     (if (s-blank? filedir)
         (cwd)
       filedir))))
(defalias 'my/pwd 'get-dir)

;; (cd (get-dir))


;; (my/apply-to-region 'capitalize)
;; (my/apply-to-region 'fz)
(defun replace-region (s)
  "Apply the function to the selected region. The function must accept a string and return a string."
  (let ((rstart (if (region-active-p) (region-beginning) (point-min)))
        (rend (if (region-active-p) (region-end) (point-max)))
        (was_selected (selected-p))
        (deactivate-mark nil))

    (if buffer-read-only
        (progn
          (message "buffer is readonly. placing in temp buffer")
          (nbfs s))
      (progn
        (let ((doreverse (< (point) (mark))))
          (delete-region
           rstart
           rend)
          (insert s)

          (if doreverse
              (call-interactively 'cua-exchange-point-and-mark)))

        (if (not was_selected)
            (deselect))))))

(defmacro flash-region (&rest body)
  `(let ((fg "#00aa00")
         (bg "#006600")
         (fg_blue "#5555ff")
         (bg_blue "#2222bb")
         (fg_purple "#ff55ff")
         (bg_purple "#bb22bb")
         (fg_limegreen "#55ff55")
         (bg_limegreen "#22bb22")
         (fg_yellow "#ffff55")
         (bg_yellow "#bbbb22")
         (fg_orange "#ffA500")
         (bg_orange "#996200"))

     (set-face-foreground 'region fg_limegreen)
     (set-face-background 'region bg_limegreen)
     ;; (redraw-display)

     ;; This makes the change of face visible
     (sit-for 0.05)

     (let ((r ,@body))
       (set-face-foreground 'region fg)
       (set-face-background 'region bg)
       ;; (redraw-display)
       r)))

(defun my/apply-to-region (func)
  "Apply the function to the selected region. The function must accept a string and return a string."
  (let ((rstart (if (region-active-p) (region-beginning) (point-min)))
        (rend (if (region-active-p) (region-end) (point-max))))

    (let ((res ;; (funcall func (buffer-substring rstart rend))
           (flash-region
            (ptw func (buffer-substring rstart rend)))))
      (replace-region res))))
(defalias 'region-filter 'my/apply-to-region)
(defalias 'rfilter 'my/apply-to-region)


(defun my/date ()
  (format-time-string "%a %b %e %H:%M:%S %Z %Y"))

(defun my/date-insert ()
  (interactive)
  (insert (my/date)))

(defun my/thing-at-point (&optional only-if-selected)
  (interactive)

  ;; (require 'cl-extra)
  ;; (str (symbol-at-point))
  (if (and only-if-selected
           (not (selected-p)))
      nil
    (if (or (selected-p)
            iedit-mode)
        (my/selected-text)
      (str
       (or (thing-at-point 'symbol)
           (thing-at-point 'sexp)
           (let ((s (str (thing-at-point 'char))))
             (if (string-equal s "\n")
                 ""
               s))
           "")))))

;; Used in fz, ivy, helm,
(defun default-search-string ()
  (if (selectionp)
      (selection)
    (if (or (major-mode-p 'dired-mode)
            (major-mode-p 'ranger-mode))
        nil
      (my/thing-at-point))))

(defun eack (thing)
  (interactive)
  (sph (concat "eack " (q thing))))

(defun dack-top (thing)
  (interactive)
  (sph (concat "cd \"$(vc get-top-level)\" && pwd" "; " "dack " (q thing))))

(defun eack-top (thing)
  (interactive)
  (sph (concat "cd \"$(vc get-top-level)\" && pwd" "; " "eack " (q thing))))

(defun dack-selection-top ()
  (interactive)
  (if (selected-p)
      (dack-top (selection))
    (dack-top (my/thing-at-point))))

(defun eack-selection-top ()
  (interactive)
  (if (selected-p)
      (eack-top (concat "\\b" (selection) "\\b"))
    (eack-top (concat "\\b" (my/thing-at-point) "\\b"))))
(defalias 'eack-thing-top 'eack-selection-top)

(defun eack-selection ()
  (interactive)
  (if (selected-p)
      (eack (selection))
    (eack (my/thing-at-point))))
(defalias 'eack-thing 'eack-selection)

(defun eack-thing-in-parent-dir ()
  (interactive)
  (s/cd ".."
        (sph (concat "eack " (q (my/thing-at-point))))))

(defun open-date-orgs ()
  (interactive)
  ;; gr: elisp open list of files
  )

(defun open-org (uri)
  "This takes a string. It could be a url or a file path. And it turns the thing into org-mode. Then opens in emacs."
  (interactive)
  (find-file (bl open-org uri)))

(defun shorten-org-markdown ()
  (interactive)
  (cfnb "shorten-org-markdown"))

(defun unarchive-slack-message-url ()
  (interactive)
  (cfnb "unarchive-slack-message-url"))

;; Filter region through this
(defun snake-case2camel-case ()
  (interactive)
  (fp "snake-case2camel-case"))

(defun win-swap ()
  "Swap windows using buffer-move.el"
  (interactive)
  (if (null (windmove-find-other-window
             'right))
      (buf-move-left)
    (buf-move-right)))

(defun change-file-extension (&optional ext)
  (interactive (list (fz '(python-py
                           haskell-hs
                           shell-sh
                           zshell-zsh
                           racket-rkt
                           expect-exp
                           common-lisp-cl
                           problog
                           awk
                           tcl))))
  (save-temp-if-no-file)
  (save-buffer)
  (if (not (empty ext))
      (let* ((ext (e/chomp (bp sed "s/.*-//" ext)))
             (newpath (e/chomp (concat (sed "s/\\..*//" (buffer-file-path)) "." ext))))
        (my-rename-file-and-buffer (e/chomp (bp xa basename (str newpath)))))))

;; Re-define this so it actually works
(defun kill-this-buffer ()
  (interactive)
  (kill-buffer (current-buffer)))

(defun save-annotations-on-buffer-killed ()
  (if (major-mode-p 'dired-mode)
      (shut-up (annotate-save-annotations))))

;; (add-hook 'kill-buffer-hook 'save-annotations-on-buffer-killed)

;; (defset kill-buffer-hook nil)
(add-hook 'kill-buffer-hook 'save-annotations-on-buffer-killed)
;; (remove-hook-ignore 'kill-buffer-hook 'save-annotations-on-buffer-killed)
;; (remove-hook 'kill-buffer-hook 'save-annotations-on-buffer-killed)


(defun kill-this-buffer-volatile (&optional buffer-name)
  "Kill current buffer, even if it has been modified."
  (interactive)
  (if buffer-name
      (switch-to-buffer buffer-name))
  (set-buffer-modified-p nil)
  (if (and (local-variable-p 'kill-window-when-done)
           kill-window-when-done)
      (my-kill-buffer-and-window)
    (kill-this-buffer)))
(defalias 'kill-buffer-immediately 'kill-this-buffer-volatile)

(defmacro expand-result (body)
  "Do not return anything."
  ;; body
  (let ((result (eval body)))
    `(,@result)))
(defalias 'er 'expand-result)

;; (er (make-list 5 '(defun fun (args) "docstring" (interactive "P"))))

(defun cscope-gen ()
  "Regenerate cscope and ctags from the top level"
  (interactive)
  (b cscope_gen.sh 2>&1))

(defun find-thing (thing)
  (interactive)
  (if (stringp thing)
      (setq thing (str2sym thing)))
  (try (find-function thing)
       (find-variable thing)
       (find-face-definition thing)
       (ns (concat (str thing) " is neither function nor variable"))))
(defalias 'j 'find-thing)
(defalias 'ft 'find-thing)
;; (find-thing "position-list-next")


;; (require 'ht)
;; (let ((h (ht))
;;       (l completing-read-hist-github-query-))
;;   ;; (cl-loop for e in l do
;;   ;;          (message e)
;;   ;;          ;; (ht-set h)
;;   ;;          ;; (buffer-file-name buf)
;;   ;;          )
;;   ;; l
;;   l)


;; Remember: For ivy, M-u M-j will use the current text and ignore the candidates
(defun completing-read-hist (prompt &optional initial-input histvar default-value)
  "read-string but with history."
  ;; ignoring default-value for the moment
  ;; It should be the thing under cursor
  (if (not histvar)
      (setq histvar (str2sym (concat "completing-read-hist-" (slugify prompt)
                                     ;; (if initial-input (concat "-" initial-input) "")
                                     ))))

  (setq prompt (sor prompt ":"))

  (if (not (re-match-p " $" prompt))
      (setq prompt (concat prompt " ")))

  (initvar histvar)
  (message-no-echo (concat "Using histvar " (sym2str histvar)))
  (if (and (not initial-input)
           (listp histvar))
      (setq initial-input (first histvar)))
  (eval `(progn
           ;; (str (completing-read ,prompt ,histvar nil nil initial-input ',histvar nil))
           (let ((inhibit-quit t))
             (or (with-local-quit
                   ;; def is like a better initial-input
                   ;; (str (completing-read ,prompt ,histvar nil nil initial-input (cons ',histvar 2) nil))
                   ;; ivy-completing-read-with-empty-string-def
                   (let ((completion-styles ;; '(basic partial-completion emacs22)
                          '(basic))
                         ;; (str (ivy-completing-read-with-empty-string-def ,prompt ,histvar nil nil initial-input ',histvar nil))
                         ;; my-ivy-completing read doesn't escape +
                         (s (str (my-ivy-completing-read ,prompt ,histvar nil nil initial-input ',histvar nil))))

                     ;; This uniqify is not necessary with ivy
                     (setq ,histvar (seq-uniq ,histvar 'string-equal))
                     s)
                   ;; (str (helm-comp-read ,prompt ,histvar :initial-input ,initial-input :must-match nil :history ,histvar :input-history ',histvar))
                   ;; (str (helm-comp-read ,prompt nil :initial-input ,initial-input :must-match nil :history ,histvar :input-history ',histvar))
                   )
                 "")))))
(defalias 'read-string-hist 'completing-read-hist)
(defalias 'rshi 'completing-read-hist)
;; (read-string-hist "myprompt$ " 'mytesthist)

(defalias 'region2string 'buffer-substring)

(defmacro dff (&rest body)
  "This defines a 0 arity function with name based on the contents of the function.
It should only really be used to create names for one-liners.
It's really meant for key bindings and which-key, so they should all be interactive."
  ;; The mnm here was killing emacs loading
  (let* ((slugsym (str2sym (slugify ;; (mnm (pp body))
                            (pp body) t))))
    `(defun ,slugsym () (interactive) ,@body)))


;; (cmd2list "hello there \"noob noob\"")
(defun cmd2list (cmd)
  (str2list (cl-sn (concat "args2lines " cmd) :chomp t)))

(defun list2cmd-eval (l)
  (mapconcat 'q-eval l " "))

(defun bs-dollar (input)
  (bs "$" input))

(defun list2cmd-posix (l)
  ;; (setq l (mapcar 'bs-dollar l))
  ;; (cl-sn (bs-dollar (concat "cmd-posix " (mapconcat 'qf l " "))) :chomp t)
  (cl-sn (concat "cmd-posix " (mapconcat 'qf l " ")) :chomp t))

(defun list2cmd (l)
  ;; (setq l (mapcar 'bs-dollar l))
  ;; (cl-sn (bs-dollar (concat "cmd-real " (mapconcat 'qf l " "))) :chomp t)
  (cl-sn (concat "cmd-real " (mapconcat 'qf l " ")) :chomp t)
  )
(defalias 'l2c 'list2cmd)
(defalias 'cmdl 'list2cmd)

(defun ecmd (&rest args)
  (e/chomp (s-join " " (mapcar 'e/q args))))

(defun cmd (&rest args)
  (list2cmd args))
(defalias 'aqf 'cmd)

(defun cmd-posix (&rest args)
  (list2cmd-posix args))
(defalias 'aqf-posix 'cmd-posix)
(defalias 'aqfp 'cmd-posix)
(defalias 'cmdp 'cmd-posix)

(defun acmd (arglist)
  (apply 'cmd arglist))

(defun tv-env ()
  (interactive)
  (tv (snc (cmd "env"))))

(provide 'my-utils-1)

(load "/home/shane/var/smulliga/source/git/config/emacs/config/my-utils.2.el")

(provide 'my-utils)