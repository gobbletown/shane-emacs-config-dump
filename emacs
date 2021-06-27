;; .emacs vs init.el
;; [[https://www.reddit.com/r/emacs/comments/8mreuq/split_emacs_and_emacsdinitel/][Split .emacs and .emacs.d/init.el : emacs]]

;; I want to start in lispy mode, not on a comment. I can, however, just
;; use the 'f' key.
;; Double comment starts it in lispy mode.

;; I could collect this from an environment variable if I wanted
;; Or use this:
;; user-emacs-directory
(defvar emacsdir "/home/shane/var/smulliga/source/git/config/emacs")

(require 'f)

(defmacro yes (&rest body)
  `(flet ((yes-or-no-p (&rest args) t)
          (y-or-n-p (&rest args) t))
     (progn ,@body)))

;; This prevents packages from loading until I specifically require them
;; https://emacs.stackexchange.com/questions/32451/disable-package-without-uninstalling
;; Fixed a bug in spacemacs
(setq package-load-list '(all
                          (sly nil)))

;; DISCARD Completely disable lsp-treemacs
;; (add-to-list 'package-load-list '(lsp-treemacs nil))

(load (concat emacsdir "/config/my-package-blacklist.el"))

(view-echo-area-messages)
;; (switch-to-buffer "*Messages*")

;;(with-current-buffer (messages-buffer)
;;  (goto-char (point-max))
;;  (switch-to-buffer (current-buffer)))

(load (concat emacsdir "/config/my-basic.el"))

;; Unfortunately, these appear to need to be defined at the site (some
;; file) -- verify this
;; (load (concat emacsdir "/config/my-prefixes.el"))

;; This is how I can debug (as a daemon, which is needed to catch all
;; the errors)
;; sp nw --debug-init
(setq my-daemon-name (daemonp))
; (setq my-daemon-name "SPACEMACS")

(load (concat emacsdir "/config/my-messages.el"))
(load (concat emacsdir "/config/my-syntax-extensions.el"))
(load (concat emacsdir "/config/my-serialise.el"))
(load (concat emacsdir "/config/my-global-argument.el"))
(load (concat emacsdir "/config/my-kill.el"))
(load (concat emacsdir "/config/my-kitchin.el"))

(load (concat emacsdir "/config/my-custom-conf.el"))

(defun byte-recompile-directory (directory &optional arg force)
  "I hope this disables this function"
  nil)

;; I hate how hard it is to debug emacs -- the lack of error messages.

;; Will this fix it? Emacs stack traces are impossible to read.
;;(setq debug-ignored-errors t)

;; Why is there no

;; God I hate byte compilation
;;(byte-compile-disable-warning 'bytecomp)

;; Without this, emacs will likely hang
(setq org-agenda-skip-unavailable-files t)


;; Hopefully this disables the constant annoying 'checking'.
(setq no-byte-compile t)

;; this appears to break things.
(setq server-socket-dir "~/.emacs.d/server")

;; This is bad usually. Masking warnings is not a good idea
;;(setq warning-minimum-level :emergency);;*

;; this allows unsafe variables to be set but I don't get prompted ever
;; and I have full features
;; https://emacs.stackexchange.com/questions/28/safe-way-to-enable-local-variables
(setq enable-local-variable :all)

;; Can't do this. I have files in this folder that I don't want to load.
;; They will be loaded automatically if I use load-path
;;(add-to-list 'load-path (concat emacsdir "/"))
(add-to-list 'load-path (concat emacsdir "/config"))
(add-to-list 'load-path (concat emacsdir "/settings"))

;; Don't put this intel utils.els
(defun lc (package-names)
  "loads a package from a config directory. Switch this to require."
  (if (listp package-names)
      (dolist (name package-names)
        (load (concat emacsdir "/config/" name ".el")))
    (load (concat emacsdir "/config/" package-names ".el"))))

(load (concat emacsdir "/config/my-gud.el"))
(load (concat emacsdir "/config/my-tags.el"))

(load (concat emacsdir "/manual-packages/dash.el/dash.el"))
(load-library "dash")

;; (load (concat emacsdir "/config/my-aliases.el"))
(lc "my-aliases")
;; (load (concat emacsdir "/config/my-macros.el"))
(lc "my-macros")

(load (concat emacsdir "/config/my-strings.el"))

;; (defun my/load (fp)
;;   (load (concat emacsdir "/manual-packages/dash.el/dash.el"))
;;   )


;; Disable the ranger key early so when ranger is loaded, it doesn't
;; override C-p in dired
(defset ranger-key nil)

(load (concat emacsdir "/manual-packages/emacs-memoize/memoize.el"))
(load (concat emacsdir "/manual-packages/problog-mode/problog-mode.el"))
(load (concat emacsdir "/manual-packages/s.el/s.el"))
;; "$MYGIT/emacsmirror/emacswiki.org/info+.el"
(load (concat emacsdir "/manual-packages/info+/info+.el"))
(load (concat emacsdir "/manual-packages/f.el/f.el"))
(load (concat emacsdir "/manual-packages/asoc.el/asoc.el"))
(load (concat emacsdir "/manual-packages/ob-php/ob-php.el"))

;; (load (concat emacsdir "/manual-packages/ob-tmux/ob-tmux.el"))
(load (concat emacsdir "/manual-packages/emacs-noflet/noflet.el"))

(load (concat emacsdir "/manual-packages/emacs-pipe/pipe.el"))
(load (concat emacsdir "/manual-packages/wn-org/wn-org.el"))
(load (concat emacsdir "/manual-packages/speed-of-thought-lisp/sotlisp.el"))
(load (concat emacsdir "/manual-packages/emacs-cppref/cppref.el"))
(load (concat emacsdir "/manual-packages/glsl-mode/glsl-mode.el"))

(add-to-list 'load-path "/var/smulliga/source/git/config/emacs/packages27/org-20200316")
(require 'org-macs)
(require 'org)
(load "/var/smulliga/source/git/config/emacs/packages27/org-20200316/org-macs.el")
(load "/var/smulliga/source/git/config/emacs/packages27/org-20200316/org.el")
(load "/var/smulliga/source/git/config/emacs/packages27/org-20200316/org-tempo.el")

;; Not sure why I can't simply require org-tempo
;; https://github.com/abo-abo/hydra/issues/308
;; This is for compatibility so maybe it should be in here
;; $MYGIT/config/emacs/config/my-compatibility.el

;; (load "/var/smulliga/source/git/config/emacs/packages27/org-20190408/org.el")
;; (load "/var/smulliga/source/git/config/emacs/packages27/org-20190408/org-tempo.el")
(require 'org-tempo)
(setq org-structure-template-alist (eval (car (get 'org-structure-template-alist 'standard-value))))

;; vim +/"Use ~org-save-outline-visibility~ instead." "$MYGIT/config/emacs/packages27/org-plus-contrib-20190408/etc/ORG-NEWS"

(defalias 'org-try-structure-completion 'org-tempo-complete-tag)
(defalias 'org-outline-overlay-data 'org-save-outline-visibility)
(defalias 'org-set-outline-overlay-data 'org-save-outline-visibility)
(defalias 'org-context-p 'org-element-at-point)


;; (require 'my-utils) (exit)

;;(require 'my-utils)

;; When I create the macro/function for loading elisp files, check if a .cruft.el
;; file also exists and load it

;; divide this up because saving this file is slow slow it makes me want
;; to take my own life
(load (concat emacsdir "/config/my-cua.el"))
(load (concat emacsdir "/config/my-utils.el"))
(load (concat emacsdir "/config/my-net.el"))
(load (concat emacsdir "/config/my-show-map.el"))
(load (concat emacsdir "/config/my-advice-1.el"))
(load (concat emacsdir "/config/my-filters.el")) ;; needed for e/q
(load (concat emacsdir "/config/my-utils.cruft.el"))

(load (concat emacsdir "/config/my-prefixes.el"))

(load (concat emacsdir "/config/my-el-db.el"))

(load (concat emacsdir "/config/my-fuzzy.el"))
(load (concat emacsdir "/config/my-nix.el"))
(load (concat emacsdir "/config/my-myrc.el"))
(load (concat emacsdir "/config/my-tools.el"))

(load (concat emacsdir "/config/my-operators.el"))

;; (exit)
(load (concat emacsdir "/config/my-compatibility.el"))
(require 'my-compatibility)


;; Re-enable
(load (concat emacsdir "/select-distribution.el"))

;; at this point everything works, even with font-lock mode
;; spacemacs works with its starting menu
;; (exit)

;; disable C-v C-c windows-like mappings
(setq cua-enable-cua-keys nil)



;;(setq user-init-file (or load-file-name (buffer-file-name)))
;;(setq user-emacs-directory (file-name-directory user-init-file))


;; vim +/"byte-compile) {" "/home/shane/scripts/e"
;; (byte-recompile-directory (expand-file-name "~/.emacs.d") 0)

;; If the variable isn't set then set it to nil. This avoids problems
;; when scimax is sourced first.
(if (not (boundp 'this-is-scimax))
    (setq this-is-scimax nil))

;; (exit)

;; (load (tv (concat emacsdir "/config/my-rainbow.el")))
(load (concat emacsdir "/config/my-rainbow.el"))

(load (concat emacsdir "/config/my-yasnippet.el"))
(load (concat emacsdir "/config/my-hippie-expand.el"))

(load (concat emacsdir "/config/my-yatemplate.el"))

(load (concat emacsdir "/config/my-packages.el"))

;; I think this is troublesome. It's breaking
;;(require 'my-repl-history)
(load (concat emacsdir "/config/my-repl-history.el"))

;;(exit)
;; emacs25 doesn't have this
;;(ignore-errors (set-default-font "Monospace-10"))


;; working here
;;(exit)
;; (catch 'my-catch (when t (throw 'my-catch "always going to throw"))

;;(server-start)

(ignore-errors
  (winum-mode 0))                          ; This needs to be up the top somewhere

;; minibuffer history is saved
(savehist-mode 1)

;; for autocompletion
(setq tab-always-indent 'complete)
(add-to-list 'completion-styles 'initials t)

;; This stuff must be up the top because it has to load before org files are found for the agenda, that sort of thing
(load (concat emacsdir "/config/my-linum.el"))

;; This works on everything, which is very undesirable, actually, especially when I have tables.
;; Start annotate mode
;; annotate mode sucks
;; (define-globalized-minor-mode
;;   my-global-window-margin-mode
;;   window-margin-mode
;;   (lambda ()
;;     (shut-up
;;       (ignore-errors
;;         (progn
;;           (window-margin-mode 1))))))

;; (my-global-window-margin-mode 1)

;; this is amazing. proper wrapping of lines in org-mode.
;; However, the default mode for org-mode is truncate-lines mode.
;; This will also help me to understand subconsciously the way org mode
;; handles indentation.


;; no read-only repl at this point
;; (exit)

;; This makes swiper extremely slow. Not worth it. In shane-minor-mode I have come up with a solution.
;; Surround swipe with a call to temporarily disable visual-line-mode

;; This was evil
;; (global-visual-line-mode t)


;; BISECT

;; This makes lines wrap at 80c width without adding newlines
(setq-default fill-column 90)
;; not sure why this is not working
;; (add-hook 'text-mode 'window-margin-mode)
;; (add-hook 'org-mode (lambda () window-margin-mode))

;;(exit)

;; this appears to cause the repls to be read-only. Removing this fixed
;; the repl read-only bug.
;; Instead, do this inside $EMACSD/auto-mode-load.el
;; (add-to-list 'auto-minor-mode-alist '("\\(\\.el\\|emacs\\)\\'" . org-link-minor-mode))

;; ;; [[https://github.com/seanohalpin/org-link-minor-mode][GitHub - seanohalpin/org-link-minor-mode: Enable org-mode bracket links in non-org modes]]
;; (define-globalized-minor-mode
;;   my-global-org-link-mode
;;   org-link-minor-mode
;;   (lambda ()
;;     (shut-up
;;       (ignore-errors
;;         (progn
;;           (org-link-minor-mode 1))))))
;; (my-global-org-link-mode 1)

;; don't prompt to enter the directory of a symlink. just do it.
;; this affects the way emacs handles being in a git directory.

(setq vc-follow-symlinks t)

(setq mode-require-final-newline nil)

;; getting the read only repl
;;(exit)

(setq-default truncate-lines t)
;; (setq truncate-lines t)
;; (setq truncate-lines nil)

;; https://github.com/emacs-helm/helm/issues/550
(setq helm-exit-idle-delay 0)

;;use the bs-show buffer menu instead of list-buffers
;;(global-set-key [?\C-x ?\C-b] 'bs-show)
(global-set-key [?\C-x ?\C-b] 'helm-buffers-list)


;;(load "$MYGIT/andreasjansson/language-detection.el/language-detection.el")

;; Spacemacs is still broken for daemon mode. It's OK here. But not at
;; 20%
;;(exit)


(load (concat emacsdir "/config/my-agda.el"))

;; (load "/var/smulliga/source/git/config/emacs/my-treemacs.el")


(load (concat emacsdir "/config/my-region-filters.el"))


(global-undo-tree-mode)

;; example
(defun insertline-before ()             ;; Every extension is a function
  "Inserts a line prior to the cursor." ;; Describe the function for fun.
  (interactive)                         ;; This can be called from M-x
  (let ( (current-spot (point) ) )      ;; Store the position of the cursor
    (move-beginning-of-line 1)          ;; Move cursor to front of line, Duh.
    (insert "\n")                       ;; New line
    (goto-char current-spot)            ;; Go back to where we were... Oh no.
    (forward-char)))                    ;; We need to move forward since we
;; inserted a new line.
;;(global-set-key (kbd "C-S-o")  'insertline-before)


;; fix alt as meta
(setq x-alt-keysym 'meta)


;; Make delete word work the same as zsh
;; More convenient than C-M-8
(define-key global-map "\C-\M-h" 'backward-kill-word)
;; fix C-h. How then to get help using C-h i ???
;;(define-key global-map "\C-h" 'backward-delete-char)

;; Make *scratch* buffer blank.


;; This section still broke spacemacs in daemon mode. I had to comment
;; it out
;; (defun my-close-scratch ()
;;  (ignore-errors (kill-buffer "*scratch*"))
;;  (kill-buffer "*Messages*")
;;  ;;(if (not (delq nil (mapcar 'buffer-file-name (buffer-list))))
;;  ;;  (new-untitled-buffer)
;;  ;;  )
;;  )
;;
;;(if (not (cl-search "SPACEMACS" my-daemon-name))
;;  ; this breaks spacemacs' daemon mode
;;(setq initial-scratch-message nil)
;;
;;
;;
;;  ; this breaks spacemacs' start menu
;;  (defun my-emacs-startup-hook ()
;;    (my-close-scratch))
;;
;;  (add-hook 'emacs-startup-hook 'my-emacs-startup-hook)
;;  )

;; this is what is working for me now
(setq magit-display-buffer-function
      (lambda (buffer)
        (if magit-display-buffer-noselect
            ;; the code that called `magit-display-buffer-function'
            ;; expects the original window to stay alive, we can't go
            ;; fullscreen
            (magit-display-buffer-traditional buffer)
          (delete-other-windows)
          ;; make sure the window isn't dedicated, otherwise
          ;; `set-window-buffer' throws an error
          (set-window-dedicated-p nil nil)
          (set-window-buffer nil buffer)
          ;; return buffer's window
          (get-buffer-window buffer))))


;; disable menu bar
(menu-bar-mode -1) "M-x menu-bar-mode"
(tool-bar-mode -1) "M-x tool-bar-mode"
(toggle-scroll-bar -1)

(mouse-avoidance-mode 'exile)           ; Move mouse pointer out of way of cursor


(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))



;;(cond
;; ((string= "magit" my-daemon-name)
;;  (global-font-lock-mode 1)
;;  )
;; (t
;;  (ignore-errors
;;    (progn
;;      (global-font-lock-mode 0)
;;      )
;;    )
;;  )
;; )


(defhydra hydra-zoom (global-map "<f2>")
  "zoom"
  ("g" text-scale-increase "in")
  ("l" text-scale-decrease "out"))

(defhydra hydra-buffer-menu (:color pink
                                    :hint nil)
  "
^Mark^             ^Unmark^           ^Actions^          ^Search
^^^^^^^^-----------------------------------------------------------------
_m_: mark          _u_: unmark        _x_: execute       _R_: re-isearch
_s_: save          _U_: unmark up     _b_: bury          _I_: isearch
_d_: delete        ^ ^                _g_: refresh       _O_: multi-occur
_D_: delete up     ^ ^                _T_: files only: % -28`Buffer-menu-files-only
_~_: modified
"
  ("m" Buffer-menu-mark)
  ("u" Buffer-menu-unmark)
  ("U" Buffer-menu-backup-unmark)
  ("d" Buffer-menu-delete)
  ("D" Buffer-menu-delete-backwards)
  ("s" Buffer-menu-save)
  ("~" Buffer-menu-not-modified)
  ("x" Buffer-menu-execute)
  ("b" Buffer-menu-bury)
  ("g" revert-buffer)
  ("T" Buffer-menu-toggle-files-only)
  ("O" Buffer-menu-multi-occur :color blue)
  ("I" Buffer-menu-isearch-buffers :color blue)
  ("R" Buffer-menu-isearch-buffers-regexp :color blue)
  ("c" nil "cancel")
  ("v" Buffer-menu-select "select" :color blue)
  ("o" Buffer-menu-other-window "other-window" :color blue)
  ("q" quit-window "quit" :color blue))

(define-key Buffer-menu-mode-map "." 'hydra-buffer-menu/body)


;; This replaces many of the normal find-file key bindings with
;; ffap-based versions. It's super nice.
(ffap-bindings)

(global-set-key (kbd "M-i") 'iedit-mode)


(load (concat emacsdir "/config/my-translation-map.el"))


(dolist (key
         '("M-l"
           "M-c"
           "C-o"
           "M-o"
           ))
  (global-unset-key (kbd key)))

;;(global-set-key (kbd "C-o") 'jumplist-previous)
;;(global-set-key (kbd "M-o") 'jumplist-next)

;; disabling prompts -- https://www.masteringemacs.org/article/disabling-prompts-emacs
;; -----------------------------------------------------------------------------------
(fset 'yes-or-no-p 'y-or-n-p)
(setq confirm-nonexistent-file-or-buffer nil)
(setq ido-create-new-buffer 'always)
(setq inhibit-splash-screen t)
(setq inhibit-startup-message t)
(setq kill-buffer-query-functions
      (remq 'process-kill-buffer-query-function
            kill-buffer-query-functions))

;; Making tooltips appear in the echo area -- https://www.masteringemacs.org/article/making-tooltips-appear-in-echo-area
;; ---------------------------------------------------------------------------------------------------------------------
(tooltip-mode -1)
(setq tooltip-use-echo-area t)



(setq eww-search-prefix "")



(defun xah-new-empty-buffer ()
  "Create a new empty buffer.
 New buffer will be named “untitled” or “untitled<2>”, “untitled<3>”, etc.

 URL `http://ergoemacs.org/emacs/emacs_new_empty_buffer.html'
 Version 2016-12-27"
  (interactive)
  (let ((-buf (generate-new-buffer "untitled")))
    (switch-to-buffer -buf)
    (funcall initial-major-mode)
    (setq buffer-offer-save t)))


;; define function to shutdown emacs server instance
(defun server-shutdown ()
  "Save buffers, Quit, and Shutdown (kill) server"
  (interactive)
  (save-some-buffers)
  (kill-emacs)
  )

;; this makes emacs call rebalance-windows (which is what C-x + is
;; bound to by default) after every resize. It's not what I want all
;; the time, but I want it much more often than the default behavior.
(defadvice split-window-horizontally (after rebalance-windows activate)
  (balance-windows))
(ad-activate 'split-window-horizontally)


(defun oleh-eww-hook ()
;; to stop newlines being added to the web page when I press C-j or
;; C-m in an area without a button.
  (define-key eww-mode-map "\C-j/" nil)
  (define-key eww-mode-map "\C-m/" nil)
;;(define-key eww-mode-map "j" 'oww-down)
;;(define-key eww-mode-map "k" 'oww-up)
;;(define-key eww-mode-map "l" 'forward-char)
;;(define-key eww-mode-map "L" 'eww-back-url)
;;(define-key eww-mode-map "h" 'backward-char)
;;(define-key eww-mode-map "v" 'recenter-top-bottom)
;;(define-key eww-mode-map "V" 'eww-view-source)
;;(define-key eww-mode-map "m" 'eww-follow-link)
;;(define-key eww-mode-map "a" 'move-beginning-of-line)
;;(define-key eww-mode-map "e" 'move-end-of-line)
;;(define-key eww-mode-map "o" 'ace-link-eww)
;;(define-key eww-mode-map "y" 'eww))
  )
(add-hook 'eww-mode-hook 'oleh-eww-hook)


(message ".emacs: lisp")

;; This is all lisp stuff, common lisp and elisp
(load (concat emacsdir "/lisp.el"))

;; just never load it
;;(if (not (is-spacemacs))
;;    (load (concat emacsdir "/config/my-counsel.el"))
;;    )
(load (concat emacsdir "/config/my-counsel.el"))


(load (concat emacsdir "/manual-packages/handle/handle.el"))
(load (concat emacsdir "/config/my-handle.el"))
(load (concat emacsdir "/config/my-prog.el"))
(load (concat emacsdir "/config/my-rc.el"))


(load (concat emacsdir "/config/my-isearch.el"))


;; (exit)
;; must come before my-evil
;; I want to combine selected and visual-mode
(load (concat emacsdir "/config/my-selected.el")) ;; needs my-doc

(load (concat emacsdir "/config/my-fuzzy-lists.el"))

(load (concat emacsdir "/config/my-lisp.el"))
(load (concat emacsdir "/config/my-lispy.el"))
(load (concat emacsdir "/config/my-common-lisp.el"))

(load (concat emacsdir "/config/evil-lisp.el"))

;;(add-to-list 'load-path (concat emacsdir "/manual-packages/sly"))
;;(require 'sly)
;; (load (concat emacsdir "/manual-packages/sly/sly.el"))

(load (concat emacsdir "/config/my-slime.el"))
(load (concat emacsdir "/config/my-hydra-window.el"))

(load (concat emacsdir "/config/my-ssh.el"))

(load "/var/smulliga/source/git/config/emacs/fixes.el")

(load (concat emacsdir "/config/my-vim.el"))

;; (if (region-active-p)

;; https://emacs.stackexchange.com/questions/352/how-to-override-major-mode-bindings
;;     ;; If you want the keybinding to override all minor modes that may also bind
;;     ;; the same key, use the `bind-key*' form:
;;
;;     ;; I need this:
;;
;;     (bind-key* "<C-return>" 'other-window)

(load (concat emacsdir "/config/my-general-bindings.el"))

;; enable powerline
(ignore-errors (powerline-vim-theme))

(load (concat emacsdir "/dired-maps.el"))

;(require 'shut-up)
;;; Why do I need to forcefully load this?
;(load "/home/shane/var/smulliga/source/git/config/emacs/packages27/shut-up-20180628.1830/shut-up.el")

;; (define-key my-mode-map (kbd "M-y M-p")
;; (lambda ()
;; (interactive)
;; (shell-command (concat "echo -E \"" buffer-file-name "\" | xclip-in.sh &>/dev/null") t)
;; ))

;; this doesn't fix it
;;(define-key global-map (kbd "M-y") nil)
;;(define-key dired-mode-map (kbd "M-y") nil)


;; Here’s a variant of cycle-thing-region that iterates over
;; ‘thing-types’ until either it finds some thing near point, or the
;; list is exhausted.


(defun cycle-thing-region-with-continue ()
  "Select the first thing from `thing-types' found near point.
 Successive uses select the next thing from the list to be found near point.
 On each use, the command will iterate over the list until something is found.
 This can be really slow when `thing-types' is long and so is the buffer."
  (interactive)
  (if (eq last-command this-command)
      (goto-char thgcmd-thing-region-point)
    (setq thgcmd-thing-region-index  0
          thgcmd-thing-region-point   (point)))
  (let ((success nil))
    (if (= thgcmd-thing-region-index (length thing-types))
        (setq thgcmd-thing-region-index 0))
    (while (and (not success) (< thgcmd-thing-region-index (length thing-types)))
      (setq thing (elt thing-types thgcmd-thing-region-index))
      (setq thgcmd-thing-region-index  (1+ thgcmd-thing-region-index))
      (setq success (thing-region thing))
      (when success
        (setq thgcmd-last-thing-type  (intern thing))
        (message "%s" (capitalize
                       (elt thing-types (1- thgcmd-thing-region-index))))))))

(load (concat emacsdir "/config/my-clipboard.el"))

(defun xx ()
  "print current word."
  (interactive)
  (message "%s" (thing-at-point 'word)))

;; (global-auto-complete-mode t)

;; Python
;; it's not working atm
;;(elpy-enable)

;; Enable per-mode
;;(add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode)
;;(add-hook 'clojure-mode-hook #'aggressive-indent-mode)
;;(add-hook 'ruby-mode-hook #'aggressive-indent-mode)

;; Enable for all modes
;; this is bad
;;(global-aggressive-indent-mode 1)

;; replace audio notifications with visual
;; (setq visible-bell t)

;; disable audio notifications
(setq ring-bell-function 'ignore)

;; appears to not work
;; this is how to auto load the correct modes
;; this works
;; (setq auto-mode-alist
;;       (append
;;         ;; File name (within directory) starts with a dot.
;;         '(("/\\.[^/]*\\'" . fundamental-mode)
;;           ;; File name has no dot.
;;           ("/[^\\./]*\\'" . fundamental-mode)
;;           ;; this overrides the default incorrect JavaScript-mode
;;           ("\\.json\\'" . json-mode)
;;           ("\\.org\\'" . org-mode)
;;           ("\\.kt\\'" . kotlin-mode)
;;           ("\\.exs\\'" . alchemist-mode)
;;           ;; File name ends in ‘.C’.
;;           ("\\.C\\'" . c++-mode)
;;          )
;;       )
;;       auto-mode-alist)
;;           ; ("\\.py\\'" . jedi-mode)

;;(autoload 'kotlin-mode "kotlin" "Some documentation." t)


(load (concat emacsdir "/config/auto-mode-load.el"))
(load (concat emacsdir "/config/my-shebang.el"))

;; (defun his-tracing-function (shr-copy-url &rest args)
;; (message "display-buffer called with args %S" args)
;; (let ((res (apply shr-copy-url args)))
;; (message "display-buffer returned %S" res)
;; res))

;; (advice-add 'display-buffer :around #'his-tracing-function)


;; vim +/auto-mode-alist $VSGIT/config/emacs/emacs

;; (require 'my-utils)(exit)


;; Enable this. use screen-2color to toggle colour instead. I get some
;; nice black and white decoration if I leave this on.

;; this is what is causing my REPLs to be read-only
(global-font-lock-mode 1)
;; but I don't think that is the only thing

;; (require 'my-utils)(exit)


(setq path-to-ctags "/usr/local/bin/ctags") ;; <- your ctags path here
(defun create-tags (dir-name)
  "Create tags file."
  (interactive "DDirectory: ")
  (shell-command
   (format "%s -f TAGS -e -R %s" path-to-ctags (directory-file-name dir-name))))

(load (concat emacsdir "/config/my-mc.el"))

;; disable auto-indent. This is the less-aggressive auto-indent that
;; happens after pressing enter
(when (fboundp 'electric-indent-mode) (electric-indent-mode -1))

;; Create a function that inserts a line
;; ’above’ the current cursor position.
(defun my/insert—line—before ()
  "Inserts a newline(s) above the 'Line containing
  the cursor."
  (interactive)
  (save-excursion
    (move-beginning-of-line 1)
    (newline)))


(message ".emacs: which-key")
;; (require 'my-utils)(exit)

(load (concat emacsdir "/config/my-which-key.el"))
(load (concat emacsdir "/config/my-prettify-symbols.el"))

;; You don't want to run both guide-key and which-key
(load (concat emacsdir "/config/my-guide-key.el"))

;; reenable later. it's breaking spacemacs

;; ((not (string= "scimax" my-daemon-name))

(ignore-errors
  (progn
    (require 'subr-x)
    ;; subr-x is needed for some packages
    ;; copy-as-format: Symbol's function definition is void: string-empty-p
    )
  )

;; git-link doesn't work well
;; SUPER IMPORTANT
;; *   It doesn't follow the philosophy of when I install something, I
;;     should seek out how to get it and then automate it that way.
;;     As in, automate it myself and do not guess.
;;
;;     But maybe this one works
;;     [[https://github.com/rmuslimov/browse-at-remote][GitHub - rmuslimov/browse-at-remote: Browse target page on github/bitbucket from emacs buffers]]
;;         Still not convinced.
;;
;;         https://stackoverflow.com/questions/32912320/creating-pull-requests-right-from-emacs
;;             Hmm, looks awesome but still not convinced. Automate other things.



;; (ignore-errors
;;   (progn
;;     (require 'git-link)
;;     (eval-after-load 'git-link
;;       '(progn
;;          (add-to-list 'git-link-remote-alist
;;                       '("corp606.us.crownlift.net" git-link-bitbucket))
;;          (add-to-list 'git-link-commit-remote-alist
;;                       '("corp606.us.crownlift.net" git-link-commit-bitbucket))))))

(ignore-errors
  (progn
    (require 'browse-at-remote)
    (global-set-key (kbd "C-c g g") 'browse-at-remote)
    (global-set-key (kbd "C-c w s") 'copy-as-format-slack)
    (global-set-key (kbd "C-c w g") 'copy-as-format-github)
    )
  )

;; (require 'my-utils)(exit)

;; this doesn't work to detect scimax
(cond
 ((string= "scimax" my-daemon-name)
  (identity nil))
 (t
  (ignore-errors
    (progn
      ;; do not start git gutter. I want a clean tmux window for
      ;; copying things
      ;;(global-git-gutter-mode +1)

      ;;(add-hook 'ruby-mode-hook 'git-gutter-mode)
      ;;(add-hook 'python-mode-hook 'git-gutter-mode)
      ;;(add-hook 'c++-mode-hook 'git-gutter-mode)

      (global-set-key (kbd "C-x v p") 'git-messenger:popup-message)

      (define-key git-messenger-map (kbd "m") 'git-messenger:copy-message)

      ;; Use magit-show-commit for showing status/diff commands
      (custom-set-variables
       '(git-messenger:use-magit-popup t))

      (require 'helm-config)
      (require 'helm-ack)

      (custom-set-variables
       ;; Does not insert '--type' option
       '(helm-ack-auto-set-filetype nil)
       ;; Insert "thing-at-point 'symbol" as search pattern
       '(helm-ack-thing-at-point 'symbol))))))

(setq org-startup-folded nil)




;; Start annotate mode
;; annotate mode sucks
;;(define-globalized-minor-mode my-global-annotate-mode annotate-mode
;;  (lambda () (shut-up (ignore-errors (progn (annotate-clear-annotations) (annotate-mode 1))))))
;;(my-global-annotate-mode 1)

(shut-up
  (ignore-errors
    (progn
      ;; ipython pylab
      (setq py-python-command-args '("-pylab" "-colors" "LightBG"))

      ;; Don't highlight thing at cursor. It doesn't work well with
      ;; black and white
      ;;(setq highlight-thing-what-thing 'word)
      ;;(setq highlight-thing-delay-seconds 0)
      ;;(setq highlight-thing-limit-to-defun t)
      ;;(setq highlight-thing-case-sensitive-p t)

      ;;(global-highlight-thing-mode)
      )))

(load "/var/smulliga/source/git/config/emacs/clients.el")

(message ".emacs: add hooks")


;; (require 'my-utils)(exit)

;; see:
;; $VSGIT/config/emacs/python-settings.el

;; this is for ac-js2
(add-hook 'js2-mode-hook 'ac-js2-mode)
(add-hook 'js2-mode-hook 'skewer-mode)
(add-hook 'css-mode-hook 'skewer-css-mode)
(add-hook 'html-mode-hook 'skewer-html-mode)

;; Setup
;; Copy the snippet below if you want to evaluate your Javascript code for candidates. Not setting this value will still provide you with basic completion.
;;(setq ac-js2-evaluate-calls t)
;; Add any external Javascript files to the variable below. Make sure you have initialised ac-js2-evaluate-calls to t if you add any libraries.
;; (setq ac-js2-external-libraries '("full/path/to/a-library.js"))



;; see:
;; https://ipython.org/ipython-doc/1/config/editors.html
;; Actually, I don't know what this is used for.
(defvar server-buffer-clients)
(when (and (fboundp 'server-start) (string-equal (getenv "TERM") 'xterm))
  (server-start)
  (defun fp-kill-server-with-buffer-routine ()
    (and server-buffer-clients (server-done)))
  (add-hook 'kill-buffer-hook 'fp-kill-server-with-buffer-routine))


(setq ropemacs-enable-autoimport 't)


;; https://emacs.stackexchange.com/questions/728/how-do-i-switch-buffers-quickly
(ido-mode 1)
(setq ido-separator "\n")


;; This doesnt work. Because C-c C-e t A wasn't a binding.
;; C-c C-e was a binding.
;;(define-key key-translation-map (kbd "C-c C-e t a") (kbd "C-c C-e t A"))

;; I probably don't want a translation map. Also, do other bindings
;; rely on C-o?
;;(define-key key-translation-map (kbd "C-o") (kbd "C-u C-SPC"))

(setq browse-url-browser-function 'eww-browse-url)

;; This only works in emacs 26+ (spacemacs)
;; spx /home/shane/notes2018/uni/cosc/480-project_FY/research/22.03.18.org
;; (setq browse-url-browser-function 'xwidget-webkit-browse-url)



(setq smerge-command-prefix "\C-cv")


;; I've tried a lot of things, but this is the only thing that seemed to work to get paste working
;;(setq x-select-enable-clipboard t)
;;(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)
;;(cua-mode nil)
;;(global-unset-key (kbd "C-y"))
;;(global-set-key (kbd "C-y") 'x-clipboard-yank)

;; I'm disabling simpleclip
;; (global-set-key (kbd "C-y") 'simpleclip-paste)
;; (define-key org-mode-map (kbd "C-y") 'simpleclip-paste)


;; (require 'my-utils) (exit)

;;; Read this again
;;; https://emacs.stackexchange.com/questions/16469/how-to-merge-git-conflicts-in-emacs
;;; this enables smerge-mode when i'm visiting a file with conflict
;;; markers, although I think this might already work.
;;(defun my-enable-smerge-maybe ()
;;  (when (and buffer-file-name (vc-backend buffer-file-name))
;;    (save-excursion
;;      (goto-char (point-min))
;;      (when (re-search-forward "^<<<<<<< " nil t)
;;        (smerge-mode +1)))))
                                        ;
;;(add-hook 'buffer-list-update-hook #'my-enable-smerge-maybe)

;; This goes to the header from the source
(global-set-key (kbd "C-x C-o") 'ff-find-other-file)

;; DISCARD Do not require this on scimax because it's not a package. I
;; probably just needed a package refresh
;; (require 'programmer-dvorak)

;; I don't think I liked this.
;; (set-input-method "programmer-dvorak")
;; (add-hook 'shane-minor-mode-hook (set-input-method "programmer-dvorak"))


;; Is this better than htop?
(global-set-key (kbd "C-x p") 'proced)

;; enable xterm mouse for emacs and emacsclient
(load (concat emacsdir "/emacsclient.el"))

;; Will no longer say this buffer still has clients
;; (remove-hook 'kill-buffer-query-functions 'server-kill-buffer-query-function)
(load (concat emacsdir "/disable-prompts.el"))

(setq server-kill-new-buffers 'nil)

(ignore-errors (require 'xah-lookup))



(setq isearch-allow-scroll 't)

;; not the scrolling command
;; not the empty string
;; not the first key (to lazy highlight all matches w/o recenter)
;; the point in within the given window boundaries
(defadvice isearch-update (before my-isearch-update activate)
  (sit-for 0)
  (if (and (not (eq this-command
                    'isearch-other-control-char))
           (> (length isearch-string) 0)
           (> (length isearch-cmds) 2)
           (let ((line (count-screen-lines
                        (point)
                        (window-start))))
             (or (> line
                    (* (/ (window-height) 4) 3))
                 (< line
                    (* (/ (window-height) 9) 1)))))
      (let ((recenter-position 0.3))
        (recenter '(4)))))

;; vertical split.
;; (setq split-width-threshold nil)

;; horizontal split.
;; (setq split-width-threshold 1 )

;; sp /home/shane/notes2018/ws/python/features/iterating-over-a-sequence.org

;; magit highlighting works here. it's broken below
;; (require 'my-utils) (exit)

;;(font-lock-add-keywords 'org-mode
;;                    '(("\\(src_\\)\\([^[{]+\\)\\(\\[:.*\\]\\){\\([^}]*\\)}"
;;                       (1 '(:foreground "black" :weight 'normal :height 10)) ; src_ part
;;                       (2 '(:foreground "cyan" :weight 'bold :height 75 :underline "red")) ; "lang" part.
;;                       (3 '(:foreground "#555555" :height 70)) ; [:header arguments] part.
;;                       (4 'org-code) ; "code..." part.
;;                       )))


(message ".emacs: spacemacs extra")
;; (require 'my-utils) (exit)

(load (concat emacsdir "/spacemacs-extra-config.el"))

(when (> emacs-major-version 24)
;; emacs 24 is packing a sad with this
  (require 'codesearch)
  )

(load (concat emacsdir "/ansi-programs.el"))

(defadvice w3m-print-current-url (around no-y-or-n activate)
  (flet ((yes-or-no-p (&rest args) t)
         (y-or-n-p (&rest args) t))
    ad-do-it))


;; Allow org-mode bindings
(when (< emacs-major-version 26)
  (load "/home/shane/var/smulliga/source/git/yyr/xterm-extras.el/xterm-extras.el")
  (xterm-extra-keys)
  )

;; magit highlighting is ok here. the problem is below
;; (require 'my-utils) (exit)
;; (message ".emacs: org")

;; Configuring Things like the statup screen. Not using this currently.
(load (concat emacsdir "/startup.el"))
;; (require 'my-utils) (exit)
(load (concat emacsdir "/config/org-config.el"))
(load (concat emacsdir "/config/my-org-agenda.el"))
(load (concat emacsdir "/config/my-cpp.el"))

(setq paradox-github-token "89c6012174dd3f39863bab512276ae8dd469dc2d")

(setq enable-recursive-minibuffers t)


;; magit syntax working here. look below
;; (require 'my-utils) (exit)

(load (concat emacsdir "/config/my-auto-complete.el"))

(load (concat emacsdir "/config/my-cscope-ctags.el"))

(load (concat emacsdir "/config/my-buttons.el"))

;; annot.el breaks spacemacs
;; (load (concat emacsdir "/manual-packages/annot/src/annot.el"))

(load (concat emacsdir "/config/my-hydra.el"))

;(progn
(load (concat emacsdir "/manual-packages/ox-ipynb/ox-ipynb.el")) ; must come after hydra

;; Disabled
;;(load (concat emacsdir "/manual-packages/ov-highlight/ov-highlight.el"))



;;(exit)
;; (require 'config/use-package)

;; This is not working
;;(load (concat emacsdir "/config/my-use-package.el"))

;; (require 'my-utils) (exit)

(require 'manage-minor-mode)

;; (require 'my-utils) (exit)


;; this is the problem with magit syntax highlighting. rainbow mode was
;; enabled permanently here
(load (concat emacsdir "/config/my-manage-minor-mode.el"))

;; diff-hl is not the thing that highlights charecter changes
;; it's the gitgutter thing
;; ;; Now I have the nice highlighting everywhere?
;; (add-to-list 'load-path "/home/shane/var/smulliga/source/git/purcell/emacs.d/lisp")
;; (require 'init-elpa)
;; (require 'init-utils)
;; (require 'init-vc)

;; magit syntax not working here. look upwards (previous) for bad line
;; (require 'my-utils) (exit)


(message ".emacs: config files")


(load (concat emacsdir "/config/my-python.el"))
;;(if (not (is-spacemacs))
;;   (load (concat emacsdir "/config/my-python.el"))
;;  )


;; ;; This really helps with lsp-mode
;; ;; But I have enabled it only for certain modes
;; (electric-pair-mode 1)

(recentf-mode 1)
(setq recentf-max-menu-items 25)
;; Actually, I don't like this
;; (global-set-key "\C-x\ \C-r" 'recentf-open-files)

(load (concat emacsdir "/config/my-help.el"))

(load (concat emacsdir "/config/my-pdf-tools.el"))
(load (concat emacsdir "/config/my-search.el"))
(load (concat emacsdir "/config/org/my-link-types.el")) ;requires my-search
(load (concat emacsdir "/config/org/org-man.el"))
(load (concat emacsdir "/config/org/org-google.el")) ;; this works but most of the file is unnecessary
(load (concat emacsdir "/config/my-pretty.el"))

(load (concat emacsdir "/config/my-misc.el"))
;; Oh my god. Don't load this. hmm ok.
;; (org-babel-load-file (expand-file-name "/home/shane/var/smulliga/source/git/zwpdbh/emacs/myinit.org"))

;; Is this breaking it? I don't think so.
;; Yes, it's breaking it again.
;;(org-babel-load-file (expand-file-name (concat emacsdir
;;"/myinit.org")))

(load (concat emacsdir "/config/my-evil.el"))
(load (concat emacsdir "/config/my-evil-escape.el"))

;; I think this was breaking it. Test properly before adding to emacs
;;(load (concat emacsdir "/config/my-slack.el"))

;; this does not cause the arrayp error. And it does not cause problems
;; as far as I know
(require 'setup-magit) ; ./settings/

(require 'my-magit) ; ./config
(require 'my-magithub) ; ./config
; my-magithub.el

;; OMG I DID IT. I Fix! the byte recompile crap; I only fixed it for saving. Not for when I install a package.
(remove-hook 'after-save-hook (lambda nil (byte-force-recompile default-directory)) t)

;; (message ".emacs: telephone")

;; ;; This is better than spacemacs' mode line
;; ;; But it doesn't have ascii so disable it
;; (require 'telephone-line)
;; (setq telephone-line-lhs
;;       '((evil   . (telephone-line-evil-tag-segment))
;;         (accent . (telephone-line-vc-segment
;;                    telephone-line-erc-modified-channels-segment
;;                    telephone-line-process-segment))
;;         (nil    . (telephone-line-minor-mode-segment
;;                    telephone-line-buffer-segment))))
;; (setq telephone-line-rhs
;;       '((nil    . (telephone-line-misc-info-segment))
;;         (accent . (telephone-line-major-mode-segment))
;;         (evil   . (telephone-line-airline-position-segment))))
;; (telephone-line-mode 1)



;; Use this command of what face (C-u C-x =)
;; (defun what-face (pos)
;;   (interactive "d")
;;   (let ((face (or (get-char-property (pos) 'read-face-name)
;;                   (get-char-property (pos) 'face))))
;;     (if face (message "Face: %s" face) (message "No face at %d" pos))))

(require 'org-link-minor-mode)

(load (concat emacsdir "/manual-packages/straight.el/straight.el"))
(load (concat emacsdir "/config/my-straight.el"))
;; I want this disabled for most things. There are alternative completion frameworks which are working and are find
;; Company is newer than autocomplete-mode. They're not compatible. I'm running both.
(load (concat emacsdir "/manual-packages/company-tabnine/company-tabnine.el"))
(load (concat emacsdir "/config/my-tabnine.el"))
(load (concat emacsdir "/config/my-company.el"))


;; This allows smooth scrolling in lisp mode, when using js to scroll
(setq scroll-conservatively 101
      scroll-margin 10
      scroll-preserve-screen-position 't)



(defun byte-recompile-directory (directory &optional arg force)
  "I hope this disables this function"
  nil)


;;;; load quicklisp's implementation of slime
;;;; https://www.quicklisp.org/beta/
;;(load (expand-file-name "~/quicklisp/slime-helper.el"))
;;;; Replace "sbcl" with the path to your implementation
;;(setq inferior-lisp-program "sbcl")



(defun my-yank-org-link (text)
  (if (derived-mode-p 'org-mode)
      (insert text)
    (string-match org-bracket-link-regexp text)
    (insert (substring text (match-beginning 1) (match-end 1)))))

(defun my-org-retrieve-url-from-point ()
  (interactive)
  (let* ((link-info (assoc :link (org-context)))
         (text (when link-info
                 ;; org-context seems to return nil if the current element
                 ;; starts at buffer-start or ends at buffer-end
                 (buffer-substring-no-properties (or (cadr link-info) (point-min))
                                                 (or (caddr link-info) (point-max))))))
    (if (not text)
        (error "Not in org link")
      (add-text-properties 0 (length text) '(yank-handler (my-yank-org-link)) text)
      (kill-new text))))


(defun insert-date ()
    (interactive)
    (insert
     (sh-notty "k f8 | s chomp")))

(define-key global-map (kbd "<M-f8>") #'insert-date)

(require 'org)
;; This didn't work to fix spacemacs
;;(require 'org-macs)
;; So I did this
;; (load "/var/smulliga/source/git/config/emacs/packages27/org-20190408/org-macs.el")

;; Not sure why I have to load it, but requiring it doesn't work
(require 'org-compat)
;; (load "/var/smulliga/source/git/config/emacs/packages27/org-20190408/org-compat.el")
(load "/var/smulliga/source/git/config/emacs/packages27/org-20200316/org-compat.el")
;; (load "/var/smulliga/source/git/config/emacs/packages27/org-20190408/org-compat.el")

;; DONT USE org-evil
;; DO USE   evil-org
;; https://github.com/Somelauw/evil-org-mode
;; (require 'org-evil)
(require 'evil-org)


;; Define all function keys
;; I haven't yet decided what I want to do with this
;; (progn
;;   (define-key emacs-lisp-mode-map [(f1)] 'describe-foo-at-point)
;;   (define-key emacs-lisp-mode-map [(control f1)] 'describe-function)
;;   (define-key emacs-lisp-mode-map [(shift f1)] 'describe-variable))


;; Emacs is actually slow with this (when there are lots of errors), but at least I don't get those very distracting error messages
(setq flycheck-checker-error-threshold 2000)

;; The overlay is actually quite good with emacs GUI. I dislike the eldoc overlay with the terminal. It's very distracting
;; (global-eldoc-overlay-mode t)
(global-eldoc-overlay-mode 0)

;; This means that I can see documention in minibuffer. but i hate it
;; (setq eldoc-overlay-in-minibuffer-flag t)
(setq eldoc-overlay-in-minibuffer-flag nil)

;; BISECT
(load (concat emacsdir "/config/my-prefix-maps.el"))
(load (concat emacsdir "/config/my-browser.el"))

(load (concat emacsdir "/config/my-fuzzyfinders.el"))

(load (concat emacsdir "/config/my-el-get.el"))
(load (concat emacsdir "/config/my-quelpa.el"))
(load (concat emacsdir "/config/my-exwm.el"))

;; ; (require 'my-haskell)
(load (concat emacsdir "/config/my-pcre.el"))
(load (concat emacsdir "/config/my-advice.el"))
(load (concat emacsdir "/config/my-memoize.el"))

(load (concat emacsdir "/config/my-haskell.el"))
(load (concat emacsdir "/config/my-hledger.el"))
(load (concat emacsdir "/config/my-backspace.el"))
(load (concat emacsdir "/config/my-piper.el"))
(load (concat emacsdir "/manual-packages/parent-mode/parent-mode.el"))
(load (concat emacsdir "/manual-packages/lsp-prolog/prolog-ls.el"))
(load (concat emacsdir "/config/my-parent-mode.el"))
(load (concat emacsdir "/manual-packages/logpad/logpad.el"))

;; This wont work for this version of emacs. It requires 'anything', an ancient version of helm.
;; I may need an older version of emacs that has 'anything'.
;; (load (concat emacsdir "/manual-packages/perl-completion/perl-completion.el"))

(load (concat emacsdir "/config/my-hooks.el"))
(load (concat emacsdir "/config/my-youtube.el"))
(load (concat emacsdir "/config/my-clojure.el"))
(load (concat emacsdir "/config/my-clojerl.el"))
(load (concat emacsdir "/config/my-expand-region.el"))
(load (concat emacsdir "/config/my-google.el"))
(load (concat emacsdir "/config/my-paredit.el"))
;;(load (concat emacsdir "/config/my-evil-fringe.el")) ; this only works
;;for gui emacs. So forget it. Also, can't be bothered figuring out
;;dependencies

;; FIXED
(load (concat emacsdir "/config/my-lsp.el"))
; disable this until I have python working properly
;; company-lsp might be outdated now. Or perhaps it was my manual installation
(load (concat emacsdir "/manual-packages/company-lsp/company-lsp.el"))

(load (concat emacsdir "/manual-packages/lsp-kotlin-el/lsp-kotlin.el"))

;; reenable
;; (load (concat emacsdir "/manual-packages/lsp-racket-el/lsp-racket.el"))
;; (load (concat emacsdir "/manual-packages/lsp-clojure-el/lsp-clojure.el"))
(load (concat emacsdir "/manual-packages/keepass-mode/keepass-mode.el"))
(load (concat emacsdir "/config/my-ht.el"))
(load (concat emacsdir "/config/my-lsp-clients.el"))
(load (concat emacsdir "/config/my-lsp-java.el"))
(load (concat emacsdir "/config/my-dap.el"))

(load (concat emacsdir "/config/my-semantic.el"))
(load (concat emacsdir "/config/my-vertico.el"))
(load (concat emacsdir "/config/my-ivy.el"))
(load (concat emacsdir "/config/my-shackle.el"))
(load (concat emacsdir "/config/my-newfile.el"))
(load (concat emacsdir "/config/my-minibuffer.el"))
(load (concat emacsdir "/config/my-highlight-thing.el"))

;good
(load (concat emacsdir "/config/my-bpr.el"))
(load (concat emacsdir "/config/my-markdown.el"))
(load (concat emacsdir "/config/my-adoc.el"))
(load (concat emacsdir "/config/my-swipe.el"))
(load (concat emacsdir "/config/my-info.el"))
(load (concat emacsdir "/config/my-hy.el"))
(load (concat emacsdir "/config/my-url.el"))
(load (concat emacsdir "/config/my-helm.el"))
;; (message "helm done")
(load (concat emacsdir "/config/my-eshell.el"))
;; (message "eshell done")
(load (concat emacsdir "/config/my-emms.el"))
;; (message "emms done")
(load (concat emacsdir "/config/my-thesaurus.el"))
(load (concat emacsdir "/config/my-alist.el"))
(load (concat emacsdir "/config/my-load-early.el"))
(load (concat emacsdir "/config/my-org.el"))
(load (concat emacsdir "/config/my-ox.el"))
(load (concat emacsdir "/config/my-grep.el"))
(load (concat emacsdir "/config/my-chords.el"))
(load (concat emacsdir "/config/my-openwith.el"))
(load (concat emacsdir "/config/my-open.el"))
(load (concat emacsdir "/config/my-dired.el"))
(load (concat emacsdir "/config/my-perl.el"))
(load (concat emacsdir "/config/my-wordnet.el"))
(load (concat emacsdir "/config/my-text.el"))
;; Good

;; (load (concat emacsdir "/config/my-ycm.el"))
(load (concat emacsdir "/config/my-desktop.el"))
(load (concat emacsdir "/config/my-threading.el"))
(load (concat emacsdir "/highlighting/myhl-compilation.el"))
(load (concat emacsdir "/gist/turn-off-messaging.el"))
(load (concat emacsdir "/config/my-imenu.el"))
(load (concat emacsdir "/config/my-troubleshooting.el"))
(load (concat emacsdir "/config/my-scheme.el"))
(load (concat emacsdir "/config/my-predicates.el"))
(load (concat emacsdir "/config/my-engine.el"))
;; Sadly I can't use selected for M-7, M-8 M-9 bindings
(load (concat emacsdir "/config/my-doc.el")) ;; needs my-engine
(load (concat emacsdir "/config/my-hide-minor-modes.el"))
(load (concat emacsdir "/config/my-hide-sensitive-password.el"))
(load (concat emacsdir "/config/my-speed-of-thought.el"))
(load (concat emacsdir "/config/my-javascript.el"))
(load (concat emacsdir "/config/my-find-cmd.el"))
;; good
;; Do not activate it
;; (load (concat emacsdir "/config/my-xah-fly-keys.el"))
(load (concat emacsdir "/config/my-powerline"))
(load (concat emacsdir "/config/my-proselint.el"))
(load (concat emacsdir "/config/my-tramp.el"))
(load (concat emacsdir "/config/my-bm.el"))
(load (concat emacsdir "/config/my-terraform.el"))
(load (concat emacsdir "/config/my-asciinema.el"))
(load (concat emacsdir "/config/my-url-cookie.el"))
(load (concat emacsdir "/config/my-eww.el"))
(load (concat emacsdir "/config/my-tls.el"))
(load (concat emacsdir "/config/my-pdf-view.el"))
(load (concat emacsdir "/config/my-man.el"))
(load (concat emacsdir "/config/my-radix-tree.el"))
(load (concat emacsdir "/config/my-go-playground.el"))
(load (concat emacsdir "/config/my-dumb-jump.el"))
(load (concat emacsdir "/config/my-comint.el"))
(load (concat emacsdir "/config/my-lentic.el"))
(load (concat emacsdir "/config/my-appearance.el"))
(load (concat emacsdir "/config/my-encryption.el"))
(load (concat emacsdir "/config/my-rust.el"))

(add-to-list 'load-path (concat emacsdir "/manual-packages/flymake-racket"))
(require 'flymake-racket)

(load (concat emacsdir "/config/my-racket.el"))

(load (concat emacsdir "/config/my-accessors.el"))
(load (concat emacsdir "/config/my-x.el"))
(load (concat emacsdir "/config/my-distributions.el")) ; This must precede my-spacemacs.el
(load (concat emacsdir "/config/my-purcell.el"))
(load (concat emacsdir "/config/my-prelude.el"))

(load (concat emacsdir "/config/my-julia.el"))
(load (concat emacsdir "/script-functions/sf-ruby.el"))

;; Don't do this. I want spacemacs to work
;; (load (concat emacsdir "/config/my-ido.el"))

(load (concat emacsdir "/config/my-aliases-2.el"))

(load (concat emacsdir "/config/my-git.el"))
(load (concat emacsdir "/config/my-comparators.el"))
(load (concat emacsdir "/config/my-helm-dash.el"))
(load (concat emacsdir "/config/my-emacs-lisp.el"))
(load (concat emacsdir "/config/my-emacs.el"))
(load (concat emacsdir "/config/my-projectile.el"))
(load (concat emacsdir "/config/my-scripts.el"))
(load (concat emacsdir "/config/my-scratch.el"))
(load (concat emacsdir "/config/my-libraries.el"))
(load (concat emacsdir "/config/my-rx.el"))
(load (concat emacsdir "/config/my-regex.el"))
(load (concat emacsdir "/config/my-xr.el"))
(load (concat emacsdir "/config/my-apis.el"))
(load (concat emacsdir "/config/my-music.el")) ; requires my-utils
(load (concat emacsdir "/config/my-path.el"))
;; (load (concat emacsdir "/config/my-go.el"))

;; GOOD

;; this breaks saving in org-mode
;; (load (concat emacsdir "/manual-packages/hyper-org-mode-el/hyper-org-mode.el"))


(load (concat emacsdir "/manual-packages/ob-racket/ob-racket.el")) ;; comes after utils

(load (concat emacsdir "/config/my-ob-racket.el"))


(load (concat emacsdir "/config/my-automation.el"))

(load (concat emacsdir "/manual-packages/extensible-shell-mode/extensible-shell-mode.el"))

; sqlite broken cbf
; (load (concat emacsdir "/manual-packages/emacs-sqlite3/sqlite3.el"))
; (load (udn (concat emacsdir "/manual-packages/emacs-sqlite3/sqlite3.el")))
; (load (concat emacsdir "/manual-packages/imdb.el/imdb.el"))
; (load (concat emacsdir "/manual-packages/imdb.el/imdb-mode.el"))

(load (concat emacsdir "/manual-packages/exec-path-from-shell/exec-path-from-shell.el"))

(load (concat emacsdir "/config/my-blimp.el"))
(load (concat emacsdir "/config/my-yaml.el"))
(load (concat emacsdir "/config/my-trello.el"))
(load (concat emacsdir "/config/my-goto-definition.el"))
(load (concat emacsdir "/config/my-elasticsearch.el"))
(load (concat emacsdir "/config/my-lingo.el"))
(load (concat emacsdir "/config/my-flim.el"))
(load (concat emacsdir "/config/my-wanderlust.el"))

(load (concat emacsdir "/config/my-compilation.el"))
(load (concat emacsdir "/manual-packages/glimpse/glimpse.el"))
(load (concat emacsdir "/config/my-glimpse.el"))

;; GOOD here
(load (concat emacsdir "/config/my-ruby.el"))
(load (concat emacsdir "/config/my-rust-playground.el"))
(load (concat emacsdir "/config/my-google-translate.el"))
(load (concat emacsdir "/config/my-repl-toggle.el"))
(load (concat emacsdir "/config/my-sanityinc.el"))

(load (concat emacsdir "/manual-packages/jq-mode/jq-mode.el"))
(load (concat emacsdir "/manual-packages/jq-mode/ob-jq.el"))
(load (concat emacsdir "/manual-packages/slack-search.el/slack-search.el"))
(load (concat emacsdir "/manual-packages/antlr-mode/antlr-mode.el"))
(load (concat emacsdir "/manual-packages/moustache-mode/mustache-mode.el"))
(load (concat emacsdir "/manual-packages/rpl-mode/rpl-mode.el"))
(load (concat emacsdir "/manual-packages/cc-playground/cc-playground.el"))
(load (concat emacsdir "/manual-packages/hierarchy/hierarchy.el"))
;; GOOD

;; this is how I should be doing it, not with load
;; (add-to-list 'load-path "/path/to/jq-mode-dir")
;; (autoload 'jq-mode "jq-mode.el"


;; (global-set-key (kbd "C-x C-r") 'counsel-recentf) ; This one is what I used to use last
(define-key global-map (kbd "C-x C-r") 'helm-mini)
;; (global-set-key (kbd "C-x C-r") 'helm-recentf)

;; (define-key my-mode-map (kbd "C-x C-r") 'helm-mini)


;; This is a nice debugger. Has python support and many other languages.
(load-library "realgud")


;; (my/with 'rainbow-identifiers
;;          (rainbow-identifiers-mode 1))

;; global-hl-line-mode is not the solution I want to the problem of finding the cursor
;; Also, it makes selected regions invisible with some themes


;; (defun locate (search-string)
;;   (interactive)
;;   (interactive (list
;;                 (locate-prompt-for-search-string)
;;                 nil
;;                 current-prefix-arg))
;;   (locate-in-alternate-database
;;    search-string
;;    "$HOME/var/mlocate.db"))

(defun my/log-args (f &rest args)
(message "advice for %s:\nargs = %s" f args)
(apply f args))
;; (advice-add 'target-function :around 'my/log-args)

;; stop emacs from complaining about stealing focus
(setq create-lockfiles nil)

(setq source-directory "/home/shane/var/smulliga/source/git/emacs-mirror/emacs/src/")
(setq find-function-C-source-directory "/var/smulliga/source/git/emacs-mirror/emacs/src/")

(load (concat emacsdir "/config/my-mouse.el"))

(load (concat emacsdir "/config/my-fp.el"))
(load (concat emacsdir "/config/my-spacemacs.el"))
(load (concat emacsdir "/config/my-arxiv.el"))
(load (concat emacsdir "/manual-packages/hierarchy/examples/hierarchy-examples-fs.el"))
(load (concat emacsdir "/config/my-highlight-indent-guides.el"))

     ;; not sure why but I can't put these into my-faces.
     ;; I think the directory changes with load.
     ;; Once in the config directory, requires no longer work
     (set-face-attribute 'ivy-current-match nil
                         :background "#0099ff"
                         :foreground "#111111")
     (set-face-attribute 'helm-selection nil
                         :background "#0099ff"
                         :foreground "#111111")

(load (concat emacsdir "/config/my-libyamlmod.el"))
(load (concat emacsdir "/config/my-dictionary.el"))

      (load (concat emacsdir "/manual-packages/ob-problog/ob-problog.el"))
      (load (concat emacsdir "/manual-packages/ob-show-dot/ob-show-dot.el"))
(load (concat emacsdir "/manual-packages/helm-fzf/helm-fzf.el"))
(load (concat emacsdir "/manual-packages/helm-generic-find/helm-generic-find.el"))
      (load (concat emacsdir "/config/my-babel.el"))

      (load (concat emacsdir "/config/my-org-brain.el"))
      (load (concat emacsdir "/config/my-ace-link.el"))
(load (concat emacsdir "/config/my-link-hint.el"))
      (load (concat emacsdir "/config/my-anaconda.el"))
      (load (concat emacsdir "/config/my-intero.el"))
      ;; (load (concat emacsdir "/config/my-ycmd.el"))
      (load (concat emacsdir "/config/my-circe.el"))
      (load (concat emacsdir "/config/my-pipenv.el"))
      (load (concat emacsdir "/config/my-ansible.el"))
      (load (concat emacsdir "/config/my-eldoc.el"))
(load (concat emacsdir "/config/my-hi-lock.el"))
      (load (concat emacsdir "/config/my-flycheck.el"))
      (load (concat emacsdir "/config/my-flyspell.el"))
(load (concat emacsdir "/config/my-fly.el"))
      (load (concat emacsdir "/config/my-pydoc.el"))
      (load (concat emacsdir "/config/my-java.el"))
      (load (concat emacsdir "/config/my-shoebox.el"))
      (load (concat emacsdir "/config/my-dash.el"))
      (load (concat emacsdir "/config/my-nyan.el"))
      (load (concat emacsdir "/config/my-occur.el"))
      (load (concat emacsdir "/config/my-hl.el"))
      ;; (load (concat emacsdir "/config/my-telephone-line.el"))
      (load (concat emacsdir "/config/my-smerge.el"))
      (load (concat emacsdir "/config/my-tab.el"))
      (load (concat emacsdir "/config/my-insert-shebang.el"))
      (load (concat emacsdir "/config/my-deft.el"))
(load (concat emacsdir "/config/my-profiler.el"))
(load (concat emacsdir "/config/my-header-line.el"))
      (load (concat emacsdir "/config/my-lispier.el"))
      (load (concat emacsdir "/config/my-foundation.el"))
      (load (concat emacsdir "/config/my-subr.el"))
      (load (concat emacsdir "/config/my-avy.el"))
      (load (concat emacsdir "/config/my-lispify.el"))
      (load (concat emacsdir "/config/my-navigation.el"))
      (load (concat emacsdir "/config/my-editing.el"))
      (load (concat emacsdir "/config/my-gdb-mi.el"))
      (load (concat emacsdir "/config/my-gpg.el"))
      (load (concat emacsdir "/config/my-exordium.el"))
      (load (concat emacsdir "/config/my-forth.el"))
      ;; (load (concat emacsdir "/config/my-md4rd.el")) ;; this has problems
      (load (concat emacsdir "/config/my-prolog.el"))
      (load (concat emacsdir "/config/my-prodigy.el"))
      (load (concat emacsdir "/config/my-ghcide.el"))
      (load (concat emacsdir "/config/my-cursor.el"))
; This fixes the anaconda-mode thing cosmetically anyway
(load (concat emacsdir "/config/my-list-processes.el"))
(load (concat emacsdir "/config/my-hugo.el"))
      (load (concat emacsdir "/config/my-persp.el"))
      (load (concat emacsdir "/config/my-tetris.el"))
      (load (concat emacsdir "/config/my-parsec.el"))
      (load (concat emacsdir "/config/my-goto-chg.el"))
      (load (concat emacsdir "/config/my-helpful.el"))
      (load (concat emacsdir "/config/my-indent-tools.el"))
      (load (concat emacsdir "/config/my-globalized-minor-modes.el"))
      ;; Don't use flymake
      ;; (load (concat emacsdir "/config/my-flymake.el"))
      (load (concat emacsdir "/config/my-deadgrep.el"))
      (load (concat emacsdir "/config/my-general.el"))
;; recursive load stops emacs from starting. the problem might have been that i was loading the packages26 packages
(load (concat emacsdir "/config/my-gist.el"))
(load (concat emacsdir "/config/my-w3m.el"))
      (load (concat emacsdir "/config/my-todo.el"))
      (load (concat emacsdir "/config/my-jenkins.el"))
      (load (concat emacsdir "/config/my-travis.el"))
;; good lsp
      (load (concat emacsdir "/config/my-circleci.el"))
      (load (concat emacsdir "/config/my-libvterm.el"))
      (load (concat emacsdir "/config/my-git-timemachine.el"))
      (load (concat emacsdir "/config/my-omnisharp.el"))
      (load (concat emacsdir "/config/my-mastodon.el"))
      (load (concat emacsdir "/config/my-gitignore.el"))
      (load (concat emacsdir "/config/my-pollen.el"))
      (load (concat emacsdir "/config/my-gtags.el"))
      (load (concat emacsdir "/config/my-xref.el"))
      (load (concat emacsdir "/config/my-k8s.el"))

;; good lsp
      (load (concat emacsdir "/config/my-latex.el"))

      (load (concat emacsdir "/config/my-conf.el"))
      (load (concat emacsdir "/config/my-visual-line.el"))
      (load (concat emacsdir "/config/my-r.el"))
      (load (concat emacsdir "/config/my-protobuf.el"))
      (load (concat emacsdir "/config/my-log.el"))
      (load (concat emacsdir "/config/my-systemd.el"))

;; dashboard appears to have broken lsp -- maybe -- verify. it works for e nw, but not for sp nw
;; It does not work for e sd when dashboard exists in packages -- confirmed
;; It does work for e sd when dashboard is not loaded
;; (load (concat emacsdir "/config/my-dashboard.el"))

(load (concat emacsdir "/config/my-minimap.el"))
      (load (concat emacsdir "/config/my-func-lists.el"))
(load (concat emacsdir "/config/my-reference-lists.el"))
      (load (concat emacsdir "/config/my-mode-line.el"))
(load (concat emacsdir "/config/my-lists.el"))
(load (concat emacsdir "/config/my-hash.el"))

(load (concat emacsdir "/config/my-sx.el"))
(load (concat emacsdir "/config/my-wgrep.el"))
      (load (concat emacsdir "/config/my-css.el"))
(load (concat emacsdir "/config/my-ranger.el"))
      (load (concat emacsdir "/config/my-json.el"))
      (load (concat emacsdir "/config/my-attrap.el"))

      (load (concat emacsdir "/config/my-clean-aindent.el"))
      (load (concat emacsdir "/config/my-playgrounds.el"))

      (load (concat emacsdir "/config/my-helm-fzf.el"))


      (load (concat emacsdir "/config/clql-mode.el"))
      (load (concat emacsdir "/config/my-tmux.el"))
      (load (concat emacsdir "/config/my-pretty-hydra.el"))
      (load (concat emacsdir "/config/my-git-messenger.el"))
(load (concat emacsdir "/config/my-annotate.el"))

(load (concat emacsdir "/config/my-edbi.el"))
(load (concat emacsdir "/config/my-daemons.el"))
;; this is hit. So why does daemons config not take effect?
;; (ns "got past daemons")
(load (concat emacsdir "/config/my-tty.el"))
;; GOOD


      (load (concat emacsdir "/manual-packages/per-mode/per-mode.el"))
      (load (concat emacsdir "/manual-packages/tshell/tshell.el"))

      (load (concat emacsdir "/manual-packages/perl-repl/perl-repl.el"))
      (load (concat emacsdir "/manual-packages/ghci-repl/ghci-repl.el"))
      (load (concat emacsdir "/config/my-ghci.el"))
      (load (concat emacsdir "/manual-packages/awk-ward.el/awk-ward.el"))
      (load (concat emacsdir "/manual-packages/font-lock-ext/font-lock-ext.el"))
      (load (concat emacsdir "/manual-packages/sln-mode/sln-mode.el"))
      (load (concat emacsdir "/manual-packages/csh-mode/csh-mode.el"))

      (load (concat emacsdir "/manual-packages/linkd/linkd.el"))
      (load (concat emacsdir "/manual-packages/yasnippet-snippets/yasnippet-snippets.el"))
(load (concat emacsdir "/manual-packages/counsel-web/counsel-web.el"))

(load (concat emacsdir "/manual-packages/lua-eldoc-mode/lua-eldoc-mode.el"))

;;
;; lua--rx-symbol: Symbol’s function definition is void: rx-form
;; (load (concat emacsdir "/config/my-lua.el"))

(load (concat emacsdir "/config/my-zeal.el"))

(load (concat emacsdir "/manual-packages/elexandria/elexandria.el"))

;; GitHub Semmle / CodeQL
(load (concat emacsdir "/manual-packages/semmle/dbscheme-mode.el"))
(load (concat emacsdir "/manual-packages/semmle/ql-mode-base.el"))

(load (concat emacsdir "/manual-packages/eldoc-eval/eldoc-eval.el"))

(load (concat emacsdir "/manual-packages/kubectl/kubectl.el"))
(load (concat emacsdir "/manual-packages/graph.el/graph.el"))
(load (concat emacsdir "/manual-packages/my-goto.el/my-goto.el"))
(load (concat emacsdir "/manual-packages/org-graph-view/org-graph-view.el"))

;; This was rubbish
;; (load (concat emacsdir "/manual-packages/python-import-add/python-import-add.el"))

;; This works, but it needs me to interactively enter email and password
;; Also, it only shows meetings. It doesn't do email.
;; (load (concat emacsdir "/config/my-excorporate.el"))

(load (concat emacsdir "/config/my-window.el"))

(load (concat emacsdir "/config/my-ros.el"))

(load (concat emacsdir "/config/my-eldoc-eval.el"))

(load (concat emacsdir "/config/my-cc-playground.el"))

(load (concat emacsdir "/config/my-term-modes.el"))
(load (concat emacsdir "/config/my-tui-terminal-user-interfaces.el"))
(load (concat emacsdir "/config/my-smart-scholar.el"))
(load (concat emacsdir "/config/my-eww-modes.el"))
(load (concat emacsdir "/config/my-procfile.el"))
(load (concat emacsdir "/config/stolen-from-spacemacs.el"))
(load (concat emacsdir "/config/my-simple.el"))
(load (concat emacsdir "/config/my-slime-repl.el"))
(load (concat emacsdir "/config/my-buffers.el"))
(load (concat emacsdir "/config/my-lfe.el"))
(load (concat emacsdir "/config/my-kmacro.el"))
(load (concat emacsdir "/config/my-undo-tree.el"))
(load (concat emacsdir "/config/my-crux.el"))
(load (concat emacsdir "/config/my-frame.el"))
(load (concat emacsdir "/config/my-uniqify.el"))
(load (concat emacsdir "/config/my-command-log.el"))
(load (concat emacsdir "/config/my-mode-highlighting.el"))
(load (concat emacsdir "/config/my-gitlab.el"))
(load (concat emacsdir "/config/my-calc.el"))
(load (concat emacsdir "/config/my-slack.el"))
(load (concat emacsdir "/config/my-micro-blogging.el"))
(load (concat emacsdir "/config/my-csv.el"))
(load (concat emacsdir "/config/my-tablist.el"))
(load (concat emacsdir "/config/my-tablist-modes.el"))
(load (concat emacsdir "/config/my-xah-get-thing.el"))
(load (concat emacsdir "/config/my-cmd-tabulated-list.el"))

(load (concat emacsdir "/manual-packages/magit-pretty-graph/magit-pretty-graph.el"))

(load (concat emacsdir "/manual-packages/gtest-mode/gtest-mode/gtest-mode.el"))
(load (concat emacsdir "/manual-packages/gitlab-ci-mode/gitlab-ci-mode.el"))
(load (concat emacsdir "/manual-packages/gitlab-ci-mode-flycheck/gitlab-ci-mode-flycheck.el"))
(load (concat emacsdir "/config/my-grip.el"))
(load (concat emacsdir "/config/my-plantuml.el"))
(load (concat emacsdir "/config/my-mermaid.el"))

;; Not currently working
;; (load (concat emacsdir "/config/my-org-sidebar.el"))


(load (concat emacsdir "/manual-packages/jenkinsfile-mode/jenkinsfile-mode.el"))

;; Unfortunately, it just doesn't load this way
;; (load (concat emacsdir "/manual-packages/emacs-slack/slack.el"))

(load (concat emacsdir "/config/my-magit-section-mode.el"))
(load (concat emacsdir "/config/my-treemacs.el"))
(load (concat emacsdir "/config/my-alert.el"))
(load (concat emacsdir "/config/my-lastfm.el"))
(load (concat emacsdir "/config/my-vuiet.el"))
(load (concat emacsdir "/config/my-helm-spotify-plus.el"))


;; Ensure ivy is the completing read we use, not helm.
;; We want to be able to enter empty string and enter what we have typed, not always the selection
(setq completing-read-function 'ivy-completing-read)

(add-to-list 'load-path (concat emacsdir "/manual-packages/edbi-sqlite-20160221.1923"))
(require 'edbi-sqlite)

(add-to-list 'load-path (concat emacsdir "/manual-packages/subed/subed"))
(require 'subed)
(load (concat emacsdir "/config/my-subed.el"))

;; (load (concat emacsdir "/manual-packages/bufler.el/bufler.el"))
(add-to-list 'load-path (concat emacsdir "/manual-packages/bufler.el"))
(require 'bufler)


;; (add-to-list 'load-path (concat emacsdir "/manual-packages/evil.el"))
;; (require 'evil)


;; Org-wiki is hooking into org files and possibly slowing down exporting CV and hugo
(load (concat emacsdir "/manual-packages/bufler.el/bufler.el"))
(add-to-list 'load-path (concat emacsdir "/manual-packages/org-wiki"))
(require 'org-wiki)



;; This is installed via a package
;; (add-to-list 'load-path (concat emacsdir "/manual-packages/structured-haskell-mode.el"))
;; (require 'structured-haskell-mode)

(add-to-list 'load-path (concat emacsdir "/manual-packages/docker.el"))
(require 'docker)
(load (concat emacsdir "/config/my-docker.el"))

;; This is for helm-list-elisp-packages to work
(add-to-list 'load-path (concat emacsdir "/manual-packages/url-http-ntlm"))
(require 'url-http-ntlm)

(add-to-list 'load-path (concat emacsdir "/manual-packages/unpackaged.el"))
(require 'unpackaged)

;; (add-to-list 'load-path "/home/shane/source/git/akermu/emacs-libvterm")
;; (require 'vterm)

;; (add-to-list 'load-path (concat emacsdir "/manual-packages/mount-mode"))
(load "/home/shane/var/smulliga/source/git/config/emacs/manual-packages/mount-mode/mount.el")
(require 'mount-mode)

;; This isn't great. But it's something in terms of prose highlighting
(add-to-list 'load-path (concat emacsdir "/manual-packages/bannedit"))
(require 'bannedit)

;; (add-to-list 'load-path (concat emacsdir "/manual-packages/emacs-crossword"))
;; (require 'crossword)

(add-to-list 'load-path (concat emacsdir "/manual-packages/fs-mode"))
(require 'fs-mode)
(load (concat emacsdir "/config/my-fs.el"))

(load (concat emacsdir "/config/my-org-roam.el"))
(load (concat emacsdir "/config/my-free-keys.el"))

(load (concat emacsdir "/config/my-org-tables.el"))
(load (concat emacsdir "/config/my-org-link-minor-mode.el"))

(load (concat emacsdir "/config/my-gnus.el"))

(load (concat emacsdir "/config/my-kubernetes.el"))
(load (concat emacsdir "/config/my-kubel.el"))
(load (concat emacsdir "/config/my-bell.el"))

;; (load (concat emacsdir "/config/my-overriding-terminal.el"))

(load (concat emacsdir "/config/my-wordnut.el"))
;; recursive load
(load (concat emacsdir "/config/my-github.el"))
(load (concat emacsdir "/config/my-ordinal.el"))
(load (concat emacsdir "/config/my-context-functions.el"))
(load (concat emacsdir "/config/my-major-mode.el"))
(load (concat emacsdir "/config/my-xdotool.el"))
(load (concat emacsdir "/config/my-code-architecture.el"))

;; Automatically open binary files in hexl mode
(load (concat emacsdir "/config/my-hexl.el"))
(load (concat emacsdir "/config/my-makefile.el"))
(load (concat emacsdir "/config/my-lint.el"))
(load (concat emacsdir "/config/my-cc.el"))
(load (concat emacsdir "/config/my-nixos.el"))
(load (concat emacsdir "/config/my-guix.el"))
(load (concat emacsdir "/config/my-completion-style.el"))
(load (concat emacsdir "/config/my-position-list-navigator.el"))

(load (concat emacsdir "/config/my-computed-context.el"))
(load (concat emacsdir "/config/my-default-keywords.el"))
(load (concat emacsdir "/config/my-pipe.el"))
(load (concat emacsdir "/config/my-lean.el"))

(load (concat emacsdir "/config/my-qa.el"))

(load (concat emacsdir "/config/my-glossary-error.el"))
(load (concat emacsdir "/config/my-glossary.el"))
(load (concat emacsdir "/config/my-filter-cmd-buttonize.el"))
(load (concat emacsdir "/config/my-file-parsers.el"))
(load (concat emacsdir "/config/my-suggest-imports.el"))
(load (concat emacsdir "/config/my-buttoncloud.el"))
(load (concat emacsdir "/config/my-status-buttoncloud.el"))

(load (concat emacsdir "/config/my-toggle-scripts.el"))
(load (concat emacsdir "/config/my-hyperbole.el"))

(load (concat emacsdir "/config/my-iedit.el"))
(load (concat emacsdir "/config/my-jump-tree.el"))
(load (concat emacsdir "/config/my-skeletor.el"))
(load (concat emacsdir "/config/my-server-suggest.el"))
(load (concat emacsdir "/config/my-helm-org-rifle.el"))

(load (concat emacsdir "/config/my-calfw.el"))
(load (concat emacsdir "/config/my-special.el"))

(load (concat emacsdir "/config/my-proxy.el"))

(load (concat emacsdir "/config/my-file-local-variables.el"))

(load (concat emacsdir "/config/my-calendar.el"))
(load (concat emacsdir "/config/my-aws.el"))
(load (concat emacsdir "/config/my-tor.el"))
(load (concat emacsdir "/config/my-code-questions.el"))
(load (concat emacsdir "/config/my-system-custom.el"))
(load (concat emacsdir "/config/my-zone.el"))

(load (concat emacsdir "/config/my-outline.el"))
(load (concat emacsdir "/config/my-custom-repls.el"))
(load (concat emacsdir "/config/my-programs.el"))
(load (concat emacsdir "/config/my-default-google.el"))
(load (concat emacsdir "/config/my-graphviz.el"))
(load (concat emacsdir "/config/my-enlive.el"))
(load (concat emacsdir "/config/my-tree-sitter.el"))

;; TODO Fix this?
;; [2021-03-23T21:05:53.380953] Auto-evilification could not remap these functions in map ‘elfeed-search-mode-map’:
(ignore-errors (load (concat emacsdir "/config/my-elfeed.el")))

(load (concat emacsdir "/config/my-calibre.el"))
(load (concat emacsdir "/config/my-universal-file-conversion.el"))
(load (concat emacsdir "/config/my-wa.el"))
(load (concat emacsdir "/config/my-hercules.el"))
(load (concat emacsdir "/config/my-direnv.el"))
(load (concat emacsdir "/config/my-directory-navigation.el"))
(load (concat emacsdir "/config/my-widgets.el"))
(load (concat emacsdir "/config/my-readme.el"))
(load (concat emacsdir "/config/my-sql-mode.el"))
;; (load (concat emacsdir "/config/my-transient-tabulated.el"))

(load (concat emacsdir "/config/my-right-click-context.el"))
(load (concat emacsdir "/config/my-sh.el"))

(load (concat emacsdir "/config/my-selectrum.el"))
(load (concat emacsdir "/config/my-marginalia.el"))

(load (concat emacsdir "/config/my-nlp.el"))
(load (concat emacsdir "/config/my-gcs.el"))
(load (concat emacsdir "/config/my-generic-refactor.el"))
(load (concat emacsdir "/config/my-emojify.el"))
(load (concat emacsdir "/config/my-apu.el"))
(load (concat emacsdir "/config/my-transient.el"))
(load (concat emacsdir "/config/my-text-coding-system.el"))
(load (concat emacsdir "/config/my-new-project.el"))
(load (concat emacsdir "/config/my-chess.el"))
(load (concat emacsdir "/config/my-bash-completion.el"))

;; pdfs
(load (concat emacsdir "/config/my-find-file.el"))



;; (load (concat emacsdir "/manual-packages/bufler.el/bufler.el"))
(add-to-list 'load-path (concat emacsdir "/manual-packages/bufler.el"))
(require 'bufler)

;; This is a little bit useless, and old.
;; The language server works for tcl-mode, but it doesn't provide anything useful
;; (add-to-list 'load-path (concat emacsdir "/manual-packages/lsp-soar.el"))
;; (require 'lsp-soar)

(load (concat emacsdir "/config/my-load-manually.el"))

;; (add-to-list 'load-path (concat emacsdir "/manual-packages/el-go"))
;; (require 'go)
;; (load-library "go")

;;(add-to-list 'load-path (concat emacsdir "/manual-packages/gkroam.el"))
;;(require 'gkroam)
;;(load-library "gkroam")

(load (concat emacsdir "/config/my-messer.el"))
(load (concat emacsdir "/config/my-hn.el"))
(load (concat emacsdir "/config/my-twittering.el"))

(load (concat emacsdir "/config/my-org-tidbits.el"))


(load (concat emacsdir "/config/my-mode-line-progressbar.el"))

(require 'inf-mongo)

;; (my-load (concat emacsdir "/packages27/evil-*/evil-commands.el"))


;; Bind to company-complete instead
;; ;; I am using M-l M-m (hydra.el)
;; ;; Use this to start counting (C-u)
;; (define-key global-map (kbd "M-~") (kbd "C-u"))
;; ;; (my/with 'evil
;; ;;          (define-key global-map (kbd "M-~") #'evil-switch-to-windows-last-buffer))


(save-place-mode 1)


;; don't want control-Z to suspend frame, it just hangs Emacs --
;; awesome! Thanks Simon!
;; https://github.com/tesujimath/emacs.d.annex/blob/master/init-local.el#L61

(global-unset-key (kbd "C-z"))

(require 'json)

(require 'company)
;; Added here to make it stick
;; vim +/"(define-key company-active-map (kbd \"<RET>\") #'company-complete)" "$EMACSD/config/my-company.el"
(define-key company-active-map (kbd "<RET>") #'company-complete)

;; Use (setq set-mark-command-repeat-pop t) so after pressing C-u C-SPC
;; to jump to a mark popped off the local mark ring, you can just
;; keeping pressing C-SPC to repeat! (It's like repeatedly running
;; repeat with C-x z z z z ...).
;; I learned this from Tony Ballantyne's blog.
(setq set-mark-command-repeat-pop 't)

(global-hide-mode-line-mode 1)

(load (concat emacsdir "/config/my-editorconfig.el"))

;; These appear to get overridden later
;; Therefore put it in an even better map, the translation map
;; Complete this list
;; (define-key global-map (kbd "<f13>") (kbd "<S-f1>"))
;; (define-key global-map (kbd "<f14>") (kbd "<S-f2>"))
;; (define-key global-map (kbd "<f15>") (kbd "<S-f3>"))
;; (define-key global-map (kbd "<f16>") (kbd "<S-f4>"))
;; (define-key global-map (kbd "<f17>") (kbd "<S-f5>"))
;; (define-key global-map (kbd "<f18>") (kbd "<S-f6>"))
;; (define-key global-map (kbd "<f19>") (kbd "<S-f7>"))
;; (define-key global-map (kbd "<f20>") (kbd "<S-f8>"))
;; (define-key global-map (kbd "<f21>") (kbd "<S-f9>"))
(define-key key-translation-map (kbd "<f13>") (kbd "<S-f1>"))
(define-key key-translation-map (kbd "<f14>") (kbd "<S-f2>"))
(define-key key-translation-map (kbd "<f15>") (kbd "<S-f3>"))
(define-key key-translation-map (kbd "<f16>") (kbd "<S-f4>"))
(define-key key-translation-map (kbd "<f17>") (kbd "<S-f5>"))
(define-key key-translation-map (kbd "<f18>") (kbd "<S-f6>"))
(define-key key-translation-map (kbd "<f19>") (kbd "<S-f7>"))
(define-key key-translation-map (kbd "<f20>") (kbd "<S-f8>"))
(define-key key-translation-map (kbd "<f21>") (kbd "<S-f9>"))

;; this may contain things like enabling themes which may not yet be
;; loaded. Therefore, keep it at the end
(_ns custom
     ;; Do not load my-custom.el
     ;; Hopefully the custom stuff never leaves here from now on
     ;; (setq custom-file (concat emacsdir "/config/my-custom.el"))
     ;; (load custom-file 'noerror)
     ;; treat all themes as safe
     (load (concat emacsdir "/config/my-themes.el"))
     (load (concat emacsdir "/config/my-faces.el")))

;; TODO; Reload it with reload-spacemacs-dark
;; (load-library "my-lsp-custom")

;; I had to load later
;; vim +/"after-window-setup-body" "$EMACSD/select-distribution.el"

;; Make this happen very late so the =term-raw-map= is defined properly.
(load (concat emacsdir "/config/my-term.el"))
(load (concat emacsdir "/config/org/my-link-types.el"))
(load (concat emacsdir "/config/my-web-mode.el"))

(load (concat emacsdir "/config/my-apps.el"))

(load (concat emacsdir "/config/pen.el"))

(load (concat emacsdir "/config/my-files.el"))
(load (concat emacsdir "/config/my-openai.el"))

(load (concat emacsdir "/config/my-quick-edit-conf-file.el"))

(mu
 (dolist
     (fn
      (str2list (chomp (b ls $EMACSD/config/trivial))))
   (load (concat "$EMACSD/config/trivial/" fn))))

;; To load the global bindings within, this must be loaded
;; I don't think this is the thing that broke emacs
;; (load (concat emacsdir "/config/shane-minor-mode.el"))
;; (progn)
(setq minibuffer-max-depth nil)

;; This was causing ... to appear in emacs lisp when pressing M-TAB and also causing the minibuffer signatures of elisp functions such as 'sn' to become truncated
;; It's being set per buffer when emacs lisp is started
;; Could this be truncate-long-lines? (C-x t l) It doesn't appear to change these variables.
;; Add to prog-mode.
(defun disable-truncate-code ()
  (setq print-level nil)
  (setq print-length nil))
(add-hook 'prog-mode-hook 'disable-truncate-code)

;; Ensure open-doc-as-text hook comes before persp-add-or-not-on-find-file
;; persp-add-or-not-on-find-file
;; (remove-hook 'find-file-hooks 'open-doc-as-text)
;; (add-hook 'find-file-hooks 'open-doc-as-text)

;; It's actually problematic. It forces itself to be first. I don't like that
;; (remove-hook 'find-file-hooks 'persp-add-or-not-on-find-file)
;; (remove-hook 'find-file-hook 'persp-add-or-not-on-find-file)
;; I couldn't fix it, so I'm just going to redefine the function
;; v +/"(add-hook 'find-file-hook              #'persp-add-or-not-on-find-file)" "$EMACSD/packages27/persp-mode-20180930.1720/persp-mode.el"
(defun persp-add-or-not-on-find-file ())

(load (concat emacsdir "/config/my-warnings.el"))

(load (concat emacsdir "/config/my-polymode.el"))

(setq completing-read-function 'ivy-completing-read)

(load (concat emacsdir "/config/my-recentf.el"))

;; (load (concat emacsdir "/config/my-.el"))

(load (concat emacsdir "/config/my-post-bindings.el"))

(message "Got through .emacs")


;; This must happen extremely late in emacs startup or emacs may not start
;; It drives me mad
;; custom-initialize-reset: Value returned by ‘initial-buffer-choice’ is not a live buffer: nil
(setq initial-buffer-choice nil)


;; This doesn't help
;; (load (concat emacsdir "/config/my-faces.el"))

;; I'm not sure why, but erc gets the window too small for splitting error

(defun final-package-loads-requiring-splitable-window ()
  (load (concat emacsdir "/config/my-erc.el"))
  (load (concat emacsdir "/manual-packages/erc-sasl/erc-sasl.el"))
  (load (concat emacsdir "/config/my-erc-sasl.el"))
  )

(add-hook 'window-setup-hook
          'final-package-loads-requiring-splitable-window t)

;; Somewhere the lsp settings are being written over.
;; Run again
;; (load (concat emacsdir "/config/my-lsp.el"))

;; (load (concat emacsdir "/config/my-daemons.el"))
