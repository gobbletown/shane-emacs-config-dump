(defalias 'deselect 'deactivate-mark)

(defalias 'call-function 'funcall)

(defalias 'sh-notty 'sn)

(defalias 'symbol2string 'symbol-name)
(defalias 'sym2str 'symbol-name)
(defalias 'y2s 'symbol-name)
(defalias 'string2symbol 'intern)
(defalias 'str2sym 'intern)
(defalias 's2y 'intern)

(defalias 'tail 'cdr)

(defalias 'ff 'find-file)

(defalias 'l 'lambda)


(defalias 'list-buffers 'ibuffer) ; always use ibuffer

;; make frequently used commands short
(defalias 'qrr 'query-replace-regexp)
(defalias 'lml 'list-matching-lines)
(defalias 'dml 'delete-matching-lines)
(defalias 'dnml 'delete-non-matching-lines)
(defalias 'dtw 'delete-trailing-whitespace)
(defalias 'sl 'sort-lines)
(defalias 'rr 'reverse-region)
(defalias 'ss 'replace-string)

(defalias 'wtb 'with-temp-buffer)

(defalias 'g 'grep)
(defalias 'gf 'grep-find)
(defalias 'fd 'find-dired)

(defalias 'rb 'revert-buffer)

;; sh is a function of mine
;; (defalias 'sh 'shell)

(defalias 'fb 'my-flyspell-buffer)
(defalias 'sbc 'set-background-color)
(defalias 'rof 'recentf-open-files)
(defalias 'lcd 'list-colors-display)
;; (defalias 'cc 'calc)

