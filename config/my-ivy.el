(require 'ivy)

;; This is useful for setting the size of counsel-ag
(setq ivy-height 30)

(defun ivy-filtered-candidates ()
  "Returns the list of candidates filtered by the currently entered pattern"
  (ivy--filter ivy-text ivy--all-candidates))

(defun ivy-current-string ()
  "Returns the candidate currently under the cursor (not all marked candidates)"
  ;; The problem with this is index is visible index and all candidates
  ;; includes invisible (not matched by pattern entered)
  ;; (message (concat "ivy--index:" (str ivy--index)))
  ;; (nth ivy--index ivy--all-candidates)

  ;; This works
  (nth ivy--index (ivy-filtered-candidates))

  ;; The problem with this is marked candidates is for candidates i have
  ;; marked with the mark keybinding if it exists at all. i.e. it has
  ;; nothing to do with the pattern entered.
  ;; (nth ivy--index ivy-marked-candidates)
  )


(require 'lv)

(defun ivy-display-function-lv (text)
  (let ((lv-force-update t))
    (lv-message
     (replace-regexp-in-string
      "%" "%%"
      (if (string-match "\\`\n" text)
          (substring text 1)
        text)))))


(require 'popup)

(defun ivy-display-function-popup (text)
  (with-ivy-window
    (popup-tip
     (setq ivy-insert-debug
           (substring text 1))
     :nostrip t)))

(defun ivy-display-function-window (text)
  (let ((buffer (get-buffer-create "*ivy-candidate-window*"))
        (str (with-current-buffer (get-buffer-create " *Minibuf-1*")
               (let ((point (point))
                     (string (concat (buffer-string) "  " text)))
                 (add-face-text-property
                  (- point 1) point 'ivy-cursor t string)
                 string))))
    (with-current-buffer buffer
      (let ((inhibit-read-only t))
        (erase-buffer)
        (insert str)))
    (with-ivy-window
      (display-buffer
       buffer
       `((display-buffer-reuse-window
          display-buffer-below-selected)
         (window-height . ,(1+ (ivy--height (ivy-state-caller ivy-last)))))))))


(setq ivy-display-functions-alist
      '((counsel-M-x . ivy-display-function-lv)
        (ivy-completion-in-region . ivy-display-function-overlay)
        ;; (counsel-ag . ivy-display-function-overlay)
        ;; (my-counsel-ag . ivy-display-function-overlay)
        (t . nil)
        ;; (t . ivy-display-function-overlay)
        ;; (t . ivy-display-function-lv)
        ;; (t . ivy-posframe-display)
        ))


(defun ivy-tvipe-filtered-candidates ()
  (interactive)
  (tvd (list2str (ivy-filtered-candidates))))

(defun ivy-get-selection ()
  "Copy the selected candidate as a string."
  (interactive)
  ;; ivy-text is what the use has typed
  ;; (message (concat "ivy-text:" ivy-text))
  ;; (message (concat "ivy-text:" (ivy-thing-at-point)))
  ;; (message (concat "ivy-text:" (ivy-current-string)))
  ;; (my/copy ivy-text t)
  ;; (my/copy (ivy-current-string) t)
  (let ((ret nil))
    (if (ivy--prompt-selected-p)
        (ivy-immediate-done)
      ;; (delete-minibuffer-contents)
      (setq ivy-current-prefix-arg current-prefix-arg)
      (cond ((or (> ivy--length 0)
                 ;; the action from `ivy-dispatching-done' may not need a
                 ;; candidate at all
                 (eq this-command 'ivy-dispatching-done))
             (let ((s (ivy-current-string)))
               (my/copy s t)
               (setq ret s)
               s)
             ;; (ns (concat "ivy-text: " (list2string ivy-marked-candidates)))
             ;; (ivy--done (ivy-state-current ivy-last))
             )
            ((memq (ivy-state-collection ivy-last)
                   '(read-file-name-internal internal-complete-buffer))
             (if (or (not (eq confirm-nonexistent-file-or-buffer t))
                     (equal " (confirm)" ivy--prompt-extra))
                 ;; (ivy--done ivy-text)
                 (ivy--done (ivy-current-string))
               (setq ivy--prompt-extra " (confirm)")
               ;; (my/copy ivy-text t)
               (my/copy (ivy--done (ivy-current-string)) t)
               (ivy--exhibit)))
            ((memq (ivy-state-require-match ivy-last)
                   '(nil confirm confirm-after-completion))
             ;; (ivy--done ivy-text)
             (ivy--done (ivy-current-string)))
            (t
             (setq ivy--prompt-extra " (match required)")
             ;; (my/copy ivy-text t)
             (setq ret (ivy-current-string))
             (ivy--exhibit))))
    ret))


(defun ivy-copy-selection ()
  "Copy the selected candidate as a string."
  (interactive)
  ;; ivy-text is what the use has typed
  ;; (message (concat "ivy-text:" ivy-text))
  ;; (message (concat "ivy-text:" (ivy-thing-at-point)))
  ;; (message (concat "ivy-text:" (ivy-current-string)))
  ;; (my/copy ivy-text t)
  ;; (my/copy (ivy-current-string) t)
  (if (ivy--prompt-selected-p)
      (ivy-immediate-done)
    ;; It's really strange how it doesn't show, but it does copy
    (my/copy (ivy-get-selection))))


(defun ivy-open-selection-in-vim ()
  "Copy the selected candidate as a string."
  (interactive)
  (if (ivy--prompt-selected-p)
      (ivy-immediate-done)
    (sps (concat "v " (q (s-replace-regexp " .*" "" (ivy-get-selection)))))))


(defun ivy-sps-open ()
  "Copy the selected candidate as a string."
  (interactive)
  (if (ivy--prompt-selected-p)
      (ivy-immediate-done)
    ;; (sps (concat "zrepl o " (q (ivy-get-selection))))
    (sps (concat "o " (q (ivy-get-selection))))))

(defun ivy-sps-ff ()
  "Copy the selected candidate as a string."
  (interactive)
  (if (ivy--prompt-selected-p)
      (ivy-immediate-done)
    ;; (sps (concat "zrepl o " (q (ivy-get-selection))))
    (sps (concat "ff " (q (ivy-get-selection))))))

(defun ivy-sps-eww ()
  "Copy the selected candidate as a string."
  (interactive)
  (if (ivy--prompt-selected-p)
      (ivy-immediate-done)
    ;; (sps (concat "zrepl o " (q (ivy-get-selection))))
    (sps (concat "zrepl eww-ne " (q (ivy-get-selection))))))

(_ns ivy-config
     ;; (use-package counsel
     ;;   :after ivy
     ;;   :bind (("C-x C-f" . counsel-find-file)
     ;;          ("M-x" . counsel-M-x)
     ;;          ("M-y" . counsel-yank-pop)))

     ;; This should be a lambda but cant figure out how to put one as an argument to :bind
     (defun send-m-del ()
       (interactive)
       (ekm "M-DEL"))

     (use-package ivy
       :defer 0.1
       :diminish
       :bind (
              :map ivy-minibuffer-map
              ("M-D" . send-m-del)
              ("M-c" . ivy-copy-selection)
              ("M-v" . ivy-open-selection-in-vim)
              ("M-h" . sph)
              ("M-s" . spv)
              ("M-o" . ivy-sps-open)
              ("M-y" . ivy-sps-ff)
              ("M-e" . ivy-sps-eww)
              ;; Why is this globally bound? because  i have to prefix with :map
              ("C-c o" . ivy-tvipe-filtered-candidates)
              ;; ("<PageDown>" . nil)
              ;; ("<PageUp>" . nil)
              )
       ;; :bind (("C-c C-r" . ivy-resume)
       ;;        ("C-x b" . ivy-switch-buffer)
       ;;        ("C-x B" . ivy-switch-buffer-other-window))
       :custom
       (ivy-count-format "(%d/%d) ")
       (ivy-display-style 'fancy)
       (ivy-use-virtual-buffers t)
       :config (ivy-mode))

     (define-key ivy-minibuffer-map (kbd "M-c") 'ivy-copy-selection)
     (define-key ivy-minibuffer-map (kbd "M-v") 'ivy-open-selection-in-vim)
     (define-key ivy-minibuffer-map (kbd "M-D") 'send-m-del)
     (define-key ivy-minibuffer-map (kbd "C-c o") 'ivy-tvipe-filtered-candidates)

     (define-key ivy-mode-map (kbd "M-c") nil)
     (define-key ivy-mode-map (kbd "M-D") nil)
     (define-key ivy-mode-map (kbd "C-c o") nil)

     (use-package ivy-rich
       :after ivy
       :custom
       (ivy-virtual-abbreviate 'full
                               ivy-rich-switch-buffer-align-virtual-buffer t
                               ivy-rich-path-style 'abbrev)
       :config
       (ivy-set-display-transformer 'ivy-switch-buffer
                                    'ivy-rich-switch-buffer-transformer))

     ;; (use-package swiper
     ;;   :after ivy
     ;;   :bind (("C-s" . swiper)
     ;;          ("C-r" . swiper)))
     )


(defun ivy-alt-done (&optional arg)
  "Modified to = ivy-immediate-done.

Exit the minibuffer with the selected candidate.
When ARG is t, exit with current text, ignoring the candidates.
When the current candidate during file name completion is a
directory, continue completion from within that directory instead
of exiting.  This function is otherwise like `ivy-done'."
  (interactive "P")
  (ivy-immediate-done)
  ;; (setq ivy-current-prefix-arg current-prefix-arg)
  ;; (let (alt-done-fn)
  ;;   (cond ((or arg (ivy--prompt-selected-p))
  ;;          (ivy-immediate-done))
  ;;         ((setq alt-done-fn (ivy-alist-setting ivy-alt-done-functions-alist))
  ;;          (funcall alt-done-fn))
  ;;         (t
  ;;          (ivy-done))))
  )


;; THis hasn't worked
;; (defun ivy-alt-done-invert-prefix (proc &rest args)
;;   (cond
;;    (current-prefix-arg (setq current-prefix-arg nil))
;;    ((not current-prefix-arg) (setq current-prefix-arg (list 4))))
;;   (let ((res (apply proc args)))
;;     res))

;; (advice-add 'ivy-alt-done :around #'ivy-alt-done-invert-prefix)


;; I really don't want fuzzy matching in ivy. Searching for functions is a pain
;; enable fuzzy matching everywhere in ivy except in swiper
;; (with-eval-after-load 'ivy
;;   (push (cons #'swiper (cdr (assq t ivy-re-builders-alist)))
;;         ivy-re-builders-alist)
;;   (push (cons t #'ivy--regex-fuzzy) ivy-re-builders-alist))


;; Don't let ivy take over the find file function
;; (defun default-find-file ()
;;   (interactive)
;;   (exit-minibuffer)
;;   (let  ((completing-read-function 'completing-read-default))
;;     (call-interactively 'find-file) ))


;; (define-key my-mode-map (kbd "C-x C-f") #'default-find-file)
;; (define-key my-mode-map (kbd "C-x C-f") nil)

;; ivy-minibuffer-map is defined in here
;; $HOME$MYGIT/spacemacs/packages27/ivy-20180315.1446/ivy.el


;; $HOME/notes2018/todo/new-emacs-bindings.org
;; These need bindings:
;; ivy-toggle-fuzzy
;; ivy-toggle-ignore
;; ivy-toggle-calling
;; ivy-toggle-case-fold
;; ivy-toggle-regexp-quote


;; (defvar ivy-minibuffer-map
;;   (let ((map (make-sparse-keymap)))
;;     (define-key map (kbd "C-m") 'ivy-done)
;;     (define-key map [down-mouse-1] 'ignore)
;;     (define-key map [mouse-1] 'ivy-mouse-done)
;;     (define-key map [mouse-3] 'ivy-mouse-dispatching-done)
;;     (define-key map (kbd "C-M-m") 'ivy-call)
;;     (define-key map (kbd "C-j") 'ivy-alt-done)
;;     (define-key map (kbd "C-M-j") 'ivy-immediate-done)
;;     (define-key map (kbd "TAB") 'ivy-partial-or-done)
;;     (define-key map [remap next-line] 'ivy-next-line)
;;     (define-key map [remap previous-line] 'ivy-previous-line)
;;     (define-key map (kbd "C-s") 'ivy-next-line-or-history)
;;     (define-key map (kbd "C-r") 'ivy-reverse-i-search)
;;     (define-key map (kbd "SPC") 'self-insert-command)
;;     (define-key map [remap delete-backward-char] 'ivy-backward-delete-char)
;;     (define-key map [remap backward-delete-char-untabify] 'ivy-backward-delete-char)
;;     (define-key map [remap backward-kill-word] 'ivy-backward-kill-word)
;;     (define-key map [remap delete-char] 'ivy-delete-char)
;;     (define-key map [remap forward-char] 'ivy-forward-char)
;;     (define-key map [remap kill-word] 'ivy-kill-word)
;;     (define-key map [remap beginning-of-buffer] 'ivy-beginning-of-buffer)
;;     (define-key map [remap end-of-buffer] 'ivy-end-of-buffer)
;;     (define-key map (kbd "M-n") 'ivy-next-history-element)
;;     (define-key map (kbd "M-p") 'ivy-previous-history-element)
;;     (define-key map (kbd "C-g") 'minibuffer-keyboard-quit)
;;     (define-key map [remap scroll-up-command] 'ivy-scroll-up-command)
;;     (define-key map [remap scroll-down-command] 'ivy-scroll-down-command)
;;     (define-key map (kbd "<next>") 'ivy-scroll-up-command)
;;     (define-key map (kbd "<prior>") 'ivy-scroll-down-command)
;;     (define-key map (kbd "C-v") 'ivy-scroll-up-command)
;;     (define-key map (kbd "M-v") 'ivy-scroll-down-command)
;;     (define-key map (kbd "C-M-n") 'ivy-next-line-and-call)
;;     (define-key map (kbd "C-M-p") 'ivy-previous-line-and-call)
;;     (define-key map (kbd "M-r") 'ivy-toggle-regexp-quote)
;;     (define-key map (kbd "M-j") 'ivy-yank-word)
;;     (define-key map (kbd "M-i") 'ivy-insert-current)
;;     (define-key map (kbd "C-o") 'hydra-ivy/body)
;;     (define-key map (kbd "M-o") 'ivy-dispatching-done)
;;     (define-key map (kbd "C-M-o") 'ivy-dispatching-call)
;;     (define-key map [remap kill-line] 'ivy-kill-line)
;;     (define-key map [remap kill-whole-line] 'ivy-kill-whole-line)
;;     (define-key map (kbd "S-SPC") 'ivy-restrict-to-matches)
;;     (define-key map [remap kill-ring-save] 'ivy-kill-ring-save)
;;     (define-key map (kbd "C-'") 'ivy-avy)
;;     (define-key map (kbd "C-M-a") 'ivy-read-action)
;;     (define-key map (kbd "C-c C-o") 'ivy-occur)
;;     (define-key map (kbd "C-c C-a") 'ivy-toggle-ignore)
;;     (define-key map (kbd "C-c C-s") 'ivy-rotate-sort)
;;     (define-key map [remap describe-mode] 'ivy-help)
;;     map)
;;   "Keymap used in the minibuffer.")


(defun mugu-counsel-describe-custom ()
  "List all customizable variables."
  (interactive)
  (ivy-read "Describe variable: " obarray
            :predicate #'custom-variable-p
            :require-match t
            :history 'counsel-describe-symbol-history
            :keymap counsel-describe-map
            :preselect (ivy-thing-at-point)
            :sort t
            :action (lambda (x)
                      (funcall counsel-describe-variable-function (intern x)))
            :caller 'counsel-describe-variable))


;; DISCARD Change this to make it select through options instead of complete
;; TODO Make it copy what's selected into the repl
(defun ivy-partial-or-done ()
  "Complete the minibuffer text as much as possible.
If the text hasn't changed as a result, forward to `ivy-alt-done'."
  (interactive)
  (cond
   ((and (numberp completion-cycle-threshold)
         (< (length ivy--all-candidates) completion-cycle-threshold))
    (let ((ivy-wrap t))
      (ivy-next-line)))
   ((and (eq (ivy-state-collection ivy-last) #'read-file-name-internal)
         (or (and (equal ivy--directory "/")
                  (string-match-p "\\`[^/]+:.*\\'" ivy-text))
             (= (string-to-char ivy-text) ?/)))
    (let ((default-directory ivy--directory)
          dir)
      (minibuffer-complete)
      (ivy-set-text (ivy--input))
      (when (setq dir (ivy-expand-file-if-directory ivy-text))
        (ivy--cd dir))))
   (t
    (or (ivy-partial)
        (cond
         ((eq this-command last-command)
          (progn (ivy-set-text (ivy-get-selection))
                 (ivy--update-minibuffer))
          ;; TODO Make it copy the current thing into the repl
          ;; (ivy-next-line)
          )
         ((eq ivy--length 1) (ivy-alt-done)))))))


;; This does not escape +
(defun my-ivy-completing-read (prompt collection
                                      &optional predicate require-match initial-input
                                      history def inherit-input-method)
  "Read a string in the minibuffer, with completion.

This interface conforms to `completing-read' and can be used for
`completing-read-function'.

PROMPT is a string that normally ends in a colon and a space.
COLLECTION is either a list of strings, an alist, an obarray, or a hash table.
PREDICATE limits completion to a subset of COLLECTION.
REQUIRE-MATCH is a boolean value or a symbol.  See `completing-read'.
INITIAL-INPUT is a string inserted into the minibuffer initially.
HISTORY is a list of previously selected inputs.
DEF is the default value.
INHERIT-INPUT-METHOD is currently ignored."
  (let ((handler
         (and (< ivy-completing-read-ignore-handlers-depth (minibuffer-depth))
              (assq this-command ivy-completing-read-handlers-alist))))
    (if handler
        (let ((completion-in-region-function #'completion--in-region)
              (ivy-completing-read-ignore-handlers-depth (1+ (minibuffer-depth))))
          (funcall (cdr handler)
                   prompt collection
                   predicate require-match
                   initial-input history
                   def inherit-input-method))
      ;; See the doc of `completing-read'.
      (when (consp history)
        (when (numberp (cdr history))
          (setq initial-input (nth (1- (cdr history))
                                   (symbol-value (car history)))))
        (setq history (car history)))
      (when (consp def)
        (setq def (car def)))
      (let ((str (ivy-read
                  prompt collection
                  :predicate predicate
                  :require-match (when (and collection require-match)
                                   require-match)
                  :initial-input (cond ((consp initial-input)
                                        (car initial-input))
                                       ;; ((and (stringp initial-input)
                                       ;;       (not (eq collection #'read-file-name-internal))
                                       ;;       (string-match-p "\\+" initial-input))
                                       ;;  (replace-regexp-in-string
                                       ;;   "\\+" "\\\\+" initial-input))
                                       (t
                                        initial-input))
                  :preselect def
                  :def def
                  :history history
                  :keymap nil
                  :dynamic-collection ivy-completing-read-dynamic-collection
                  :extra-props '(:caller ivy-completing-read)
                  :caller (if (and collection (symbolp collection))
                              collection
                            this-command))))
        (if (string= str "")
            ;; For `completing-read' compat, return the first element of
            ;; DEFAULT, if it is a list; "", if DEFAULT is nil; or DEFAULT.
            (or def "")
          str)))))



(defun ivy-j-selection ()
  "Go to the thing if it's an emacs symbol."
  (interactive)
  (if (ivy--prompt-selected-p)
      (ivy-immediate-done)
    (sps (cmd "ynx" "j" (ivy-get-selection)))))

(define-key ivy-minibuffer-map (kbd "M-j") 'ivy-j-selection)

(provide 'my-ivy)