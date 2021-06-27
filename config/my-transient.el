(require 'transient)
(require 'my-strings)

;; Add ',name to the end so I can use E in lispy
;; Define and run
(defmacro transient-define-prefix (name arglist &rest args)
  "Define NAME as a transient prefix command.

ARGLIST are the arguments that command takes.
DOCSTRING is the documentation string and is optional.

These arguments can optionally be followed by key-value pairs.
Each key has to be a keyword symbol, either `:class' or a keyword
argument supported by the constructor of that class.  The
`transient-prefix' class is used if the class is not specified
explicitly.

GROUPs add key bindings for infix and suffix commands and specify
how these bindings are presented in the popup buffer.  At least
one GROUP has to be specified.  See info node `(transient)Binding
Suffix and Infix Commands'.

The BODY is optional.  If it is omitted, then ARGLIST is also
ignored and the function definition becomes:

  (lambda ()
    (interactive)
    (transient-setup \\='NAME))

If BODY is specified, then it must begin with an `interactive'
form that matches ARGLIST, and it must call `transient-setup'.
It may however call that function only when some condition is
satisfied; that is one of the reason why you might want to use
an explicit BODY.

All transients have a (possibly nil) value, which is exported
when suffix commands are called, so that they can consume that
value.  For some transients it might be necessary to have a sort
of secondary value, called a scope.  Such a scope would usually
be set in the commands `interactive' form and has to be passed
to the setup function:

  (transient-setup \\='NAME nil nil :scope SCOPE)

\(fn NAME ARGLIST [DOCSTRING] [KEYWORD VALUE]... GROUP... [BODY...])"
  (declare (debug (&define name lambda-list
                           [&optional lambda-doc]
                           [&rest keywordp sexp]
                           [&rest vectorp]
                           [&optional ("interactive" interactive) def-body]))
           (indent defun)
           (doc-string 3))
  (pcase-let ((`(,class ,slots ,suffixes ,docstr ,body)
               (transient--expand-define-args args)))
    `(progn
       (defalias ',name
         ,(if body
              `(lambda ,arglist ,@body)
            `(lambda ()
               (interactive)
               (transient-setup ',name))))
       (put ',name 'interactive-only t)
       (put ',name 'function-documentation ,docstr)
       (put ',name 'transient--prefix
            (,(or class 'transient-prefix) :command ',name ,@slots))
       (put ',name 'transient--layout
            ',(cl-mapcan (lambda (s) (transient--parse-child name s))
                         suffixes))
       ;; This is my addition
       ',name)))


;; Add ',name to the end so I can use E in lispy
;; Define and run
(defmacro transient-define-infix (name _arglist &rest args)
  "Define NAME as a transient infix command.

ARGLIST is always ignored and reserved for future use.
DOCSTRING is the documentation string and is optional.

The key-value pairs are mandatory.  All transient infix commands
are equal to each other (but not eq), so it is meaningless to
define an infix command without also setting at least `:class'
and one other keyword (which it is depends on the used class,
usually `:argument' or `:variable').

Each key has to be a keyword symbol, either `:class' or a keyword
argument supported by the constructor of that class.  The
`transient-switch' class is used if the class is not specified
explicitly.

The function definitions is always:

   (lambda ()
     (interactive)
     (let ((obj (transient-suffix-object)))
       (transient-infix-set obj (transient-infix-read obj)))
     (transient--show))

`transient-infix-read' and `transient-infix-set' are generic
functions.  Different infix commands behave differently because
the concrete methods are different for different infix command
classes.  In rare case the above command function might not be
suitable, even if you define your own infix command class.  In
that case you have to use `transient-suffix-command' to define
the infix command and use t as the value of the `:transient'
keyword.

\(fn NAME ARGLIST [DOCSTRING] [KEYWORD VALUE]...)"
  (declare (debug (&define name lambda-list
                           [&optional lambda-doc]
                           [&rest keywordp sexp]))
           (indent defun)
           (doc-string 3))
  (pcase-let ((`(,class ,slots ,_ ,docstr ,_)
               (transient--expand-define-args args)))
    `(progn
       (defalias ',name ,(transient--default-infix-command))
       (put ',name 'interactive-only t)
       (put ',name 'function-documentation ,docstr)
       (put ',name 'transient--suffix
            (,(or class 'transient-switch) :command ',name ,@slots))
       ;; I added this
       ',name)))

;; Add ',name to the end so I can use E in lispy
;; Define and run
(defmacro transient-define-suffix (name arglist &rest args)
  "Define NAME as a transient suffix command.

ARGLIST are the arguments that the command takes.
DOCSTRING is the documentation string and is optional.

These arguments can optionally be followed by key-value pairs.
Each key has to be a keyword symbol, either `:class' or a
keyword argument supported by the constructor of that class.
The `transient-suffix' class is used if the class is not
specified explicitly.

The BODY must begin with an `interactive' form that matches
ARGLIST.  The infix arguments are usually accessed by using
`transient-args' inside `interactive'.

\(fn NAME ARGLIST [DOCSTRING] [KEYWORD VALUE]... BODY...)"
  (declare (debug (&define name lambda-list
                           [&optional lambda-doc]
                           [&rest keywordp sexp]
                           ("interactive" interactive)
                           def-body))
           (indent defun)
           (doc-string 3))
  (pcase-let ((`(,class ,slots ,_ ,docstr ,body)
               (transient--expand-define-args args)))
    `(progn
       (defalias ',name (lambda ,arglist ,@body))
       (put ',name 'interactive-only t)
       (put ',name 'function-documentation ,docstr)
       (put ',name 'transient--suffix
            (,(or class 'transient-suffix) :command ',name ,@slots))
       ;; I added this
       ',name)))


(defalias 'list2vector 'vconcat)

;; Snippet go or ca for the shell script

;; Should I generate the getopts shell code?

;; options=$(getopt -o brg --long color: -- "$@")
;; aptions="$(getopt -o H:f: -- "$@")"
;; if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; exit 1 ; fi

;; (define-transient-command test-transient ()
;;   "Test Transient Title"
;;   ["Arguments"
;;    ("-s" "Switch" "--switch")
;;    ("-a" "Another switch" "--another")
;;    ("-m" "Message" "--message=")] ;; simpler
;;   ["Actions"
;;    ("d" "Action d" test-function)])

;; What are the predicates?
;; vim +/"\* Complete list" "$NOTES/ws/google/search-operators.org"

;; I need a shell script to interpret the arguments with getopts and generate the final query
;; I could make it in python, actually.
;; That might handle the --option= type arguments better

(defset google-key-value-predicates
  ;; prefix with - to invert i.e. -inurl:
  ;; ext is the same as filetype
  (list ;; "ext"
   "filetype"
   "intext"
   "intitle"
   "inurl"
   "site"))

(defset github-key-value-predicates
  ;; prefix with - to invert i.e. -inurl:
  (list ;; "ext"
   "repo"
   "extension"
   "path"
   "filename"
   "followers"
   "language"
   "license"))

(defun google-transient-search (&optional args)
  (interactive
   (list (transient-args 'google-transient)))
  (let ((query (cl-sn (concat "gen-google-query " (mapconcat 'q args " ")) :chomp t)))
    (eegr query))
  ;; (message "args %s" args)
  ;; (message "args %s" (pp-to-string args))
  ;; (message "args %s" (pp-to-string args))
  )

(defun google-transient-search-with-keywords (&optional args)
  (interactive
   (list (transient-args 'google-transient)))
  (let* ((keywords (read-string-hist "gl keywords:"))
         (query (cl-sn (concat "gen-google-query " (mapconcat 'q args " ") " " keywords) :chomp t)))
    (eegr query))
  ;; (message "args %s" args)
  ;; (message "args %s" (pp-to-string args))
  ;; (message "args %s" (pp-to-string args))
  )

(defun github-transient-search (&optional args)
  (interactive
   (list (transient-args 'github-transient)))
  (let ((query (cl-sn (concat "gen-github-query " (mapconcat 'q args " ") " main") :chomp t)))
    (eegh query))
  ;; (message "args %s" args)
  ;; (message "args %s" (pp-to-string args))
  ;; (message "args %s" (pp-to-string args))
  )

(defun github-transient-search-with-keywords (&optional args)
  (interactive
   (list (transient-args 'github-transient)))
  (let* ((keywords (read-string-hist "gh keywords:"))
         (query (cl-sn (concat "gen-github-query " (mapconcat 'q args " ") " " (string-or keywords "main")) :chomp t)))
    (eegh query))
  ;; (message "args %s" args)
  ;; (message "args %s" (pp-to-string args))
  ;; (message "args %s" (pp-to-string args))
  )

(defun create-my-transient (name kvps searchfun kwsearchfun &optional keywordonly)
  (let ((sym (str2sym (concat name "-transient")))
        (args
         (vconcat (list "Arguments")
                  (append
                   ;; (let ((c 0))
                   ;;   (cl-loop for p in google-key-value-predicates do (setq c (1+ c))
                   ;;            collect
                   ;;            (list ;; (concat "-" (str c))
                   ;;             (str c) p (concat "--" p "="))
                   ;;            collect
                   ;;            (list ;; (concat "-" (str c))
                   ;;             (concat "-" (str c)) (concat "not" p) (concat "--not-" p "=")))
                   ;;   (concat "-" (str c)))
                   (let ((c 0))
                     (cl-loop for p in kvps do (setq c (1+ c)) collect (list (str c) p (concat "--" p "="))))
                   (let ((c 0))
                     (cl-loop for p in kvps do (setq c (1+ c)) collect (list (concat "-" (str c)) (concat "not" p) (concat "--not-" p "="))))
                   ;; (list (list "k" "keywords" "--keywords="))
                   )))
        (actions
         (vconcat
          (if keywordonly
              (list "Actions"
                    (list "k" "Search with keywords" kwsearchfun))
            (list "Actions"
                    (list "s" "Search" searchfun)
                    (list "k" "Search with keywords" kwsearchfun))))))
    (eval `(define-transient-command ,sym ()
             ,(concat (s-capitalize name) " transient")
             ,args
             ,actions))))

(create-my-transient "google" google-key-value-predicates 'google-transient-search 'google-transient-search-with-keywords)
(create-my-transient "github" github-key-value-predicates 'github-transient-search 'github-transient-search-with-keywords t)
;; (create-google-transient)

;(define-key global-map (kbd "H-\\") 'google-transient)


;; (convert-hydra-to-sslk "H-?"
;;                        (defhydra hydra-internet-search (:color blue)
;;                          "Search internet"
;;                          ("h" 'github-transient "github advanced search")
;;                          ))

(define-key global-map (kbd "H-? h") 'github-transient)
(define-key global-map (kbd "H-? g") 'google-transient)

;; (define-key global-map (kbd "H-?") nil)

(provide 'my-transient)