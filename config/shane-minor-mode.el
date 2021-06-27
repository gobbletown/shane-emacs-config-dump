;; https://swsnr.de/posts/emacs-script-pitfalls
;; This is amazing

;; Reloading shis file appears to break emacs' key bindings

;; Main use is to have my key bindings have the highest priority
;; https://github.com/kaushalmodi/.emacs.d/blob/master/elisp/modi-mode.el

(require 'my-utils)
(require 'my-distributions)


(require 'evil)
(defalias 'evil-goto-last-line 'evil-goto-line)

;; Spacemacs appears to not mind here
(require 'my-prefixes)

;; Spacemacs appears to not mind here
(load (concat emacsdir "/config/my-prefixes.el"))


(defvar my-mode-map (make-sparse-keymap)
  "Keymap for `my-mode'.")

;;;###autoload
(define-minor-mode my-mode
  "A minor mode so that my key settings override annoying major modes."
  ;; If init-value is not set to t, this mode does not get enabled in
  ;; `fundamental-mode' buffers even after doing \"(global-my-mode 1)\".
  ;; More info: http://emacs.stackexchange.com/q/16693/115
  :init-value t
  :lighter " my-mode"
  :keymap my-mode-map)
                                        ;  :keymap (let ((map (make-sparse-keymap)))
                                        ;            (define-key map [backtab] 'other-window)
                                        ;            map)
                                        ;  )
                                        ;            ; (define-key map (kbd "C-c f") 'insert-foo)

;;;###autoload
(define-globalized-minor-mode global-my-mode my-mode my-mode)

;; https://github.com/jwiegley/use-package/blob/master/bind-key.el
;; The keymaps in `emulation-mode-map-alists' take precedence over
;; `minor-mode-map-alist'
(add-to-list 'emulation-mode-map-alists `((my-mode . ,my-mode-map)))

;; Turn off the minor mode in the minibuffer
(defun turn-off-my-mode ()
  "Turn off my-mode."
  (my-mode -1))
(add-hook 'minibuffer-setup-hook #'turn-off-my-mode)

;; Minor mode tutorial: http://nullprogram.com/blog/2013/02/06/


(define-key my-mode-map (kbd "M-g M-a") #'org-agenda)


;;(define-key my-mode-map (kbd "backtab") #'other-window)
;; Don't do this because backtab is used in eww to go to the previous
;; link; Stick to C-x o
;;(define-key my-mode-map [backtab] #'other-window)
;; this used to be 'write email'
;;C-x m           compose-mail
(define-key global-map (kbd "C-x m") #'magit-status)
;; (define-key global-map (kbd "C-x l") #'magit-blame)
(defun magit-blame-addition-toggle ()
  (interactive)
  (if (minor-mode-p magit-blame-mode)
      (call-interactively 'magit-blame-quit)
    (call-interactively 'magit-blame-addition)))

(defun git-this-file ()
  (interactive)

  (tryonce
   (if (>= (prefix-numeric-value current-prefix-arg) 4)
       (magit-blame-addition-toggle)
     (magit-log-buffer-file)
     ;; (let ((fp (get-path)))
     ;;   ;; (magit-diff)
     ;;   (with-current-buffer (magit-log-buffer-file)
     ;;     ;; (magit-diff-dwim)
     ;;     ;; Running non-interactively uses the current file
     ;;     ;; (sleep 1)
     ;;     (tsk (concat "d--" (l2c magit-buffer-log-files)))
     ;;     (tsk "Enter")
     ;;     ;; (magit-diff)
     ;;     ;; magit-buffer-log-files
     ;;     ;; 
     ;;     ))
     )
   (user-error "File not associated with a git repository.")))

(define-key global-map (kbd "C-x l") 'git-this-file)

(define-key global-map (kbd "C-x C-s") #'my-save-buffer)
;; (define-key global-map (kbd "C-x C-s") nil)
;; (define-key my-mode-map (kbd "C-x C-s") nil)

;; These are both M-f1, but sometimes only one or the other works
;; M-F1
(define-key global-map (kbd "<M-f1>") #'revert-and-quit-emacsclient-without-killing-server)
(define-key global-map (kbd "<f49>") #'revert-and-quit-emacsclient-without-killing-server)
(define-key global-map (kbd "<esc>[1;9P") #'revert-and-quit-emacsclient-without-killing-server)


(define-key global-map (kbd "<f50>") #'revert-and-kill-buffer)
;; M-f4 -- should close the window
                                        ;(define-key global-map (kbd "<f52>") #'(lambda () (interactive) (shut-up (annotate-save-annotations)) (force-revert-buffer) (my-kill-buffer-and-window)))

(define-key global-map (kbd "<M-f4>") #'my/revert-kill-buffer-and-window)
(define-key global-map (kbd "<f52>") #'my/revert-kill-buffer-and-window)

;; C-x 4 0
                                        ;(define-key global-map (kbd "C-x 4 0") #'(lambda () (interactive) (shut-up (annotate-save-annotations)) (force-revert-buffer) (my-kill-buffer-and-window)))
(define-key global-map (kbd "C-x 4 0") #'my/revert-kill-buffer-and-window)
;; make a save and quit binding

                                        ;(define-key global-map (kbd "<home>") #'save-and-quit-emacsclient)

;; Instead of having all of these, I should make the keys more useful?
;; M-F7
(define-key global-map (kbd "<f55>") #'save-and-kill-buffer)
;; M-F9
(define-key global-map (kbd "<f57>") #'save-and-quit-emacsclient)
;; M-F12
(define-key global-map (kbd "<f60>") #'save-and-kill-buffer-and-window)


;;(load "$MYGIT/config/emacs/shane-minor-mode-uncamelcase.el")


;;; I want a key to open the current buffer all over the screen.


;; (global-set-key  (kbd "M-[ M-h") (kbd "M-m M-m h"))
(define-key global-map (kbd "M-[ M-h") #'git-gutter+-previous-hunk)
(define-key global-map (kbd "M-] M-h") #'git-gutter+-next-hunk)
(define-key global-map (kbd "M-g M-c") #'go-locate)
(define-key global-map (kbd "M-g M-w") #'go-which)
(define-key global-map (kbd "M-g M-i") #'server-edit)

;; Do I care about having another command that waits? No I don't. Emacs
;; automatically reloads

;; https://stackoverflow.com/questions/37531124/emacs-how-to-use-call-interactively-with-parameter
;; (global-set-key (kbd "C-c o") (lm (call-interactively 'tmux-edit t (vector "v" "nh"))))

(define-key my-mode-map (kbd "M-g M-v") (df open-in-vim (sh-notty (concat "tm breakp -s v " (q (buffer-file-path))))))

(defun open-in-vim ()
  "Opens v in current window for buffer contents"
  (interactive)
  ;; (sh-notty (concat "tm breakp -s v " (q (buffer-file-path))))
  (tmux-edit "v" "cw")
  )

(defun open-in-vs-for-copying ()
  "Opens v in current window for buffer contents"
  (interactive)
  ;; (sh-notty (concat "tm breakp -s v " (q (buffer-file-path))))
  (tmux-edit "vs" "cw")
  )

;; (global-set-key (kbd "M-g M-v") #'open-in-vim)
;; (global-set-key (kbd "M-q v") #'open-in-vim)
;; (global-set-key (kbd "M-q V") #'e/open-in-vim)
;; (global-set-key (kbd "M-q M-V") #'e/open-in-vim)
;; (global-set-key (kbd "M-q M-v") #'open-in-vim) ;This is like vim's M-q M-m for opening in emacs in the current pane

(define-key global-map (kbd "M-g v") #'open-in-vim)
(define-key global-map (kbd "M-g M-v") #'open-in-vim)

;; These work in term but nowhere else
(define-key global-map (kbd "M-q v") #'open-in-vim)
(define-key global-map (kbd "M-q V") #'e/open-in-vim)
(define-key global-map (kbd "M-q M-V") #'e/open-in-vim)
(define-key global-map (kbd "M-q M-v") #'open-in-vim) ;This is like vim's M-q M-m for opening in emacs in the current pane

;; These work everywhere except term
(define-key my-mode-map (kbd "M-q v") #'open-in-vim)
(define-key my-mode-map (kbd "M-q V") #'e/open-in-vim)
(define-key my-mode-map (kbd "M-q M-V") #'e/open-in-vim)
(define-key my-mode-map (kbd "M-q M-v") #'open-in-vim) ;This is like vim's M-q M-m for opening in emacs in the current pane

;; (define-key my-mode-map (kbd "M-l V") #'e/open-in-vim)
(define-key my-mode-map (kbd "M-l M-V") #'e/open-in-vim)

(define-key my-mode-map (kbd "M-q M-S") #'open-in-vscode)


(defun tm-edit-v-in-nw ()
  "Opens v in new window for buffer contents"
  (interactive)
  (tmux-edit "v" "nw"))
(define-key my-mode-map (kbd "C-c o") #'tm-edit-v-in-nw)

;; (global-set-key (kbd "C-c o") (lm (call-interactively 'tmux-edit t (vector "v" "nh"))))

(defun tm-edit-vs-in-nw ()
  "Opens vs in new window for buffer contents"
  (interactive)
  (tmux-edit "vs" "nw"))
;; (global-set-key (kbd "C-c O") #'tm-edit-vs-in-nw)
(define-key my-mode-map (kbd "C-c O") #'tm-edit-vs-in-nw)

(defun tm-edit-vs-here ()
  "Opens vim in this buffer with the same buffer contents"
  (interactive)
  (tmux-edit "vs" "nw")
  ;; (term \"$(nsfa "$@")\")
  )
(global-set-key (kbd "C-c v") #'tm-edit-vs-here)

(defun edit-contents-temp-buffer ()
  "Edits the contents of the buffer in a temporary buffer"
  (interactive)
  (let ((contents (buffer-contents)))
    (with-temp-buffer-window
     "scratch-contents"
     nil
     '(prin1 contents))))

(global-set-key (kbd "C-c B") #'edit-contents-temp-buffer)

;; I want to be able to pipe into lisp commands and get output. But also use the same function for regular commands

;; What do I really want for M-q?
;; I should use it for filtering.
;; Create hydra bindings for save, revert and quit
(define-key my-mode-map (kbd "M-q M-w") #'my-save)
(define-key my-mode-map (kbd "M-q M-e") #'my-revert)
(define-key my-mode-map (kbd "M-q E") #'my-revert-from-disk)

;; (define-key my-mode-map (kbd "M-g M-w") #'my-quit)

;; reverted, I don't know how to find the prefix key to extend in
;; spacemacs.
;; Also, I- don't know how to make my own prefix keys.





;; Put these bindings under L- instead of M-
(if (cl-search "SPACEMACS" my-daemon-name)
    (progn
      (define-key my-mode-map (kbd "M-g M-m") #'open-in-org-editor))
  (progn
    (define-key my-mode-map (kbd "M-g M-m") #'open-in-spacemacs)))






;; (define-key my-mode-map (kbd "M-~") #'run-region-in-tmux)

(define-key minibuffer-local-map (kbd "M-m") (lm (run-line-or-region-in-tmux) (exit-minibuffer)))
;; (define-key minibuffer-local-map (kbd "M-m") 'run-region-in-tmux)

;; tm -d nw vim
(define-key minibuffer-local-map (kbd "M-e") #'keyboard-quit-and-revert-buffer)


;; Don't I really just want *narrow* ?

;; Why is it doing this?
;; DONE Because I need to unbind some things that emacs has bound
;; (if (is-spacemacs)
;;     (define-key my-mode-map (kbd "M-C-m M-C-m") #'my/enter-edit-emacs)
;;   (define-key my-mode-map (kbd "M-C-m") #'my/enter-edit-emacs))
(define-key my-mode-map (kbd "M-C-m") #'my/enter-edit-emacs)

(define-key my-mode-map (kbd "C-m") #'my/enter-edit)
(define-key my-mode-map (kbd "C-w") #'my/c-w-cut)
;; (define-key my-mode-map (kbd "C-w") nil)
(define-key my-mode-map (kbd "M-w") #'my/m-w-copy)
(define-key my-mode-map (kbd "M-e") nil) ;This is reserved for lispy



(defun my-send-m-e ()
  "Runs 'tvipe' if a region is selected."
  (interactive)
  (if (derived-mode-p 'org-mode)
      (let ((my-mode nil))
        (execute-kbd-macro (kbd "M-E")))
    (call-interactively 'my/evil-evil-forward-WORD-end-unmark)))


;; (define-key my-mode-map (kbd "M-E") #'my/evil-evil-forward-WORD-end-unmark)
;; (define-key my-mode-map (kbd "M-E") 'my-send-m-e)
(define-key my-mode-map (kbd "M-E") nil)


(require 'evil)

;; Can't do this sadly
;; (global-set-key (kbd "M-;") 'evil-ex)

;; This works but I no longer need it
;; (global-set-key (kbd "M-~") 'evil-ex)
;; (define-key my-mode-map (kbd "M-~") 'evil-ex)

(global-set-key (kbd "M-:") 'eval-expression)

;; M-w is copy, dummy. I need this to work only when region selected
;; (define-key my-mode-map(kbd "M-w") '(lambda () (interactive) (my-save-buffer) (message "saved")))



;; These minibuffer bindings cant complete once the minibuffer has closed. I should avoid minibuffer bindings
(define-key minibuffer-local-map (kbd "M-r") #'(lambda () (interactive) (ignore-errors (exit-minibuffer)) (my-save-buffer)))

;; Aliases:
;; (define-key my-mode-map (kbd "M-;") (lookup-key (current-global-map) (kbd "M-:")))


;; These are annoying like this.
;; (define-key my-mode-map (kbd "M-m C-i") #'evil-jump-forward)
;; (define-key my-mode-map (kbd "M-m C-o") #'evil-jump-backward)


;; use lamdas where i want to run multiple functions in the placet of
;; a single function
                                        ; (add-hook 'planner-mode-hook
                                        ; #'(lambda ()
                                        ; (local-set-key (kbd "M-RET") 'muse-insert-list-item)
                                        ; (local-set-key (kbd "M-S-RET") 'pcomplete)
                                        ; (define-key (current-local-map) (kbd "&lt;f5&gt;")
                                        ; (lookup-key (current-local-map) (kbd "C-c C-j")))))


(add-hook 'mouse-leave-buffer-hook 'stop-using-minibuffer)
;; This has to be global-map for term to work
(define-key global-map (kbd "C-a") 'beginning-of-line-or-indentation)
;; (define-key my-mode-map (kbd "C-a") nil)
                                        ;(eval-after-load "cc-mode"
                                        ;     '(define-key c-mode-base-map (kbd "C-a") 'beginning-of-line-or-indentation))

;; (define-key my-mode-map (kbd "C-x C-v") #'spv-ranger)
(define-key my-mode-map (kbd "C-x C-v") #'sps-ranger)

;; Must unbind M-y for M-y M-d to work
(define-key my-mode-map (kbd "M-y") nil)
(define-key my-mode-map (kbd "M-y M-p") #'yank-path)
;; (define-key my-mode-map (kbd "M-y M-d") #'yank-dir)
(define-key my-mode-map (kbd "M-y M-d") #'yank-dir)
(define-key my-mode-map (kbd "M-y M-f") #'yank-file)
(define-key my-mode-map (kbd "M-y M-p") #'yank-path)
(define-key my-mode-map (kbd "M-y M-g") #'yank-git-path)
(define-key my-mode-map (kbd "M-y M-m") #'yank-git-path-master)
(define-key my-mode-map (kbd "M-y M-G") #'yank-git-path-sha)
;; (define-key my-mode-map (kbd "M-y M-p") #'yank-bn)

;; (define-key my-mode-map (kbd "M-q M-q") #'revert-and-quit-emacsclient-without-killing-server)
(define-key my-mode-map (kbd "M-q M-q") #'server-edit)



;; I want this to be gowhich
;; (define-key my-mode-map (kbd "M-g M-w") #'server-edit)

;; quit emacsclient without killing server

;; (define-key my-mode-map (kbd "M-q M-e M-.")
;;  (lambda ()
;;   (interactive)
;;   (shell-command (concat "tnw.sh \"" buffer-file-name "\" \"fpvd \\\"" buffer-file-name "\\\"\" &>/dev/null &") t)
;;   ))

;; (define-key my-mode-map (kbd "<home>") #'completion-at-point)
(define-key my-mode-map (kbd "<home>") nil)

;; gr -- emacs (read-shell-command "Shell command on buffer: ")



                                        ; ;; this function still hangs
                                        ; (defun open-list-of-files-in-emacs ()
                                        ;   (interactive)
                                        ;   (shell-command-on-region
                                        ;    (point-min) (point-max)
                                        ;    (concat "tmux-open-list-of-files-in-emacs.sh &")))
                                        ;
                                        ; (define-key my-mode-map (kbd "M-q M-e M-o") 'open-list-of-files-in-emacs)


;; get-buffer-contents

(define-key my-mode-map (kbd "M-q M-3") 'fzf-on-buffer)

;; vim has this. But it was annoying with magit.
;;(define-key my-mode-map (kbd "M-3") 'fzf-on-buffer)

(define-key my-mode-map (kbd "M-q M-f") #'my/fwfzf)
(define-key my-mode-map (kbd "M-q M-r") #'rt-from-region)

;; Should I start using js backbone in my scripts?
;; Because of its nice fp methods?

(define-key my-mode-map (kbd "M-q M-j") #'my/bind-1-with-fzf)
(define-key my-mode-map (kbd "M-q M-k M-t") #'show-ctags-for-buffer)
(define-key my-mode-map (kbd "M-g M-e") #'my/open-thing-at-point)

(load "/var/smulliga/source/git/config/emacs/multi-occur-bindings.el")

(global-set-key (kbd "C-c n") #'my-new-buffer-frame)
(require 'scratch)
(global-set-key (kbd "C-c j") #'scratch)


;;    M-O
;;        This key cannot ever be bound to anything. it prefixes many other keys such as the arrow key.

;; You can't toggle a major mode. You would want to go back to the
;; 'default' mode for that buffer.


(define-key my-mode-map (kbd "M-q M-d M-o") 'org-mode)


;; I want to go back in buffer history, not merely to the previous one. This is evil. Use C-o
;; (define-key my-mode-map (kbd "M-o") 'switch-to-previous-buffer)
(define-key my-mode-map (kbd "M-o") nil)

(require 'lispy)
;; This was lispy-string-oneline. Remap it maybe
(define-key lispy-mode-map (kbd "M-o") nil)


(define-key global-map (kbd "M-k") 'avy-goto-char)
(define-key my-mode-map (kbd "M-k") nil)
;; (define-key my-mode-map (kbd "M-k") 'avy-goto-char)

;; had to put it here so it overrides bindings from other packages
;; such as lispy.


;; isearch-forward-regexp

;; (define-key my-mode-map (kbd "C-s") 'swiper)
;; Swiper makes itself stick around. It won't disable when I toggle my-mode

(defun my-scroll-up ()
  (interactive)
  (call-interactively-with-prefix-and-parameters 'cua-scroll-down 8))

(defun my-scroll-down ()
  (interactive)
  (call-interactively-with-prefix-and-parameters 'cua-scroll-up 8))

;; Disable this? eshell is kind cool but not worth learning so avoid
;; using it. unless I want to extend it, which I don't.
;; (global-set-key "\C-n" "\C-u8\C-v")
;; (global-set-key "\C-p" "\C-u8\M-v")

(global-set-key "\C-n" 'my-scroll-down)
(global-set-key "\C-p" 'my-scroll-up)

;; (define-key my-mode-map (kbd "M-q M-d") 'company-yasnippet)
;; Don't break emacs bindings such as M-c (capitalize)
;; This is what I want
;; (define-key my-mode-map (kbd "M-c M-a") 'switch-to-previous-buffer)
(define-key my-mode-map (kbd "M-g M-l") 'switch-to-previous-buffer)
;;  use seleted-mode for this
;; (define-key my-mode-map (kbd "M-c M-c") 'capitalize-word)
;; Use hydra
;; (define-key my-mode-map (kbd "M-c M-e") 'my-revert)
;; (define-key my-mode-map (kbd "M-c M-w") 'my-save)

;; (define-key my-mode-map (kbd "M-c M-l") 'company-yasnippet)


;; this opens firefox


;; ;; I really don't want this
;; (if (is-spacemacs)
;;     (global-linum-mode 1))


;; This isn't going to work because of the prefix key thing
;; (if (not (cl-search "SPACEMACS" my-daemon-name))
;;     (define-key global-map (kbd "M-m f f") #'counsel-find-file))


;; Never map the delete key
;; This means that I have to come up with a new way of invoking help, because I will not change tmux's delete mechanism.


;; Make paste work in the GUI version
(define-key global-map (kbd "<M-f3>") (kbd "C-y"))

(define-key my-mode-map (kbd "C-M-k") 'previous-line)
(define-key my-mode-map (kbd "C-M-j") 'next-line)
;; See: [[/home/shane/var/smulliga/source/git/config/emacs/config/my-backspace.el][my-backspace.el]]
(define-key my-mode-map (kbd "C-M-l") 'right-char)


;; Good, these are translation-map bindings. This makes it much more reliable. Don't do this for DEL though.
(define-key key-translation-map (kbd "C-M-p") (kbd "<prior>"))
(define-key key-translation-map (kbd "C-M-n") (kbd "<next>"))

;; (define-key global-map (kbd "C-M-o") [?\C-?])

;; remappings
;; These are to allow you to use the command line emacs as you do the GUI version
(define-key key-translation-map (kbd "C-x ;") (kbd "C-x C-;"))

(define-key my-mode-map (kbd "M-D") 'backward-kill-word)

;; Make elisp around this

;; Not the best way to do it. Use hydra if I still want these
;; (global-set-key (kbd "\e\ei") #'my/go-to-emacs-el)
;; (global-set-key (kbd "\e\es") #'my/go-to-shane-minor-mode)
;; (global-set-key (kbd "\e\ec") #'my/go-to-myinit-org)

;;  I want this to be unbound while in term. I think if it's global then it will be unbound
;; (define-key my-mode-map (kbd "C-c C-x C-n") 'org-next-link)
;; It's still a bad map
(define-key global-map (kbd "C-c C-x C-p") 'org-previous-link)
(define-key global-map (kbd "C-c C-x C-n") 'org-next-link)
(define-key my-mode-map (kbd "C-c C-x C-n") nil)
;; This is also important for term
(define-key my-mode-map (kbd "C-c C-x") nil)

(defun show-kill-ring-lisp ()
  (interactive)
  (with-current-buffer
      (new-buffer-from-string
       (pp
        (mapcar
         'substring-no-properties
         (-take 30 kill-ring))))
         ;; (-take 30 kill-ring)
         ;; kill-ring)))
    (call-interactively 'special-lispy-alt-multiline)
    (emacs-lisp-mode)
    (call-interactively 'special-lispy-mark-list)
    (call-interactively 'my/lisp-first-child)))

(my/with 'helm-ring (define-key my-mode-map (kbd "C-c k") #'helm-show-kill-ring))
(my/with 'helm-ring (define-key my-mode-map (kbd "C-c K") #'show-kill-ring-lisp))

;; (defun my/quote-maybe ()
;;         "Quote selected text when region active or insert double quote."
;;         (interactive)

;;         (if (selected)
;;             (filter-selection 'q)
;;           (let ((my-mode nil))
;;             (execute-kbd-macro (kbd "\"")))))

;; Use selected.el instead of this
(if (is-spacemacs)
    (progn
      (defun my/evil-star-maybe ()
        "Perform an evil star if text is selected."
        (interactive)

        (if (selected)
            (progn (spacemacs/enter-ahs-forward)
                   (deselect)
                   (execute-kbd-macro (kbd "p")))
          (let ((my-mode nil))
            (execute-kbd-macro (kbd "*")))))

      (defun my/evil-star ()
        "Perform an evil star if text is selected."
        (interactive)

        (progn (spacemacs/enter-ahs-forward)
               (deselect)
               (execute-kbd-macro (kbd "p")))))
  (progn
    (defun my/evil-star-maybe ()
      "Perform an evil star if text is selected."
      (interactive)

      (if (selected)
          (progn
            (pcre-mode -1)
            (evil-search-word-forward)
            (execute-kbd-macro (kbd "p"))
            ;; (deselect)
            )
        (let ((my-mode nil))
          (execute-kbd-macro (kbd "*")))))
    (defun my/evil-star ()
      "Perform an evil star if text is selected."
      (interactive)

      (progn
        (pcre-mode -1)
        (evil-search-word-forward)
        (execute-kbd-macro (kbd "p"))
        ;; (deselect)
        ))))

(define-key my-mode-map (kbd "*") #'my/evil-star-maybe)


(defun my-goto-char-or-byte ()
  (interactive)
  (if (>= (prefix-numeric-value current-prefix-arg) 4)
      (call-interactively 'goto-byte)
    (call-interactively 'goto-char)))

;; (define-key my-mode-map (kbd "M-g M-g") 'evil-goto-first-line)
(define-key my-mode-map (kbd "M-g M-g") 'my-goto-char-or-byte)
(define-key my-mode-map (kbd "M-G") 'evil-goto-last-line)
(define-key my-mode-map (kbd "M-g g") 'goto-line)

;; (define-key my-mode-map (kbd "M-p") #'previous-defun)
;; (define-key my-mode-map (kbd "M-p") nil)
;; (define-key my-mode-map (kbd "M-n") #'next-defun)
;; (define-key my-mode-map (kbd "M-n") nil)

;; Sometimes I override TAB for tab completion. This ensures there is still a way to indent
;; (define-key my-mode-map (kbd "C-M-i") #'indent-for-tab-command)
;; (define-key my-mode-map (kbd "C-M-i") nil)

(require 'avy)

;; TODO Make the regex match fewer characters
;; I also need to enable more types of letters used in the decision tree -- this should be the first thing I changes
(defun my-avy-goto-subword-0 (&optional arg predicate beg end)
  "Jump to a word or subword start.
The window scope is determined by `avy-all-windows' (ARG negates it).

When PREDICATE is non-nil it's a function of zero parameters that
should return true.

BEG and END narrow the scope where candidates are searched."
  (interactive "P")
  (require 'subword)
  (avy-with avy-goto-subword-0
    (let ((case-fold-search nil)
          (subword-backward-regexp
           "\\(\\(\\W\\|[[:lower:][:digit:]]\\)\\([!-/:@`~[:upper:]]+\\W*\\)\\|\\W\\w+\\)")
          candidates)
      (avy-dowindows arg
        (let ((syn-tbl (copy-syntax-table)))
          (dolist (char avy-subword-extra-word-chars)
            (modify-syntax-entry char "w" syn-tbl))
          (with-syntax-table syn-tbl
            (let ((ws (or beg (window-start)))
                  window-cands)
              (save-excursion
                (goto-char (or end (window-end (selected-window) t)))
                (subword-backward)
                (while (> (point) ws)
                  (when (or (null predicate)
                            (and predicate (funcall predicate)))
                    (unless (not (avy--visible-p (point)))
                      (push (cons (point) (selected-window)) window-cands)))
                  (subword-backward))
                (and (= (point) ws)
                     (or (null predicate)
                         (and predicate (funcall predicate)))
                     (not (get-char-property (point) 'invisible))
                     (push (cons (point) (selected-window)) window-cands)))
              (setq candidates (nconc candidates window-cands))))))
      (avy-process candidates))))

(defun my/avy-goto-word-0 ()
  (interactive)
  (if (major-mode-p 'biblio-selection-mode)
      (let ((my-mode nil))
        (execute-kbd-macro (kbd "C-j")))
    ;; (call-interactively #'avy-goto-word-0)
    (call-interactively #'my-avy-goto-subword-0)))

;; (define-key my-mode-map (kbd "C-j") #'my/avy-goto-word-0)
(define-key my-mode-map (kbd "C-j") #'avy-goto-char-timer)

;; It's still needed for modes like prodigy which are not prog-mode
(define-key my-mode-map (kbd "M-p") #'previous-defun)
(define-key my-mode-map (kbd "M-n") #'next-defun)

;; (define-key my-mode-map (kbd "M-n") nil)

(define-key global-map (kbd "C-c l") #'org-store-link)
;; (define-key my-mode-map (kbd "C-c l") nil)
(define-key my-mode-map (kbd "M-_") #'irc-find-prev-line-with-diff-char)
(define-key my-mode-map (kbd "M-+") #'irc-find-next-line-with-diff-char)
(define-key global-map (kbd "M-g c") #'goto-char)

(if (cl-search "SPACEMACS" my-daemon-name)
    (define-key spacemacs-default-map-root-map (kbd "M-m a S") nil))

(define-key global-map (kbd "C-c o") nil)

(if (not (cl-search "SPACEMACS" my-daemon-name))
    ;; Ensure prefixes are defined -- not idempotent. M-m will erase all
    (progn
      (define-prefix-command 'my-prefix-m)
      (define-key my-mode-map (kbd "M-m") 'my-prefix-m)
      ;; Define the prefixes used elsewhere too, including my-hydra.el
      (define-prefix-command 'my-prefix-m-f)
      (define-key my-mode-map (kbd "M-m f") 'my-prefix-m-f)
      (define-prefix-command 'my-prefix-m-d)
      (define-key my-mode-map (kbd "M-m d") 'my-prefix-m-d)
      (define-prefix-command 'my-prefix-m-a)
      (define-key my-mode-map (kbd "M-m a") 'my-prefix-m-a)
      (define-prefix-command 'my-prefix-m-S)
      (define-key my-mode-map (kbd "M-m S") 'my-prefix-m-S)))

(defun list-restclient-files-ws ()
  (chomp (sh-notty "cd /; find $NOTES/ws/rest -name '*.restc' -or -name '*.restclient' | mnm" nil "/")))

(defun list-restclient-files ()
  (chomp (sh-notty "ci -t 3600 le -u \"\\(restc\\|restclient\\)\" | mnm" nil "/")))

(require 'restclient)
(defun my-choose-restclient ()
  (interactive)
  (let ((result (fz (list-restclient-files) nil t)))
    (if result
        (find-file (umn result)))))
(define-key my-mode-map (kbd "M-m a R") #'my-choose-restclient)

(define-key my-mode-map (kbd "M-m M-f M-s") #'save-buffer)
(define-key my-mode-map (kbd "M-m M-f s") #'save-buffer)
(define-key my-mode-map (kbd "M-m f s") #'save-buffer)

(defun dired-here ()
  (interactive)
  (dired "."))

(defun dired-here-columnate ()
  (interactive)
  (with-current-buffer
      (dired ".")
    (my-columnate-window 2)))

(define-key my-mode-map (kbd "M-m f d") #'dired-here)

(defun copy-last-eval-repl-result ()
  "Copy last result from Eval:"
  (interactive)
  (message (str (car values)))
  (kill-new (str (car values))))

;; TODO Need a command to copy the last thing evaluated
(defun copy-last-result ()
  (interactive)
  (message (str (car values)))
  (kill-new (str (car values))))

(defun toggle-fast-mode ()
  "If editing is too slow, toggle modes that may be more featureful but slow it bdown"
  (interactive)

  (make-local-variable 'fast-mode-on)

  (if (not (varexists 'fast-mode-on))
      ;; It should be on by default
      (setq fast-mode-on t))

  (if fast-mode-on
      (setq fast-mode-on nil)
    (setq fast-mode-on t))

  (case (intern (current-major-mode))
    ;; ('haskell-mode (shut-up (my-toggle-intero)))
    ('haskell-mode (my-toggle-intero)))

  ;; (if fast-mode-on
  ;;     (message "fast mode enabled")
  ;;   (message "fast mode disabled"))
  )

;; These are M-l. Therefore, the must be global maps so they will work in term
;; (define-key my-mode-map (kbd "M-l M-SPC") nil)
;; (define-key my-mode-map (kbd "M-l M-q M-r") nil)
;; (define-key my-mode-map (kbd "M-l M-q M-h") nil)
;; (define-key my-mode-map (kbd "M-l M-q M-b") nil)
;; (define-key my-mode-map (kbd "M-l M-q M-p") nil)
;; (define-key my-mode-map (kbd "M-l M-q M-g") nil)
;; (define-key my-mode-map (kbd "M-l M-q M-v") nil)

(defun my-selection-note ()
  (interactive)

  ;; Try with the detected language and then with the major mode

  (let* ((lang (buffer-language))
         (mode (str major-mode))
         (query (if (selection-p) (selection) (str (sexp-at-point)))))
    (find-file (sh-notty (concat "selection-note " (q query) " " lang " " mode)))))

(defun tm-click ()
  (interactive)
  (sh-notty "tm click"))

(defun tm-mousedown ()
  (interactive)
  (sh-notty "tm mousedown"))

(defun tm-mouseup ()
  (interactive)
  (sh-notty "tm mouseup"))

(define-key my-mode-map (kbd "M-\"") 'my-helm-fzf)
(define-key my-mode-map (kbd "M-L") 'helm-buffers-list)
(define-key my-mode-map (kbd "M-K") 'my-swipe)
(define-key my-mode-map (kbd "M-S") 'my-swipe)

(define-key my-mode-map (kbd "M-l M-SPC") #'toggle-fast-mode)

;; This manages old advice not new advice
;; (define-key my-mode-map (kbd "M-l M-q M-a") #'helm-manage-advice)

;; This manages new advice
(define-key my-mode-map (kbd "M-l M-q M-a") #'advice-unadvice)

(define-key my-mode-map (kbd "M-l M-q M-r") #'rosettacode)
(define-key my-mode-map (kbd "M-l M-q M-;") #'hs-run-again)
(define-key my-mode-map (kbd "M-l M-q M-h") #'hyperpolyglot)
(define-key my-mode-map (kbd "M-l M-q M-,") #'tm-click)
(define-key my-mode-map (kbd "M-l M-q M-.") #'tm-mousedown)
(define-key my-mode-map (kbd "M-l M-q M-/") #'tm-mouseup)
(define-key my-mode-map (kbd "M-l M-q M-b") #'eww-list-bookmarks)
(define-key my-mode-map (kbd "M-l M-q M-p") #'helm-bookmarks)
(define-key my-mode-map (kbd "M-l M-q M-L") #'recent-playground)
(define-key my-mode-map (kbd "M-l M-q M-G") #'recent-git)
(define-key my-mode-map (kbd "M-l M-q M-P") #'recent-project)
(define-key my-mode-map (kbd "M-l M-q M-e") #'show-extensions-below)
(define-key my-mode-map (kbd "M-l M-q M-g") #'customize-group)
;; (define-key my-mode-map (kbd "M-l M-q M-f") #'customize-face)
(define-key my-mode-map (kbd "M-l M-q M-f") #'my-customize-face)
(define-key my-mode-map (kbd "M-l M-q M-m") #'change-mode)
(define-key my-mode-map (kbd "M-l M-q M-w") #'change-wallpaper)

(define-key my-mode-map (kbd "M-l M-q M-v") #'customize-variable)
(define-key my-mode-map (kbd "M-m f n") 'rename-file)

(define-key my-mode-map (kbd "M-m f h") 'find-file-at-point)

(define-key my-mode-map (kbd "M-l M-q M-q") 'my-selection-note)

(define-key my-mode-map (kbd "M-#") 'handle-rc)

(defun rtcmd-sed ()
  (interactive)
  (sh-notty (concat "tm -f -S -tout nw -noerror " (q "siq")) (buffer-contents)))
(defalias 'siq 'rtcmd-sed)

(defun rtcmd-scrape ()
  (interactive)
  (sh-notty (concat "tm -f -S -tout nw -noerror " (q "ciq")) (buffer-contents)))
(defalias 'ciq 'rtcmd-scrape)
(defalias 'scrape-pcre-rt 'rtcmd-scrape)

(defun scrape-pcre (re input)
  (sh-notty (concat "scrape " (q re)) input))

(define-key my-mode-map (kbd "M-q M-l") #'rtcmd-sed)

;; Just don't have a forward. It doesn't work at all anyway.
;; (define-key my-mode-map (kbd "C-o") #'evil-jump-backward)


(defun my-holy-mark ()
  (interactive)
  (cond
   ((>= (prefix-numeric-value current-prefix-arg) 16) (call-interactively 'evil-show-marks) )
   ((>= (prefix-numeric-value current-prefix-arg) 4) (call-interactively 'evil-goto-mark-line))
   (t (call-interactively 'evil-set-marker))))

(define-key global-map (kbd "M-M") #'my-holy-mark)

(define-key global-map (kbd "M-l M-k M-&") 'show-interactive-prefix)

;; tm vim-open-buffer-list-in-windows

(defun open-these-windows-in-tmux-windows ()
  (interactive)
  )


(defun my-select-thing-at-point ()
  (interactive)
  (deselect)
  (if (>= (prefix-numeric-value current-prefix-arg) 4)
      (my-select-regex-at-point "[^ ]+")
    (my-select-regex-at-point (my/thing-at-point) t)))

(define-key my-mode-map (kbd "M-u") 'my-select-thing-at-point)


(defun my-join-line ()
  (interactive)
  (save-excursion
    (next-line)
    (join-line)))

(define-key my-mode-map (kbd "M-J") 'my-join-line)

(define-key my-mode-map (kbd "H-w") 'get-path)


(provide 'my-mode)