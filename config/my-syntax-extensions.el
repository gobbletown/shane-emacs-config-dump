(defvar _namespaces ())

(require 'rx)

(defun message-no-echo (format-string &rest args)
  (let ((inhibit-read-only t))
    (with-current-buffer (messages-buffer)
      (goto-char (point-max))
      (when (not (bolp))
        (insert "\n"))
      (insert (apply 'format format-string args))
      (when (not (bolp))
        (insert "\n"))))
  ;; (let ((minibuffer-message-timeout 0))
  ;;   (message format-string args))
  )

(defun add-hook-last (hook fun-to-add)
  (set hook (append (eval hook) (list fun-to-add))))
(defalias 'append-hook 'add-hook-last)

(defun escape (chars input)
  "Escapes chars inside a string"
  ;; unknown rx form mapc. rx must contain only specific functions
  ;; (rx (group (mapc 'any '("u" "o" "i" "e" "a"))))
  ;; rx has an (eval) i decided to go with quasiquotes
  (let ((re (eval `(rx (group (any ,@(butlast (cdr (split-string chars "")))))))))
    (replace-regexp-in-string re "\\\\\\1" input)))

(defun bs (chars input)
  (escape input chars))

;; (defalias 'bs 'escape)
;; ;; (defun bs (chars input)
;; ;;   (escape chars input))

;; elt is short for element
;; seq is short for lit
;; (defalias 'remove-from-list 'delete)
(defmacro remove-from-list (list-var elt)
  `(set ,list-var (delete ,elt ,(eval list-var))))

;; Just make sure these are defined. Don't add my-utils as a dependency
(defalias 'sym2str 'symbol-name)
(defalias 'str2sym 'intern)

(defun slime-curry (fun &rest args)
  "Partially apply FUN to ARGS.  The result is a new function.
This idiom is preferred over `lexical-let'."
  `(lambda (&rest more) (apply ',fun (append ',args more))))

(defun my-load (path)
  ;; seq is my own
  (dolist (item (glob (umn path)))
    (load item)))

(defmacro never (&rest body)
  "Do not run this code"
  `(if nil
       (progn
         ,@body)))

;; (never
;;  (message "yo")
;;  (message "yo"))

;; Can't use initvar because I may pass a sexp
;; (initvar (str2sym (concat "completing-read-hist-" (slugify "GitHub awesome:"))))
;; This is a sexp, not a symbol
;; After using eval, it works
(defmacro initvar (symbol &optional value)
  "defvar while ignoring errors"
  (let ((sym (eval symbol)))
    `(progn (ignore-errors (defvar ,sym nil))
            ;; (ignore-errors (defvar ,symbol nil))
            (if ,value (setq ,symbol ,value)))))

(defmacro defset (symbol value &optional documentation)
  "Instead of doing a defvar and a setq, do this. [[http://ergoemacs.org/emacs/elisp_defvar_problem.html][ergoemacs.org/emacs/elisp_defvar_problem.html]]"

  `(progn (defvar ,symbol ,documentation)
          (setq ,symbol ,value)))

(defmacro defset-local (symbol value &optional documentation)
  "Instead of doing a defvar and a setq, do this. [[http://ergoemacs.org/emacs/elisp_defvar_problem.html][ergoemacs.org/emacs/elisp_defvar_problem.html]]
Interestingly, defvar-local does not come into effect until run, but I guess defset-local would, because it has a set."

  `(progn (defvar-local ,symbol ,documentation)
          (setq-local ,symbol ,value)))

(defmacro _ns (section_name &rest body)
  "These namespaces do nothing but help me organise my code. It does not break definition locations."
  ;; Here I should create a list by the name of each defun.

  ;; (tvipe (type section_name))
  ;; (tvipe section_name)

  (let ((ns_name (str2sym (concat "ns/" (sym2str section_name)))))

    `(progn

       ;; I tried to use a let around the defvar, but I think I need to use macro expansion on the symbol name, or it wont work.
       ;; This is because defvar is a special form.

       ;; (defvar ,(str2sym (concat "ns/" (sym2str section_name))) nil )
       (defset ,ns_name
         (quote ,(mapcar
                  (lambda (item)
                    (cond ((eq 'defalias (car item))
                           (eval (car (cdr item))))
                          ((or (eq 'defun (car item))
                               (eq 'defmacro (car item))
                               (eq 'defvar (car item))
                               (eq '_ns (car item))) (car (cdr item)))
                          (t nil)))
                  body)) "A list of functions and macros.")

       (add-to-list '_namespaces
                    (quote
                     ,ns_name))
       ,@body))

  ;; `(progn ,@body)
  )

(defun keyword-to-symbol (keyword)
  "Convert KEYWORD to symbol."
  (intern (substring (symbol-name keyword) 1)))

;; (keyword-to-symbol :foo) ; => 'foo


;; change all prompts to y or n
;; (defalias 'yes-or-no-p 'y-or-n-p)
;; y or n is enough
(fset 'yes-or-no-p 'y-or-n-p)

;; One of these broke emacs startup
;; (defun t ()
;;   t)
;; (defun f ()
;;   nil)
;; (defun noop ()
;;   nil)

(defmacro testn (s)
  `(and ,s (> (length ,s) 0)))
(defalias 'tn 'testn)

(defmacro iftn (s &rest body)
  `(if (tn ,s) ,@body))



(defmacro ifn (c form &rest body)
  "if not c then execute form otherwise execute remaining forms"
  `(if (not ,c)
       ,form
       (progn
         ,@body)))


(defmacro cl-genfuncwrapper (fun)
  (let* (
         (newfun (intern (concat "cl-" (symbol-name fun))))
         (optional nil)
         (sigbuilder (-flatten (cl-loop for e in (help-function-arglist fun) collect
                                        (progn
                                          (if (eq '&optional e)
                                              (progn (setq optional t)
                                                     '())
                                            (if optional
                                                (list '&key e)
                                              (list e)))))))
         (callbuilder (-flatten (cl-loop for e in (help-function-arglist fun) collect
                                         (progn
                                           (if (or (eq '&optional e)
                                                   (eq '&key e))
                                               '()
                                             (list e))))))
         (sig sigbuilder)
         (iform (interactive-form fun)))
    `(cl-defun ,newfun ,sig ,iform (,fun ,@callbuilder))))


;; (cl-genfuncwrapper counsel-locate-action-extern)

;; (defmacro string-or (&rest strings)
;;   "Return the first element of STRINGS that is a non-blank string.
;; STRINGS will be evaluated in normal `or' order."
;;   `(string-or-1 (list ,@strings)))

;; (defun string-or-1 (strings)
;;   (let (string)
;;     (while strings
;;       (setq string (pop strings))
;;       (if ;; (string-match "\\`\\'" string)
;;           (string-empty-p string)
;;     (setq string nil)
;;     (setq strings nil)))
;;     string))


(defun string-empty-or-nil-p (s)
  (or (not s)
      (string-empty-p s)))

(defun string-not-empty-nor-nil-p (s)
  (not (string-empty-or-nil-p s)))

; The reason why this asks for a string, even if
;; the thing is a string, is because =sor= is not
;; a macro.
(defun string-first-nonnil-nonempty-string (&rest ss)
  "Get the first non-nil string."
  (let ((result))
    (catch 'bbb
      (dolist (p ss)
        (if (string-not-empty-nor-nil-p p)
            (progn
              (setq result p)
              (throw 'bbb result)))))
    result))
;; (defun string-first-nonnil-nonempty-string (s)
;;   (if (not (string-empty-p s))
;;       s))


(defalias 'sor 'string-first-nonnil-nonempty-string)

;; The macro implementation also has the problem of evaluating all strings first
(defmacro str-or (&rest strings)
  "Return the first element of STRINGS that is a non-blank string.
STRINGS will be evaluated in normal `or' order."
  `(generic-or-1 'string-empty-or-nil-p (list ,@strings)))

(defalias 'string-or 'str-or)
(defalias 'stror 'str-or)

(defalias 's-or 'str-or)

(defmacro generic-or (p &rest items)
  "Return the first element of ITEMS that does not fail p.
ITEMS will be evaluated in normal `or' order."
  `(generic-or-1 ,p (list ,@items)))

(defun generic-or-1 (p items)
  (let (item)
    (while items
      (setq item (pop items))
      (if (call-function p item)
    (setq item nil)
    (setq items nil)))
    item))

;; (str-or "" "yo")
;; (generic-or-1 'string-empty-p (list (sn "echo -n") "yo"))

(defmacro after-sec (time_sec &rest body)
  `(run-with-timer ,time_sec nil (lambda () (eval ,@(if (major-mode-p 'eww-mode)
                                                        (eww-reload))))))

(defun noop (&rest args)
  "Do nothing."
  nil)

(provide 'my-syntax-extensions)