(defun my-concat (&rest body)
  "Converts to string and concatenates."
  (mapconcat 'str body ""))

(defalias 'cc 'my-concat)
(defalias 's+ 'my-concat)

(defalias 'mcc 'mapconcat)

(defalias 'l 'lambda)

; elisp
(defalias 'eb 'eval-buffer)
(defalias 'er 'eval-region)
(defalias 'ed 'eval-defun)
(defalias 'eis 'elisp-index-search)
(defalias 'sf 'load-file)               ; source file
;; (defalias 'lf 'load-file)

                                        ; major modes
(defalias 'hm 'html-mode)
;; (defalias 'tm 'text-mode)
(defalias 'elm 'emacs-lisp-mode)
(defalias 'om 'org-mode)
(defalias 'ssm 'shell-script-mode)

; minor modes
(defalias 'wsm 'whitespace-mode)
(defalias 'gwsm 'global-whitespace-mode)
(defalias 'vlm 'visual-line-mode)
(defalias 'glm 'global-linum-mode)

(defalias 'defkey 'define-key)

;; (defalias 'dk 'define-key) ;this is replaced by a macro
(defalias 'dm 'defmacro)
(defalias 'da 'defalias)

;; Example (major-mode-p 'emacs-lisp-mode) ; has a tick, returns the derived mode, not simply t
(defalias 'major-mode-p 'derived-mode-p)
(defalias 'major-mode-enabled 'derived-mode-p)

;; Example (minor-mode-p go-playground-mode) ; no tick, returns t
(defalias 'minor-mode-p 'bound-and-true-p)
(defalias 'minor-mode-enabled 'bound-and-true-p)
;; (not (minor-mode-enabled semantic-mode))


;; (defun empty-string-p (string)
;;   "Return true if the string is empty or nil. Expects string."
;;   (or (null string)
;;       (zerop (length (trim string))))
;;   )
(defalias 'empty-string-p 's-blank?)

(defalias 'typeof 'type-of)
(defalias 'type 'type-of)

(da 'expandmacro 'macroexpand)
(da 'em 'macroexpand)
(da 'me 'macroexpand)
(da 'expand-macro 'macroexpand)

(da 'expand-function 'symbol-function)
(da 'functionexpand 'symbol-function)

;; like clojure's source macro
(da 'source 'symbol-function)

(da 'i 'interactive)
(da 'pn 'progn)

;; (defalias 'ekm 'execute-kbd-macro)

;; (dm ekm (binding)
;;   `(execute-kbd-macro (kbd ,binding)))

(defun ekm (binding)
  (let ((fun (key-binding (kbd binding))))
    (if fun
        (call-interactively fun)
      (execute-kbd-macro (kbd binding)))))

(defun execute-keyboard-macro-literally (kbm-literal)
  (ekm (mapconcat 'identity (split-string kbm-literal "" t "") " ")))
(defalias 'ekml 'execute-keyboard-macro-literally)

(dm dk (name binding f)
  `(define-key ,name (kbd ,binding) ,f))

(dm uk (name binding)
    `(define-key ,name (kbd ,binding) nil))

(da 'up 'use-package)

(da 'rq 'require)

(da 'uc 'upcase)
(da 'lc 'downcase)

;; buffer-string is a function
(da 'buffer-contents 'buffer-string)

;; To delete an alias
;;(da 'buffer-contents nil)
;;(da 'buffer-contents)

(defun word-meta-at-point ()
  "Return sexp representing the word at point, including highlighting."
  (format "%S" (thing-at-point 'word)))

(defun word-at-point-string ()
  "Return the word at point."
  (format "%s" (thing-at-point 'word)))
(da 'word-at-point 'word-at-point-string)

(defun sexp-at-point ()
  "Return the sexp at point. If you're not looking at lisp, then this will show the sexp that represents the word at point."
  (str (thing-at-point 'sexp)))

;; (defalias 'selected 'region-active-p)
(defun selected ()
  (or
   ;; This may be safer than region-active-p
   (use-region-p)
   ;; (region-active-p)
   (evil-visual-state-p)))
(defalias 'selectedp 'selected)
(defalias 'selectionp 'selected)
(defalias 'selected-p 'selected)
(defalias 'selection-p 'selected)

;; (evil-visual-state-p)

(defalias 'expand-glob 'file-expand-wildcards)

;; It would be nice if I could alias to something that would first check
;; if an elisp version exists. It doesn't matter, unless chomp is taken
;; by some other library
;; (da 'chomp 'my/chomp)
(da 'chomp 'e/chomp)

(da 'tmv 'spv)

(defmacro df (name &rest body)
  "Named interactive lambda with no arguments"
  `(defun ,name ()
     (interactive)
     ,@body))
(defalias 'lf 'df)

(defalias 'current-buffer-name 'buffer-name)

;; The lambda macro must be an inline macro
;; I was a little confused when I made the snippet
;; (lm 5)
;; A lambda macro is just a quasiquote
;; (macroexpand `(+ 1 ,5))
;; OK, so how do i repeat a list?

;; This stands for lambda, not lambda macro
(defmacro lm (&rest body)
  "Interactive lambda with no arguments."
  `(lambda () (interactive) ,@body))
(defalias 'il 'lm)

(defalias 'so 'source)

(defalias 'sleep 'sleep-for)

(da 'apropos-function 'apropos)

(defalias 'my/function-exists 'fboundp)
(defalias 'fexists 'fboundp)
(defalias 'function-p 'fboundp)

;; (defalias 'my/variable-exists 'boundp) ; boundp treats nil as exists. this can be annoying. intern-soft treats it as false
(defun variable-p (s)
  (and (not (eq s nil))
       (boundp s)))

;; (defmacro variable-p (s)
;;   `(and (not (eq ,s nil))
;;        (boundp ,s)))

(defalias 'my/variable-exists 'variable-p)
(defalias 'varexists 'variable-p)


;; What do you call predicates without parameters?
(defalias 'terminal-p (lm (not (display-graphic-p)))) ; Ha. I didn't know I could define functions like this
(defalias 'is-tty-p 'terminal-p)
(defalias 'emacs-nw-p 'terminal-p)
(defalias 'gui-p 'display-graphic-p)
(defalias 'is-gui-p 'display-graphic-p)

;; I hope this is not as evil as it looks. I would need to make it easy
;; to write a lambda then
(defalias 'λ 'lambda)

(defalias 'su 'shut-up)

;; Use ic and not ci because I want to use ci for cacheit
(defalias 'ic 'call-interactively)

;; (fmakunbound 'my-def-lang-doc-engine)
(defalias 'undefun 'fmakunbound)
(defalias 'unset-function 'fmakunbound)

;; (defalias 'unset-variable 'makunbound)
(defun unset-variable (s &optional local)
  (if local
      (kill-local-variable s)
    (makunbound s)))
(defalias 'unset-local-variable 'kill-local-variable)
(defalias 'unset-global-variable 'makunbound)

(defun unset (s &optional local)
  ;; Ensure I can unset local / global
  (if (function-p s)
      (fmakunbound s))
  (if (variable-p s)
      (if local
          (kill-local-variable s)
        (makunbound s))))

(defun prepend-element-to-set (myelement mylist)
  (add-to-list 'mylist myelement))

(defun prepend-element-to-list (myelement mylist)
  (add-to-list 'mylist myelement nil ))

(defalias 'kill-window 'delete-window)
(defalias 'only-window 'delete-other-windows)

(defalias 'timets 'time-to-seconds)
(defalias 'str2lines 's-lines)

(defalias 'copy-list 'copy-tree)

;; call interactively with parameters
(defalias 'fci 'funcall-interactively)

;; (defalias 'string-or 'gnus-string-or)

(defalias 'yn 'yes-or-no-p)


(defun ignore-truthy (&rest _arguments)
  "Do nothing and return nil.
This function accepts any number of ARGUMENTS, but ignores them."
  (interactive)
  t)

(defmacro auto-yes (&rest body)
  ""
  `(cl-letf (((symbol-function 'yes-or-no-p) #'ignore-truthy)
             ((symbol-function 'y-or-n-p) #'ignore-truthy))
     (progn ,@body)))
(defmacro auto-no (&rest body)
  ""
  `(cl-letf (((symbol-function 'yes-or-no-p) #'ignore)
             ((symbol-function 'y-or-n-p) #'ignore))
     (progn ,@body)))

;; (auto-no (if (yn "yes?") (message "true") (message "no")))



;; Use ht.el instead
;; $EMACSD/packages27/ht-20190404.1202/ht.el
(defmacro mht (&rest body)
  "Make hash table"
  `(make-hash-table :test 'equal ,@body))


;; (nconc '("hi") '("yo"))
(defalias 'join-lists 'nconc)

(defalias 'run-after-time 'run-with-timer)

(defalias 'pps 'pp-to-string)

(defalias 'current-window 'selected-window)

(defalias 'line 'get-current-line-string)
(defalias 'getline 'get-current-line-string)
(defalias 'current-line-string 'get-current-line-string)
;; (get-current-line-string)

(provide 'my-aliases)