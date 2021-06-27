(require 'my-pcre)

(defun ignore-errors-around-advice (proc &rest args)
  (ignore-errors
    (let ((res (apply proc args)))
      res)))

(defun ignore-errors-passthrough-around-advice (proc arg)
  (try
   (let ((res (apply proc (list arg))))
     res)
   arg))


(defun wiki-summary-after-advice (&rest args)
  ;; No longer needed as we use shackle now
  ;; (call-interactively  'other-window)
  ;; (ns (str (current-buffer)))
  (toggle-read-only)
  (cfilter "ttp")
  (toggle-read-only)
  ;; (deselect)
  )

;; This runs when wiki-summary is finished
(advice-add 'wiki-summary/format-summary-in-buffer :after 'wiki-summary-after-advice)

(defun compile-goto-error-after-advice (&rest args)
  (delete-other-windows))
(advice-add 'compile-goto-error :after 'compile-goto-error-after-advice)


(defun advice-unadvice (sym)
  "Remove all advices from symbol SYM."
  (interactive "aFunction symbol: ")
  (advice-mapc (lambda (advice _props) (advice-remove sym advice)) sym))
(defalias 'advice-remove-all-from 'advice-unadvice)





(defun unique-buffer-generic-after-advice (&rest args)
  "Give the buffer a unique name"
  (ignore-errors (let* ((hash (short-hash (str (time-to-seconds))))
                        (new-buffer-name (pcre-replace-string "(\\*?)$" (concat "-" hash "\\1") (current-buffer-name))))
                   (rename-buffer new-buffer-name))))

(defun perl-repl-after-advice (&rest args)
  "Give the buffer a unique name"
  (with-current-buffer "*Perl-REPL*" (eval `(unique-buffer-generic-after-advice ,@args))
                       t))

;; (advice-add 'perl-repl :after 'advise-perl-repl)
;; (advice-add 'perl-repl :after 'unique-buffer-generic-after-advice)
(advice-add 'perl-repl :after 'perl-repl-after-advice)
;; (advice-unadvice 'perl-repl)

;; (advice-add 'dictionary-search
;;             :after '(lambda (&rest args)
;;                       "Give the buffer a unique name"
;;                       (ignore-errors (rename-buffer (concat "*Dictionary-" (short-hash (concat (car args) (str (time-to-seconds)))) "*")) t)))
(advice-add 'dictionary-search :after 'unique-buffer-generic-after-advice)
;; (advice-unadvice 'dictionary-search)

(advice-add 'calculator :after 'unique-buffer-generic-after-advice)

;; Unfortunately, the edbi-sqlite buffer can't be renamed
;; (advice-add 'edbi-sqlite :after 'unique-buffer-generic-after-advice)
;; (advice-remove 'edbi-sqlite 'unique-buffer-generic-after-advice)

(advice-add 'term :after 'unique-buffer-generic-after-advice)
;; (advice-unadvice 'calculator)

;; Can't rename calc's window because it uses multiple windows and may need the name
;; (advice-add 'full-calc
;;             :after '(lambda (&rest args)
;;                       "Give the buffer a unique name"
;;                       (ignore-errors (rename-buffer (concat "*calc-" (short-hash (concat (car args) (str (time-to-seconds)))) "*")) t)))

;; Unfortunately, this doesn't work because the buffer is renamed
;; DISCARD. Do it the same way I uniqified eww with my/eww
;; The my/eww way wouldn't work either. The
;; only way is to find the exact function which
;; names the buffer and add advice to that.
;; (advice-add 'howdoyou-query
;;             :after '(lambda (&rest args)
;;                       "Give the buffer a unique name"
;;                       (ignore-errors (rename-buffer (concat "*How Do You-" (short-hash (concat (car args) (str (time-to-seconds))))) "*") t)))

;; This is a promise function. Therefore, I have to 'get' the buffer by name before renaming it
(defun howdoyou-after-advice (&rest args)
  "Give the buffer a unique name"

  ;; Frustratingly, howdoyou--get-buffer is called twice. I only want to rename
  ;; on the response.
  ;; So just find where it is called.
  ;; (with-current-buffer "*How Do You*" (message (buffer-name)))
  (ignore-errors (with-current-buffer "*How Do You*" (rename-buffer (concat "*How Do You-" (short-hash (str (time-to-seconds))) "*"))) t)
  ;; (ignore-errors (rename-buffer (concat "*How Do You-" (short-hash (concat (car args) (str (time-to-seconds)))) "*")) t)
  ;; (rename-buffer (concat "*How Do You-" (short-hash (str (time-to-seconds))) "*"))
  )

;; (advice-add 'howdoyou--get-buffer :after 'howdoyou-after-advice)
(advice-add 'howdoyou--print-answer :after 'howdoyou-after-advice)


;; ad-advised-functions
;; This variable tells me about the advised functions

;; This is meant to show advice for a function. It gives me nil. I think that's because my advice-add didn't work
(ad-get-advice-info 'wiki-summary)

                                        ; (wiki-summary "List_of_cosmological_horizons")


;; I should try to advise this function to disable
;; (message "Mark set"))
;; instead of redefining it
(defun helm--advice-push-mark (&optional location nomsg activate)
  (unless (null (mark t))
    (let ((marker (copy-marker (mark-marker))))
      (setq mark-ring (cons marker (delete marker mark-ring))))
    (when (> (length mark-ring) mark-ring-max)
      ;; Move marker to nowhere.
      (set-marker (car (nthcdr mark-ring-max mark-ring)) nil)
      (setcdr (nthcdr (1- mark-ring-max) mark-ring) nil)))
  (set-marker (mark-marker) (or location (point)) (current-buffer))
  ;; Now push the mark on the global mark ring.
  (setq global-mark-ring (cons (copy-marker (mark-marker))
                               ;; Avoid having multiple entries
                               ;; for same buffer in `global-mark-ring'.
                               (cl-loop with mb = (current-buffer)
                                        for m in global-mark-ring
                                        for nmb = (marker-buffer m)
                                        unless (eq mb nmb)
                                        collect m)))
  (when (> (length global-mark-ring) global-mark-ring-max)
    (set-marker (car (nthcdr global-mark-ring-max global-mark-ring)) nil)
    (setcdr (nthcdr (1- global-mark-ring-max) global-mark-ring) nil))
  ;;(or nomsg executing-kbd-macro (> (minibuffer-depth) 0)
  ;;    (message "Mark set"))
  (when (or activate (not transient-mark-mode))
    (set-mark (mark t)))
  nil)



;; (advice-add 'shr-copy-url :around #'wrap2)
(defun wrap2 (orig-fun &rest args)
  (message "shr-copy-url called with args %S" args)
  (let ((res (apply orig-fun args)))
    (message "shr-copy-url returned %S" res)
    res))
(advice-add 'shr-copy-url :around #'wrap2)


;; (require 'dash)
;; Just change helm-dash-browser-func
;; browse-url-generic
;; (setq helm-dash-browser-func 'eww)
;; (defun dash-eww (orig-fun &rest args)
;;   ;; (message "shr-copy-url called with args %S" args)
;;   (let ((res (apply orig-fun args)))
;;     (message "shr-copy-url returned %S" res)
;;     res))
;; (advice-add 'shr-copy-url :around #'wrap2)


(defun my/revert-kill-buffer-and-window ()
  (interactive)
  ;; I can't do the revert or find-file-hooks will kill emacs with svgs, html or anything that uses hyn

  ;; setting to nil doesn't work
  ;; (let ((find-file-hooks nil))
  ;;   (force-revert-buffer))

  ;; I needed preserve-modes for it to not reopen
  ;; (revert-buffer t t t)

  (force-revert-buffer)

  (my-kill-buffer-and-window))

(defun my/go-to-emacs-el ()
  (interactive)
  (find-file
   "/home/shane/var/smulliga/source/git/config/emacs/emacs"))

(defun my/go-to-shane-minor-mode ()
  (interactive)
  (find-file
   "/home/shane/var/smulliga/source/git/config/emacs/config/shane-minor-mode.el"))

(defun my/go-to-myinit-org ()
  (interactive)
  (find-file
   "/home/shane/var/smulliga/source/git/config/emacs/myinit.org"))

;; It would be cool to send this to messages without displaying
;; in the minibuffer
(defun my/log-args (f &rest args)
         (message "advice for %s: %s" f args)
         (apply f args))
;; (advice-add 'target-function :around 'my/log-args)


;; advice-add is the new way of adding advice
;; ad-advice is the old way of adding advice
;; This works but unfortunately nadvice does not add functions to this list.
(defmacro run-with-advice-disabled (&rest body)
  `(progn (ad-deactivate-all)
          ,@body
          (ad-activate-all)
          ))

(defalias 'disable-advice-temporarily 'run-with-advice-disabled)
(defalias 'progn-noadvice 'run-with-advice-disabled)


(defun lispy-goto-symbol-around-advice (proc &rest args)
  (let ((res (apply proc args)))
    res))
(advice-add 'lispy-goto-symbol :around #'lispy-goto-symbol-around-advice)


;; What is this doing here???
;; (let ((my/lisp-mode nil)) (execute-kbd-macro (kbd "e")))


;; ;; This did not work. I have redefined it
(require 'org)
;; This works now
(defun org-kill-line-around-advice (proc &rest args)
  (cl-letf (((symbol-function 'kill-visual-line) #'kill-line))
    (let* ((res (apply proc args))
           res))))
(advice-add 'org-kill-line :around #'org-kill-line-around-advice)
;; (advice-remove 'org-kill-line #'org-kill-line-around-advice)


(defun helm-etags-select-around-advice (proc &rest args)
  (cl-letf (((symbol-function 'thing-at-point) (lambda (&rest body) "")))
    (let ((res (apply proc args)))
      res)))

(advice-add 'helm-etags-select :around #'helm-etags-select-around-advice)


;; (defun quoted-insert-around-advice (proc &rest args)
;;   (let* ((overwrite-mode 'overwrite-mode-textual)
;;          (res (apply proc args)))
;;     res))
;; (advice-add 'quoted-insert :around #'quoted-insert-around-advice)
;; (advice-remove 'quoted-insert #'quoted-insert-around-advice)

;; I did this with a wrapper function instead
;; j quoted-insert-nooctal


;; A failsafe if C-x C-e has not been defined for the current lisp mode
(defun eval-last-sexp-around-advice (proc &rest args)
  (if (major-mode-p 'emacs-lisp-mode)
      (let ((res (apply proc args)))
        (message "eval-last-sexp returned %S" res)
        res)
    (error "Not emacs lisp.")))
(advice-add 'eval-last-sexp :around #'eval-last-sexp-around-advice)



(defun advise-to-shut-up (proc &rest args)
  (shut-up
    (let ((res (apply proc args)))
      res)))
(defalias 'shut-up-around-advice 'advise-to-shut-up)

(defun advise-to-ignore-errors (proc &rest args)
  (ignore-errors
    (let ((res (apply proc args)))
      res)))

(defun advise-to-save-excursion (proc &rest args)
  (save-excursion
    (let ((res (apply proc args)))
      res)))

(defmacro save-excursion-and-region-reliably (&rest body)
  `(save-excursion
     (save-region)
     (let* ((ma mark-active)
            (deactivate-mark nil)
            (res (progn ,@body)))
       (restore-region)
       (if (and (not ma)
                mark-active)
           (deactivate-mark t))
       res)))

(defun advise-to-save-region (proc &rest args)
  (if (selected)
      (save-excursion
        (save-region)
        (let* ((deactivate-mark nil)
               (res (ignore-errors (apply proc args))))
          (restore-region)
          ;; (message "restored")
          ;; (exchange-point-and-mark)
          ;; (reselect-last-region)
          res))
    (let ((res (apply proc args)))
      res)))

;; (defun advise-to (proc wrapfun &rest args)
;; (advice-add 'orderless-all-completions :around #'advise-to-ignore-errors)
;;   `(,wrapfun
;;     (let ((res (apply proc args)))
;;       res)))

;; (advice-add 'generate-glossary-buttons-over-buffer :around #'advise-to-save-excursion)
;; (advice-remove 'generate-glossary-buttons-over-buffer #'advise-to-save-excursion)
;; (advice-add 'reload-glossary-and-generate-buttons :around #'advise-to-save-excursion)

;; This fixes an error in find-file-hook
(advice-add 'find-file-hook--open-junk-file :around #'advise-to-ignore-errors)

;; This fixes an error when writing code in elisp
(advice-add 'flyspell-check-word-p :around #'advise-to-ignore-errors)

;; This fixes an error when typing comments in elisp
(advice-add 'orderless-all-completions :around #'advise-to-ignore-errors)
(advice-add 'all-completions :around #'advise-to-ignore-errors)
;; (advice-add 'company-idle-begin :around #'advise-to-ignore-errors)
;; (advice-add 'company-capf :around #'advise-to-ignore-errors)
;; (advice-add 'orderless-filter :around #'advise-to-ignore-errors)
;; (advice-add 'company--fetch-candidates :around #'advise-to-ignore-errors)

;; (advice-add 'revert-buffer :around #'ignore-errors-around-advice)
;; (advice-remove 'revert-buffer #'ignore-errors-around-advice)


(defun advise-to-yes (proc &rest args)
  (cl-letf (((symbol-function 'yes-or-no-p) #'true))
    (let ((res (apply proc args)))
      res)))
(advice-add 'yas-reload-all :around #'advise-to-yes)


;; This breaks interactive, and it doesn't work anyway
;; The aim was to ensure that a single C-g can exist a function
(defun cgify-around-advice (proc &rest args)
  (let ((inhibit-quit t))
    (unless (with-local-quit
              (let ((res (apply proc args)))
                res)
              t)
      (progn
        (message "%s" (concat "you hit C-g on " (sym2str proc)))
        (setq quit-flag nil)))))
;; (advice-add 'cgify :around #'cgify-around-advice)



(provide 'my-advice)