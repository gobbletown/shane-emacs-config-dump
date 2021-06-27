(require 'tabulated-list)
(require 'transient)

;; A macro that combines a transient with a command

;; The addition of ',name to the bottom of the macro allows me to more easily nest them
;; But I'll only do this with my own


;; (defmacro transient-define-prefix (name arglist &rest args)
;;   "Define NAME as a transient prefix command.

;; ARGLIST are the arguments that command takes.
;; DOCSTRING is the documentation string and is optional.

;; These arguments can optionally be followed by key-value pairs.
;; Each key has to be a keyword symbol, either `:class' or a keyword
;; argument supported by the constructor of that class.  The
;; `transient-prefix' class is used if the class is not specified
;; explicitly.

;; GROUPs add key bindings for infix and suffix commands and specify
;; how these bindings are presented in the popup buffer.  At least
;; one GROUP has to be specified.  See info node `(transient)Binding
;; Suffix and Infix Commands'.

;; The BODY is optional.  If it is omitted, then ARGLIST is also
;; ignored and the function definition becomes:

;;   (lambda ()
;;     (interactive)
;;     (transient-setup \\='NAME))

;; If BODY is specified, then it must begin with an `interactive'
;; form that matches ARGLIST, and it must call `transient-setup'.
;; It may however call that function only when some condition is
;; satisfied; that is one of the reason why you might want to use
;; an explicit BODY.

;; All transients have a (possibly nil) value, which is exported
;; when suffix commands are called, so that they can consume that
;; value.  For some transients it might be necessary to have a sort
;; of secondary value, called a scope.  Such a scope would usually
;; be set in the commands `interactive' form and has to be passed
;; to the setup function:

;;   (transient-setup \\='NAME nil nil :scope SCOPE)

;; \(fn NAME ARGLIST [DOCSTRING] [KEYWORD VALUE]... GROUP... [BODY...])"
;;   (declare (debug (&define name lambda-list
;;                            [&optional lambda-doc]
;;                            [&rest keywordp sexp]
;;                            [&rest vectorp]
;;                            [&optional ("interactive" interactive) def-body]))
;;            (indent defun)
;;            (doc-string 3))
;;   (pcase-let ((`(,class ,slots ,suffixes ,docstr ,body)
;;                (transient--expand-define-args args)))
;;     `(progn
;;        (defalias ',name
;;          ,(if body
;;               `(lambda ,arglist ,@body)
;;             `(lambda ()
;;                (interactive)
;;                (transient-setup ',name))))
;;        (put ',name 'interactive-only t)
;;        (put ',name 'function-documentation ,docstr)
;;        (put ',name 'transient--prefix
;;             (,(or class 'transient-prefix) :command ',name ,@slots))
;;        (put ',name 'transient--layout
;;             ',(cl-mapcan (lambda (s) (transient--parse-child name s))
;;                          suffixes))
;;        ;; ',name
;;        )))


(defun show-args-function (&optional args)
  (interactive
   (list (transient-args 'test-transient)))
  (message "args: %s" args))

(defun test-function (&optional args)
  (interactive
   (list (transient-args 'test-transient)))
  (message "args: %s" args))

(defun ttl-test-function ()
  (interactive)
  (message "args: %s" args))


;; (eval `(define-transient-command test-transient ()
;;          "Test Transient Title"
;;          ["Arguments"
;;           ("-s" "Switch" "--switch")
;;           ("-a" "Another switch" "--another")]
;;          ["Actions"
;;           ("d" "Action d"
;;            ,(eval `(define-transient-command test-transient2 ()
;;                      "Test Transient Title"
;;                      ["Arguments"
;;                       ("-s" "Switch2" "--switch")
;;                       ("-a" "Another switch" "--another")]
;;                      ["Actions"
;;                       ("d" "Action2 d"
;;                        ,(eval `(define-transient-command test-transient3 ()
;;                                  "Test Transient Title"
;;                                  ["Arguments"
;;                                   ("-s" "Switch3" "--switch")
;;                                   ("-a" "Another switch" "--another")]
;;                                  ["Actions"
;;                                   ("d" "Action3 d" show-args-function)])))])))]))


;; Can I separate the recursion?

;; Must I overload this for define-transient-tabulated-list so that it automatically adds the function from the parent?
;; (defun transient--parse-suffix (prefix spec)


;; define-transient-command
;; (defmacro define-transient-tabulated-list (cmd &rest args)
;;   ""
;;   (let ((name (str2sym (concat "ttl-" (slugify cmd))))
;;         (arglist '())
;;         (title cmd))
;;     ;; The docstring/title can just be the command
;;     (setq args (cons title args))
;;     ;; (etv args)
;;     (declare (debug (&define name lambda-list
;;                              [&optional lambda-doc]
;;                              [&rest keywordp sexp]
;;                              [&rest vectorp]
;;                              [&optional ("interactive" interactive) def-body]))
;;              (indent defun)
;;              (doc-string 3))
;;     (pcase-let ((`(,class ,slots ,suffixes ,docstr ,body)
;;                  (transient--expand-define-args args)))
;;       `(progn
;;          (defalias ',name
;;            ,(if body
;;                 `(lambda ,arglist ,@body)
;;               `(lambda ()
;;                  (interactive)
;;                  (transient-setup ',name))))
;;          (put ',name 'interactive-only t)
;;          (put ',name 'function-documentation ,docstr)
;;          (put ',name 'transient--prefix
;;               (,(or class 'transient-prefix) :command ',name ,@slots))
;;          (put ',name 'transient--layout
;;               ',(cl-mapcan (lambda (s) (transient--parse-child name s))
;;                            suffixes))
;;          ',name))))

;; I need maps
;; v +/"(defvar kubernetes-mode-map" "$HOME/source/gist/abrochard/dd610fc4673593b7cbce7a0176d897de/presentation.org"
;; I should go over this presentation again tomorrow and try to get it


;; For the moment a non-nestable version should be ok

(defmacro define-transient-tabulated-list (cmd &rest transients)
  ""
  (let ((commonname (concat "ttl mode (" cmd ")"))
        (name (str2sym (concat "ttl-transient-" (slugify cmd))))
        (ttlname (str2sym (concat "ttl-" (slugify cmd))))
        (ttlmodesym (str2sym (concat "ttl-" (slugify cmd) "-mode")))
        (ttlmapsym (str2sym (concat "ttl-" (slugify cmd) "-mode-map")))
        (arglist '())
        (title cmd))

    ;; The docstring/title can just be the command
    ;; (setq args (cons title args))

    `(progn

       (define-derived-mode ,ttlmodesym tabulated-list-mode ,commonname
         "Kubernetes mode"
         ;; Don't do set up here. It's already set up when the buffer is created. We still need

         ;; tablist-buffer-from-csv-string
         ;; (let ((columns [("Pod" 100)])
         ;;       (rows (mapcar (lambda (x) `(nil [,x]))
         ;;                     (split-string (shell-command-to-string
         ;;                                    "seq 1 10") "\n"))))
         ;;   (setq tabulated-list-format columns)
         ;;   (setq tabulated-list-entries rows)
         ;;   (tabulated-list-init-header)
         ;;   (tabulated-list-print))
         )

       ;; (use-local-map
       ;;  (let ((map (make-sparse-keymap)))
       ;;    (suppress-keymap map)
       ;;    (prog1 map
       ;;      (define-key map "RET" ',name)
       ;;      ;; (define-key map "q" 'forecast-quit)
       ;;      )))

       (defvar ,ttlmapsym
         (let ((map (make-sparse-keymap)))
           ;; (define-key map (kbd "RET") ',name)
           map))

       ,@(cl-loop
          for (binding flags actions) in transients collect
          `(progn
             (define-key ,ttlmapsym (kbd ,binding) ',name)

             (define-transient-command
               ,name
               ,arglist
               ,title
               ,(list2vec (cons "Arguments" flags))
               ;; Wrap all actions functions in a let providing the args
               ;;

               ;; (defun test-function (&optional args)
               ;; (interactive
               ;;  (list (transient-args ',name)))
               ;; (message "args: %s" args)
               ,(list2vec
                 (cons "Actions"
                       (mapcar
                        (lambda (e)
                          (list
                           (first e)
                           (second e)
                           ;; third is a column
                           ;; but along with the command specification, I must
                           ;; define a function
                           (let (
                                 ;; column number
                                 (third-arg (third e))
                                 ;; keyword or string for action function
                                 (fourth-arg (fourth e)))
                             (cond
                              ;; transient
                              ((stringp fourth-arg)
                               ;; TODO Ensure a =ttl= can be called with an argument (flag string)
                               (let ((subttlsym (str2sym (concat "ttl-" (slugify fourth-arg)))))
                                 ;; When the sub-ttl function runs, it should check for an existing =ttl= / =tabulated-list= and get the data it needs from the current row
                                 ;; Work out syb-ttls later
                                 subttlsym

                                 ;; Creating a new function based on flags and column isn't going to work
                                 ;; I can create a new function, but it must get its input from global state, not from parameters
                                 ;; Since transients can be used in different combinations, I must keep my own global state, not rely on "transient-args ',name"

                                 ;; I have to reutn a lambda which starts this ttl with the args
                                 ;; (lambda ()
                                 ;;   (interactive)
                                 ;;   ;;  Here I want to join the command args
                                 ;;   (let ((ttl-args (transient-args ',name)))
                                 ;;     ;; (call-function 'message "hi")
                                 ;;     (call-function subttlsym (cmd ttl-args))))
                                 )
                               ;; get symbol for transient function
                               )

                              ;; This will be the easiest to implement first
                              ((plist-get e :sps)
                               (eval
                                `(dff (sn ,(plist-get e :sps))))
                               ;; (lambda ()
                               ;;   (interactive)
                               ;;   ;;  Here I want to join the command args
                               ;;   (let ((ttl-args (transient-args ',name)))
                               ;;     (third e)))
                               )
                              ((plist-get e :sn)
                               ;; When the action is run, the transient arguments are saved to a named variable, but I must save them globally too
                               ;; Because I don't know which transient invoked the new command
                               (dff (sn (plist-get e :sn)))))
                             (let ((col (third e))
                                   (spscmd (plist-get e :sps))
                                   (spscmd (plist-get e :sps)))))

                           ;; Will this lambda even work?
                           ;; (lambda ()
                           ;;   (interactive)
                           ;;   ;;  Here I want to join the command args
                           ;;   (let ((ttl-args (transient-args ',name)))
                           ;;     (third e)))
                           ))
                        actions))))

             (defun ,ttlname (&optional flags-string)
               (interactive)
               ;; (switch-to-buffer "*kubernetes*")
               ;; I should also check for the existence of a global flags-string variable.
               ;; I need to do it this way because transient-mode calls the action and doesn't specify all arguments (column)
               (let* ((cmdfull (if (re-match-p ,cmd "%s")
                                   (format ,cmd (string-or
                                                 flags-string
                                                 ""))
                                 ,cmd))
                      (b (cmd-out-to-tablist-quick cmdfull)))
                 ;; (,ttlmodesym)
                 (with-current-buffer b
                   (,ttlmodesym)

                   ;; (use-local-map
                   ;;  (let ((map (make-sparse-keymap)))
                   ;;    (suppress-keymap map)
                   ;;    (prog1 map
                   ;;      (define-key map "RET" ',name)
                   ;;      ;; (define-key map "q" 'forecast-quit)
                   ;;      )))
                   )

                 ;; Instead of calling the transient, bind it to something
                 ;; RET makes sense
                 ;; (call-interactively ',name)
                 ;; b should be disposed of after the transient has run
                 ;; (kill-buffer b)
                 ;;)
                 ;; &rest body here
                 )))))
    ;; name
    ))
(defalias 'dttl 'define-transient-tabulated-list)

;; TODO Also ensure that actions are easy to build up
;; TODO Also, ensure that I can chain these things together entirely within emacs
;; One ttl may open another ttl
;; Chaining spreadsheets together -- this is a very powerful concept
;; The command generates the spreadsheet
;; OOHHHH. I need only one command, to generate the next table based on flags

;; https://magit.vc/manual/transient.html
;; TODO Learn to use nested transients


;; TODO Figure out how to nest transients as actions

;; (dttl "echo hi; arp -a"
;;       ( "Arguments"
;;        ("-f" "Follow" "-f") )
;;       ( "Actions"
;;         ("l" "Log" zone)))



;; The function should be derived from the flag name
;; Somehow I must make this work for multi-columns

;; Design dttl to be nested?
;; cmd-out-to-tablist-quick

;; I must make it so all action functions when they are run also make the tablist

;; When the action is run, also run arp and create a tabulated list


;; TODO Make a macro around something that works
;; I don't actually need to nest them initially
;; Actually, well, I should aim for that.


;; TODO Stop trying to optimise
;; Start by writing what I want the code to look like
;; I need it to be functional

;; I do not want to fully expand the macro in one go
;; In fact, I don't even want it to be a macro.
;; I want it to be a function.
;; This is because I want to call it.
;; The transient should not always call more ttls

;; Merely define the atom.
;; Pass a single row as positional arguments.

;; A dttl is literally just a command to generate the tabulated list and a description of the transient, and starts both immediately
;; I should try and use the original define-transient-command

;; I actually want to define many transients per tabulated list, with different bindings
;; Also, it would be nice to have proper keymaps that I can query

;; Do I even need transient? For the long term, maybe.

;; Specify a column/slice number for actions (-1 is the last column)
(dttl
 "df -h %s | sed 's/Mounted on/MountedOn/'"
 ;; (("-a" "any record" "-type=all"))
 ;; Multiple transients bound to a key
 ("RET"
  (("-b" "any record" "-type"))
  (("l" "Log"
    nil
    ;; dttl must define a function and put the name here
    ;; I should put here a function that expects args
    ttl-test-function)))
 ("M-a"
  (("-a" "any record" "-type"))
  (("l" "Log"
    nil
    ;; dttl must define a function and put the name here
    ;; I should put here a function that expects args
    ttl-test-function)))
 ("d"
  nil
  (
   ;; actions under d with no arguments (save for the column value)
   (
    ;; kb
    "u"
    ;; name
    "ncdu"
    ;; column to get the value from
    -1
    ;; if symbol, run function with args as unspatted params
    ;; if list, evaluate to create function
    ;; if string, concatenate arguments to shell function and run that in bg
    ;; these keyword arguments should set things
    ;; is there a getopts for elisp lists? which can work with both positional and named arguments?
    :sps "ncdu"
    ;; I must have things which can accept the arguments unsplatted. they are all strings
    ;; not everything would fit into this restriction
    )))
 ("b"
  nil
  ;; Start the lsblk transient
  (("l" "lsblk" 0 "lsblk %s"))))

(dttl
 ;; %s is the flags followed by the column value of the previous ttl
 "lsblk %s"
 ("RET"
  (("-b" "any record" "-type"))
  (("l" "Log"
    ttl-test-function)))
 ("n"
  nil
  (("s" "lsblk" 0 :sn "ns %s"))))

;; (dttl
;;  "arp -a"
;;  (("-n" "numeric addresses" "-n"))
;;  (("l" "Log" show-args-function)))

(define-transient-command my-transient ()
  "Something Title"
  ["Arguments"
   ("-s" "Switch" "-switch")
   ("-a" "Another switch" "--another")]
  ["Actions"
   ("d" "Action d" test-function)])

(define-transient-command test-transient ()
  "Test Transient Title"
  ["Arguments"
   ("-s" "Switch" "-switch")
   ("-a" "Another switch" "--another")]
  ["Actions"
   ("d" "Action d" test-function)])


;; TODO Create this recursive macro structure
;; TODO Learn to create recursive macros
;; (dttl
;;  "arp -a"
;;  ;; The first list is the arguments
;;  ;; Transform into a vector if not nil
;;  (;; "Arguments"
;;   ;; The third argument is the generated flag
;;   ("-n" "numeric addresses" "-n"))
;;  (;; "Actions"
;;   ;; The 2nd list is the actions
;;   ;; Transform into a vector if not nil
;;   ("l"
;;    ;; "nslookup"
;;    ,(eval
;;      `(lambda ()
;;         (interactive)
;;         (cmd-out-to-tablist-quick "arp -a")
;;         ;; &rest body here
;;         )))))

;; (eval
;;  `(dttl
;;    "arp -a"
;;    ;; The first list is the arguments
;;    ;; Transform into a vector if not nil
;;    (;; "Arguments"
;;     ;; The third argument is the generated flag
;;     ("-n" "numeric addresses" "-n"))
;;    (;; "Actions"
;;     ;; The 2nd list is the actions
;;     ;; Transform into a vector if not nil
;;     ("l"
;;      ;; "nslookup"
;;      ,(eval
;;        `(lambda ()
;;           (interactive)
;;           (cmd-out-to-tablist-quick "arp -a")
;;           (call-interactively
;;            (dttl "nslookup"
;;                  ["Arguments"
;;                   ("-a" "any record" "-type=any")]
;;                  ["Actions"
;;                   ("l" "Log"
;;                    ;; ,(dff (message "hi"))
;;                    show-args-function)]))))))))
;; (eval
;;  `(dttl
;;    "arp"
;;    ["Arguments"
;;     ;; The third argument is the generated flag
;;     ("-a" "BSD style" "-a")]
;;    ["Actions"
;;     ("l"
;;      ;; "nslookup"
;;      (dttl "nslookup"
;;            ["Arguments"
;;             ("-a" "any record" "-type=any")]
;;            ["Actions"
;;             ("l" "Log"
;;              ;; ,(dff (message "hi"))
;;              show-args-function)]))]))



;; (defmacro remacro (keys)
;;   (if keys
;;       `(abc ,(car keys)
;;             (remacro ,(cdr keys)))))

;; (remacro (a b c))

;; (macroexpand-all '(remacro (a b c)))



;; trantab
(provide 'my-transient-tabulated)