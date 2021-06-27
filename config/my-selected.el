;;  This is just what I needed

;;  I kinda hate hydra though. It's horrible compared to regular commands. Avoid using it. Use selected instead for visual commands.
;; See if I can start replacing this hydra with regular bindings

;; I also want it to work for evil-mode
;; vim +/"(defmacro visual-map (KEYS fun)" "$MYGIT/config/emacs/config/my-evil.el"

;; I think defining this before creating the mode makes lispy buffer-local
;; No need for this
;; (defvar-local selected-minor-mode nil)
(require 'selected)
;; Sadly I can't use selected for M-7, M-8 M-9 bindings
;; This is because it needs to work in lisp modes
;; (require 'my-doc)
(require 'my-utils)
(require 'my-filters)

;; This just means it's bound
(defun minor-mode-enabled-in-list (mode)
  "This should be true more often."
  (member mode (current-minor-modes-list)))

;; remember that minor modes stay enabled, even when switching buffers
(defun turn-on-selected-minor-mode ()
  "Enable selected-minor-mode maybe"
  (interactive)
  ;; Don't

  ;; my/lisp mode simply may not be true at the time at which this is checked
  ;; Therefore, it needs to check something else.
  (if ;; (and nil (or (minor-mode-enabled my/lisp-mode)
      ;;              ;; Thankfully this works. It's hard-coded though. Not great...
      ;;              (string-match-p "\\.\\(el\\|cl\\|rkt\\)$" (buffer-name))
      ;;              ))
      (or (minor-mode-enabled my/lisp-mode)
          ;; Thankfully this works. It's hard-coded though. Not great...
          (string-match-p "\\.\\(el\\|cl\\|rkt\\)$" (buffer-name))
          )
      (progn
        (selected-minor-mode -1)
        (selected-region-active-mode -1)
        ;; (if (string-match-p
        ;;      "\.el$"
        ;;      (buffer-name))
        ;;     (progn ;; (tvipe-buffer-properties-json)
        ;;       (tvipe (buffer-name))))
        ;; (message (concat (buffer-name) " is lispy"))
        )
    (progn
      (selected-minor-mode 1)
      ;; (selected-minor-mode 1)
      ;; (message "is not lispy")
      )))

;; (defun turn-on-search-highlight-persist ()
;;   "Enable search-highlight-persist in the current buffer."
;;   (evil-search-highlight-persist
;;    (if (eq 'fundamental-mode major-mode) -1 1)))

;; Only disable this in future if it interferes with lispy
;; selected-mode is truly fucked 21.12.19
;; No way around lispy. Just disable it for lispy.
;; The problem is disabling it everywhere except the modes I want
(define-globalized-minor-mode
  global-selected-minor-mode selected-minor-mode turn-on-selected-minor-mode)
(global-selected-minor-mode t)


;; I don't think I can define my own global mode for selected. It doesn't work
;; I have to define them on an ad-hoc basis or figure out how to use the global mode inside the plugin


;; (selected-minor-mode 1)

;; (defun copy-search-file ()
;;   (interactive)
;;   (xc (bs "$*\"[\]" (selection)))
;;   ;;(bp xc -m "vim +/\"'.escape(a:sel,'/"$*[]').'" "'.expand('%:p').'"')
;;   )

(define-key selected-keymap (kbd "C-h") (kbd "C-w"))
(define-key selected-keymap (kbd "C-k") (kbd "C-w"))

;; Selected mode appears to remain on. Not sure why.
;; I don't want this. It's annoying when editing lisp.
;; (define-key selected-keymap (kbd "q") #'selected-off)

(defun filter-region-through-external-script ()
  "docstring"
  (interactive)
  (if (region-active-p)
      (let ((script
             (read-string "!")))
        (region-pipe script))))

(define-key selected-keymap (kbd "\\!") #'filter-region-through-external-script)
;; The M- version technically isn't in vim
(define-key selected-keymap (kbd "M-\\ !") #'filter-region-through-external-script)

(define-key selected-keymap (kbd "U") #'upcase-region)
(define-key selected-keymap (kbd "M-U") #'upcase-region)

(define-key selected-keymap (kbd "u") #'downcase-region)
(define-key selected-keymap (kbd "M-u") #'downcase-region)

(define-key selected-keymap (kbd "M-c M-c") #'capitalize-region)

(define-key selected-keymap (kbd ">") #'fi-org-indent)
(define-key selected-keymap (kbd "<") #'fi-org-unindent)

(define-key selected-keymap (kbd "D") #'pen-run-prompt-function)


;; This is a useful key in lispy mode
;; There are a lot of useful keys
;; d, J, K
(define-key selected-keymap (kbd "J") #'fi-join)

(defun selected-backspace-delete-and-deselect ()
  (interactive)
  (ekm "")
  (deselect))

(define-key selected-keymap (kbd "C-h") 'selected-backspace-delete-and-deselect)

;; This interferes with lispy. I need w and s to rearrange items in a list.
;; I should make it so
;; (define-key selected-keymap (kbd "w") #'count-words-region)

(define-key selected-keymap (kbd "m") #'apply-macro-to-region-lines)

;; Useful
;; Is it possible for me to use a macro to bind keys to both select AND evil?
(define-key selected-keymap (kbd "I") #'string-insert-rectangle)
(define-key selected-keymap (kbd "=") #'clear-rectangle)

;; I did it here
;; vim +/"(my\/truly-selective-binding \"Y\" #'new-buffer-from-selection-detect-language)" "$EMACSD/config/my-evil.el"
;; DISCARD I need Y for copy selected.
;; Only use Y for this in eww
;; (define-key selected-keymap (kbd "Y") 'new-buffer-from-selection-detect-language)
;; (define-key selected-keymap (kbd "Y") nil)


;; * TODO Make emacs commands that do what my tmux commands do but instantly
;; - Open selected text in a new temporary buffer that is modifiable.
;; How to
(df
 open-region-untitled
 ()
 (new-buffer-from-string
  (selection))
 (save-temp-if-no-file)
 ;; This did not work to disable it
 ;; (let ((intero-mode nil))
 ;;   (save-temp-if-no-file))
 ;; (intero-mode -1)
                                        ;Ensure this is not on; But it's enabled during save-temp-if-no-file
 (deselect))
(define-key selected-keymap (kbd "T") #'open-region-untitled)

;; I'm still getting funky things happen when coding in lisp. Therefore, disable selected mode when entering lisp in auto-mode
(defun my/selected-kill-rectangle ()
  (interactive)
  ;; (call-interactively 'kill-rectangle)
  (if (minor-mode-enabled lispy-mode)
      (let ((selected-minor-mode nil)
            (selected-region-active-mode nil))
        (ekm "D"))
    (call-interactively 'kill-rectangle)))
(define-key selected-keymap (kbd "D") #'my/selected-kill-rectangle)


(defun goto-thing-at-point ()
  (interactive)
  (j (str2sym (my/thing-at-point))))


;; man
;; (define-key selected-keymap (kbd "K") #'evil-lookup)
(define-key selected-keymap (kbd "K") #'man-thing-at-point)

;; (define-key selected-keymap (kbd "m") 'deactivate-mark)
;; (define-key selected-keymap (kbd "m") nil)
(define-key selected-keymap (kbd "j") 'goto-thing-at-point)
(define-key selected-keymap (kbd "u") 'undo)
;; (define-key my-mode-map-keymap (kbd "u") 'undo)
;; (define-key my-mode-map-keymap (kbd "u") nil)

;; Weird choice of letter, but it is quick
(define-key selected-keymap (kbd "O") 'yas-insert-snippet)


(require 'mc-edit-lines)
(define-key selected-keymap (kbd "|") #'mc/edit-lines)

;; This sometimes appears to not respond because it's not actually being called
;; If I C-g on a helm, I must wait a bit before pressing C-g again.
;; This would not be evident on a faster computer.
(defun selected-keyboard-quit ()
  "keyboard-quit and turn off selected mode"
  (interactive)
  (ignore-errors
    (selected-off))
  (deselect)
  ;; (abort-recursive-edit)
  ;; (keyboard-quit)
  ;; (message "selected off")
  )

(define-key selected-keymap (kbd "C-g") #'selected-keyboard-quit)

(defun save-region (&optional sym1 sym2)
  (interactive)
  (setq sym1 (or sym1 'm1))
  (setq sym2 (or sym2 'm2))
  (make-local-variable sym1)
  (make-local-variable sym2)
  (set sym1 (copy-marker (mark)))
  (set sym2 (copy-marker (point))))

(defun restore-region (&optional sym1 sym2)
  (interactive)
  (setq sym1 (or sym1 'm1))
  (setq sym2 (or sym2 'm2))
  (set-mark (eval sym1))
  (goto-char (eval sym2)))

(defun get-vimlinks-url ()
  (interactive)
  (if (selected)
      ;; (my/copy (concat "vim +/\"" (bs (selection) "\`/\"$*[]") "\" " (q (get-current-url))))
      ;; (let ((cmd (concat "vim +/\"" (escape "\`/\"$*[]" (selection)) "\" " (q (bp github-url-to-raw (get-current-url))))))
      (my/copy (se show (concat "vim +/\"" (escape "\`\"$*[]" (selection)) "\" " (q (bp github-url-to-raw (get-current-url))))))
        (my/copy cmd)
        (message "%s" cmd)))

(defun vim-escape (s)
  "Escape a string for a vim pattern"
  (concat "\"" (escape "`/\"$*[]\\" (escape "\\" s)) "\"")
  ;; (concat "\"" (escape "`/\"$*[]\\" s) "\"")
  )

(defun open-selection-sps ()
  (interactive)

  ;; (if (selected)
  ;;     (sps (concat "o " (q (selection)))))

  (if (selected)
      (let ((sel (umn (selection))))
        (edit-fp-on-path sel))))

(defun get-vim-link (&optional editor)
  (interactive)
  (if (not editor)
      (setq editor "v"))
  (defvar uri)
  (defvar vimcmd)
  (setq uri (mnm (get-path t)))

  (setq vimcmd
        (cond ((major-mode-enabled 'eww-mode) "ewwlinks")
              ((major-mode-enabled 'Info-mode) "emacshelp")
              (t editor)))

  (if (selected)
      ;; (my/copy (concat "vim +/\"" (bs (selection) "/\"$*[]") "\" " (q (get-current-url))))
      ;; (my/copy (se 'show (concat "vim +/\"" (escape "`/\"$*[]" (selection)) "\" " (q (bp github-url-to-raw (get-current-url))))))
      (let ((cmd (concat vimcmd " +/" (vim-escape (e/chomp (bp head -n 1 (selection)))) " " (q uri))))
        (my/copy cmd)
        (message "%s" cmd)
        (deselect))))

(defun get-emacs-link (&optional editor)
  (interactive)

  (if (and
       (major-mode-enabled 'eww-mode)
       (>= (prefix-numeric-value current-prefix-arg) 4)
       (selected-p))
      (my/copy (concat (get-path) "#:~:text=" (urlencode (e/chomp-all (selection)))))

      (progn
        (if (not editor)
            (setq editor "sp"))
        (get-vim-link editor))))

;; (defun get-vimlinks-url ()
;;   (interactive)
;;   (if (selected)
;;       (my/copy (concat "vim +/\"" (bs (selection) ".") "\" " (q (get-current-url))))))

(defun forget-region ()
  (interactive)
  (set-marker m1 nil)
  (set-marker m2 nil))


;; Instead of binding and falling back, just use selected mode
;; This is an 'OK' way of doing it without selected.el
;; (defun my/quote-maybe ()
;;   "Quote selected text when region active or insert double quote."
;;   (interactive)

;;   (if (selected)
;;       (filter-selection 'q)
;;     (let ((my-mode nil))
;;       (execute-kbd-macro (kbd "\"")))))
;; (define-key my-mode-map (kbd "\"") #'my/quote-maybe)

;; redefine this function to check if is lisp
;; This is the magic thing that fixes selected. Can't do it any other way
(defun selected--on ()
  (if (not (or (minor-mode-enabled lispy-mode)
               (evil-enabled)))
      (selected-region-active-mode 1))
  ;; (selected-region-active-mode 1)
  )

(define-key selected-keymap (kbd "*") 'my/evil-star-maybe)

;; (define-key eww-mode-map (kbd "M-*") 'my/evil-star-maybe)

;; (define-key selected-keymap (kbd "M-*") 'my/evil-star-maybe)
;; (define-key selected-keymap (kbd "M-*") nil)

(provide 'my-selected)