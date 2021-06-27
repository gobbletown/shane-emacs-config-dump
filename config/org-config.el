(require 'org)
(require 'org-macs)
(require 'my-aliases)
(require 'org-table)

;; (require 'org-bullets)
;; unicode bullets
;; (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
;; (org-bullets-mode 1)
;; Nice bullets. I don't like it really. Disable it from spacemacs.

(setq org-blank-before-new-entry '((heading . t) (plain-list-item . t)))

;; Instead of doing this, create a new syntax highlighting and some new digraphs, maybe
;; (setq org-todo-keywords
;;       '((sequence "TODO" "DISCARD" "IMPORTANT" "KEEP IN MIND" "SUPER IMPORTANT" "FEEDBACK" "VERIFY" "|" "DONE" "DELEGATED")))

;; (setq org-todo-keywords
;;       '((sequence "TODO" "BLOCKED" "|" "DISCARD" "DONE")))
(setq org-todo-keywords
      '((sequence "TODO" "|" "DONE" "DISCARD" "FAILED")))


(load-library "find-lisp")

(defun org-agenda-refresh ()
  (interactive)
  (setq org-agenda-files (find-lisp-find-files "~/agenda" "\.org$"))
  (org-agenda-redo))

(define-key org-agenda-mode-map (kbd "r") 'org-agenda-refresh)


;; This only takes about a second
;; (setq org-agenda-files (find-lisp-find-files "~/notes" "\.org$"))
(setq org-agenda-files (find-lisp-find-files "~/agenda" "\.org$"))
;; (defvar yo (bash "locate -r '/home/shane/notes2018/.*\.*org$'" nil t))

(add-hook 'org-mode-hook (lambda () (modify-syntax-entry (string-to-char "\u25bc") "w"))) ; Down arrow for collapsed drawer.


; Speed up org-mode
; Reduce the number of Org agenda files to avoid slowdowns due to hard drive accesses.
; Reduce the number of ‘DONE’ and archived headlines so agenda operations that skip over these can finish faster.
; Do not dim blocked tasks:
(setq org-agenda-dim-blocked-tasks nil)
; Stop preparing agenda buffers on startup:
(setq org-agenda-inhibit-startup nil)
; Disable tag inheritance for agendas:
(setq org-agenda-use-tag-inheritance nil)

(setq org-cycle-separator-lines 0)

(setq org-link-file-path-type 'absolute)
(setq org-startup-indented t)
(setq org-hide-leading-stars t)         ; This uses the face 'org-hide' behind the scenes. Therefore, it wont hide in vt100
(setq org-odd-level-only nil)
(setq org-insert-heading-respect-content nil)
(setq org-M-RET-may-split-line '((item) (default . t)))
(setq org-special-ctrl-a/e t)
(setq org-return-follows-link nil)

(setq org-use-speed-commands t)
;; (setq org-use-speed-commands nil)
(setq org-speed-commands-user
      '(("x" . org-cut-subtree)
        ("n" . (org-speed-move-safe 'org-next-visible-heading))
        ("p" . (org-speed-move-safe 'org-previous-visible-heading))
        ("j" . (org-speed-move-safe 'org-forward-heading-same-level))
        ("k" . (org-speed-move-safe 'org-backward-heading-same-level))
        ;; ("g"             . org-goto)
        ("g" . counsel-outline)
        ("o" . counsel-outline)
        ;; ("G" . (org-refile t))
        ))

(setq org-startup-align-all-tables nil)
(setq org-log-into-drawer nil)
(setq org-tags-column 1)
(setq org-ellipsis " \u25bc" )
;; (setq org-speed-commands-user nil)
(setq org-blank-before-new-entry '((heading . nil) (plain-list-item . nil)))
(setq org-completion-use-ido t)
(setq org-indent-mode -1)               ; it's ugly with indent-mode disabled. But adding extra stars in vt100 is unacceptable
(setq org-startup-indented nil) ;; this prevents spacemacs from turning on indent mode automatically
;; (setq org-indent-mode t) ;; this looks nice but is annoying in vt100 ;; this added extra stars to the start
;; and needs an annoying redraw
(setq org-startup-truncated nil)
;; (setq org-startup-truncated t) ;; I think i want this ; this isn't truncating long lines so disable it
(setq auto-fill-mode -1)
;; (setq-default fill-column 99999)
;; (setq fill-column 99999)
(global-auto-revert-mode t)
(prefer-coding-system 'utf-8)
;(cua-mode t) ;; keep the cut and paste shortcut keys people are used to.
(cua-mode nil) ;; keep the cut and paste shortcut keys people are used to.
(setq cua-auto-tabify-rectangles nil) ;; Don't tabify after rectangle commands
(transient-mark-mode nil)               ;; No region when it is not highlighted
(setq cua-keep-region-after-copy t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; python
(setq-default indent-tabs-mode nil)    ; use only spaces and no tabs
(setq default-tab-width 4)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; a sample of how to call shell or python program from emacs.
(defun todo-export ()
  (interactive)
  (save-buffer)
  (save-some-buffers t)
  (call-process-shell-command "/bin/bash -c \"cd ~/Desktop/personal; git pull; git commit -am '-'; git push;\"" nil 0 ))

(global-set-key (kbd "") 'todo-export)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; i like pressing f3 to switch to my todo list from wherever i am.
(defun switch-to-personal-todo ()
  (interactive)
  (find-file "path-to-file"))
(global-set-key (kbd "") 'todo-export)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; i like pageup page down for buffer changes.
(global-set-key [(control next)] 'next-buffer)
(global-set-key [(control prior)] 'previous-buffer)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Add copy a whole line to clipboard to Emacs, bound to meta-c.
(defun quick-copy-line ()
  "Copy the whole line that point is on and move to the beginning of the next line.
    Consecutive calls to this command append each line to the
    kill-ring."
  (interactive)
  (let ((beg (line-beginning-position 1))
        (end (line-beginning-position 2)))
    (if (eq last-command 'quick-copy-line)
        (kill-append (buffer-substring beg end) (< end beg))
      (kill-new (buffer-substring beg end))))
  (beginning-of-line 2)
  (message "Line appended to kill-ring."))
; (define-key global-map (kbd "M-c") 'quick-copy-line)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Add inserting current date time.
(defun my-insert-date (prefix)
    "Insert the current date. With prefix-argument, use ISO format. With
   two prefix arguments, write out the day and month name."
    (interactive "P")
    (let ((format (cond
                   ((not prefix) "%Y-%m-%d %H:%M")
                   ((equal prefix '(4)) "%Y-%m-%d")
                   ((equal prefix '(16)) "%A, %d. %B %Y")))
          )
      (insert (format-time-string format))))
; (define-key global-map (kbd "C-M-d") 'my-insert-date)


(define-key org-mode-map (kbd "M-{") nil) ; remove old binding
(define-key org-mode-map (kbd "M-p") 'org-backward-element)

(define-key org-mode-map (kbd "M-}") nil) ; remove old binding
(define-key org-mode-map (kbd "M-n") 'org-forward-element)

;(define-key org-mode-map (kbd "M-h") nil) ; remove old binding


;; This
;; (define-key org-mode-map (kbd "M-q M-p") #'org-insert-heading-before-current)

(define-key org-mode-map (kbd "M-q M-n") #'org-insert-heading-after-current)


;;  This is more important than occur
(define-key org-mode-map (kbd "M-q M-o") #'org-insert-heading-after-current)


(defun output-up-heading-top (arg)
  "Goes to the top-level heading"
  (interactive "p")
  ;; (kbd "M-1 0 0 M-a")
  (dotimes (i 100)
    (outline-up-heading arg)))


;; (define-key org-mode-map (kbd "C-M-a") (kbd "M-1 0 0 M-a"))
(define-key org-mode-map (kbd "C-M-a") #'output-up-heading-top)
(define-key org-mode-map (kbd "M-a") #'outline-up-heading)
(define-key org-mode-map (kbd "M-p") #'org-backward-heading-same-level)
(define-key org-mode-map (kbd "M-n") #'org-forward-heading-same-level)
(define-key org-mode-map (kbd "M-e") #'org-next-visible-heading)
(define-key org-mode-map (kbd "M-E") #'org-previous-visible-heading)

                                        ; My stuff
(setq org-journal-dir "/var/smulliga/notes/journal/emacs/")

;; Now anything I put inside any org files in my notes folder will
;; be used when looking at the agenda.
;; (setq org-agenda-files '("~/notes"))


;; This is the thing that's slow. I also think this command is responsible for actually opening the org files and hence change the recent files.
;; (org-agenda-list)
;; (delete-other-windows)

; HIGHLIGHT LATEX TEXT IN ORG MODE
(setq org-highlight-latex-and-related '(latex))


;; I don't know if org-table is available for emacs 27
;; Also it doesn't work for scimax right now.
;; It's not something I use so I'm disabling it

;; But this is needed for M-r within table cells
;; It works for spacemacs again
;; (when (< emacs-major-version 27))
(use-package org-table
  :defer t
  :config
  (progn
;;;; Table Field Marking
    (defun org-table-mark-field ()
      "Mark the current table field."
      (interactive)
      ;; Do not try to jump to the beginning of field if the point is already there
      (when (not (looking-back "|[[:blank:]]?"))
        (org-table-beginning-of-field 1))
      (set-mark-command nil)
      (org-table-end-of-field 1))

    (defhydra hydra-org-table-mark-field
      (:body-pre (org-table-mark-field)
                 :color red
                 :hint nil)
      "
  ^^      _k_     ^^
 _h_  selection  _l_
  ^^      _j_     ^^
"
      ("x" exchange-point-and-mark "exchange point/mark")
      ("l" (lambda (arg)
             (interactive "p")
             (when (eq 1 arg)
               (setq arg 2))
             (org-table-end-of-field arg)))
      ("h" (lambda (arg)
             (interactive "p")
             (when (eq 1 arg)
               (setq arg 2))
             (org-table-beginning-of-field arg)))
      ("j" next-line)
      ("k" previous-line)
      ("q" nil "cancel" :color blue))

    (bind-keys
     :map org-mode-map
     :filter (org-at-table-p)
     ("M-r" . hydra-org-table-mark-field/body))))


(defadvice org-end-of-line (around my-org-eol-around activate)
  (interactive)

  (let ((visual-line-mode -1))
    (if (interactive-p)
	(call-interactively (ad-get-orig-definition 'org-end-of-line))
      ad-do-it)))

(setq org-yank-folded-subtrees nil)
(setq org-yank-adjusted-subtrees t)

(dk org-mode-map "M-J" 'evil-join)





;;; Org File Apps
(progn
  ;; Make firefox the default web browser for applications like viewing
  ;; an html file exported from Org ( C-c C-e h o )
  (when (executable-find "firefox")
    (add-to-list 'org-file-apps '("\\.x?html\\'" . "firefox %s")))


  (remove-from-list 'org-file-apps '("\\.pdf\\'" . default))

  ;; (remove-from-list 'org-file-apps '("\\.pdf\\'" . "z %s"))

  ;; Change the default app for opening pdf files from org
  ;; http://stackoverflow.com/a/9116029/1219634
  ;; (setcdr (assoc "\\.pdf\\'" org-file-apps) "acroread %s")

  ;; Disable this, but add a find-file hook
  ;; (setcdr (assoc "\\.pdf\\'" org-file-apps) "z %s")
  )

;; I don't even know if this works
;; Never load ob-sh. Change it to ob-shell
(defadvice org-babel-do-load-languages (around org-babel-do-load-languages-around activate)
  ;; "I don't think this actually has to be interactive. No it does not.
  ;;(require 'asoc)

  (setq org-babel-load-languages (delq (assoc 'sh org-babel-load-languages) org-babel-load-languages))

  ;; (if (asoc-contains-key? org-babel-load-languages 'sh)
  ;;     (setf (alist-get 'sh org-babel-load-languages) nil))
  ad-do-it

  ;; (let ((org-babel-load-languages))
  ;;   (if (interactive-p)
  ;;       (call-interactively (ad-get-orig-definition 'org-babel-do-load-languages))
  ;;     ad-do-it))
  )

;; prevent org mode from automatically executing babel blocks. hopefully this also prevents blocks from being executed when clicking on the block
(setq org-export-babel-evaluate nil)