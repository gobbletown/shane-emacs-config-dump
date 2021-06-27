(require 'my-mode)

;; See also:
;; j:my-list-of-tuis

;; my-term-modes.el comes before my-term.el
;; (require 'my-term)

;; (my/function-exists 'esh-chkservice)

;; Enable this again when it starts working

(defset my-term-modes-commands '(tmux
                                 asciimation
                                 ncdu br
                                 octotui
                                 gpg-tui
                                 tig
                                 github-stats
                                 gq vim
                                 rubiks_cube k9s
                                 chkservice lazydocker
                                 rat irssi
                                 nano mc
                                 weechat sen
                                 zsh dive
                                 tpb df-bay12)
  "A list of commands to create term minor modes for")

(defun make-etui-cmd (cmd closeframe)
  "This function expects a one term command (binary name only) and it returns a new interactive function."
  (let ((funname (concat "esh-" cmd)))
    (eval `(defun ,(str2sym funname) (&rest args)
             "This function expects a one term command (binary name only)."
             (interactive)
             (term-nsfa (mapconcat 'q (cons ,cmd args) " ") nil ,cmd ,closeframe)))))

(defmacro defcmdmode (cmd &optional cmdtype)
  (setq cmd (str cmd))
  (setq cmdtype (or cmdtype "term"))
  (let* ((cmdslug (slugify (str cmd)))
         (modestr (concat cmdslug "-" cmdtype "-mode"))
         (modesym (str2sym modestr))
         (mapsym (str2sym (concat modestr "-map"))))
    `(progn
       (defvar ,mapsym (make-sparse-keymap)
         ,(concat "Keymap for `" modestr "'."))
       (defvar-local ,modesym nil)

       (define-minor-mode ,modesym
         ,(concat "A minor mode for the '" cmd "' " cmdtype " command.")
         :global nil
         :init-value nil
         :lighter ,(s-upcase cmdslug)
         :keymap ,mapsym)
       (provide ',modesym))))

(defun make-or-run-etui-cmd (cmd &rest args)
  (interactive (list (read-string "Command name:")))
  (let* ((funname (concat "esh-" cmd))
         ;; (fnsym (str2sym funname))
         (fnsym
          ;; Force overwrite
          (make-etui-cmd cmd t)
          ;; (if (my/function-exists fnsym)
          ;;     fnsym
          ;;   (make-etui-cmd cmd))
          ))
    (eval `(defcmdmode ,cmd))
    (eval `(,fnsym ,@args))))

;; Reenable this

;; TODO This should be implicit and creating bindings for programs in term should require no extra work
(defalias 'midnight-commander-term-mode 'mc-term-mode)

(defset my-term-modes
  (cl-loop for cmd in my-term-modes-commands collect (eval `(defcmdmode ,cmd))))

(defalias 'v-term-mode 'vim-term-mode)
(defalias 'vs-term-mode 'vim-term-mode)

;; We don't want a global mode
;; (define-globalized-minor-mode global-mc-minor-mode mc-minor-mode mc-minor-mode)

(defun zsh-copy-previous-line ()
  (interactive)
  (my/copy (sh-notty "tail -n 2 | head -n 1" (buffer-string))))

(define-key zsh-term-mode-map (kbd "C-c M-1") 'zsh-copy-previous-line)

(define-key sen-term-mode-map (kbd "M-<") (lm (ekm "<home>")))
(define-key sen-term-mode-map (kbd "M->") (lm (ekm "<end>")))
(define-key dive-term-mode-map (kbd "q") (lm (ekm "C-c C-c")
                                          ;; (tsk "C-c")
                                             ))
(define-key dive-term-mode-map (kbd "h") (lm (ekm "C-i")))
(define-key dive-term-mode-map (kbd "l") (lm (ekm "C-i")))
(define-key dive-term-mode-map (kbd "j") (lm (ekm "<down>")))
(define-key dive-term-mode-map (kbd "k") (lm (ekm "<up>")))

;; This is definitely a bad solution
(define-key mc-term-mode-map (kbd "<up>") (lm (tsk "C-p")))
(define-key mc-term-mode-map (kbd "<down>") (lm (tsk "C-n")))
(define-key mc-term-mode-map (kbd "M-n") (lm (term-send-raw-meta) (message "This worked but did you mean <down>?")))
(define-key mc-term-mode-map (kbd "M-p") (lm (term-send-raw-meta) (message "This worked but did you mean <up>?")))
;; (define-key mc-term-mode-map (kbd "<right>") (lm (tsk "M-3")))
(define-key mc-term-mode-map (kbd "<left>") (lm (tsk "PgUp")))
(define-key mc-term-mode-map (kbd "<right>") (lm (tsk "PgDn")))

(define-key df-bay12-term-mode-map (kbd "M-!") (lm (tsk "Bob")))

;; M-F1
(define-key vim-term-mode-map (kbd "<f49>") (lm (ekm "ZQ")))
;; M-F2
(define-key vim-term-mode-map (kbd "<f52>") (lm (ekm "ZQ")))

;; (define-key rat-term-mode-map (kbd "<down>") (lm (ekm "j")))
(define-key rat-term-mode-map (kbd "<down>") (kbd "j"))
(define-key rat-term-mode-map (kbd "<up>") (kbd "k"))

(define-key rat-term-mode-map (kbd "C-n") (lm (ekm "j j j j j")))
(define-key rat-term-mode-map (kbd "C-p") (lm (ekm "k k k k k")))

(define-key rat-term-mode-map (kbd "<next>") (lm (ekm "C-f")))
(define-key rat-term-mode-map (kbd "<prior>") (lm (ekm "C-b")))

(define-key rat-term-mode-map (kbd "M-<") (lm (ekm "g g")))
(define-key rat-term-mode-map (kbd "M->") (lm (ekm "G")))

;; (define-key asciimation-term-mode-map (kbd "q") (lm (ekm "C-\\ C-n : q C-m")))

;; I had to disable asciimation-term-mode for the macro to go through
;; Because q is bound
(define-key asciimation-term-mode-map (kbd "q") (lm
                                                 (let ((asciimation-term-mode nil))
                                                   (ekm "C-\\ C-n : q C-m"))))

(defun tm-get-window ()
  (chomp (sh-notty "TMUX= tmux display-message -p '#{window_id}' 2>/dev/null")))

(defun tm-get-pane ()
  (chomp (sh-notty "TMUX= tmux display-message -p '#{pane_id}' 2>/dev/null")))

;; x doesnt work without a tty, so i use (sh). i need to fix that
;; (lm (sh (concat "x -tma \"" (tm-get-window) "\" -s \"222\"")))

(defun df-test ()
    (interactive)
  (sh
   (concat "x -tma \"" (tm-get-window) "\""
           " -s \"222\""
           " -c m"
           " -sl 0.5"
           ;; " -e raw"
           " -c m")))

(defun df-browse ()
    (interactive)
  (sh
   (concat "x -tma \"" (tm-get-window) "\""
           " -s 2"
           " -sl 0.5"
           " -s 222"
           " -c m"
           " -sl 1"
           " -c m")))

(defun df-create-world ()
    (interactive)
  (sh
   (concat "x -tma \"" (tm-get-window) "\""
           " -se 222"
           " -sl 0.2"
           " -s 8"
           " -c m"
           " -e \"to continue\""
           " -sl 1"
           " -s \"\\\\\""
           " -e \"Enter title\""
           " -se t"
           " -s Shane"
           " -c m")))

;; (define-key df-bay12-term-mode-map (kbd "M-@") (lm (sh (concat "x -tma \"" (tm-get-window) "\" -s \"222\""))))

(define-key df-bay12-term-mode-map (kbd "M-@") #'df-test)
(define-key df-bay12-term-mode-map (kbd "M-#") #'df-browse)
(define-key df-bay12-term-mode-map (kbd "M-$") #'df-create-world)

(defun tpb-enable-syntax-highlighting ()
  (interactive)
  (set (make-local-variable 'tpb-term-font-lock-keywords)
       ;; '(("\\_<\\(720\\|1080\\|2019\\)\\_>" . font-lock-function-name-face)
       ;;   ("\\_<\\(Magnet\\S[0-9]+E[0-9]+\\)\\_>" . font-lock-constant-face))
       '(
         ;; J 270
         ;; Not sure if works. It does but it's naive
         ;; ("\"[^\"]+?\"" 0 font-lock-string-face keep t)
         ;; This works
         ;; ("([^)]+?)" 0 font-lock-string-face keep t)
         ;; Works
         ;; ("J" 0 font-lock-string-face keep t)
         ;; This works but it doesn't override the existing syntax highlighting
         ("\\(J\\|T\\)" 0 font-lock-string-face keep t)
         ("\\(720\\|1080\\|2019\\)" . font-lock-function-name-face)
         ("\\(Magnet\\|S[0-9]+E[0-9]+\\)" . font-lock-constant-face)))
  ;; (font-lock-add-keywords nil tpb-term-font-lock-keywords 3)

  (if (fboundp 'font-lock-flush)
      (font-lock-flush)
    (when font-lock-mode
      (with-no-warnings (font-lock-fontify-buffer)))))

;; In theory this should work
;; But these highlights can't override existing highlights
;; Therefore, I must find a way to disable term-mode's font-lock
(defun init-tpb-term-mode ()
  (interactive))

(add-hook 'tpb-term-mode-hook #'init-tpb-term-mode)

(defun tpb-next-magnet ()
  (interactive)
  (if (looking-at-p "Magnet")
      (ekm "C-f"))
  (ekm "C-s Magnet C-m")
  ;; The sleep is needed because the program updates asynchronously
  (sleep 0 200)
  (if (looking-at-p "agnet")
      (ekm "C-b"))
  (hl-line-mode -1)
  (hl-line-mode 1))

(defun tpb-prev-magnet ()
  (interactive)
  (ekm "C-r Magnet C-m")
  (sleep 0 200)
  (hl-line-mode -1)
  (hl-line-mode 1))

(define-key tpb-term-mode-map (kbd "M-n") #'tpb-next-magnet)
(define-key tpb-term-mode-map (kbd "M-p") #'tpb-prev-magnet)

;; Make some x scripts for df
;; x -tma '@1485' -s "222"\

(defun tmux-copy-pane-initial-command ()
  (interactive)
  (chomp (sh "tm copy-pane-command | cat" nil t)))

(defun tmux-copy-pane-initial-command-full ()
  (interactive)
  (chomp (sh "tm-copy-pane-cmd | cat" nil t)))

(defun tmux-copy-pane-current-command-full ()
  "Copy the current command and the working directory"
  (interactive)
  (chomp (sh "tm-copy-pane-cmd | cat" nil t)))

(defun string2kbm (s)
  (interactive (list (read-string "literal:")))
  (switch-to-buffer "*scratch*")
  (with-current-buffer "*scratch*"
    (call-interactively 'kmacro-start-macro)
    (tsl s)
    (sleep 1)
    (call-interactively 'kmacro-end-macro))

  (last-kbd-macro-string))

(defun e/chomp-all (str)
  "Chomp leading and tailing whitespace from STR for each line."
  (while (string-match "\\`\n+\\|^\\s-+\\|\\s-+$\\|\n+\\'"
                       str)
    (setq str (replace-match "" t t str)))
  str)

(defun e/chomp (str)
  "Chomp (remove tailing newline from) STR."
  (replace-regexp-in-string "\n\\'" "" str))

(defun type-keys (s)
  "Type out the string"
  (interactive (list (read-string "string:")))
  (ekm (make-kbd-from-string s)))
(defalias 'ekl 'type-keys)

(defun make-kbd-from-string (s)
  (let ((quoted-string (let ((print-escape-newlines t))
                         (prin1-to-string s))))
    (chomp (eval `(ci (sh (concat "ci emacs-string2kbm " (q ,s)) nil t))))))

(defun make-kbd-from-string-nodeps (s)
  (let ((quoted-string (let ((print-escape-newlines t))
                         (prin1-to-string s)))
        (tf (make-temp-file "emacskbm" nil ".exp")))

    (ignore-errors (with-temp-buffer
                     (insert (concat
                              "outfile=/tmp/emacskbm.txt\n"
                              "rm -f \"$outfile\"\n"
                              "\n"
                              "cat > /tmp/emacskbm.exp <<HEREDOC\n"
                              "if { \\$argc >= 1 } {\n"
                              "    set literal [lindex \\$argv 0]\n"
                              "}\n"
                              "\n"
                              "spawn sh\n"
                              "send -- \"emacs -Q -nw\"\n"
                              "send -- \\015\n"
                              "expect -exact \"scratch\"\n"
                              "send -- \\030\n"
                              "send -- \"(\"\n"
                              "send -- \"\\$literal\"\n"
                              "send -- \\030\n"
                              "send -- \")\"\n"
                              "send -- \\033:\n"
                              "send -- \"(with-temp-buffer (insert (replace-regexp-in-string \\\"^Last macro: \\\" \\\"\\\" (kmacro-view-macro))) (write-file \\\"$outfile\\\"))\"\n"
                              "send -- \\015\n"
                              "send -- \\033:\n"
                              "send -- \"(kill-emacs)\"\n"
                              "send -- \\015\n"
                              "send -- \\004\n"
                              "interact\n"
                              "HEREDOC\n"
                              "\n"
                              "{\n"
                              "expect -f /tmp/emacskbm.exp \"$@\"\n"
                              "} &>/dev/null\n"
                              "tmux wait-for -S emacskbm\n"))
                     (write-file tf)))

    (shell-command (concat "tmux neww -t localhost_current: -d bash " tf " " quoted-string "; tmux wait-for emacskbm"))
    (e/chomp (with-temp-buffer
               (insert-file-contents "/tmp/emacskbm.txt")
               (buffer-string)))))

(defun irssi-search-channels (pattern)
  (interactive (list (read-string "pattern:")))
  ;; The 7th window is probably a freenode window
  (snc "tm sel localhost_im:irssi")
  (ekm "M-7")
  (ekm "C-a C-k")
  ;; (insert "/msg alis LIST * -topic github")
  (ekm (edmacro-format-keys (concat "/msg alis LIST * -topic " pattern)))
  (ekm "C-m")
  (ekm (edmacro-format-keys "/query alis"))
  (ekm "C-m"))

(define-key irssi-term-mode-map (kbd "M-/") #'irssi-search-channels)

(define-key br-term-mode-map (kbd "C-h") (lm (ekm "DEL")))
;; (define-key br-term-mode-map (kbd "C-h") (lm (tsk "DC")))




(defun term-get-url-at-point ()
  (interactive)
  (my/copy (sh/xurls (term-get-line-at-point)) t))


(define-key nano-term-mode-map (kbd "M-u") #'term-get-url-at-point)

(defun rubiks-randomize ()
  (interactive)
  (sh
   (concat "x -tma " (q (tm-get-window))
           " -s m"
           " -sl 0.5"
           " -e Resume"
           ;; " -s \"<down>\""
           " -down"
           " -c m"
           " -e Enter"
           " -s " (q (random 50))
           " -c m")))

;; (setq rubiks-cube-term-mode-map (make-sparse-keymap))

;; Don't use vim nav, use ijkl
(define-key rubiks-cube-term-mode-map (kbd "w") (lm (ekm (s-join " " (-repeat 8 "<up>")))))
(define-key rubiks-cube-term-mode-map (kbd "s") (lm (ekm (s-join " " (-repeat 8 "<down>")))))
(define-key rubiks-cube-term-mode-map (kbd "a") (lm (ekm (s-join " " (-repeat 8 "<left>")))))
(define-key rubiks-cube-term-mode-map (kbd "d") (lm (ekm (s-join " " (-repeat 8 "<right>")))))

(defun tsrs (st)
  (let* ((l (s-split "" st t))
         (i 0)
         (g (length l)))
    (cl-loop for s in l
             do
             (setq i (+ 1 i))
             (if (not (equal 1 i))
                 (sleep 0.5))
             (term-send-raw-string s))))

(defun rubiks-left-trigger ()
  (interactive)
  (tsrs "ruR"))

(defun rubiks-right-trigger ()
  (interactive)
  (tsrs "LUl"))

(defun spinz ()
  (interactive)
  (term-send-raw-string "z"))

(defun spinz-inv ()
  (interactive)
  (term-send-raw-string "Z"))

(define-key rubiks-cube-term-mode-map (kbd "q") 'rubiks-left-trigger)
(define-key rubiks-cube-term-mode-map (kbd "e") 'rubiks-right-trigger)
(define-key rubiks-cube-term-mode-map (kbd "z") 'rubiks-randomize)
(define-key rubiks-cube-term-mode-map (kbd "x") 'spinz)
(define-key rubiks-cube-term-mode-map (kbd "X") 'spinz-inv)

;; (define-key hte-term-mode-map (kbd "<Esc>") (lm (tsk "<Esc>")))
;; (define-key hte-term-mode-map (kbd "<Esc>") nil)

(provide 'my-term-modes)