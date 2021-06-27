(require 'my-utils-1)

;; (region-pipe "tm filter")
;; (region-filter 'capitalize)
;; (region-filter (lambda (input) (bp s field 2 | s chomp input)))
(defun region-pipe (cmd)
  (interactive (list (read-string "shell filter:")))
  "pipe region through shell command"
  ;; Sadly, cfilter breaks the mark
  (if (not cmd)
      (setq cmd "tm filter"))
  (region-filter (lambda (input) (sh-notty (concat cmd) input))))
(defalias 'cfilter 'region-pipe)

(defun my/fwfzf ()
  "This will pipe the selection into fzf filters, replacing the original region. If no region is selected, then the entire buffer is passed read only."
  ;; (if (my/selected-text))
  ;; (my/selected-text)
  (interactive)
  (if (region-active-p)
      (if (>= (prefix-numeric-value current-prefix-arg) 4)
          ;; (my/apply-to-region (lambda (input) (sh-notty (concat "tm filter") input)))
          (region-pipe "tm filter")
        (region-pipe (chomp (esed " #.*" ""
                                  (fz
                                   (cat "$HOME/filters/filters.sh")
                                   nil nil "my/fwfzf: ")))))
    ;; (my/nil (sh-notty (concat "tm -tout filter") (buffer-contents)))
    (my/nil (sh-notty (concat "tm -f -S -tout nw -noerror " (q "f filter-with-fzf") " &") (buffer-contents)))

    ;; (shell-command (concat "tm filter") t)
    ;;(sh (concat "tm filter") (buffer-contents) nil)
    ;; (sh-notty (concat "tm filter | tvipe") (buffer-contents))
    ;; (shell-command (concat "tm -te -d nw \"f filter-with-fzf \\\"" buffer-file-name "\\\"\" 1>/dev/null 2>/dev/null &") t)
    ))

(defun rt-from-region ()
  "Start an rtcmd with the current region as input"
  (interactive)
  (if (selected-p)
      (nwp "rtcmd awk '{$2 = gensub("$", " |", "g", $2); print $0}'" (selection))
    ;; (nwp "rtcmd cat" (selection))
    ))


(defun fzf-on-buffer ()
  (interactive)
  (shell-command-on-region
   (point-min) (point-max)
   (concat "tm -S -tout nw 'fzf --sync | tm -S -soak -tout nw v'")))


(defun show-ctags-for-buffer ()
  (interactive)
  ;; (nw (concat "ctags-hr " (q buffer-file-name) " | sp"))
  (new-buffer-from-string (sn (concat "ctags-hr " (q buffer-file-name)))))


(defun my/open-thing-at-point ()
  (interactive)
  (setq path
        (str (if mark-active
                 (buffer-substring (region-beginning) (region-end))
               (thing-at-point 'filename))))
  (bl tm -f -d sph -fargs open path)
  (deactivate-mark))


;; (make-frame-command)

(defvar new-buffer-hooks '())

;; (defun my-new-buffer-frame ()
;;   "Create a new frame with a new empty buffer."
;;   (interactive)
;;   (let ((buffer (generate-new-buffer "*untitled*")))
;;     (set-buffer-major-mode buffer)
;;     (display-buffer buffer '(display-buffer-pop-up-frame . nil))))
(defun my-new-buffer-frame (&optional contents bufname mode nodisplay)
  "Create a new frame with a new empty buffer."
  (interactive)
  (if (not bufname)
      (setq bufname "*untitled*"))
  (let ((buffer (generate-new-buffer bufname)))
    (set-buffer-major-mode buffer)
    ;; (display-buffer buffer '(display-buffer-pop-up-frame . nil))
    (if (not nodisplay)
        (display-buffer buffer '(display-buffer-same-window . nil)))
    (with-current-buffer buffer
      (if contents (insert (str contents)))
      (company-mode 1)
      (beginning-of-buffer)
      ;; A hack to get the modeline to not display -- though this makes huge delays if there is docker, aws, etc.
      (ignore-errors (toggle-chrome))
      (ignore-errors (toggle-chrome))
      (if mode (call-function mode))
      (run-hooks 'new-buffer-hooks))
    buffer))
(defalias 'new-buffer-from-string 'my-new-buffer-frame)
(defalias 'nbfs 'my-new-buffer-frame)

(defun new-buffer-from-o (o)
  (new-buffer-from-string (if (stringp o)
                              o
                            (pp-to-string o))))
(defalias 'nbfo 'new-buffer-from-o)

(defun etv (o)
  "returns the object. see btv if you want the buffer"
  (new-buffer-from-o o)
  o)

(defun etvpps (o)
  (etv (pps o)))
(defalias 'etp 'etvpps)

(defmacro mtv (o)
  "This might do an etv. It will do an etv if it was called interactively"

  ;; This must be a macro so that when mtv is 'called', it gets its interactive status from the its calling function
  `(if (interactive-p)
       (etv ,o)
     ,o))

(defun btv (o)
  "like tv but returns the buffer"
  (new-buffer-from-o o))

(defun etvd (o)
  (new-buffer-from-o o)
  nil)

(_ns search
     (defun search-with-url-prefix (urlprefix &optional replprefix terms)
       "my search is a wrapper for making search functions"
       (interactive)
       (setq replprefix (or replprefix "terms"))
       (setq replprefix (concat replprefix ": "))

       (if (not terms)
           (progn
             (if (not (selected-p))
                 (setq terms (read-string replprefix)))
             (setq terms (selection))))

       (browse-url (concat urlprefix terms)))

     (defun my-google (&optional terms)
       "Googles a query or region if any."

       (interactive)
       (search-with-url-prefix "http://www.google.com/search?ie=utf-8&oe=utf-8&q=" "Google" terms))

     (defun my-youtube (&optional terms)
       "Search YouTube with a query or region if any."

       (interactive)
       (search-with-url-prefix "https://www.youtube.com/results?search_query=" "Youtube" terms)))


(_ns applications
     (defun magit-and-cd (cwd)
       (ignore-errors (magit-status))
       (ignore-errors (cd cwd)))

     (defun sunrise-and-cd (cwd)
       (ignore-errors (sunrise))
       (ignore-errors (cd cwd))))


(_ns windows
     (defun all-over-the-screen ()
       (interactive)
       (delete-other-windows)
       (split-window-horizontally)
       (split-window-horizontally)
       (balance-windows)
       (follow-mode t)))


(defun make-current-file-exec ()
  "Adds x perm to current file acl."
  (interactive)
  ;; (sh-notty (concat "chmod a+x " (q buffer-file-name)))
  (bl chmod a+x (buffer-file-name)))


(defun if-shebang-exec-otherwise-remove ()
  "Adds x perm to current file acl if file has a shebang."
  (interactive)
  (try (if (string-equal (buffer-substring (point-min) (2+ (point-min))) "#!")
           (progn
             (if (not (blq u isx (s/rp (buffer-name))))
                 (progn
                   (ns "file is a shebang but not executable. making file executable.")
                   (bl chmod a+x (buffer-file-name)))))
         (progn
           (if (blq u isx (s/rp (buffer-name)))
               (progn
                 (ns "file is not shebang and is executable. removing executable.")
                 (bl chmod a-x (buffer-file-name))))))))

(_ns file-menu
     (defun my-save ()
       (interactive)
       (save-buffer)
       (shut-up (if-shebang-exec-otherwise-remove))

       ;; Add this as advice to all save functions
       ;; M-m f s
       ;; M-l M-w

       ;; C-x C-s
       ;; (make-local-variable 'saved-undo-node)

       ;; Save current state to ^ register
       ;; (ekm "C-x r u ^")
       ;; (undo-tree-save-state-to-register "a")

       (message "%s" "File saved"))

     ;; For some reason this needs arg as a parameter
     ;; Advice functions must need to have at least one argument
     (defun undo-tree-save-root (&optional r)
       (if (not r)
           (setq r ?^))
       ;; (require 'undo-tree)
       (undo-tree-save-state-to-register r))

     (defun remove-undo-tree-advice (&optional r)
       (advice-remove 'save-buffer 'undo-tree-save-root)
       (remove-hook 'find-file-hook 't)
       )

     ;; These hooks will break the loading of plugins unless they are placed in after-init-hook
     (add-hook 'after-init-hook
               (lambda ()
                 ;; I have disabled undo-tree
                 (never
                  (advice-add 'save-buffer :after 'undo-tree-save-root))
                 (advice-add 'kill-emacs :before 'remove-undo-tree-advice)
                 ;; (advice-remove 'save-buffer 'undo-tree-save-root)

                 ;; I have disabled undo -tree
                 (never
                  (add-hook 'find-file-hook 'undo-tree-save-root t))
                 (remove-hook 'find-file-hook 'undo-tree-save-root t)

                 ;; (remove-hook 'find-file-hook 'undo-tree-save-root t)
                 ;; (remove-hook 'find-file-hook 't)
                 ))

     ;; These hooks will break the loading of plugins
     ;; (add-hook 'find-file-hook 'undo-tree-save-root t)
     ;; (remove-hook 'find-file-hook 'undo-tree-save-root)
     ;; (remove-hook 'find-file-hook 't)

     ;; I have disabled undo-tree
     (remove-hook 'find-file-hook 'undo-tree-save-root)

     (defun clear-undo-tree ()
       (interactive)
       (setq buffer-undo-tree nil))

     (defun my-revert (arg)
       (interactive "P")
       ;; Why remove overlays again?
       (remove-overlays (point-min) (point-max))
       ;; Do this manually for the moment
       ;; (make-buttons-for-all-filter-cmds)
       (run-buttonize-hooks)
       (let ((l (line-number-at-pos))
             (c (current-column)))

         ;; Excursion doesn't work for compressed files
         ;; Therefore we also use goto-line


         ;; (save-excursion)
         ;; I can query this to see if it's a compressed file
         ;; jka-compr-really-do-compress
         ;; I'mquite happy with goto-line and move-to-column instead of save-excursion

         (if arg
             (progn (force-revert-buffer)
                    (message "%s" "Reverted from disk"))
           (progn (try (progn (if (string-match-p "\\*Org .*" (buffer-name))
                                  (message "Not going to revert.")
                                ;; Babel
                                ;; (undo-tree-restore-state-from-register ?')
                                ;; It's undo-tree-restore-state-from-register which is SLOW
                                (undo-tree-restore-state-from-register ?^))
                              ;; (message "%s" "Reverted to last saved state from undo-tree history")
                              )
                       (progn (force-revert-buffer)
                              ;; (message "%s" "Reverted from disk because the ^ register was used elsewhere")
                              )))  ; revert without loading from disk
           ;; (ekm "C-x r U ^") ; revert without loading from disk

           ;; (if (varexists 'saved-undo-node)
           ;;     (ekm C-x r U ^)
           ;;   ;; (progn (undo-tree-node-undo saved-undo-node)

           ;;   ;;        ;; (undo-tree-undo 10000)
           ;;   ;;        (message "%s" "undid"))
           ;;   ;; (progn
           ;;   ;;   (message "%s" "no undid"))
           ;;   )
           )

         (goto-line l)
         (move-to-column c)
         ;; For some reason, this hook is added whenever I revert. Therefore remove it. What is adding it?
         (remove-hook 'after-save-hook (lambda nil (byte-force-recompile default-directory)) t)
         ;; (message "%s" "File reverted")
         )
       (clear-undo-tree)
       (company-cancel))

     (defun my-revert-from-disk ()
       (interactive)
       (setq current-prefix-arg '(1))
       (call-interactively 'my-revert))

     (defun my-quit ()
       (interactive)
       (revert-and-quit-emacsclient-without-killing-server))

     (defun keyboard-quit-and-revert-buffer ()
       (interactive)
       (exit-minibuffer)
       ;; anything after exit-minibuffer is not run... I don't know why
       ;; (keyboard-quit)
       ;; (force-revert-buffer)
       )

     (defun revert-buffer-no-confirm ()
       "Revert buffer without confirmation."
       (interactive)
       (revert-buffer t t t))

     (defun save-buffer-with-path (name)
       (interactive "sFilename: ")
       (save-some-buffers 'no-confirm (lambda () (and buffer-file-name (equal buffer-file-name name)))))

     ;; (defun org-archive-to-date-file (&optional dir)
     ;;   "Move subtree at point to timestamp file in DIR."
     ;;   (interactive)
     ;;   (let* ((timestamptz-string (org-entry-get nil "CREATED_AT_TIMESTAMPTZ"))
     ;;          (datestamp (s-left 10 timestamptz-string))
     ;;          (raw-filename (concat (or datestamp "missing-timestamp") ".org"))
     ;;          (destination-filepath (expand-file-name raw-filename (or dir "~/org/archive/")))
     ;;          (org-archive-location (concat destination-filepath "::")))
     ;;     (write-region "" nil destination-filepath t)
     ;;     (org-archive-subtree)
     ;;     (save-buffer-with-path destination-filepath)
     ;;     (let ((destination-buffer (get-file-buffer destination-filepath)))
     ;;       (kill-buffer raw-filename))))

     (defun my-kill-buffer-and-window ()
       (interactive)
       ;; (shut-up (annotate-save-annotations))
       (if (major-mode-p 'ranger-mode)
           (ranger-close)
         (if (equal 1 (count-windows))
             (ignore-errors (kill-buffer))
           (ignore-errors (kill-buffer-and-window)))))

     (defun my-save-buffer ()
       (interactive)
       (if ;; (minor-mode-enabled magit-popup-mode)
           (or (minor-mode-enabled magit-popup-mode)
               ;; (minor-mode-enabled magit-file-mode)
                                        ;this appears to be on in normal circumstances, so it cant be used as a check
               )
           (let ((my-mode nil))
             (ekm "C-c C-s")            ;For magit-popu
             )
         ;; (shut-up (annotate-save-annotations))
         (save-buffer)))

     (defun save-and-kill-buffer ()
       (interactive)
       (my-save-buffer)
       (kill-buffer))

     (defun save-and-kill-buffer-and-window ()
       (interactive)
       (my-save-buffer)
       ;; (shut-up (annotate-save-annotations))
       (kill-buffer-and-window))

     (defun save-and-quit-emacsclient ()
       "description string can flow to next line without continuation character"
       (interactive)
       (my-save-buffer)
       (kill-buffer)
       (save-buffers-kill-terminal))

     (defun revert-and-quit-emacsclient ()
       "description string can flow to next line without continuation character"
       (interactive)
       ;; ignore errors allows the command to continue even if the buffer
       ;; is not associated with a file
       (ignore-errors
         (revert-buffer-no-confirm))
       (kill-buffer)
       (save-buffers-kill-terminal))

     ;; This doesnt work
     (defun kill-window-and-quit-emacsclient ()
       "description string can flow to next line without continuation character"
       (interactive)
       (progn
         (kill-buffer)
         (save-buffers-kill-terminal)
         (quit-window)))

     ;; this doesn't quit the server but it aljjso doesn't close emacsclient.
     ;; It would be perfect if it did
     (defun revert-and-quit-emacsclient-without-killing-server ()
       "description string can flow to next line without continuation character"
       (interactive)
       ;; (force-revert-buffer)
       ;; (my-kill-buffer-and-window)
       ;; (server-edit)
       (ignore-errors
         (delete-frame)))

     (defun revert-and-kill-buffer ()
       "description string can flow to next line without continuation character"
       (interactive)
       ;; ignore errors allows the command to continue even if the buffer
       ;; is not associated with a file
       (force-revert-buffer)
       (kill-buffer))

     (defun force-revert-buffer ()
       (interactive)
       (ignore-errors
         (revert-buffer-no-confirm))))



;; misc functions
(defun cat-to-file (stdin file_path)
  ;; The ignore-errors is needed for babel for some reason
  (ignore-errors (with-temp-buffer
                   (insert stdin)
                   (delete-file file_path)
                   (write-file file_path)))
  ;; (sh-notty
  ;;  (concat "cat > " (q file_path)) stdin)
  )
(defalias 'write-string-to-file 'cat-to-file)
(defalias 'write-to-file 'cat-to-file)

(defun append-uniq-to-file (stdin file_path)
  (sh-notty
   (concat "cat " (q file_path) " | uniqnosort | sponge " (q file_path)) stdin))

(defun append-to-file (stdin file_path)
  (sh-notty
   (concat "cat >> " (q file_path)) stdin))
(defalias 'append-string-to-file 'append-to-file)
;;(defalias 'append-to-file 'cat-to-file)


;; operate on the buffer
(_ns methods
     (defun open-in-org-editor ()
       (interactive)
       (tmux-edit "og"))

     (defun open-in-spacemacs ()
       (interactive)
       (tmux-edit "sp" "nw")))

(defun git-buffer-name-to-file-name ()
  (if (string-match "\.~" (buffer-name))
      (sh-notty "tr -s \/ _" (sed "s/^\\(.*\\)\\(\\.~\\)\\(.*\\)$/\\3\\1/" (buffer-name)))
    (buffer-name)))


(defun my/mktemp (template &optional input)
  "Create a temporary file."
  (let ((fp (snc (concat "mktemp -p /tmp " (q (concat "XXXX" (slugify template)))))))
    (if (and (sor fp)
             (sor input))
        (shut-up (write-to-file input fp)))
    fp))
(defalias 'tf 'my/mktemp)


(defmacro my/nil (body)
  "Do not return anything."
  ;; body
  `(progn (,@body) nil))


(defun my/magit-save-buffer-to-file ()
  (cat-to-file
   (buffer-contents)
   (my/mktemp
    (git-buffer-name-to-file-name))))


;; (defun my-line ()
;;   (number-to-string (line-number-at-pos)))

;; (defun my-col ()
;;   (number-to-string (current-column)))

;; e v "$HOME/notes2018/scratch/perspective.org" 3 1
;; e "$HOME/notes2018/scratch/perspective.org" 3 1
;; e c "$HOME/notes2018/scratch/perspective.org" 3 1
(defun tmux-edit (&optional editor window_type)
  "Simple function that allows us to open the underlying file of a buffer in an external program."
  (interactive (list "v" "spv"))
  ;; This is not ready because e can't take number arguments for line:col yet
  ;; (setq editor "e")
  (if (not editor)
      ;; (setq editor "v")
      (setq editor "v"))

  (if (not window_type)
      ;; (setq editor "v")
      (setq window_type "spv"))
  ;; (when buffer-file-name
  ;;   (shell-command (concat "tm -d -f nw -fa e \"" buffer-file-name "\"")))

  (let ((line-and-col (cc "+" (line-number-at-pos) ":" (current-column))))
    (if (and buffer-file-name (not (string-match "\\[*Org Src" (buffer-name))))
        (progn
          (save-buffer)
          ;; e c -l 5 -c 1 file.org
          ;; (shell-command (tvipe (concat "tm -d -te spv -fa edit -e " editor " -l " (number-to-string (line-number-at-pos)) " -c " (number-to-string (+ (current-column) 1)) " " (q buffer-file-name))))
          ;; (shell-command (tvipe (concat "tm -d -te spv -fa " editor " +" (number-to-string (line-number-at-pos)) " -c " (number-to-string (+ (current-column) 1)) " " (q buffer-file-name))))
          (shell-command (cc "tm -d -te " window_type " -fa " editor " " line-and-col " " (q buffer-file-name))))
      ;; ""tm -d"" breaks stdin
      (cond ((string-match "\.~" (buffer-name))
             (let ((new_fp (my/magit-save-buffer-to-file)))

               ;; (vim "+")
               ;; (number-to-string (line-number-at-pos))
               ;; (number-to-string (+ (current-column) 1))
               (shell-command-on-region (point-min) (point-max) (cc "tsp -wincmd " window_type " -fa " editor " " line-and-col))))
            ((string-match "\\[*Org Src" (buffer-name))
             (shell-command-on-region (point-min) (point-max) (cc "tsp -wincmd " window_type " -fa " editor " " line-and-col)))
            (t
             (shell-command-on-region (point-min) (point-max) (cc "tsp -wincmd " window_type " -fa " editor " " line-and-col)))))))
(defalias 'open-in 'tmux-edit)



;; doesn't work perrfectly. But it's useful.
;; http://grapevine.net.au/~striggs/elisp/emacs-homebrew.el
;; Useful custom functions
(defun reselect-last-region ()
  (interactive)
  (let ((start (mark t))
        (end (point)))
    (goto-char start)
    (call-interactively' set-mark-command)
    (goto-char end)))
(defalias 'reselect 'reselect-last-region)

;; (defun reselect-region ()
;;   "Reselects the region, so long as you haven't drifted away since performing whatever operation and deactivating the region selection."
;;   (interactive)
;;   ;; (ekm "C-x C-x d")
;;   (ekm "C-x C-x C-x C-x"))
(defalias 'activate-region 'reselect-last-region)
(defalias 'activate-region 'reselect-last-region)

(defun my-select-current-line ()
  (interactive)
  (move-beginning-of-line nil)
  (set-mark-command nil)
  (move-end-of-line nil)
  (setq deactivate-mark nil))

(defun run-region-in-through-command (command)
  "Put selection through a command"
  (interactive)
  ;; let allows you to create local variables.
  ;; setq makes global variables
  (if (not (region-active-p))
    (my-select-current-line))
  (let ((rstart (region-beginning))
        (rend (region-end)))
    (shell-command-on-region rstart rend command)))

;; What you have selected IS the command.
;; Doesn't pipe in to a command.
(defun run-line-or-region-in-tmux ()
  "description string"
  (interactive)
  ;; let allows you to create local variables.
  ;; setq makes global variables
  (if (not (region-active-p))
      (my-select-current-line))
  (let ((rstart (region-beginning))
        (rend (region-end)))
    (shell-command-on-region rstart rend "tm -tout -S nw -pakf -rsi"))
  (deselect))


;; Initially go to the start of the line but toggle with going to the
;; start of the code as well
;; See haskell-interactive-mode's binding for C-a
(defun beginning-of-line-or-indentation ()
  "move to beginning of line, or indentation"
  (interactive)
  (cond ((or (major-mode-p
              'haskell-interactive-mode)
             (major-mode-p 'eshell-mode))
         (let ((my-mode nil))
           (execute-kbd-macro (kbd "C-a"))))
        (t
         (progn
           (if (bolp)
                                        ; beginning of line
               (back-to-indentation)
             (beginning-of-line))))))

;; If you use the mouse to select another window, this will close the
;; minibuffer so subsequent chords will not result in:
;; "Command attempted to use minibuffer while in minibuffer"
(defun stop-using-minibuffer ()
  "kill the minibuffer"
  (when (and (>= (recursion-depth) 1) (active-minibuffer-window))
    (abort-recursive-edit)))


(defun term-ranger ()
  (interactive)
  ;; ranger just doesn't look good in term
  ;; (term-nsfa (concat "ranger " (q (current-directory))))
  (nw (concat "ranger " (q (current-directory)))))

(defun spv-ranger ()
  (interactive)
  (shell-command (concat "tm -f -d -te spv -c " (q default-directory) " ranger")))

(defun sps-ranger (dir)
  (interactive (list default-directory))
  (shell-command (concat "tm -f -d -te sps -c " (q dir) " ranger")))
(defalias 'sh/ranger 'sps-ranger)


;; Works
;; (bp-tty xc -i "hi")

(defun xc-m (s)
  ;; (bp-tty xc -i s)
  ;; (kill-ring-save)
  ;; (yp-fast)

  ;; Annoyingly, if I don't move the cursor after doing yp, this code will append to the temp-buffer, which isnt destroyed
  (when s
    (with-temp-buffer
      (erase-buffer)                    ;This does not fix it
      (insert s)
      (clipboard-kill-region (point-min) (point-max)))
    (message "%s" s))

  (message "%s" (concat "Copied: " s)))

(defun my/buffer-file-name ()
  (s/rp (buffer-file-name)))

(defun get-visible-text-topic ()
  "Classify the visible text"
  ;; Use tmux
  (upd (pen-pf-keyword-extraction (tmux-pane-capture))))

(defun get-path-semantic ()
  (interactive)
  (cond
   ((major-mode-enabled 'org-brain-visualize-mode)
    (org-brain-pf-topic))
   (t (org-brain-pf-topic))))

;; This is usually used programmatically to get a single path name
(defun get-path (&optional soft no-create-path for-clipboard semantic-path)
  "Get path for buffer. semantic-path means a path suitable for google/nl searching"
  (interactive)

  (setq semantic-path (or
                       semantic-path
                       (>= (prefix-numeric-value current-prefix-arg) 4)))

  "If it's just for the clipboard then we can copy"
  ;; (xc-m (s/rp (buffer-file-name)))
  (let ((path
         (or (and (eq major-mode 'Info-mode)
                  (if soft
                      (concat "(" (basename Info-current-file) ") " Info-current-node)
                    (concat Info-current-file ".info")))

             (and (major-mode-enabled 'eww-mode)
                  (s-replace-regexp "^file:\/\/" ""
                                    (url-encode-url
                                     (or (eww-current-url)
                                         eww-followed-link))))

             (and (major-mode-enabled 'sx-question-mode)
                  (sx-get-question-url))

             (and (major-mode-enabled 'org-brain-visualize-mode)
                  (org-brain-get-path-for-entry org-brain--vis-entry semantic-path))

             (and (major-mode-enabled 'ranger-mode)
                  (dired-copy-filename-as-kill 0))

             (and (major-mode-enabled 'dired-mode)
                  (string-or (and
                              for-clipboard
                              (mapconcat 'q (dired-get-marked-files) " "))
                             (my/pwd)))

             ;; This will break on eww
             (if (and (not (eq major-mode 'org-mode))
                      (string-match-p "\\[\\*Org Src" (or (buffer-file-name) "")))
                 (s-replace-regexp "\\[\\*Org Src.*" "" (buffer-file-name)))
             (buffer-file-name)
             (try (buffer-file-path)
                  nil)
             dired-directory
             (progn (if (not no-create-path)
                        (save-temp-if-no-file))
                    (let ((p (full-path)))
                      (if (stringp p)
                          (e/chomp p)))))))
    (if (interactive-p)
        (my/copy path)
      path)))
(defun get-path-nocreate ()
  (get-path nil t))

(defun disable-docker-wrapper ()
  (interactive)
  (message (sh-notty "2>&1 disable-docker-wrapper")))

(defun enable-docker-wrapper ()
  (interactive)
  (message (sh-notty "2>&1 enable-docker-wrapper")))

(defun vc-get-top-level ()
  (chomp (sh-notty "vc get-top-level")))

(defun buffer-file-path ()
  (if (major-mode-enabled 'eww-mode)
      ;; (sh/ptw/xurls (or (eww-current-url)
      ;;                   eww-followed-link))
      (or (eww-current-url)
          eww-followed-link)
    (try (s/rp (or (buffer-file-name)
                   (and (string-match-p "~" (buffer-name))
                        (concat (vc-get-top-level) "/" (sed "s/\\.~.*//" (buffer-name))))
                   ;; (concat (s/chomp (b vc get-top-level)) "/" (buffer-name))
                   (error "no file for buffer")
                   ))
         nil)))
(defalias 'full-path 'buffer-file-path)

(defun buffer-file-dir ()
  (u/dn (s/rp (buffer-file-name))))

;; Interestingly, this usually saves dired as a .hs file
(defun save-temp-if-no-file ()
  (interactive)

  (let* ((lang (detect-language))

         ;; TODO use auto-mode-alist to determine extension from language
         ;; 'auto-mode-alist
         ;; Use get-ext-for-mode

         (ext (cond (t (get-ext-for-mode major-mode))
                    ((string-equal lang "python") "py")
                    ((string-equal lang "haskell") "hs")
                    ;; Shell lang detection is dodgy
                    ;; ((string-equal lang "shell") "sh")
                    ((string-equal lang "go") "go")
                    ((string-equal lang "html") "html")
                    ;; (t "txt")
                    )))
    ;; (ns ext)

    (if (not (buffer-file-name)) (write-file (e/chomp (eval `(b tf ,ext)))))))

(_ns copy
     (defun yank-dir ()
       (interactive)
       ;; (xc-m default-directory)
       (cond
        ((major-mode-p 'proced-mode) (call-interactively 'proced-get-pwd))
        (t (kill-new (e/chomp (ns default-directory))))))

     (defun yank-file ()
       (interactive)
       ;; (xc-m (s/bn (buffer-file-name)))
       (my/copy (ns (e/chomp (s/bn (get-path))))))

     (defalias 'yank-bn 'yank-file)

     (defun yank-filemant ()
       (interactive)
       ;; (xc-m (file-name-base buffer-file-name))
       (kill-new (e/chomp (ns (file-name-base buffer-file-name)))))

     (defun yank-path ()
       (interactive)
       (if (selection-p)
           (with-current-buffer (new-buffer-from-string (selection))
             (guess-major-mode)
             (my/copy (ns (get-path nil nil t)))
             (kill-buffer))
         (my/copy (ns (get-path)))))

     (defun yank-git-path ()
       (interactive)
       (let ((path
              (e/chomp (ns (bp xa git-file-to-url -noask (get-path))))))

         (if (selection-p)
             (setq path (concat path "#L" (str (org-current-line)))))
         (kill-new path)))

     (defun yank-git-path-sha ()
       (interactive)
       (let ((path
              (e/chomp (ns (bp xa git-file-to-url -s -noask (get-path))))))

         (if (selection-p)
             (setq path (concat path "#L" (str (org-current-line)))))
         (kill-new path)))

     (defun yank-git-path-master ()
       (interactive)
       (let ((path
              (e/chomp (ns (bp xa git-file-to-url -m -noask (get-path))))))

         (if (selection-p)
             (setq path (concat path "#L" (str (org-current-line)))))
         (kill-new path))))


(defun my/add-to-load-path-glob (glob)
  "Add everything that matches glob."
  (mapc (lambda (x) (add-to-list 'load-path x))
        (file-expand-wildcards glob)))


(defmacro vim (&arguments)
  `(tmv))

(defmacro source-macro-expand (body))

;; Create macro for creating defun for shell commands

;; I probably need keyword arguments for this macro
;; Need an argument that contains


;; I kinda need my own format function


(defun list-major-modes ()
  "Returns list of potential major mode names (without the final -mode).
Note, that this is guess work."
  (interactive)
  (let (l)
    (mapatoms #'(lambda (f) (and
                             (commandp f)
                             (string-match "-mode$" (symbol-name f))
                             ;; auto-loaded
                             (or (and (autoloadp (symbol-function f))
                                      (let ((doc (documentation f)))
                                        (when doc
                                          (and
                                           (let ((docSplit (help-split-fundoc doc f)))
                                             (and docSplit ;; car is argument list
                                                  (null (cdr (read (car docSplit)))))) ;; major mode starters have no arguments
                                           (if (string-match "[mM]inor" doc) ;; If the doc contains "minor"...
                                               (string-match "[mM]ajor" doc) ;; it should also contain "major".
                                             t) ;; else we cannot decide therefrom
                                           ))))
                                 (null (help-function-arglist f)))
                             (setq l (cons (substring (symbol-name f) 0 -5) l)))))
    (when (called-interactively-p 'any)
      (with-current-buffer (get-buffer-create "*Major Modes*")
        ;; clear-buffer-delete is not even a function?
        ;; (clear-buffer-delete)
        (let ((standard-output (current-buffer)))
          (display-completion-list l)
          (display-buffer (current-buffer)))))
    l))

(defun fz-mode ()
  "change major mode"
  (interactive)

  (let ((m (fz (list-major-modes))))
    (if m
        (call-interactively (str2sym (concat m "-mode"))))))
(defalias 'change-mode 'fz-mode)
(defalias 'choose-mode 'fz-mode)


(defun buffer-mode (&optional buffer-or-name)
  "Returns the major mode associated with a buffer.
If buffer-or-name is nil return current buffer's mode."
  (buffer-local-value 'major-mode
                      (if buffer-or-name (get-buffer buffer-or-name) (current-buffer))))





;; (source (me (sh// t "curl" "yo")))
(defmacro sh// (needs_tty cmd args_fmt &rest args)
  (let ((cmd_fmt (my/join (cmd args_fmt) " ")))
    `(defun
         ,(s2y (concat "sh/" cmd))
         ,args
       (interactive)

       (sh-notty (format ,cmd_fmt ,@args)))))


;; I do not want to use recursive-narrow-or-widen-dwim because it uses the underlying narrow function, which operates on the same buffer
;; I have to build my own. Create a new buffer.
;; I currently don't know how to do this without making emacs hang as it's waiting for output.
;; But I do know how to do it by piping into a different program. I could pipe into a different emacs server.
;; use 'e' for the moment. This could become recursive, though.
;; Alternatively, I can figure out how to do it. Ask questions on #emacs.
;; After thinking about this, I have decided it might be best to remember
(defun edit-selection-in-mode ()
  "Opens a new temporary buffer for editing in the mode of choice."
  (if (region-active-p)
      (let ((original-mode (buffer-mode))))
    (progn
      ;; (narrow-to-region)
      (ekm "C-x n n")
      (deselect))
    ;; (tvipe nil "sp")
    (let ((my-mode nil))
      (execute-kbd-macro (kbd "M-C-m")))))

;; (my/join (quote ,body) " ")


;; Load this
;; https://raw.githubusercontent.com/DamienCassou/hierarchy/master/examples/hierarchy-examples-fs.el
;; Need list of string predicates
(_ns operations
     (defun ld (path)
       "Load things."
       (cond (()))
       (load (umn path))))


;;(defmacro my/nil (body)
;;  "Do not return anything."
;;  ;; body
;;  `(progn (,@body) nil))
;;
;;(load-http ()
;;           (sh)){}


;; (curl "cheat.sh/kubectl")


;; This function swaps occurrences of strings in the buffer or a region
;; of it.
(defun swap-text (str1 str2 beg end)
  "Changes all STR1 to STR2 and all STR2 to STR1 in beg/end region."
  (interactive "sString A: \nsString B: \nr")
  (if mark-active
      (setq deactivate-mark t)
    (setq beg
          (point-min)
          end
          (point-max)))
  (goto-char beg)
  (while (re-search-forward
          (concat
           "\\(?:\\b\\("
           (regexp-quote str1)
           "\\)\\|\\("
           (regexp-quote str2)
           "\\)\\b\\)")
          end
          t)
    (if (match-string 1)
        (replace-match str2 t t)
      (replace-match str1 t t))))


(defun swap-words (a b)
  "Replace all occurances of a with b and vice versa"
  (interactive "*sFirst Swap Word: \nsSecond Swap Word: ")
  (save-excursion
    (while (re-search-forward (concat (regexp-quote a) "\\|" (regexp-quote b)))
      (if (y-or-n-p "Swap?")
          (if (equal (match-string 0) a)
              (replace-match (regexp-quote b))
            (replace-match (regexp-quote a)))))))


(_ns clojure
     (defun cider-default-jack-in ()
       (interactive)
       (ignore-errors
         (kill-buffer
          "*cider-repl tstprjclj*"))
       (find-file
        "$HOME/notes2018/ws/clojure/projects/tstprjclj/project.clj")
       (cider-jack-in)))


;; Same as: (language-detection-buffer)
;; (defun buffer-language ()
;;   "Returns the language of the buffer."
;;   (interactive)
;;   (message "%s" (str (language-detection-string (buffer-contents)))))

(defun detect-language (&optional detect buffer-not-selection)
  "Returns the language of the buffer or selection."
  (interactive)
  (let ((lang
         (if (not detect)
             (sed "s/-mode$//" (current-major-mode-string))
           (str (language-detection-string
                 (if buffer-not-selection
                     (buffer-string)
                   (selection-or-buffer-string)))))))

    ;; (bp cut -d - -f 1 (str major-mode))
    ;; (sed "s/-mode$//" (current-major-mode-string))

    (if (string-equal "rustic" lang) (setq lang "rust"))
    (if (string-equal "clojurec" lang) (setq lang "clojure"))

    ;; Probably doesn't work because case doesn't work with strings
    ;; (setq lang (case lang
    ;;              ("rustic" "rust")
    ;;              (t lang)))

    ;; (setq lang (cond ((string-equal "rustic" lang) lang)
    ;;                  (t lang)))

    lang
    ;; (message "%s" lang)
    ))
(defalias 'current-lang 'detect-language)
(defalias 'buffer-language 'detect-language)

;; This works for setting the mode of shell files
;; (set-major-mode (concat (str (buffer-language) "-mode"))


(defun set-major-mode (name)
  (funcall (cond ((string= name "shell-mode") 'sh-mode)
                 ((string= name "emacslisp-mode") 'common-lisp-mode)
                 (t (str2sym name)))))

(defun guess-major-mode (&optional lang)
  "Guesses which major mode this file should have and set it."
  (interactive)
  (if (not lang)
      (setq lang (language-detection-string (buffer-contents))))
  (set-major-mode (concat (str lang) "-mode")))

(defun new-buffer-from-string-detect-lang (s &optional mode)
  (let* ((b (new-buffer-from-string s)))
        (with-current-buffer b
          (switch-to-buffer b)
          (if mode
              (funcall mode)
            (guess-major-mode)))))

(defun new-buffer-from-selection-detect-language ()
  "Creates a new buffer from the selection and tries to set the mode"
  (interactive)
  (if (selected-p)
      (new-buffer-from-string-detect-lang (selection))))
(defalias 'detect-language-set-mode 'guess-major-mode)

(defun indent-buffer ()
  "Indent the whole buffer."
  (interactive)
  (indent-region (point-min) (point-max)))
;; (global-set-key (kbd "C-c n") 'indent-buffer)

(defun kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer
        (delq (current-buffer)
              (remove-if-not 'buffer-file-name (buffer-list)))))

;; (buffer-string* (get-buffer-create "*Messages*"))
(defun buffer-string* (buffer)
  "returns only the visible part of the buffer"
  (with-current-buffer buffer
    (buffer-string)
    ;;(buffer-string buffer)
    ))

;; (buffer2string (get-buffer "*Messages*"))
;; (buffer2string (get-buffer-create "*Messages*"))
(defun buffer2string (buffer)
  (if (not buffer)
      ""
    (with-current-buffer buffer
      (save-restriction
        (widen)
        (buffer-substring-no-properties (point-min) (point-max))
        ;;(buffer-substring-no-properties buffer (point-min) (point-max))
        ))))

;; (defun search-scriptnames)
;; (buffer2string (get-buffer-create "*Messages*"))

(defun nv/messages ()
  "Show the messages buffer in nvim."
  (interactive)
  (my/nil (sh "mnm | nvpager -c 'normal! G'" (buffer2string "*Messages*") nil nil "sh" nil "spv")))

;; TODO finish this
(defun v/messages-source-grep (pat)
  "Show the messages buffer in nvim."
  (interactive)
  (my/nil (sh (concat "xargs grep -Hn " (q pat) " | v -c 'normal! G'") (buffer2string "*Messages*") nil nil "sh" nil "spv")))

(defalias 'current-line 'line-number-at-pos)

(defun get-current-line-string ()
  "Get the current line as a string."
  (buffer-substring-no-properties (line-beginning-position) (line-end-position))
  ;; (str (thing-at-point 'line))
  )

(defun grep-go-vim ()
  (interactive)
  (let ((path (e/chomp (cut (get-current-line-string) :d ":" :f "1")))
        (line (e/chomp (cut (get-current-line-string) :d ":" :f "2"))))
    (spv (concat "vim +" line " " (q path))))
  ;; (tvipe (cut (get-current-line-string) :d ":" :f "1"))
  )

(defun str (thing)
  "Converts object or string to an unformatted string."

  ;;It's important to check for if it's a string so we can make a copy of the string
  ;; Otherwise, my usage of str will be changing the original string.
  ;; For example, this will actually modify the current header-line-format!
  ;;(str header-line-format)

  (if thing
      (if (stringp thing)
          (substring-no-properties thing)
        (progn
          (setq thing (format "%s" thing))
          (set-text-properties 0 (length thing) nil thing)
          thing))
    ""))

(defun strsexp (thing)
  "Converts object or string to an unformatted string sexp."
  (setq thing (format "%S" thing))
  (set-text-properties 0 (length thing) nil thing)
  thing)

;; (construct-google-query 'a 'bc 'd "e")
(defun construct-google-query (&rest terms)
  (mapconcat 'str terms "+"))

;; (helm-get-mode-map-from-mode (current-major-mode-symbol))
(defun current-major-mode-symbol ()
  "Get the current major mode."
  major-mode)

(defun current-major-mode-string ()
  "Get the current major mode as a string."
  (str major-mode))

(defalias 'current-major-mode 'current-major-mode-string)

(defun current-major-mode-string ()
  "Get the current major mode as a string"
  (str major-mode))

(defun current-minor-modes-list ()
  "Get list of minor modes."
  (mapcar #'car minor-mode-alist))

(defun current-minor-modes-string ()
  "Get list of minor modes."
  (list2string (current-minor-modes-list)))

(defun emacs-properties ()
  `(("daemon/server name" . ,my-daemon-name)
    ("after-init-hook" . ,(str after-init-hook))))

;; This is a lot like mapc
(defmacro run (f &rest args)
  "run a function with remaining arguments"
  `(apply ,f (list ,@args)))

  ;; (eval `(apply ,f ,args))
  ;; `(apply ,f (quote ,args))

;; (run 'message "%s %s" "sup" "yo")
;; (run 'message "%s %s" "sup" "yo")
;; (run (lambda (x a) (+ 1 x a)) 5 9)

(defun show (thing)
  "Like message but an implicit str"
  (message "%s" (str thing)))

;; this is currently broken
(defmacro sideeffect (func &rest body)
  "Runs a function on the body before passing the body on"
  (if (not func)
      (setq func 'identity))
  (run func body)
  `(try (identity ,@body) nil))

;; (defun* sideeffect (func thing)
;;   (if (not func)
;;       (setq func 'identity))
;;   (run func thing)
;;   thing)
(defalias 'se 'sideeffect)
;; (tvipe (str (se 'ns 5)))
;; (tvipe (str (se 'show 5)))
;; (tvipe (str (se 'identity 5)) :b-quiet t)
;; (tvipe (str (se 'show 5)) :b-quiet t)

;; This trace function really needs to also use some kind of caching function to prevent running the body twice
(defmacro trace (&rest body)
  "run while tracing it in messages.
Just wrap this around anything and the value will be traced and passed on
"
  `(se (lambda (s) (message "%s" (concat "trace: " (str (car s))))) ,@body))

;; TODO rewrite this function using the sideeffect command
;;cl-defun I want to be able to trace calls to this function
;; cl-defun and defun* are equivalent
(require 'cl-lib)
;; The cl-lib library is preferred to cl, since it keeps the namespace
;; tidy by prefixing all symbols with cl-;
;;(cl-defun tvipe-message (thing &key f &key m)
;;  (if (not f)
;;      (setq f 'identity) )
;;  (if (not m)
;;      (setq m "tvm: "))
;;
;;  (se (lambda (thing) (message "%s" (concat m (str (run f thing))))) thing)
;;  ;; (se f thing)
;;  ;; (message "%s" (concat m (str (run f thing))))
;;  ;; thing
;;  )
;;;; This is how to do default arguments properly
(cl-defun tvipe-message (thing &key (f 'identity) &key (m "tvm: "))
  ;; sideeffect is broken currently
  thing

  ;; disable it. it's broken
  ;; (se (lambda (thing) (message "%s" (concat m (str (run f thing))))) thing)

  ;; (se f thing)
  ;; (message "%s" (concat m (str (run f thing))))
  ;; thing
  )
(defalias 'tvm 'tvipe-message)
;; (ns (tvm 5 :f 'show))

(defmacro tvmv (var)
  "Show contents of variable in messages"
  `(tvm ,var :m (concat "var " (sym2str ,var) ": " (str ,var))))

;; (tvm 5 :f (lambda (x) (+ 1 x)))
;; (tvm 5 :f 'identity)

(defun true ()
  t)

(defun true-p (e)
  (if e t))

(defun get-car-val (e)
  (let ((s (car e)))
    ;; (message "%s" (sym2str s))
    ;; s
    (if (and (variable-p s)
             ;; (true-p (tvm s))
             (true-p (tvm (eval s))))
        (str s))))

(defun get-enabled-minor-modes ()
  "Only list minor modes that are enabled"
  (remove '() (mapcar #'get-car-val minor-mode-alist)))

(defun get-current-mode-hook ()
  (let ((current-major-mode (str2sym (concat (current-major-mode-string) "-hook"))))
    (if (varexists current-major-mode)
        current-major-mode
      nil)))

(defun buffer-properties ()
  `(("current-major-mode-string" . ,(try (current-major-mode-string)))
    ("current-minor-modes-string" . ,(try (get-enabled-minor-modes)))
    ;; ("current-minor-modes-string" . ,(mapcar (lambda (e) (type (eval (car e)))) minor-mode-alist))
    ("completion-at-point-functions" . ,(try completion-at-point-functions))
    ("company-backends" . ,(try company-backends))
    ("current-mode-hook" . ,(try (eval (get-current-mode-hook))))
    ("buffer-name" . ,(try (buffer-name)))))

(defun my-json-encode-alist (alist)
  (sh/format-json (json-encode-alist alist)))

;; Construct a json file
;; Ultimately, I want to be using a the racket json generator library. Do this.
;; Do both, though, in this case.
(defun buffer-properties-json ()
  "Gets some properties of the current emacs buffer in json format."
  (my-json-encode-alist (buffer-properties)))

(defun force-keyvalue (e)
  ;; Make a new list
  (list
   (car e)
   (if (or (stringp (cdr e))
           (symbolp (cdr e))
           (numberp (cdr e)))
       (cdr e)
     nil)))

(defun force-alist (l)
  (mapcar 'force-keyvalue l))

(defun 2symbol (e)
  (str2sym (str e)))

(defalias '2sym '2symbol)

;; I want to be able to list enabled minor modes
(defun force-alist-bool (l)
  (mapcar
   '(lambda
      (e)
      (car l))
   l))

;; Unfortunately, this doesn't work
(defun buffer-variables-json ()
  "Gets some properties of the current emacs buffer in json format."
  ;; (my-json-encode-alist (buffer-local-variables))
  ;; (my-json-encode-alist (tvipe (list2string (mapcar 'car (buffer-local-variables)))))
  ;; (my-json-encode-alist (list (mapcar 'symbol2string (mapcar 'car (buffer-local-variables)))))
  ;; (my-json-encode-alist (list (buffer-local-variables)))
  ;; (json-encode-alist (remove nil (mapcar (lambda (l) (if (cdr l) l)) (buffer-local-variables))))

  ;; This is perfect
  (my-json-encode-alist (force-alist (buffer-local-variables))))

(defun my-list-buffer-variables ()
  (mapcar 'car (buffer-local-variables)))

(defun my-list-global-variables ()
  ;; This doesnt return json
  ;; https://stackoverflow.com/questions/8031246/listing-all-top-level-global-variables-in-emacs
  (let ((result '()))
    (mapatoms (lambda (x)
                (when (boundp x)
                  (let ((file (ignore-errors
                                (find-lisp-object-file-name x 'defvar))))
                    (when file
                      (push (cons x file) result))))))
    result)
  ;; Warning: it takes a long time to finish.

  ;; (my-json-encode-alist (force-alist global-variables-list))
  )

(defun global-variables-json ()
  (my-list-global-variables))

(defun emacs-properties-json ()
  "Gets some properties of the current emacs buffer in json format."
  (my-json-encode-alist (emacs-properties)))

(defun tvipe-properties-json ()
  "Gets some properties of the current emacs buffer in json format and puts it into tmux."
  (interactive)
  (cl-tvipe (my-json-encode-alist
          `(("emacs-properties" ,(emacs-properties))
            ("buffer-properties " ,(buffer-properties)))) :tm_wincmd "sph" :b-nowait t :b-quiet t))

(defun etv-properties-json ()
  "Gets some properties of the current emacs buffer in json format and puts it into tmux."
  (interactive)
  (new-buffer-from-string (my-json-encode-alist
                           `(("emacs-properties" ,(emacs-properties))
                             ("buffer-properties " ,(buffer-properties))))))

(defun tvipe-emacs-properties-json ()
  "Gets some properties of the current emacs buffer in json format and puts it into tmux."
  (interactive)
  (cl-tvipe (emacs-properties-json) :tm_wincmd "sph" :b-nowait t :b-quiet t))

(defun etv-emacs-properties-json ()
  "Gets some properties of the current emacs buffer in json format and puts it into tmux."
  (interactive)
  (new-buffer-from-string (emacs-properties-json)))

(defun jiq-buffer-variables-json ()
  "Gets the local variables of the current emacs buffer in json format and puts it into tmux."
  (interactive)
  (cl-sh "jiq" :stdin (buffer-variables-json) :tm_wincmd "sph" :b_wait t))

(defun tvipe-buffer-variables-json ()
  "Gets the local variables of the current emacs buffer in json format and puts it into tmux."
  (interactive)
  (cl-tvipe (buffer-variables-json) :tm_wincmd "sph" :b-nowait t :b-quiet t))

(defun etv-buffer-variables-json ()
  "Gets the local variables of the current emacs buffer in json format and puts it into tmux."
  (interactive)
  (new-buffer-from-string (buffer-variables-json)))

(defun etv-global-variables-json ()
  "Gets the local variables of the current emacs buffer in json format and puts it into tmux."
  (interactive)
  (new-buffer-from-string (global-variables-json)))

(defun tvipe-buffer-properties-json ()
  "Gets some properties of the current emacs buffer in json format and puts it into tmux."
  (interactive)
  (cl-tvipe (buffer-properties-json) :tm_wincmd "sph" :b-nowait t :b-quiet t))

(defun etv-buffer-properties-json ()
  "Gets some properties of the current emacs buffer in json format and puts it into tmux."
  (interactive)
  (new-buffer-from-string (buffer-properties-json)))

;; Idioms
;; (mapconcat 'identity list "\n") ;; assumes it's a list of strings
;; (mapconcat 'str list "\n")
;; (defalias 'str 'number-to-string) ; Don't do this, use format.

(defun insert-yanked ()
  (interactive)
  (my/nil (mapcar 'insert (substring-no-properties (car kill-ring)))))

;; (defun fz-filter-by-elisp-function ()
;;   (interactive)
;;   (let ((filter-name (fz (cat-file "$NOTES/ws/filters/emacs-lisp-functions.txt"))))
;;     (if filter-name
;;         (filter-selection (str2sym filter-name)))))

(defun fzf-filter-by-elisp-function ()
  (interactive)
  ;; (let ((filter-name (fzf (cat-file "$NOTES/ws/filters/emacs-lisp-functions.txt"))))
  ;;   (if filter-name
  ;;       (filter-selection (str2sym filter-name))))

  (let ((filter-string (fzf (cat-file "$NOTES/ws/filters/emacs-lisp-functions.txt"))))
    (if filter-string
        (filter-selected-region-through-macrostring filter-string))))

(defun fz-filter-by-elisp-function ()
  (interactive)
  ;; (let ((filter-name (fz (cat-file "$NOTES/ws/filters/emacs-lisp-functions.txt"))))
  ;;   (if filter-name
  ;;       (filter-selection (str2sym filter-name))))


  ;; TODO Do not use bp for this
  ;; This creates elisp functions
  ;;  I should not combine elisp functions with filters. They should be kept separate

  (let ((filter-string ;; (fz (cat-file "$NOTES/ws/filters/emacs-lisp-functions.txt"))
         (replace-regexp-in-string " +#.*"
                                   ""
                                   (fz (concat (awk1 (cat-file "$NOTES/ws/filters/emacs-lisp-functions.txt"))
                                               ;; (mapconcat
                                               ;;  (lambda (s) (concat "bp " ;; (bs "#" s)
                                               ;;                      s
                                               ;;                      ;; (replace-regexp-in-string " +#.*" "" s)
                                               ;;                      ))
                                               ;;  (string2list
                                               ;;   ;; I had to fudge this
                                               ;;   ;; There's no easy way without parsing for single quoted strings and then filtering them
                                               ;;   (replace-regexp-in-string "'" "\"" (cat-file
                                               ;;                                       "$HOME/filters/filters.sh")))
                                               ;;  "\n")
                                               ) "" nil "elisp filter:" nil))))
    (if filter-string
        (filter-selected-region-through-macrostring filter-string)
      ;; (eval `(hs "macrostring" (filter-selected-region-through-macrostring ,filter-string)))
      )))

(defun colorize-region (&optional fc bc)
  (interactive)
  (let ((inhibit-modification-hooks t)
        (fc (or fc "yellow"))
        (bc (or bc "deep sky blue")))
    (put-text-property (region-beginning) (region-end)
                       'face '(:foreground ,fc :background ,bc))))
; (define-key durand-presentation-mode-map [f1] 'colorize-region)

;; When the argument to helm is nil, I want emacs to go on
;; This stops exordium from complaining on M-x. But it doesn't solve the problem.
;; What is making all helm's sources nil?
;; (defun helm-get-sources (&optional sources)
;;   "Transform each element of SOURCES in alist.
;; Returns the resulting list."
;;   (when sources
;;     (mapcar (lambda (source)
;;               (if (listp source)
;;                   source (symbol-value source)))
;;             (helm-normalize-sources sources))))

;; (defun helm-get-sources (sources)
;;   "Transform each element of SOURCES in alist.
;; Returns the resulting list."
;;   (when sources
;;     (mapcar (lambda (source)
;;               (if (listp source)
;;                   source (symbol-value source)))
;;             (helm-normalize-sources sources))))



;; This is how to start and stop a timer
;; (run-with-timer 0 1 #'my-beep)
;; (cancel-function-timers #'my/beep)

;; (timer 5 'a/beep)
;; (timer :s 5 :c 'a/beep)

(cl-defmacro cl-timer (&key s &key c)
  "Set a timer. s = delta-seconds, c = code to run."
  (if (not s)
      (setq s 300))
  `(run-at-time (current-time) ,s ,c))

(defmacro timer (delta-seconds code)
  `(run-at-time (current-time) ,delta-seconds ,code))



(defun tvipe-completions ()
  "Get completions and list them in tvipe."
  (interactive)
  (my/nil (tvipe (get-completions) :b-nowait t)))


;; completion-help-at-point
;; minibuffer-completion-help

;; (def)

;; (defalias 'my-gc (source 'get-completions))

;; (get-completions)
(defun get-completions ()
  "Display the completions on the text around point.
The completion method is determined by `completion-at-point-functions'."
  (interactive)
  (let ((res (run-hook-wrapped 'completion-at-point-functions
                               #'completion--capf-wrapper 'optimist)))
    (pcase res
      (`(,_ . ,(and (pred functionp) f)))
      (`(,hookfun . (,start ,end ,collection . ,plist))
       (unless (markerp start) (setq start (copy-marker start)))
       (let* ((minibuffer-completion-table collection)
              (minibuffer-completion-predicate (plist-get plist :predicate))
              (completion-extra-properties plist)
              (completion-in-region-mode-predicate (lambda () t)))

         (setq completion-in-region--data
               `(,start ,(copy-marker end t) ,collection
                        ,(plist-get plist :predicate)))
         (completion-in-region-mode 1)
         (get-completions-region start end))))))

(defun get-completions-region (&optional start end)
  "Display a list of possible completions of the current minibuffer contents."
  (interactive)
  (let* ((start (or start (minibuffer-prompt-end)))
         (end (or end (point-max)))
         (string (buffer-substring start end))
         (md (completion--field-metadata start))
         (completions (completion-all-completions
                       string
                       minibuffer-completion-table
                       minibuffer-completion-predicate
                       (- (point) start)
                       md)))

    (if (or (null completions)
            (and (not (consp (cdr completions)))
                 (equal (car completions) string)))
        (progn

          (minibuffer-hide-completions)

          (minibuffer-message
           (if completions "Sole completion" "No completions"))
          nil
          ;; return nil
          )

      (let* ((last (last completions))
             (base-size (or (cdr last) 0))
             (prefix (unless (zerop base-size) (substring string 0 base-size)))
             (all-md (completion--metadata (buffer-substring-no-properties
                                            start (point))
                                           base-size md
                                           minibuffer-completion-table
                                           minibuffer-completion-predicate))
             (afun (or (completion-metadata-get all-md 'annotation-function)
                       (plist-get completion-extra-properties
                                  :annotation-function)
                       completion-annotate-function))

             (display-buffer-mark-dedicated 'soft)

             (pop-up-windows nil))
        (with-current-buffer-window
            ;; with-displayed-buffer-window
            "*Completions*"

            `((display-buffer--maybe-same-window
               display-buffer-reuse-window
               display-buffer--maybe-pop-up-frame-or-window

               ,(if (eq (selected-window) (minibuffer-window))
                    'display-buffer-at-bottom
                  'display-buffer-below-selected))
              ,(if temp-buffer-resize-mode
                   '(window-height . resize-temp-buffer-window)
                 '(window-height . fit-window-to-buffer))
              ,(when temp-buffer-resize-mode
                 '(preserve-size . (nil . t))))
          nil

          (when last (setcdr last nil))
          (setq completions
                (let ((sort-fun (completion-metadata-get
                                 all-md 'display-sort-function)))
                  (if sort-fun
                      (funcall sort-fun completions)
                    (sort completions 'string-lessp))))
          (when afun
            (setq completions
                  (mapcar (lambda (s)
                            (let ((ann (funcall afun s)))
                              (if ann (list s ann) s)))
                          completions)))

          (with-current-buffer standard-output
            (set (make-local-variable 'completion-base-position)
                 (list (+ start base-size) end))
            (set (make-local-variable 'completion-list-insert-choice-function)
                 (let ((ctable minibuffer-completion-table)
                       (cpred minibuffer-completion-predicate)
                       (cprops completion-extra-properties))
                   (lambda (start end choice)
                     (unless (or (zerop (length prefix))
                                 (equal prefix
                                        (buffer-substring-no-properties
                                         (max (point-min)
                                              (- start (length prefix)))
                                         start)))
                       (message "%s" "*Completions* out of date"))
                     ;; FIXME: Use `md' to do quoting&terminator here.
                     (completion--replace start end choice)
                     (let* ((minibuffer-completion-table ctable)
                            (minibuffer-completion-predicate cpred)
                            (completion-extra-properties cprops)
                            (result (concat prefix choice))
                            (bounds (completion-boundaries
                                     result ctable cpred "")))

                       (completion--done result
                                         (if (eq (car bounds) (length result))
                                             'exact 'finished)))))))

          (mapconcat 'identity completions "\n"))))))

(defun my/copy (&optional s silent)
  (interactive)
  (if (and
       s
       (not (stringp s)))
      (setq s (pps s)))
  (if (not (empty-string-p s))
      (kill-new s)
    (if (selected-p)
        (progn
          ;; Reselecting the region sucks
          (progn
            (setq s (selection))
            (call-interactively 'kill-ring-save)
            ;; (reselect-region)
            )
          ;; (xc (selection) :notify t)

          ;; I should make an sh-tty function which is much faster. It should use the sh-notty function to create a tty
          ;; (sh "xc -i" (selection) nil nil nil nil nil nil nil)
          )
      ;; simply return what's in the clipbaord
      ))
  (if s
      (if (not silent) (message "%s" (concat "Copied: " s)))
    (progn
      (shell-command-to-string "xsel --clipboard --output")
      ;; (call-function interprogram-paste-function)
      ;; (str (car kill-ring))
      )))
(defalias 'xc 'my/copy)
(defalias 'my-copy 'my/copy)

(defun drracket ()
  "Open current file in drracket."
  (interactive)
  (bld drracket (buffer-file-name)))
(defalias 'drr 'drracket)

(defun copy-fast (s)
  (interactive)
  (with-temp-buffer
    (insert s)
    (clipboard-kill-region (point-min) (point-max))))

(defun yp-fast ()
  "Put the current file name on the clipboard"
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name))))
    (when filename
      (with-temp-buffer
        (insert filename)
        (clipboard-kill-region (point-min) (point-max)))
      (message "%s" filename))))

(defun clipboard (&optional input)
  "This gets or sets what's on the clipboard"
  (interactive)
  (let (
        (output (current-kill 0))
        ;; (car kill-ring)
        )
    (if input
        (kill-new input)
      )
    (str output)
    ))
(defalias 'clip 'clipboard)
(defalias 'e/xc 'clipboard)

(defun set-buffer-contents (text)
  (let ((old-point (point)))
    (erase-buffer)
    (insert text)
    (goto-char old-point)))

;; (fp "tr f a")
;; (fp 'qne)
(defun fp (cmd)
  "This is a magical command that lets you filter the selected region through an external command."
  (filter-selection (lambda (input)
                      (interactive)
                      (sh-notty (str cmd) (str input)))))


(defun ask-for-binding ()
  "Get a key binding string from the user"
  (interactive)
  (format "%S" (key-description (read-key-sequence-vector "Key: "))))

(defun empty (user-str)
  (or (= (length user-str) 0)
      (string= "\n" user-str)))

;; This works
;; (define-key eshell-mode-map (kbd "M-n") 'eshell-next-matching-input-from-input)

(defun mark-function ()
  (interactive)
  (forward-char)
  (ekm "C-M-a C-@ M-m g d e"))

(defun subed-prev ()
  (interactive)
  (try (posix-search-backward "\n\n"))
  (call-interactively 'subed-jump-to-subtitle-text))

(defun subed-next ()
  (interactive)
  (try (posix-search-forward "\n[0-9]"))
  (call-interactively 'subed-jump-to-subtitle-text))

(defun previous-defun (arg)
  (interactive "P")
  (cond ((string= (current-major-mode) "org-mode") (call-interactively 'org-backward-heading-same-level))
        ((string= (current-major-mode) "epa-key-list-mode") (call-interactively 'widget-backward))
        ((string= (current-major-mode) "circe-query-mode") (call-interactively 'lui-previous-input))
        ((string= (current-major-mode) "subed-mode") (call-interactively 'subed-prev))
        ((string= (current-major-mode) "lsp-browser-mode") (call-interactively 'widget-backward))
        ((string= (current-major-mode) "cider-repl-mode") (call-interactively 'cider-repl-previous-input))
        ((string= (current-major-mode) "hackernews-mode") (call-interactively 'hackernews-previous-item))
        ((string= (current-major-mode) "moccur-grep-mode") (call-interactively 'moccur-prev))
        ((string= (current-major-mode) "outline-mode") (try (call-interactively 'outline-backward-same-level)
                                                            (call-interactively 'outline-previous-visible-heading)
                                                            nil))
        ((string= (current-major-mode) "sx-question-mode") (call-interactively 'sx-question-mode-previous-section))
        ((string= (current-major-mode) "imenu-list-major-mode") (call-interactively 'imenu-preview-prev))
        ((string= (current-major-mode) "Man-mode") (call-interactively 'Man-previous-manpage))
        ((string= (current-major-mode) "calibredb-search-mode") (call-interactively 'calibredb-previous-entry))
        ((string= (current-major-mode) "dashboard-mode") (call-interactively 'widget-backward))
        ((string= (current-major-mode) "spacemacs-buffer-mode") (call-interactively 'widget-backward))
        ;; ((string= (current-major-mode) "occur-mode") (call-interactively widget-back'occur-prev))
        ((minor-mode-p lsp-ui-peek-mode) (ekm "<left>"))
        ((string= (current-major-mode) "compilation-mode") (call-interactively 'compilation-previous-error))
        ((string= (current-major-mode) "kubernetes-overview-mode") (call-interactively 'magit-section-backward))
        ((string= (current-major-mode) "sly-mrepl-mode") (call-interactively 'sly-mrepl-previous-input-or-button))
        ((string= (current-major-mode) "treemacs-mode") (call-interactively 'treemacs-previous-neighbour))
        ((string= (current-major-mode) "grep-mode") (call-interactively 'compilation-previous-error))
        ((major-mode-p 'magit-section-mode) (call-interactively 'magit-section-backward-sibling))
        ((string= (current-major-mode) "org-brain-visualize-mode") (call-interactively 'backward-button))
        ((string= (current-major-mode) "elisp-refs-mode") (call-interactively 'backward-button))
        ;; ((string= (current-major-mode) "dired-mode") (call-interactively 'dired-prev-subdir))
        ;; ((string= (current-major-mode) "eshell-mode") (call-interactively 'eshell-previous-matching-input-from-input))
        ;; ((string= (current-major-mode) "eshell-mode") (eshell-previous-matching-input-from-input (string-to-int (or arg "0"))))
        ;; ((string= (current-major-mode) "eshell-mode") (call-interactively 'eshell-previous-matching-input-from-input t (vector nil)))
        ;; ((string= (current-major-mode) "eshell-mode") (ekm "C-c M-r"))
        ((string= (current-major-mode) "eshell-mode") (call-interactively 'eshell-previous-input))
        ((string= (current-major-mode) "slime-repl-mode") (call-interactively 'slime-repl-backward-input))
        ((string= (current-major-mode) "org-agenda-mode") (call-interactively 'org-agenda-previous-item))
        ((string=
          (current-major-mode)
          "occur-mode")
         (call-interactively
          (df
           occur-previous-and-display
           (call-interactively
            'occur-prev)
           (call-interactively
            'occur-mode-display-occurrence)
           ;; This appears to be the only way to get hl-line to activate
           (ekm "M-l ;")
           (ekm "M-l ;"))))
        ;; ((string= (current-major-mode) "occur-mode") (call-interactively #'occur-previous-and-display))
        ((string= (current-major-mode) "md4rd-mode") (call-interactively 'widget-backward))
        ;; ((string= (current-major-mode) "eww-bookmark-mode") (call-interactively 'previous-line-nonvisual))
        ((string= (current-major-mode) "xref--xref-buffer-mode") (call-interactively 'xref-prev-line))
        ((string= (current-major-mode) "restclient-mode") (call-interactively 'restclient-jump-prev))
        ;; ((string= (current-major-mode) "eww-mode") (call-interactively 'previous-link))
        ;; ((string= (current-major-mode) "eww-mode") (let ((my-mode nil)) (execute-kbd-macro (kbd "M-p"))))
        ;; ((string= (current-major-mode) "eww-mode") (call-interactively 'shr-previous-link))
        ((string= (current-major-mode) "eww-mode") (call-interactively 'eww-prev-fragment))
        ;; ((string= (current-major-mode) "ibuffer-mode") (call-interactively 'previous-line-nonvisual))
        ((string-match "^magit-" (current-major-mode)) (call-interactively 'magit-section-backward-sibling))
        ((string-match "^\*YASnippet Tables-" (current-buffer-name)) (progn (call-interactively 'backward-button) (my-yas-preview-snippet-under-cursor)))
        ;; ((string= (current-major-mode) "proced-mode") (call-interactively 'previous-line-nonvisual))
        ;; ((string= (current-major-mode) "prodigy-mode") (call-interactively 'previous-line-nonvisual))
        ;; ((string= (current-major-mode) "process-menu-mode") (call-interactively 'previous-line-nonvisual))
        ;; ((string= (current-major-mode) "gist-list-mode") (call-interactively 'previous-line-nonvisual))
        ((string= (current-major-mode) "mastodon-mode") (call-interactively 'mastodon-tl--previous-tab-item))
        ;; ((string= (current-major-mode) "haskell-mode") (call-interactively 'handle-prevdef))
        ;; ((string= (current-major-mode) "go-mode") (call-interactively 'handle-prevdef))
        ;; ((string= (current-major-mode) "emacs-lisp-mode") (call-interactively 'handle-prevdef))
        ;; ((string= (current-major-mode) "common-lisp-mode") (call-interactively 'handle-prevdef))
        ;; ((string= (current-major-mode) "python-mode") (call-interactively 'handle-prevdef))
        ;; ((string= (current-major-mode) "feature-mode") (call-interactively 'handle-prevdef))
        ;; ((string= (current-major-mode) "ein:notebook-multilang-mode") (call-interactively 'handle-prevdef))
        ;; ((string= (current-major-mode) "flycheck-error-list-mode") (call-interactively 'handle-prevdef))
        ((minor-mode-p magit-blame-mode) (magit-blame-previous-chunk))
        ;; flycheck-error-list-mode
        (t (try
            (let ((start-point (point))
                  (end-point))
              (call-interactively 'handle-prevdef)
              (setq end-point (point))
              (if (eq start-point end-point)
                  (error "Didn't move")))
            (call-interactively 'previous-line-nonvisual)
            nil))

        ;; (t
        ;;  (progn
        ;;    ;; If there is nothing on the line, move again
        ;;    (ignore-errors
        ;;      (beginning-of-defun))))
        ))

(defun next-defun (arg)
  (interactive "P")
  (cond ((string= (current-major-mode) "org-mode") (call-interactively 'org-forward-heading-same-level))
        ((string= (current-major-mode) "epa-key-list-mode") (call-interactively 'widget-forward))
        ((string= (current-major-mode) "lsp-browser-mode") (call-interactively 'widget-forward))
        ((string= (current-major-mode) "circe-query-mode") (call-interactively 'lui-next-input))
        ((string= (current-major-mode) "hackernews-mode") (call-interactively 'hackernews-next-item))
        ((string= (current-major-mode) "cider-repl-mode") (call-interactively 'cider-repl-next-input))
        ((string= (current-major-mode) "subed-mode") (call-interactively 'subed-next))
        ((string= (current-major-mode) "moccur-grep-mode") (call-interactively 'moccur-next))
        ((string= (current-major-mode) "sx-question-mode") (call-interactively 'sx-question-mode-next-section))
        ((string= (current-major-mode) "imenu-list-major-mode") (call-interactively 'imenu-preview-next))
        ((string= (current-major-mode) "Man-mode") (call-interactively 'Man-next-manpage))
        ((string= (current-major-mode) "calibredb-search-mode") (call-interactively 'calibredb-next-entry))
        ;; ((string= (current-major-mode) "outline-mode") (call-interactively 'outline-next-visible-heading))
        ((string= (current-major-mode) "outline-mode") (try (call-interactively 'outline-forward-same-level)
                                                            (call-interactively 'outline-next-visible-heading)
                                                            nil))
        ((string= (current-major-mode) "dashboard-mode") (call-interactively 'widget-forward))
        ((string= (current-major-mode) "spacemacs-buffer-mode") (call-interactively 'widget-forward))
        ;; ((string= (current-major-mode) "occur-mode") (call-interactively 'occur-next))
        ((string= (current-major-mode) "compilation-mode") (call-interactively 'compilation-next-error))
        ((string= (current-major-mode) "sly-mrepl-mode") (call-interactively 'sly-mrepl-next-input-or-button))
        ((string= (current-major-mode) "kubernetes-overview-mode") (call-interactively 'magit-section-forward))
        ((string= (current-major-mode) "treemacs-mode") (call-interactively 'treemacs-next-neighbour))
        ((minor-mode-p lsp-ui-peek-mode) (ekm "<right>"))
        ((string= (current-major-mode) "grep-mode") (call-interactively 'compilation-next-error))
        ((string= (current-major-mode) "org-brain-visualize-mode") (call-interactively 'forward-button))
        ((string= (current-major-mode) "elisp-refs-mode") (call-interactively 'forward-button))
        ;; ((string= (current-major-mode) "dired-mode") (call-interactively 'dired-next-subdir))
        ;; ((string= (current-major-mode) "eshell-mode") (eshell-next-matching-input-from-input arg))
        ;; ((string= (current-major-mode) "eshell-mode") (call-interactively 'eshell-next-matching-input-from-input t (vector arg)))
        ;; ((string= (current-major-mode) "eshell-mode") (ekm "C-c M-"))
        ;; eshell-next-input doesn't have problems. use evil when i want eshell-next-matching-input-from-input
        ((string= (current-major-mode) "eshell-mode") (call-interactively 'eshell-next-input))
        ((string= (current-major-mode) "slime-repl-mode") (call-interactively 'slime-repl-next-input))
        ;; ((string= (current-major-mode) "eshell-mode") (eshell-next-matching-input-from-input (string-to-int (or arg "0"))))
        ;; ((string= (current-major-mode) "eshell-mode") (eshell-next-matching-input-from-input))
        ((string= (current-major-mode) "org-agenda-mode") (call-interactively 'org-agenda-next-item))
        ((string=
          (current-major-mode)
          "occur-mode")
         (call-interactively
          (df
           occur-next-and-display
           (call-interactively
            'occur-next)
           (call-interactively
            'occur-mode-display-occurrence)
           ;; This appears to be the only way to get hl-line to activate
           (ekm "M-l ;")
           (ekm "M-l ;")
           ;; (ekb "M-l ;")
           ;; (other-window-1)
           ;; (hl-line-highlight)
           ;; (other-window-1)
           )))
        ((string= (current-major-mode) "md4rd-mode") (call-interactively 'widget-forward))
        ;; ((string= (current-major-mode) "eww-bookmark-mode") (call-interactively 'next-line-nonvisual))
        ;; ((string= (current-major-mode) "eww-mode") (let ((my-mode nil)) (execute-kbd-macro (kbd "M-n"))))
        ;; ((string= (current-major-mode) "eww-mode") (call-interactively 'shr-next-link))
        ((string= (current-major-mode) "eww-mode") (call-interactively 'eww-next-fragment))
        ((string= (current-major-mode) "xref--xref-buffer-mode") (call-interactively 'xref-next-line))
        ((string= (current-major-mode) "restclient-mode") (call-interactively 'restclient-jump-next))
        ;; ((string= (current-major-mode) "ibuffer-mode") (call-interactively 'next-line-nonvisual))
        ;; ((string= (current-major-mode) "proced-mode") (call-interactively 'next-line-nonvisual))
        ;; ((string= (current-major-mode) "prodigy-mode") (call-interactively 'next-line-nonvisual))
        ;; ((string= (current-major-mode) "process-menu-mode") (call-interactively 'next-line-nonvisual))
        ;; ((string= (current-major-mode) "gist-list-mode") (call-interactively 'next-line-nonvisual))
        ((string= (current-major-mode) "mastodon-mode") (call-interactively 'mastodon-tl--next-tab-item))
        ;; ((string= (current-major-mode) "racket-mode") (call-interactively 'lispy-flow))
        ;; ((string= (current-major-mode) "haskell-mode") (call-interactively 'handle-nextdef))
        ;; ((string= (current-major-mode) "go-mode") (call-interactively 'handle-nextdef))
        ;; ((string= (current-major-mode) "common-lisp-mode") (call-interactively 'handle-nextdef))
        ;; ((string= (current-major-mode) "common-lisp-mode") (call-interactively 'handle-nextdef))
        ;; ((string= (current-major-mode) "python-mode") (call-interactively 'handle-nextdef))
        ;; ((string= (current-major-mode) "feature-mode") (call-interactively 'handle-nextdef))
        ;; ((string= (current-major-mode) "ein:notebook-multilang-mode") (call-interactively 'handle-nextdef))
        ;; ((string= (current-major-mode) "flycheck-error-list-mode") (call-interactively 'handle-nextdef))
        ((minor-mode-p magit-blame-mode) (magit-blame-next-chunk))
        ((string-match "^magit-" (current-major-mode)) (call-interactively 'magit-section-forward-sibling))
        ((string-match "^\*YASnippet Tables-" (current-buffer-name)) (progn (call-interactively 'forward-button) (my-yas-preview-snippet-under-cursor)))
        ;; flycheck-error-list-mode
        (t (try
            (let ((start-point (point))
                  (end-point))
              (call-interactively 'handle-nextdef)
              (setq end-point (point))
              (if (eq start-point end-point)
                  (error "Didn't move")))
            (call-interactively 'next-line-nonvisual)
            nil))
        ;; (t
        ;;  (progn
        ;;    ;; If there is nothing on the line, move again
        ;;    (ignore-errors
        ;;      (beginning-of-defun -1)
        ;;      (if (string= "\n" (str (thing-at-point 'line)))
        ;;          (beginning-of-defun -1)
        ;;        (progn
        ;;          ;; (end-of-line)
        ;;          (forward-char)
        ;;          (beginning-of-defun -1)
        ;;          (beginning-of-defun))))))
        )
  ;; (let ((startpos (point)))
  ;;   (end-of-defun)
  ;;   (end-of-defun)
  ;;   (beginning-of-defun)
  ;;   (if (eq (point) startpos)
  ;;       (end-of-defun)))
  )

(defun copy-keybinding-as-table-row ()
  (interactive)
  (let ((sequence (format "%s" (key-description (read-key-sequence-vector "Key: ")))))
    (my/copy sequence)
    (message "%s" (concat "copied: " sequence))))

(cl-defun copy-keybinding-as-table-row-or-macro-string (sequence)
  (interactive (list (format "%s" (key-description (read-key-sequence-vector "Key: ")))))
  (let ((arg (prefix-numeric-value current-prefix-arg)))
    ;; (my/copy sequence)
    ;; (message "%s" (concat "copied: " sequence))
    (if (>= arg 4)
        (my/copy sequence)
      (my/copy (concat "| =" sequence "= | =" (str (key-binding (kbd sequence))) "= | =" (str (sym2str (help--binding-locus (kbd sequence) nil))) "=")))))

(cl-defun copy-keybinding-as-elisp (sequence)
  (interactive (list (format "%s" (key-description (read-key-sequence-vector "Key: ")))))
  (let* ((arg (prefix-numeric-value current-prefix-arg))
         (mapstr (str (sym2str (help--binding-locus (kbd sequence) nil))))
         (funstr (str (key-binding (kbd sequence)))))
    ;; (my/copy sequence)
    ;; (message "%s" (concat "copied: " sequence))
    (my/copy (concat "(define-key " mapstr " (kbd " (q sequence) ") '" funstr ")"))))

;; Unfortunately, this only gets the string for one combo
(defun record-keyboard-macro-string (sequence)
  "Copies the key binding after entering it"
  (interactive (list (format "%s" (key-description (read-key-sequence-vector "Key: ")))))
  ;; (xc -i (format "%S" (key-description (read-key-sequence-vector "Key: "))))

  (let ((arg (prefix-numeric-value current-prefix-arg)))
    (if (>= arg 4)
        (progn
          (setq current-prefix-arg nil)
          (copy-keybinding-as-table-row-or-macro-string sequence))
      (progn
        (my/copy sequence)
        (message "%s" (concat "copied: " sequence))))))

(defun yank-function-from-binding (sequence)
  "Copies the function name associated with a key binding after entering it"
  (interactive (list (format "%s" (key-description (read-key-sequence-vector "Key: ")))))
  (let* ((fun (str (key-binding (kbd sequence)))))
    (my/copy fun)
    (message "%s" (concat "copied: " fun))))

(defun ead-binding ()
  "ead binding in config dir"
  (interactive)
  (let* ((sequence (format "%s" (key-description (read-key-sequence-vector "Key: "))))
         (fun (key-binding (kbd sequence))))
    ;; (nw (concat "set -x; cd $EMACSD/config; ead " (q sequence) " || pak"))
    (if (my/function-exists fun)
        ;; (nw (concat "set -x; cd $EMACSD/config; ead " (q (concat "\\b" (str fun) "\\b")) " || pak"))
        (wgrep (concat "\\b" (str fun) "\\b") (mu "$EMACSD/config"))
      (message (concat "Aborting: Function " (q (str fun)) " doesn't exit")))))

;; (defun overlay-key-binding (key)
;;   (mapcar (lambda (keymap) (lookup-key keymap key))
;;           (cl-remove-if-not
;;            #'keymapp
;;            (mapcar (lambda (overlay)
;;                      (overlay-get overlay 'keymap))
;;                    (overlays-at (point))))))

(defun key-binding-at-point (key)
  (mapcar (lambda (keymap) (when (keymapp keymap)
                             (lookup-key keymap key)))
          (list
           ;; More likely
           (get-text-property (point) 'keymap)
           (mapcar (lambda (overlay)
                     (overlay-get overlay 'keymap))
                   (overlays-at (point)))
           ;; Less likely
           (get-text-property (point) 'local-map)
           (mapcar (lambda (overlay)
                     (overlay-get overlay 'local-map))
                   (overlays-at (point))))))

(defun keymaps-at-point ()
  "List entire keymaps present at point."
  (interactive)
  (let ((map-list
         (list
          (mapcar (lambda (overlay)
                    (overlay-get overlay 'keymap))
                  (overlays-at (point)))
          (mapcar (lambda (overlay)
                    (overlay-get overlay 'local-map))
                  (overlays-at (point)))
          (get-text-property (point) 'keymap)
          (get-text-property (point) 'local-map))))
    (apply #'message
           (concat
            "Overlay keymap: %s\n"
            "Overlay local-map: %s\n"
            "Text-property keymap: %s\n"
            "Text-property local-map: %s")
           map-list)))

(defun bunch-of-keybindings (key)
  (list
   (key-binding-at-point key)
   (minor-mode-key-binding key)
   (local-key-binding key)
   (global-key-binding key)
   ;; (overlay-key-binding key)
   ))
;; (bunch-of-keybindings (kbd "M-l M-r M-f"))

(defun locate-key-binding (key)
  "Determine in which keymap KEY is defined."
  (interactive "kPress key: ")
  (let ((ret
         (list
          (key-binding-at-point key)
          (minor-mode-key-binding key)
          (local-key-binding key)
          (global-key-binding key))))
    (when (called-interactively-p 'any)
      (message "At Point: %s\nMinor-mode: %s\nLocal: %s\nGlobal: %s"
               (or (nth 0 ret) "")
               (or (mapconcat (lambda (x) (format "%s: %s" (car x) (cdr x)))
                              (nth 1 ret) "\n             ")
                   "")
               (or (nth 2 ret) "")
               (or (nth 3 ret) "")))
    ret))



(defun record-keyboard-macro-string-basic ()
  (interactive)
  (kill-new (key-description (read-key-sequence-vector "Key: "))))


(defun get-github-file-path (&optional anchor)
  (require 'github-browse-file)
  "Get the url for the current file"
  (let ((url (concat "https://github.com/"
                     (github-browse-file--relative-url) "/"
                     (cond ((eq major-mode 'magit-status-mode) "tree")
                           ((member major-mode github-browse-file--magit-commit-link-modes) "commit")
                           (github-browse-file--view-blame "blame")
                           (t "blob")) "/"
                     (github-browse-file--current-rev) "/"
                     (github-browse-file--repo-relative-path)
                     (when anchor (concat "#" anchor)))))
    url))


(defun get-current-url ()
  "Get url for current file"
  (cond ((major-mode-p 'eww-mode) (plist-get eww-data :url))
        (t (get-github-file-path))))

;; (defun last-line-diff-char ()
;;   (interactive)
;;   (let ((cchar (current-ch))))
;;   )

(defun irc-find-line-with-diff-char (&optional step)
  (interactive)
  (if (not step)
      (setq step -1))
  ;; (message "%s" (str step))
  (let ((start-col (current-column))
        (start-ch (char-after (point))))
    (cl-loop
     while (zerop (forward-line step))
     when (and (not (string-equal "\n" (str (thing-at-point 'line))))
               (not (string-equal " " (str (thing-at-point 'char))))
               (not (string-equal "	" (str (thing-at-point 'char))))
               (= (move-to-column start-col) start-col)
               (/= (char-after (point)) start-ch)
               (/= (char-after (point)) (string-to-char " ")))
     return t)))

(defun irc-find-prev-line-with-diff-char ()
  (interactive)
  (irc-find-line-with-diff-char -1))

(defun irc-find-next-line-with-diff-char ()
  (interactive)
  (irc-find-line-with-diff-char 1))

;; (define-key my-mode-map (kbd "M-_") #'irc-find-prev-line-with-diff-char)
;; (define-key my-mode-map (kbd "M-+") #'irc-find-next-line-with-diff-char)

(defun my-what-face ()
  "Shows the face for what's under the cursor."
  (interactive)
  (ekm "C-u C-x ="))
(defalias 'what-face 'my-what-face)

(defun tvipe-textprops ()
  (interactive)
  (if (region-active-p)
      (tvd (format "%S" (buffer-substring (region-beginning) (region-end))))
    (tvd (format "%S" (buffer-string)))))

(defun etv-textprops ()
  (interactive)
  (if (region-active-p)
      (new-buffer-from-string (format "%S" (buffer-substring (region-beginning) (region-end))))
    (new-buffer-from-string (format "%S" (buffer-string)))))

(defun etv-urls-in-region ()
  (interactive)
  (if (region-active-p)
      (new-buffer-from-string
       (sh/ptw/uniqnosort (sh/ptw/xurls (format "%S" (buffer-substring (region-beginning) (region-end)))))
       nil 'org-mode)
    (new-buffer-from-string
     (sh/ptw/uniqnosort (sh/ptw/xurls (format "%S" (buffer-string))))
     nil 'org-mode)))

(defun recenter-top ()
  (interactive)
    (recenter-top-bottom scroll-margin))

(defun buffer-lines ()
  (interactive)
  (string-to-int (e/chomp (bp wc -l (buffer-contents)))))
(defalias 'num-lines 'buffer-lines)
(defalias 'numlines'buffer-lines )

(defun b-tabulate (s)
  "Tabulate string"
  (sh-notty "tabulate" s))

(defun my-read-webpage-in-org-mode (url)
  (interactive "sEnter a url: ")
  (let* ((url (car (split-string url "#")))
         (fn (expand-file-name
              (concat (file-name-sans-extension
                       (file-name-nondirectory url)) ".org")
              "~/Downloads")))
    (shell-command (format "pandoc %s -o %s --columns=60" url fn))
    (with-current-buffer (find-file fn)
      (hl-line-mode)
      (text-scale-set 3)
      (setq fill-column 60))))


(defun my-eval-string (string)
  "Evaluate elisp code stored in a string."
  (eval (car (read-from-string (format "(progn %s)" string)))))

(defalias 'eval-string 'my-eval-string)


(defun buffer-exists (bufname)
  (not (eq nil (get-buffer bufname))))
(defalias 'buffer-match-p 'buffer-exists)
;; (if (buffer-exists "*scratch*")  (kill-buffer "*scratch*"))

(defun tvl (l)
  (tvd (list2string l)))

(defun current-file-path ()
  buffer-file-name)

(defun current-file-name ()
  (if buffer-file-name (basename buffer-file-name)))

(defun open-next-file ()
  (interactive)
  ;; This works but killing the buffer is a little dangerous
  ;; (ekm "M-m f d <up> RET M-l M-m <f52>")
  (if (current-file-name)
      (let ((next-file (e/chomp (sh-notty (concat "next-file " (e/q (basename (current-file-name)))) nil (current-dir-name)))))
        (if next-file (find-file next-file) (message "%s" "Cannot move further")))
    (message "%s" "No current file name")))

(defun open-prev-file ()
  (interactive)
  ;; This works but killing the buffer is a little dangerous
  ;; (ekm "M-m f d <down> RET M-l M-m <f52>")
  (if (current-file-name)
      (let ((prev-file (e/chomp (sh-notty (concat "prev-file " (e/q (basename (current-file-name)))) nil (current-dir-name)))))
        (if prev-file (find-file prev-file) (message "%s" "Cannot move further")))
    (message "%s" "No current file name")))

(defun my-equals (a b)
  (if (stringp b)
      (string-equal a b)
    (eq a b)))
(defalias 'my-eq 'my-equals)

(defun error-if-equals (thing badval)
  "error if it equals something, otherwise pass it on"
  ;; (message "%s" (concat "Thing:" thing " badval:" badval))
  (if (my-equals thing badval)
      (error "error-if-equals received bad value")
    thing))

(defun fun (path)
  (interactive (list (read-string "path:")))
  "docstring"

  (if (string-empty-p path) (setq path "defaultval"))

  (let ((result (e/chomp (sh-notty (concat "ci yt-list-playlist-urls " (e/q path))))))
    (if (called-interactively-p 'any)
        ;; (message result)
        (new-buffer-from-string result)
      result)))

(defun hyperpolyglot ()
  (interactive)
  (eww-browse-url "http://hyperpolyglot.org/"))

(defun rosettacode ()
  (interactive)
  (eww-browse-url "http://rosettacode.org/wiki/Rosetta_Code"))

(defun last-message (&optional num)
  (or num (setq num 1))
  (if (= num 0)
      (current-message)
    (save-excursion
      (set-buffer "*Messages*")
      (save-excursion
    (forward-line (- 1 num))
    (backward-char)
    (let ((end (point)))
      (forward-line 0)
      (buffer-substring-no-properties (point) end))))))

(defun insert-last-message (&optional num)
  (interactive "*p")
  (insert (last-message num)))

;; (defun spv-rifle (path)
;;   "This executes rifle <path> in a split"
;;   (interactive (list (read-string "path:")))
;;   (spv (concat "trap '' HUP; rifle " (q path))))

(defun rifle (path)
  ;;   "This executes rifle <path> in a split"
  (interactive (list (read-file-name "path:")))
  (sps (concat "trap '' HUP; r " (q path))))
(defalias 'spv-rifle 'rifle)
(defalias 'r 'rifle)

(defun erase-keymap (km)
  (set km (make-sparse-keymap)))

(defun my-untabify (s)
  (s-replace-regexp "\t" (s-repeat default-tab-width " ") s))

(defun untabify-buffer ()
  "Untabify current buffer."
  (interactive)
  (save-excursion (untabify (point-min) (point-max))))

;; stringify
(defun onelinerise (l)
  (replace-regexp-in-string "\n" "\\n" (mapconcat 'e/q l " ") t t))

;; TODO Need to make an elisp version of =calc-best-n-columns=
;; Which uses the emacs window width instead of the tty width
;; https://www.gnu.org/software/emacs/manual/html_node/elisp/Window-Sizes.html
(defun columns (&optional n_columns)
  "Open columns"
  (interactive (list 80))
  (tvd (str n_columns)))

(defun list2vec (l)
  (apply 'vector l))

;; (apply 'vector (list 1 2 3))
(defun call-interactively-with-parameters (func &rest args)
  (call-interactively func t (apply 'vector args)))
(defalias 'cia 'call-interactively-with-parameters)
;; (cia 'gist-list-user "erantapaa")

(defun show-interactive-prefix ()
  (interactive)
  (message (str current-prefix-arg)))

(defun call-interactively-with-default-prefix-and-parameters (func &rest args)
  (setq current-prefix-arg (list 4)) ; C-u
  (call-interactively func t (apply 'vector args)))

(defun call-interactively-with-prefix-and-parameters (func prefix &rest args)
  (setq current-prefix-arg (list prefix)) ; C-u
  (call-interactively func t (apply 'vector args)))

;; (call-interactively 'gist-list-user t (vector "erantapaa"))
;; (call-interactively 'tmux-edit t (vector "v" "nh"))

(defun my-columnate-window (&optional max-cols)
  (interactive)
  (delete-other-windows)
  (setq max-cols (or max-cols 100))
  (setq max-cols (- max-cols 1))
  (let ((w (+ (/ (frame-width) 80) 0)))
    (if (> w max-cols)
        (setq w max-cols))
    (dotimes (i w)
      (split-window-right))
    (balance-windows)
    (follow-mode)))
(defalias 'colemacs 'my-columnate-window)

;; This is needed because apropos-function also changes buffer, when I just want a list returned
(defun scrape (re s &optional delim)
  "delim is used to guarantee i can get multiple matches per line
(etv (scrape \"\\b\\w+\\b\" (buffer-string) \" +\"))"
  ;; (s-replace-regexp "^.*\.\\([a-z0-9A-Z]+\\).*" "\\1" s)
  (if delim
      (setq s (list2str (s-split delim s))))
  ;; (tv s)
  (list2str
   (-flatten
    (cl-loop
     for
     line
     in
     (s-split "\n" (str s))
     collect
     (if (string-match-p re line)
         (s-replace-regexp (concat "^.*\\(" re "\\).*") "\\1" line))))))


(defun my-apropos-function (pattern)
  (-filter 'functionp
           (apropos-internal pattern)
           ;; (mapcar 'car
           ;;         (save-window-excursion
           ;;           (let ((r (apropos-function pattern)))
           ;;             (kill-buffer "*Apropos*")
           ;;             r)))
           ))
(defalias 're-substring 'scrape)

;; (str (scrape "\"At" "\"At minute 17.\""))

(defun mode-to-lang (&optional modesym)
  (if (not modesym)
      (setq modesym major-mode))
  (s-replace-regexp "-mode$" "" (sym2str modesym)))

(defun lang-to-mode (&optional langstr)
  (if (not langstr)
      (setq langstr (current-lang)))
  (str2sym (concat langstr "-mode")))

(defun get-ext-for-lang (langstr)
  (get-ext-for-mode (lang-to-mode langstr)))

;; This is not perfect

(defun get-ext-for-mode (&optional m)
  (interactive)
  (if (not m) (setq m major-mode))
  ;; (chomp (bp scrape ".[a-z0-9A-Z]+" (car (rassq m auto-mode-alist))))

  (cond ((eq major-mode 'json-mode) "json")
        ((eq major-mode 'python-mode) "py")
        ((eq major-mode 'fundamental-mode) "txt")
        ;; Try to guess it from =auto-mode-alist=
        (t (try (let ((result (e/chomp (s-replace-regexp "^\." "" (scrape "\\.[a-z0-9A-Z]+" (car (rassq m auto-mode-alist)))))))
                  (setq result (cond ((string-equal result "pythonrc") "py")
                                     (t result)))

                  (if (called-interactively-p)
                      (message result)
                    result))
                "txt"))))
(defalias 'get-path-ext-from-mode-alist 'get-ext-for-mode)

(defun get-mode-for-ext (ext)
  (assoc-default (concat "x." ext) auto-mode-alist #'string-match))

(defun shutdown-r-now ()
  (interactive)
  (sh-notty "sudo shutdown -r now"))

(defun hs-run-again ()
  (interactive)
  (sh-notty "hs-run-again"))

(defun tm-attach-unattached ()
  (interactive)
  (sh-notty "tmux-attach-unattached"))

(defun tm-attach-unattached-choose ()
  (interactive)
  (sh-notty "tmux-attach-unattached -s"))

(defun win-inv ()
  (interactive)
  (sh-notty "win inv"))

(defun win-uninv ()
  (interactive)
  (sh-notty "win uninv"))

;; I actually do think this properly unsets the variable, after reading
(defun unsetenv (variable)
  (setenv variable nil))

(defun eipe (value)
  "Edits string and returns it after C-c"
  (let ((this-buffer (buffer-name))
        (new-value value)
        (buffy "*edit-string*"))
    (save-excursion
      (switch-to-buffer buffy)
      (set-buffer buffy)
      (text-mode)
      (local-set-key (kbd "C-c C-c") 'exit-recursive-edit)
      (if (stringp value) (insert value))
      (message "When you're done editing press C-c C-c or C-M-c to continue.")
      (unwind-protect
          (recursive-edit)
        (if (get-buffer-window buffy)
            (progn
              (setq new-value (buffer-substring (point-min) (point-max)))
              (kill-buffer buffy))))
      (switch-to-buffer this-buffer)
      new-value)))
(defalias 'evipe 'eipe)



(defun flatten-once (list-of-lists)
  (apply #'append list-of-lists))

(defalias 'flatten-recursively '-flatten)


(defun hash-expression (expr)
  (sha1 (str expr)))

(require 'memoize)

(defun func-for-expression (nameprefix expr &optional update slugify-input)
  (let* ((funcsym (str2sym (concat nameprefix "-" (if slugify-input
                                                      (slugify slugify-input)
                                                    (hash-expression expr))))))
    (if (and (not update) (my/function-exists funcsym))
        funcsym
      (eval `(progn
               ;; I do not think it's necessary to unbind it
               ;; (fmakunbound ',funcsym)
               (defun ,funcsym ()
                 (ignore-errors (memoize-by-buffer-contents ',funcsym))
                 ,expr))))))


;; (defun change-mac-address ()
;;   (interactive)
;;   (xc (sn "change-mac-address")))

(defun copy-gateway ()
  (interactive)
  (xc (sn "i gateway")))




;; (defun my-describe-prefix-bindings (key)
;;   "Describe the bindings of the prefix used to reach this command.
;; The prefix described consists of all but the last event
;; of the key sequence that ran this command."
;;   (interactive (list (this-command-keys)))
;;   (describe-bindings
;;    (if (stringp key)
;;        (substring key 0 (1- (length key)))
;;      (let ((prefix (make-vector (1- (length key)) nil))
;;            (i 0))
;;        (while (< i (length prefix))
;;          (aset prefix i (aref key i))
;;          (setq i (1+ i)))
;;        prefix))))



(defun cip-repl ()
  (interactive)
  (let* ((cmd (read-string-hist "cip command:"))
         (command (s-replace-regexp "^[^ ]+")))))


(defalias 'tr 's-replace)

;; Lambda for keybindings
(defmacro lk (call)
  "Create interactive function from function symbol. Create a name for it based on the first arg. Propagate interactive arg"
  (let* ((symname (car call))
         (args (tail call))
         (newsymname (str2sym (concat "in-" (sym2str symname) "-" (slugify (tr "\n" "_" (list2str args)))))))
    `(defun
         ,newsymname
         (arg)
       (interactive "P")
       (call-command-or-function
        ',symname
        ,@args))))
;; (lk (ccls-navigate "L"))


(defun change-wallpaper ()
  (interactive)
  (let* ((dir "/home/shane/dump/home/shane/notes/ws/wallpapers")
         (sel (fz (sed "s/^\\.\\///" (sn (concat "cd " (q dir) "; find . -type f"))))))
    (sn (concat "feh --bg-fill " (q (concat dir "/" sel))))))


(defun edit-var-elisp (variable &optional buffer frame)
  (interactive
   (let ((v (variable-at-point))
         (enable-recursive-minibuffers t)
         (orig-buffer (current-buffer))
         val)
     (setq val (completing-read
                (if (symbolp v)
                    (format
                     "Describe variable (default %s): " v)
                  "Describe variable: ")
                #'help--symbol-completion-table
                (lambda (vv)
                  ;; In case the variable only exists in the buffer
                  ;; the command we switch back to that buffer before
                  ;; we examine the variable.
                  (with-current-buffer orig-buffer
                    (or (get vv 'variable-documentation)
                        (and (boundp vv) (not (keywordp vv))))))
                t nil nil
                (if (symbolp v) (symbol-name v))))
     (list (if (equal val "")
               v (intern val)))))
  (with-current-buffer
      (new-buffer-from-string (concat "(setq " (sym2str variable) "\n'" (pp (eval variable)) ")"))
    (emacs-lisp-mode)))
(defalias 'evar 'edit-var-elisp)

(defmacro progn-read-only-disable (&rest body)
  `(progn
     (if buffer-read-only
         (progn
           (read-only-mode -1)
           (let ((res
                  ,@body))
             res)
           (read-only-mode 1))
       (progn
         ,@body))))

(defun my-eval-string (string)
  ;; (eval (car (read-from-string (format "(progn %s)" string))))
  (eval (car (read-from-string (format "(progn %s)" string)))))

(defmacro macro-unminimise (&rest body)
  "This unminimises the code"
  (let* ((codestring (pp-to-string body))
         (ucodestring (umn codestring))
         (newcode (my-eval-string (concat "'" ucodestring))))
    `(progn ,@newcode)))
(defalias 'mu 'macro-unminimise)

(defmacro macro-minimise (&rest body)
  "This minimises the code"
  (let* ((codestring (pp-to-string body))
         (mcodestring (mnm codestring))
         (newcode (my-eval-string (concat "'" mcodestring))))
    `(progn ,@newcode)))
(defalias 'mm 'macro-minimise)


(defun pp-oneline (l)
  (chomp (replace-regexp-in-string "\n +" " " (pp l))))
(defalias 'pp-ol 'pp-oneline)

(defun pp-map-line (l)
  (string-join (mapcar 'pp-oneline l) "\n"))


(defmacro macro-sed (expr &rest body)
  "This transforms the code with a sed expression"
  ;; TODO Make this one-linerise each element of body
  (let* ((codestring (pp-map-line body))
         (ucodestring (sed expr codestring))
         (newcode (my-eval-string (concat "'(progn " ucodestring ")"))))
    ;; `(progn ,@newcode)
    newcode))
(defalias 'ms 'macro-sed)


(defun wget (url &optional dir)
  (interactive (list (read-string-hist "url: ")))
  (setq dir (or dir "/home/shane/dump/downloads/"))
  (cond
   ((string-match-p "^http.*/openreview.net/pdf" url)
    (progn
      (setq fn (concat (slugify url) ".pdf"))
      (nw (concat "CWD=" (q dir) " zrepl -cm -E " (q (concat "wget -c " (q url) " -O " (q fn)))))))
   (t
    (nw (concat "CWD=" (q dir) " zrepl -cm -E " (q (concat "wget -c " (q url)))))))

  ;; (mu (nw (concat "CWD=" (q "$DUMP$NOTES/ws/pdf/incoming/") " zrepl -cm -E " (q "wget -c " (q url)))))
  )


(defun gl-find-deb (query)
  (interactive (list (read-string-hist "binary name: ")))
  (wget (fz (cl-sn (cc "find-deb " query) :chomp t)))
  ;; find-deb ansi2txt
  )


(defmacro upd (&rest body)
  `(let ((sh-update t)) ,@body))

(defmacro noupd (&rest body)
  `(let ((sh-update nil)) ,@body))



(defun zcd (dir)
  (interactive (list (read-directory-name "zcd: ")))
  (sps (cmd "zcd" dir)))

(provide 'my-utils-2)