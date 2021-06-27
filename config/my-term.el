;; https://oremacs.com/2015/01/01/three-ansi-term-tips/

;; my-mode is disabled from term
;; but global mode bindings that are under M-l should work

:; I had to load later
:; vim +/"after-window-setup-body" "$EMACSD/select-distribution.el"

;; I think require 'term fucks everything up
;; (require 'term)

(setq explicit-shell-file-name "/bin/bash")

;; This is the way
;; I can't abolish C-c from all the minor modes
;; But at least I can control it.
(define-prefix-command 'my-term-c-c)
(define-prefix-command 'my-term-c-x)
(define-prefix-command 'my-term-c-c-esc)

(defun term-raw-or-kill ()
  (interactive)
  (if (not (term-check-proc (current-buffer)))
      ;; (message "term-raw-or-kill kill-buff")
      (kill-buffer)
    (progn
      (shut-up-c (message "sending C-d"))
      (term-send-raw))))


(defun term-send-function-key ()
  (interactive)
  (let* ((char last-input-event)
         (output (cdr (assoc (str char) term-function-key-alist))))
    (term-send-raw-string output)))

(defconst term-function-key-alist `(("f1" . ,(read-kbd-macro "<ESC> OP"))
                                    ("80" . ,(read-kbd-macro "<ESC> OP"))
                                    ("f2" . ,(read-kbd-macro "<ESC> OQ"))
                                    ("81" . ,(read-kbd-macro "<ESC> OQ"))
                                    ("f3" . ,(read-kbd-macro "<ESC> OR"))
                                    ("82" . ,(read-kbd-macro "<ESC> OR"))
                                    ("f4" . ,(read-kbd-macro "<ESC> OS"))
                                    ("83" . ,(read-kbd-macro "<ESC> OS"))
                                    ;;("f2" . "\eOQ")
                                    ;;("f3" . "\eOR")
                                    ;;("f4" . "\eOS")
                                    ))


(defun my-term-paste ()
  (interactive)
  (if (>= (prefix-numeric-value current-prefix-arg) 4)
      (term--xterm-paste)
    (term-paste)))


(defun my-term-set-raw-map ()
  (interactive)
  (let* ((map (make-keymap))
         (esc-map (make-keymap))
         (i 0))

    (define-key map (kbd "C-c") #'my-term-c-c)
    ;; (define-key map (kbd "<xterm-paste>") #'my-term-paste)
    (define-key map (kbd "C-x") #'my-term-c-x)
    (define-key map (kbd "C-c ESC") #'my-term-c-c-esc)

    ;; Send the function key to terminal
    (dolist (spec term-function-key-alist)
      (define-key map
        (read-kbd-macro (message (format "C-c <%s>" (car spec))))
        'term-send-function-key))

    (while (< i 128)
      ;; if not C-c
      (if (not (or (equalp i 3)
                   (equalp i 24)))
          (define-key map (make-string 1 i) #'term-send-raw))

      (define-key map (concat "\C-c" (make-string 1 i)) 'term-send-raw)
      ;; Avoid O and [. They are used in escape sequences for various keys.
      (unless (or (eq i ?O) (eq i 27) (eq i 91))
        (define-key esc-map (make-string 1 i) 'term-send-raw-meta))
      (setq i (1+ i)))
    (define-key map [remap self-insert-command] 'term-send-raw)
    (define-key map "\e" esc-map)
    (define-key esc-map (make-string 1 27) #'term-send-raw) ;;Send ESC, not M-ESC

    ;; Added nearly all the 'gray keys' -mm

    (if (featurep 'xemacs)
        (define-key map [button2] 'term-mouse-paste)
      (define-key map [mouse-2] 'term-mouse-paste))
    (define-key map (kbd "C-p") 'term-send-raw)
    (define-key map [up] 'term-send-up)
    (define-key map [down] 'term-send-down)
    (define-key map [right] 'term-send-right)
    (define-key map [left] 'term-send-left)
    (define-key map [C-up] 'term-send-ctrl-up)
    (define-key map [C-down] 'term-send-ctrl-down)
    (define-key map [C-right] 'term-send-ctrl-right)
    (define-key map [C-left] 'term-send-ctrl-left)
    (define-key map [delete] 'term-send-del)
    (define-key map [deletechar] 'term-send-del)
    (define-key map [backspace] 'term-send-backspace)
    (define-key map [home] 'term-send-home)
    (define-key map [end] 'term-send-end)
    (define-key map [insert] 'term-send-insert)
    (define-key map [S-prior] 'scroll-down)
    (define-key map [S-next] 'scroll-up)
    (define-key map [S-insert] 'term-paste)
    (define-key map [prior] 'term-send-prior)
    (define-key map [next] 'term-send-next)
    ;; (define-key map [xterm-paste] #'term--xterm-paste)
    (define-key map [xterm-paste] #'my-term-paste)
    (define-key map (kbd "C-d") 'term-raw-or-kill)
    (setq term-raw-map map)
    (setq term-raw-escape-map esc-map))
  (define-key term-raw-map (kbd "M-l") nil)
  (define-key term-raw-map (kbd "M-=") 'my-handle-repls)
  ;; I want M-x to transmit through
  ;; (define-key term-raw-map (kbd "M-x") nil)
  (define-key term-raw-map (kbd "C-c ESC") #'my-term-c-c-esc)
  (define-key term-raw-map (kbd "C-c M-l") #'term-send-raw-meta)
  (define-key term-raw-map (kbd "C-c C-c") #'term-send-raw)
  (define-key term-raw-map (kbd "C-c M-Y") #'clean-repl)
  (define-key term-raw-map (kbd "C-c C-M-i") #'my-company-complete)
  (define-key term-raw-map (kbd "C-c M-;") #'term-send-raw-meta)
  (define-key term-raw-map (kbd "C-c M-m") #'term-send-raw-meta)

  ;; Super
  (define-key term-raw-map (kbd "C-M-^") nil)
  ;; Hyper
  (define-key term-raw-map (kbd "C-M-\\") nil)

  (define-key term-raw-map (kbd "C-c o") #'tm-edit-v-in-nw)
  (define-key term-raw-map (kbd "C-c O") #'tm-edit-vs-in-nw)
  (define-key term-raw-map (kbd "C-c M-:") #'pp-eval-expression)
  (define-key term-raw-map (kbd "C-c M-x") #'helm-M-x)
  (define-key term-raw-map (kbd "C-x C-x") #'term-send-raw)
  (define-key term-raw-map (kbd "<backtab>") (lambda () (interactive) (term-send-raw-string "[Z")))
  ;; (define-key term-raw-map (kbd "C-s") #'term-line-mode)
  (define-key term-raw-map (kbd "C-c C-j") #'term-line-mode)
  (define-key term-raw-map (kbd "C-c C-h") #'describe-mode)
  (define-key term-raw-map (kbd "C-c h") #'evil-scroll-left)
  (define-key term-raw-map (kbd "C-c H") #'evil-scroll-left)
  ;; (define-key term-raw-map (kbd "C-c z H") #'evil-scroll-left)
  (define-key term-raw-map (kbd "C-c l") #'evil-scroll-right)
  (define-key term-raw-map (kbd "C-c L") #'evil-scroll-right)
  (define-key term-raw-map (kbd "C-c Y") #'term-get-line-at-point)
  ;; (define-key term-raw-map (kbd "C-c z L") #'evil-scroll-right)
  (define-key term-raw-map (kbd "C-d") 'term-raw-or-kill)
  (define-key term-raw-map (kbd "C-c M-q v") #'open-in-vim)
  (define-key term-raw-map (kbd "C-c M-q V") #'e/open-in-vim)
  (define-key term-raw-map (kbd "C-c M-q M-V") #'e/open-in-vim)
  (define-key term-raw-map (kbd "C-c M-q M-v") #'open-in-vim) ;This is like vim's M-q M-m for opening in emacs in the current pane
  )

(define-key term-mode-map (kbd "C-c o") #'tm-edit-v-in-nw)
(define-key term-mode-map (kbd "C-c O") #'tm-edit-vs-in-nw)

(defun term-around-advice (proc &rest args)
  (my-term-set-raw-map)
  (let ((res (apply proc args)))
    res))
(advice-add 'term :around #'term-around-advice)

;; Not sure why this is not sufficient
(my-term-set-raw-map)


(term-set-escape-char ?✓)


;; Not sure why this doesn't work
;; ;; nadvice - proc is the original function, passed in. do not modify
;; (defun term-handle-exit-around-advice (proc &rest args)
;;   (let ((res (apply proc args)))
;;     (fundamental-mode)
;;     res))
;; (advice-add 'term-handle-exit :around #'term-handle-exit-around-advice)


(defvar termframe nil)

(defun set-termframe (frame)
  "Frame is obtained from the method which calls this function"
  ;; (defvar-local termframe (selected-frame))
  ;; (defvar termframe (selected-frame))
  ;; (makunbound 'termframe)
  ;; (message (concat "setting " (str frame) " in " (str newtermbuf)))
  (message (concat "setting " (str frame)))
  (with-current-buffer "*scratch*"
    (setq termframe frame))
  ;; (message (concat "getting " (str termframe)))
  ;; (if (variable-p 'newtermbuf)
  ;;     ;; Sometimes newtermbuf is old
  ;;     (ignore-errors (with-current-buffer newtermbuf
  ;;                      (defset termframe frame)
  ;;                      )))
  ;; (remove-hook 'after-make-frame-functions 'set-termframe)
  )

;; this makes it look like this is a regular hook list, which it isn't
;; The thing which calls the functions in =after-make-frame-functions= also supplies
;; the frame as a parameter
(add-hook 'after-make-frame-functions 'set-termframe)

(defun my/term (program &optional closeframe modename buffer-name reuse)
  (interactive (list (read-string "program:")))
  (if (and buffer-name reuse (get-buffer buffer-name))
      (switch-to-buffer buffer-name)
    (with-current-buffer (term program)
      ;; (message (concat "term " (str termframe)))
      (if closeframe
          ;; (defset-local termframe-local (with-current-buffer "*scratch*" termframe))
          (defset-local termframe-local termframe))
      ;; (if (string-equal program "midnight-commander")
      ;;     (mc-minor-mode))

      ;; If mode exists for this command then use it
      (let ((modefun (str2sym (concat (slugify (or modename program)) "-term-mode"))))
        (if (function-p modefun)
            (funcall modefun)))

      (if buffer-name
          (rename-buffer buffer-name t))
      ;; (add-hook 'after-make-frame-functions 'set-termframe)
      ;; (switch-to-buffer (current-buffer))
      )))
(defalias 'et 'my/term)

;; (defun term (program &optional closeframe)
;;   "Start a terminal-emulator in a new buffer.
;; The buffer is in Term mode; see `term-mode' for the
;; commands to use in that buffer.

;; \\<term-raw-map>Type \\[switch-to-buffer] to switch to another buffer."
;;   (interactive (list (read-from-minibuffer "Run program: "
;;                                            (or explicit-shell-file-name
;;                                                (getenv "ESHELL")
;;                                                shell-file-name))))
;;   (set-buffer (make-term "terminal" program))
;;   (term-mode)
;;   (term-char-mode)
;;   ;; (defset newtermbuf (switch-to-buffer "*terminal*"))
;;   ;; (if closeframe
;;   ;;     (defset-local termframe-local (with-current-buffer "*scratch*" termframe))
;;   ;;     ;; (add-hook 'after-make-frame-functions 'set-termframe)
;;   ;;   )
;;   )


;; This runs when it starts for sure. Perhaps it no longer runs when its done
;; It used to, I think. I'm not sure what has caused the sentinel to be ignored.
;; No, this is simply being ignored
;; Something is overriding the sentinel value
;; This was overriding it
;; vim +/"(set-process-sentinel proc 'ignore) ; This removes the \"finished.\" message." "$EMACSD/config/my-subr.el"
;; vim +/";; I have disabled the 'ignore for the sentinel" "$EMACSD/config/my-subr.el"
;; This works. In spacemacs, however, the process sentinel is set but erased
;; Perhaps there is something in spacemacs force the ignore
;; 'ignore is also used to ignore messages from when processes finish completely independent of term.
;; The default process sentinel creates that message. So I simply need to overide it.
(defun oleh-term-exec-hook ()
  ;; (message "oleh-term-exec-hook()")
  (let* ((buff (current-buffer))
         (proc (get-buffer-process buff)))
    ;; (message (concat "setting " (str buff) " " (str proc)))
    (set-process-sentinel
     proc
     ;; This lambda is equal to what I would get if i used ignore, above
     ;; `(lambda
     ;;    (proc change)
     ;;    (message (concat "term event " proc " " change))
     ;;    (if
     ;;        (string-match "\\(finished\\|exited\\)" change)
     ;;        (progn
     ;;          (message "exiting")
     ;;          (kill-buffer
     ;;           (process-buffer proc))
     ;;          (if
     ;;              (>
     ;;               (count-windows)
     ;;               1)
     ;;              (progn
     ;;                (delete-window))))))
     `(lambda (process event)
        ;; (message (concat "term event " event))
        (if (string-match "\\(finished\\|exited\\)" event)
            ;; (string= event "finished\n")
            (progn
              (shut-up-c (message "finished"))
              (if (and (variable-p 'termframe-local)
                       termframe-local)
                  (progn
                    (delete-frame termframe-local t)
                    (with-current-buffer ,buff (ignore-errors (kill-buffer-and-window))))
                (with-current-buffer ,buff (ignore-errors
                                             ;; because termframe-local, doesn't exist, use my-kill-buffer-and-window as it wont kill the frame if it's the last window
                                             (my-kill-buffer-and-window))))))))

    ;; (message (concat "setting " (str buff) " " (str proc) " " (str (process-sentinel (get-buffer-process (current-buffer))))))
    ))

(add-hook 'term-exec-hook 'oleh-term-exec-hook)
;; (remove-hook 'term-exec-hook 'oleh-term-exec-hook)


(defun my-term-use-utf8 ()
  (set-buffer-process-coding-system 'utf-8-unix 'utf-8-unix))

(add-hook 'term-exec-hook 'my-term-use-utf8)


(defun my-term-set-scroll-margin ()
  (make-local-variable 'hscroll-margin)
  (setq hscroll-margin 0)
  (make-local-variable 'scroll-margin)
  (setq scroll-margin 0)
  (make-local-variable 'scroll-conservatively)
  (setq scroll-conservatively 10000))

(add-hook 'term-mode-hook #'my-term-set-scroll-margin)

;; (remove-hook 'term-mode-hook #'my-term-set-scroll-margin)

(define-key term-mode-map (kbd "M-r") nil)
;; (define-key term-mode-map (kbd "C-c C-a") #'term-send-raw)
;; (define-key term-mode-map (kbd "C-c C-x") #'term-send-raw)

(defun term-send-binding ()
  "Send the last binding typed through the terminal-emulator
without any interpretation."
  (interactive)
  (term-send-raw-string (this-command-keys)))

;; (fmakunbound 'term-set-escape-char)
;; (defun term-set-escape-char (key)
;;   )

;; (defun term-handle-exit (process-name msg)
;;   "Write process exit (or other change) message MSG in the current buffer."
;;   (message (concat "Process " process-name " " msg))
;;   (let ((buffer-read-only nil)
;; 	      (omax (point-max))
;; 	      (opoint (point)))
;;     ;; Remove hooks to avoid errors due to dead process.
;;     (remove-hook 'pre-command-hook #'term-set-goto-process-mark t)
;;     (remove-hook 'post-command-hook #'term-goto-process-mark-maybe t)
;;     ;; Record where we put the message, so we can ignore it
;;     ;; later on.
;;     (goto-char omax)
;;     (insert ?\n "Process " process-name " " msg)
;;     ;; Force mode line redisplay soon.
;;     (force-mode-line-update)
;;     (when (and opoint (< opoint omax))
;;       (goto-cha
;;        r opoint))))

;; (defun term-sentinel (proc msg)
;;   "Sentinel for term buffers.
;; The main purpose is to get rid of the local keymap."
;;   (message "sentinel")
;;   (message (concat "sentinel " (str proc) " " msg))
;;   (let ((buffer (process-buffer proc)))
;;     (when (memq (process-status proc) '(signal exit))
;;       (if (null (buffer-name buffer))
;;           ;; buffer killed
;; 	        (set-process-buffer proc nil)
;; 	      (with-current-buffer buffer
;;           ;; Write something in the compilation buffer
;;           ;; and hack its mode line.
;;           ;; Get rid of local keymap.
;;           (use-local-map nil)
;;           (term-handle-exit (process-name proc) msg)
;;           ;; Since the buffer and mode line will show that the
;;           ;; process is dead, we can delete it now.  Otherwise it
;;           ;; will stay around until M-x list-processes.
;;           (delete-process proc))))))

;; (defun term-exec (buffer name command startfile switches)
;;   "Start up a process in buffer for term modes.
;; Blasts any old process running in the buffer.  Doesn't set the buffer mode.
;; You can use this to cheaply run a series of processes in the same term
;; buffer.  The hook `term-exec-hook' is run after each exec."
;;   (message (concat "term-exec " (str buffer) " " name " command"))
;;   (with-current-buffer buffer
;;     (let ((proc (get-buffer-process buffer))) ; Blast any old process.
;;       (when proc (delete-process proc)))
;;     ;; Crank up a new process
;;     (let ((proc (term-exec-1 name buffer command switches)))
;;       (make-local-variable 'term-ptyp)
;;       (setq term-ptyp process-connection-type) ; t if pty, nil if pipe.
;;       ;; Jump to the end, and set the process mark.
;;       (goto-char (point-max))
;;       (set-marker (process-mark proc) (point))
;;       (set-process-filter proc 'term-emulate-terminal)
;;       (set-process-sentinel proc 'term-sentinel)
;;       ;; Feed it the startfile.
;;       (when startfile
;;         ;;This is guaranteed to wait long enough
;;         ;;but has bad results if the term does not prompt at all
;;         ;;	     (while (= size (buffer-size))
;;         ;;	       (sleep-for 1))
;;         ;;I hope 1 second is enough!
;;         (sleep-for 1)
;;         (goto-char (point-max))
;;         (insert-file-contents startfile)
;; 	      (term-send-string
;; 	       proc (delete-and-extract-region (point) (point-max)))))
;;     (run-hooks 'term-exec-hook)
;;     buffer))

;; I understand this was originally used to
;; add the stop undef and start undef, which was
;; solved another way I think, but I have also a
;; need for unset TTY

(defun term-exec-1 (name buffer command switches)
  ;; We need to do an extra (fork-less) exec to run stty.
  ;; (This would not be needed if we had suitable Emacs primitives.)
  ;; The 'if ...; then shift; fi' hack is because Bourne shell
  ;; loses one arg when called with -c, and newer shells (bash,  ksh) don't.
  ;; Thus we add an extra dummy argument "..", and then remove it.
  (let ((process-environment
	 (nconc
	  (list
	   (format "TERM=%s" term-term-name)
	   (format "TERMINFO=%s" data-directory)
	   (format term-termcap-format "TERMCAP="
		   term-term-name term-height term-width)

	   (format "INSIDE_EMACS=%s,term:%s" emacs-version term-protocol-version)
	   (format "LINES=%d" term-height)
	   (format "COLUMNS=%d" term-width))
	  process-environment))
	(process-connection-type t)
	;; We should suppress conversion of end-of-line format.
	(inhibit-eol-conversion t)
	;; The process's output contains not just chars but also binary
	;; escape codes, so we need to see the raw output.  We will have to
	;; do the decoding by hand on the parts that are made of chars.
	(coding-system-for-read 'binary))
    (when (term--bash-needs-EMACSp)
      (push (format "EMACS=%s (term:%s)" emacs-version term-protocol-version)
            process-environment))
    (apply #'start-process name buffer
	   "/bin/sh" "-c"
	   (format "stty stop undef; stty start undef; unset TTY; stty -nl echo rows %d columns %d sane 2>/dev/null; if [ $1 = .. ]; then shift; fi; exec \"$@\"" term-height term-width)
	   ".."
	   command switches)))


;; (defadvice ansi-term (after advice-term-line-mode activate)
;;   (term-line-mode))


(defun disable-modes-for-term ()
  (interactive)
  (progn
    (global-display-line-numbers-mode -1)
    (global-hide-mode-line-mode 1)
    (visual-line-mode -1)
    (fringe-mode -1))

  (my-mode -1))

;; (remove-hook 'term-mode-hook #'disable-modes-for-term)
;; (add-hook 'term-load-hook #'disable-modes-for-term)
;; (remove-hook 'term-load-hook #'disable-modes-for-term)

(defun term-around-advice (proc &rest args)
  (let ((res (apply proc args)))
    (disable-modes-for-term)
    res))
(advice-add 'term :around #'term-around-advice)

;; (load (concat emacsdir "/manual-packages/eterm-256color/eterm-256color.el"))
(use-package eterm-256color
  :ensure t)
(add-hook 'term-mode-hook #'eterm-256color-mode)

;; Not sure why this is required for spacemacs
(defun disable-ivy-mode ()
  (interactive)
  (setq-local ivy-mode nil))

(add-hook 'term-mode-hook 'disable-ivy-mode)

(if (cl-search "SPACEMACS" my-daemon-name)
    (progn
      (remove-hook 'term-mode-hook 'ansi-term-handle-close)))

(defun realign-term-window ()
  (interactive)

  (set-window-margins (selected-window) 0 0)
  (set-window-hscroll (selected-window) 0)
  (set-window-vscroll (selected-window) 0))

;; This fixes the scrolling for rat
;; But I bet it doesn't fix it for DF
(defun term-move-columns (delta)
  (setq term-current-column (max 0 (+ (term-current-column) delta)))
  (let ((point-at-eol (line-end-position)))
    (move-to-column term-current-column t)
    ;; If move-to-column extends the current line it will use the face
    ;; from the last character on the line, set the face for the chars
    ;; to default.
    (when (> (point) point-at-eol)
      (put-text-property point-at-eol (point) 'font-lock-face 'default)))

  ;; This is almost a fix
  (realign-term-window)
  ;; it's not a total fix. The margin still appears from time to time

  ;; TODO Find a way to keep the column within
  ;; (window-body-width)

  ;; (window-total-width)
  ;; (frame-width)

  ;; (window-vscroll)
  ;; (window-hscroll)
  ;; (set-window-vscroll (selected-window) 0)
  ;; (set-window-hscroll (selected-window) 0)
  ;; (set-fringe-mode '(0 . 0))
  ;; (window-margins) ;this must be changed to (nil) from (1)
  ;; Running git-gutter+-mode removed the margin/fringe/whatever it is

  ;; This corrects it:
  ;; But the terminal is still badly drawn
  ;; (set-window-margins (selected-window) 0 0)
  ;; (set-window-hscroll (selected-window) 0)
  ;; (set-window-vscroll (selected-window) 0)

  ;; Keep in mind that the columns may have not even
  ;; If I call this every time then the screen will get messed up
  ;; (call-interactively 'evil-scroll-left)
  )


;; petridishteam.slack.com

(defun term-get-line-at-point ()
  (interactive)
  (let* ((row (+ (term-current-row) 1))
         (col (term-current-column))
         (buf (new-buffer-from-string (buffer-contents)))
         (height term-height)
         (linecontents (with-current-buffer buf
                         (let ((nbackhistory (- (count-lines (point-min) (point-max)) height)))
                           ;; term-height
                           (goto-line (+ row nbackhistory))
                           (move-to-column col t)
                           (thing-at-point 'line)))))
    (kill-buffer buf)
    (my/copy (chomp linecontents) t)
    linecontents))


;; Hopefully this doesn't slow emacs to much
(defun insert-around-advice (proc &rest args)
  (if (major-mode-p 'term-mode)
      (dolist (s args)
        (term-send-raw-string s))
    (let ((res (apply proc args)))
      res)))
(advice-add 'insert :around #'insert-around-advice)
(advice-remove 'insert #'insert-around-advice)


(provide 'my-term)