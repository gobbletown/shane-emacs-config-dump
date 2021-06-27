(require 'my-utils)
(require 'memoize)
(require 'em-unix)

(require 'nix-env-install)
(require 'nix-modeline)
(require 'nixpkgs-fmt)

;; Use c/ to represent some kind of cast -- alternatively, just name lisp functions which perform some kind of casting, cast-
;; For example, cast-dirname or cast-directory

;; TODO
;; Add "tt" script functions
;; "tt -! $HOME/scripts/tt"
;; Need to be able to get the exit code of the script

;; REMEMBER
;; Consider using this before creating a new function
;; (tvipe (b echo -n yo))

;; (hs "ehstest" (message "hi"))

(defmacro hsr (name &rest body)
  "Macro. Record the elisp into hs before running."
  `(progn (sh/hs ,name ,@body)
          ,@body))

;; hs should be used for programs. It's not appropriate for emacs
(defun hs (name &rest body)
  "Function. Record the arguments into hs before running."
  ;; (eval `(sh/hs ,name ,(mapconcat 'str body " ")))
  (sn (concat "hist-save " (q name) " " (mapconcat 'q (mapcar 'str body) " "))))

(defun hg (name)
  (str2lines (cl-sn (concat "hist-get " (q name)) :chomp t)))

(defun hist-edit (name)
  (find-file (cl-sn (concat "hist-getfile " (q name)) :chomp t)))
(defalias 'he 'hist-edit)

(defmacro sh/hs (name &rest body)
  `(shell-command (concat "hs " "emacs-" (str ,name) " " (q (str ',@body)))))

;; (hs "eww-display-html" "https://medium.com/datadriveninvestor/rake-rapid-automatic-keyword-extraction-algorithm-f4ec17b2886c")

;; (hs "ehstest" (message "hi"))
;; (sh/hs "ehstest" (message "hi there yo"))

(defmacro m/apply (macro mylist)
  `(tvipe ',mylist))

     ;; Do not use bxr here unless I want infinite recursion
     ;; I'll have to expand the macro and use that instead


(defmacro quote-args (&rest body)
  "Join all the arguments in a sexp into a single string.
Be mindful of quoting arguments correctly."
  ;; (tvipe body)
  ;; Also say if sexp is a (quote ...) then turn it into "'..."
  `(mapconcat (lambda (input)

                ;; This is too tricky a use-case
                ;; (quote-args hi yo 'sup' hi)
                ;; And this would always fail anyway
                ;; (quote-args hi yo 'sup')

                ;; (if (and (listp input)
                ;;          (eq 'quote (car input))))
                (shellquote (str input))) ',body " "))

(defun shellquote (input)
  "If string contains spaces or backslashes, put quotes around it, but only if it is not surrounded by ''."
  (if ;; (and (not (string-match "^'.*'$" input))
      ;;      (or (string-match "\\\\" input)
      ;;          (string-match " " input)
      ;;          (string-match "*" input)
      ;;          (string-match "?" input)
      ;;          (string-match "\"" input)))
      (or (string-match "\\\\" input)
          (string-match " " input)
          (string-match "*" input)
          (string-match "?" input)
          (string-match "\"" input))
      (q input)
    input))


;; This is the way to make shell macros
;; But I want something like (tt -f fp) to work. That wouldn't work, because fp would be interpreted as a string
;; Therefore, I need a function too
(defmacro sh/tt (&rest body)
  `(let ((mylist ',body))
     (string-equal (sh-notty (concat (quote-args "tt" ,@body) " && echo -n $?")) "0")))
(defalias 'tt 'sh/tt)

(defun current-function ()
  "Gets the name OR definition of the function you are in. Does not work for compiled functions. Works for macros too. Place at the top."
  (let ((n 6) ;; nestings in this function + 1 to get out of it
        func
        bt)
    (while (and (setq bt (backtrace-frame n))
                (not func))
      (setq n (1+ n)
            func (and bt
                      (nth 0 bt)
                      (nth 1 bt))))
    func))

     ;; (defmacro create-shell-command (cmd-name)
     ;;   `(defmacro (string2symbol (concat "sh/" cmd-name)))
     ;;   ;; (let ((command-name (car body)))
     ;;   ;;   (tvipe command-name))
     ;;   )

     ;; When I have finished a macro which can run arbitrary bash, give it to MoziM
(defmacro sh/test (&rest body)
  ;; (tvipe (list ,@body))
  `(let ((mylist ',body))
     ;; (quote-args "test" ,@body)
     ;; (tvipe (list "test" ,@body))
     ;; (quote-args "test" ,@body)
     ;; (tvipe (cl-reduce 'quote-args (add-to-list 'mylist "test")))
     ;; (quote-args "test" ,@body)
     ;; (string-equal (sh-notty (concat (quote-args "test" ,@body) " && echo -n $?")) "0")
     (string-equal (sh-notty (concat (quote-args "test" ,@body) " && echo $?")) "0")
     ;; (string-equal (sh-notty (concat (quote-args "test" ,@body))) "0")
     ))
(defalias 'test 'sh/test)

     ;; (defalias 's 'magit-status)
(defmacro s (&rest body)
  ;; (tvipe (list ,@body))
  `(let ((mylist ',body))
     ;; (quote-args "test" ,@body)
     ;; (tvipe (list "test" ,@body))
     ;; (quote-args "test" ,@body)
     ;; (tvipe (cl-reduce 'quote-args (add-to-list 'mylist "test")))
     ;; (quote-args "test" ,@body)
     ;; (string-equal (sh-notty (concat (quote-args "test" ,@body) " && echo -n $?")) "0")
     (sh-notty (concat (quote-args ,@body))) "0"))

     ;; (tvipe (b unbuffer top -n 1))
     ;; I think b is used too often to put (hs) inside it
(defmacro b (&rest body)
  "Runs a shell command
Write straight bash within elisp syntax (it looks like emacs-lisp)"
  `(sh-notty (bds (concat (quote-args ,@body)) "b")))

(defmacro echo (&rest body)
  `(b echo ,@body))

(defun e (path)
  (interactive)
  (if path
      (find-file (eval `(echo -n ,path)))))

     ;; This does not use stdin or stdout
(defmacro b-tty (&rest body)
  `(sh (concat (quote-args ,@body))))

(defmacro b. (&rest body)
  "b but with chomp."
  `(sh-notty (concat (quote-args ,@body) " | s chomp")))

     ;; (let ((exit_code nil)) (sh-notty "true" nil nil exit_code) exit_code)
     ;; Don't mix up bq with the bigquery bq
     ;; (bq true)
     ;; (bq false)
(defmacro bd (&rest body)
  "Like b, but detach."
  ;; `(shut-up (sh-notty (concat (quote-args ,@body)) nil nil nil t))
  ;; shut-up appears to not work
  `(shut-up (sh-notty (concat (quote-args ,@body)) nil nil nil t)))
     ;; (bd true)

(defmacro be (&rest body)
  "Returns the exit code."
  (defset b_exit_code nil)

  `(progn
     (sh-notty (concat (quote-args ,@body)))
     (string-to-int b_exit_code)))

     ;; There is currently no be-tty because sh cant populate an exit code variable
     ;; There is currently no ble-tty because I dont have be-tty

;;;; This is not possible -- let var pointers cant be used
     ;; (defmacro ble (&rest body)
     ;;   "Returns the exit code."
     ;;   `(let ((exit_code))
     ;;      (trace (sh-notty (concat (quote-args ,@(butlast body)) " " (q ,@(last body))) nil nil 'exit_code))
     ;;      (string-to-int exit_code)))

(defun sne (cmd)
  "Returns the exit code."
  (defset b_exit_code nil)

  (progn
    (sh-notty cmd)
    (string-to-int b_exit_code)))

(defun snq (cmd)
  (let ((code (sne cmd)))
    (equal code 0)))

(defmacro ble (&rest body)
  "Returns the exit code."
  (defset b_exit_code nil)

  `(progn
     (sh-notty (concat (quote-args ,@(butlast body)) " " (q ,@(last body))))
     (string-to-int b_exit_code)))

(defmacro bld (&rest body)
  "Runs and detaches."
  `(sh-notty (ns (concat (quote-args ,@(butlast body)) " " (q ,@(last body)))) nil nil nil t))

     ;; (memoize 'bld) ; I don't want to memoize these, though. I want it to be executed each time
     ;; (memoize-restore 'bld)

(defmacro bpe (&rest body)
  "Pipe the last argument in. Returns the exit code."
  (defset b_exit_code nil)

  `(progn
     (sh-notty (concat (quote-args ,@(butlast body))) (q ,@(last body)) nil 'b_exit_code)
     (string-to-int b_exit_code)))

     ;; (defalias 'bpl 'bpe)

     ;; (be u isx (buffer-name))
(defmacro bq (&rest body)
  "True if exit code = 0."
  `(eq (be ,@body) 0))

(defmacro blq (&rest body)
  "Returns the exit code."
  `(eq (ble ,@body) 0))

     ;; (bp qftln | q | q "hi")
     ;; (bp qftln "hi")
     ;; (bp sed -n "/h/p" "hello")


(defun edit-fp-on-path (fp)
  "Edit file given by path. If not found, then look in PATH."
  (interactive (list (read-string-hist "Edit Which: ")))

  (setq fp (umn fp))
  (cond
   ((blq which fp) (ff (chomp (sh-notty (concat "which " fp)))))
   ((blq test -f fp) (ff (chomp fp)))
   ((blq test -d fp) (ff (chomp fp)))
   (t (message (concat fp " not found")))))
(defalias 'edit-which 'edit-fp-on-path)
(defalias 'ewhich 'edit-fp-on-path)
(defalias 'ew 'edit-fp-on-path)


;; filter
(defmacro bp (&rest body)
  "Pipe string into bash command. Return stdout."
  ;; Remove the last element from a list
  `(sh-notty (concat (quote-args ,@(butlast body))) ,@(last body)))

(defmacro bp-tty (&rest body)
  "Pipe string into bash command. Return stdout."
  ;; Remove the last element from a list
  `(sh (concat (quote-args ,@(butlast body))) (str ,@(last body)) t))

     ;; These are functionally equivalent
     ;; (tvipe (bxr echo (buffer-name)))
     ;; (tvipe (bp xargs echo (buffer-name)))

     ;; (bp xargs echo "(buffer-name)" (buffer-name))
     ;; (tvipe (bxr echo "(buffer-name)" (buffer-name)))
     ;; (bxr echo \(buffer-name\) (buffer-name))
     ;; (bp xargs echo \(buffer-name\) (buffer-name)) ; Does not appear to work
(defmacro bx-right (&rest body)
  "Evaluate the last argument and use as the last argument to shell script. Use the last lisp argument as the final argument to the preceding bash command."
  `(sh-notty (concat (quote-args ,@(butlast body)) " " (q (str ,@(last body))))))
(defalias 'bxr 'bx-right)
(defalias 'bl 'bx-right)

     ;; (bpq cat "hi")
     ;; (bpq cat && false "hi")
     ;; (eq (bpq cat "hi") 0)
     ;; (defmacro bpe (&rest body)
     ;;   "Pipe string into bash command. Return exit code."
     ;;   ;; Remove the last element from a list
     ;;   `(let ((exit_code))
     ;;      (sh-notty (concat (quote-args ,@(butlast body))) ,@(last body) nil 'exit_code)
     ;;      (string-to-int exit_code)))

     ;; (if (bpq cat "hi") "yo")
     ;; (if (bpq cat && false "hi") "yo")
     ;; (bpq grep -q my-revert (sh/cat "/home/shane/var/smulliga/source/git/config/emacs/config/my-utils.el"))
(defmacro bpq (&rest body)
  "Pipe string into bash command. Return exit code."
  `(eq (bpe ,@body) 0))

     ;; (sh-notty (quote-args (add-to-list 'mylist "test")))

(defun wrl_q ()
  "Quote each line -force."
  ;; (cfilter "q -ftln")
  (interactive)
  (filter-selection 'qftln))

(defun wrl_uq ()
  "Unquote each line."
  (interactive)
  (cfilter "uq -ftln"))

(defun wrl_qne ()
  "Escape each line as if quoting, but do not make surrounding quotes."
  (interactive)
  (cfilter "qne -ftln"))

(defun cssbeautify ()
  (interactive)
  (cfilter "cssbeautify"))

(defun erase-bad-whitespace ()
  (interactive)
  (cfilter "erase-trailing-whitespace"))

     ;; (message (sed "s/a/b/g" "aaaa"))

(defun sed (command stdin)
  "wrapper around sed"
  (interactive)
  (setq stdin (str stdin))

  ;; (s-replace-regexp "\\(.\\)" "\\1 " ,kb)

  (setq command (concat "sed '" (str command) "'"))
  (sh-notty command stdin)

  ;; (bp sed)
  )

     ;; (sed-p "x" "hello")
     ;; (re-sed-p "h" "hello")
     ;; (if (re-sed-p "h" "hello") (message "true"))

     ;; (tvipe (re-sed-f "defun" (sh/cat (buffer-name))))


     ;; I should probably be escaping the pattern here, for sed
     ;; $HOME/notes2018/ws/sed/links.org

     ;; I should also make functions that do all the other varieties of regex

(defun sed-s (pattern input)
  "sed substitute."
  (eval `(bp sed ,(concat "s/" pattern "/") ,input)))

(defun sed-b (pattern input)
  "sed blacklist."
  (eval `(bp sed ,(concat "/" pattern "/d") ,input)))
(defalias 're-sed-f-blacklist 'sed-b)

(defun sed-w (pattern input)
  "sed whitelist."
  (eval `(bp sed -n ,(concat "/" pattern "/p") ,input)))
(defalias 're-sed-f 'sed-w)

(defun sed-p (pattern input)
  "sed regex match predicate."
  (not (string-empty-p
        (eval `(bp sed -n ,(s+ "/" pattern "/p") ,input)))))
(defalias 're-sed-p 'sed-p)

     ;; (less (my/list-of-packages))
     ;; (less (xxd (aes (org-babel-temp-file "sh-script-"))))
(defun less (input)
  (sh "tless -r" input nil nil "sh" t "spv"))
(defalias 'tless 'less)

     ;; (chomp (vime "strftime(\"%c\")"))
(defun vime (input)
  (sh-notty "vime" input))

(defun xxd-spv (input)
  (sh "xxd -g1 | tless" input nil nil "sh" t "spv"))
(defalias 'xxd-less 'xxd-spv)

(defun aes (input)
  ;; This is dodgy. -nopad and -nosalt make it dodgy. Never use in production
  (sh-notty "openssl aes-128-cbc -K 61 -e -iv 61 -nopad -nosalt" input))

(defun xxd (input)
  (sh-notty "xxd -g1" input))

     ;; (bs "y\\" "y")
     ;; (bs "y\\")

(defun sh/bs (input &optional chars)
  (if (not chars)
      (setq chars "\\"))
  (sh-notty (concat "bs " (q chars)) input))

;; sh-notty strips ansi
(defun hls (input pattern)
  (sh (concat "hls -r " pattern) input t))

     ;; filters

     ;; I want this to chomp its output ONLY if there was no newline to begin with. Do not change the udl script. It needs to force a newline
     ;; This is a 100% useless function. I shouldn't even care about it.
(defun udl (input)
  (sh-notty "udl | s chomp" input))

(defun sh/cat (input)
  "This is useful as a sponge sometimes. I honestly don't know why fzf doesn't like being passed to filter-selection."
  (sh "cat" input t))

(defun wc (input &optional type)
  (erase-surrounding-whitespace
   (single-space-whitespace
    (chomp
     (sh-notty (concat "wc" (if type (concat " -" (str type)))) input)))))

(defun aes-xxd (input)
  (sh "openssl aes-128-cbc -K 61 -e -iv 61 -nopad -nosalt | tless" input nil nil "sh" t "spv"))

(defun vim (path)
  (sh (concat "vim " (q (concat path))) nil nil nil "sh" t "sph"))

     ;; wd of current buffer
     ;; (defvaralias 'e/_pwd 'default-directory)
(defvaralias '_pwd 'default-directory)

(defun e/pwd ()
  "Returns the current directory."
  default-directory)

(defun sh/pwd ()
  "Returns the current directory."
  default-directory)

(defun u/pwd ()
  "Returns the current directory."
  default-directory)

(defalias 'current-dir-name 'e/pwd)
(defalias 'current-dirname 'e/pwd)
(defalias 'current-directory 'e/pwd)

     ;; But I want functions so I can use them with 'apply'
     ;; ,@',body is the command passed in to defshellfilter. e.g. expands to ,@'(cat)
     ;; ,@body doesn't expand beyond ,@body
(defmacro defshellfilter (&rest body)
  "Define a new string filter function based on a shell command"
  (let* (;; (s (str2sym (concat "sh/" (sym2str (first body)))))
         (base (slugify (list2string body) t))
         (sm (str2sym (concat "sh/m/" base)))
         (sf (str2sym (concat "sh/" base)))
         (sfptw (str2sym (concat "sh/ptw/" base))))
    `(progn (defmacro ,sm
                (&rest body)
              `(bp ,@',body ,@body))
            (defun ,sf
                (&rest body)
              (eval `(bp ,@',body ,@body)))
            ;; This last one is the thing the function returns.
            (defun ,sfptw
                (&rest body)
              ;; (eval `(ptw ',',sf (quote-args ,@body)))
              (eval `(ptw ',',sf ,@body))))))

     ;; Without nested backquote
     ;; (defmacro defshellfilter (&rest body)
     ;;   `(defmacro ,(intern (concat "sh/" (symbol-name (first body))))
     ;;        (&rest inner-body)
     ;;      ,`(cons 'bp (append ',body 'body))))

(defmacro defshellfilter-new-buffer-mode (mode &rest body)
  (let* (;; (s (str2sym (concat "sh/" (sym2str (first body)))))
         (base (slugify (list2string body) t))
         (sf (str2sym (concat "sh/" base)))
         (sf-nb (str2sym (concat "sh/nb/" base)))
         ;; (sfptw-nb (str2sym (concat "sh/ptw/nb/" base)))
         )
    `(progn
       (defshellfilter ,@body)
       ;; ,sfptw-nb
       (defun ,sf-nb (s)
         (new-buffer-from-string (eval `(,',sf ,s)) nil ,mode)
         ;; Don't use ptw because we are creating a new buffer
         ;; (new-buffer-from-string-detect-lang (eval `(ptw ',',sf ,s)))
         ;; Return what was entered
         s))))
(defmacro defshellfilter-new-buffer (&rest body)
  (let* (;; (s (str2sym (concat "sh/" (sym2str (first body)))))
         (base (slugify (list2string body) t))
         (sf (str2sym (concat "sh/" base)))
         (sf-nb (str2sym (concat "sh/nb/" base)))
         ;; (sfptw-nb (str2sym (concat "sh/ptw/nb/" base)))
         )
    `(progn
       (defshellfilter ,@body)
       ;; ,sfptw-nb
       (defun ,sf-nb (s)
         (new-buffer-from-string-detect-lang (eval `(,',sf ,s)))
         ;; Don't use ptw because we are creating a new buffer
         ;; (new-buffer-from-string-detect-lang (eval `(ptw ',',sf ,s)))
         ;; Return what was entered
         s))))

(defmacro defshellfilter-new-buffer-cmd (cmd ext)
  (let* ((base (slugify (list2string cmd) t))
         (sf (str2sym (concat "sh/" base)))
         (sfptw-nb (str2sym (concat "sh/ptw/nb/" base))))
    `(progn
       (defshellfilter ,@body)
       (defun ,sfptw-nb (s)
         (new-buffer-from-string (eval `(ptw ',',sf ,s)))
         ;; Return what was entered
         s))))

(defmacro defshellcommand (&rest body)
  "Define a new string output function based on a shell command"
  (let (;; (s (str2sym (concat "sh/" (sym2str (first body)))))
        (sm (str2sym (concat "sh/m/" (slugify (list2string body) t))))
        (sf (str2sym (concat "sh/" (slugify (list2string body) t)))))
    `(progn (defmacro ,sm
                (&rest body)
              `(b ,@',body ,@body))
            (defun ,sf
                (&rest body)
              (eval `(b ,@',body ,@body))))))

(defmacro defshellinteractive (&rest body)
  (let ((sf (str2sym (concat "sh/t/" (slugify (list2string body) t))))
        (sfhist (str2sym (concat "sh/t/" (slugify (list2string body) t) "-history")))
        (cmd (mapconcat 'str body " ")))
    `(defun ,sf (args)
       (interactive (list (read-string "args:" "" ',sfhist)))
       ;; (eval `(term-nsfa (concat ,,cmd " " ,args)))
       (eval `(sph (concat ,,cmd " " ,args))))))

(defshellinteractive gist-search)


;; (defshellcommand xurls)
;; (defshellcommand xurls 1 2 3)
(defshellcommand seq)
(defshellcommand pwgen)

     ;; (e/chomp (sh/pwgen 10))

     ;; This uses the pwgen command with the first parameter set to 5
     ;; Therefore it generates lists of passwords 5 chars long

(defshellcommand pwgen 5)
     ;; (e/chomp (sh/pwgen-5 10))

     ;; Xurls is a binary that gets urls out of text
(defshellfilter uniqnosort)
(defshellfilter urlencode)
(defshellfilter head)
(defshellfilter head -n 5)

(defshellfilter xurls)
;; (defalias 'xurls 'sh/xurls)

(defshellfilter cat)
(defshellfilter c uc)
     ;; (defshellfilter xurls)

(defmacro e/seq (from &rest body)
  "Same semantics as unix seq. Returns a list of integers."
  (cond ((eq (length body) 0) from)
        ((eq (length body) 1) `(number-sequence ,from ,@body))
        ((eq (length body) 2) `(number-sequence ,from ,(second body) ,(first body)))
        ;; ((eq (length body) 2) (second body))
        (t (error (concat "bad parameters: " (str (cons from body)))))))

(defmacro sh/seq-to-list (&rest body)
  `(mapcar 'string-to-int (str2list (e/chomp (b seq ,@body)))))
     ;; (seq 1 10)

     ;; (defalias 'seq 'sh/seq)
(defalias 'seq 'e/seq)

(defmacro s/cd (dir &rest body)
  "cd for current buffer then return after body is executed."
  (setq dir (umn dir))
  (sh-notty (concat "mkdir -p " (e/q dir)))
  `(progn (cd ,dir) ,@body (cd ,_pwd)))

     ;; (defun s/cd (path)
     ;;   (setq path (umn path))
     ;;   (cd path))

     ;; Rewrite this using keyword arguments and is it as a guide on how to implement sh//
     ;; (defun sh/cut (command stdin)
     ;;   "Wrapper around cut"
     ;;   (interactive)
     ;;   (setq stdin
     ;;         (format "%s" stdin))
     ;;   (setq command
     ;;         (concat "cut "
     ;;                 (format "%s" command)))
     ;;   (sh-notty command stdin))

     ;; (cut "about : time" :d ":" :f "2")
(cl-defun sh/cut (stdin &key d &key f)
  (if (not d)
      (setq d " "))

  (if (not f)
      (setq f "1"))
  (sh-notty (concat "cut -d " (q d) " -f " (q f) " 2>/dev/null") stdin))
(defalias 'cut 'sh/cut)

(defun sh/u-rm-dirsuffix (nl-paths)
  "Ensures directories and only directories (excluding symbolic links) show a slash at the end."
  (sh-notty "u rmdirsuffix " nl-paths))
(defalias 'rmds 'sh/u-rm-dirsuffix)

     ;; Force dirname suffix
(defun sh/u-dirsuffix (nl-paths)
  "Ensures directories and only directories (excluding symbolic links) show a slash at the end."
  (sh-notty "u dirsuffix " nl-paths))
     ;; I want ds to be like base 'ds'. ie. save to variable and return same values
     ;; (defalias 'ds 'sh/u-dirsuffix)

(defun sh/u-dirname (nl-paths)
  "For directory paths, returns unchanged. For paths, returns the path of the directory they are in."
  (e/chomp (sh-notty "u dirname " nl-paths)))
(defalias 'cast-dirname 'sh/u-dirname)
(defalias 'u/dn 'sh/u-dirname)
(defalias 'c/dn 'sh/u-dirname)

(cl-defun sh/rsync (src &optional dest)
  (if (not dest)
      (setq dest "")
    (sh-notty (concat "rsync -rtlphx " (q (sh/u-dirsuffix src)) (q (sh/u-rmdirsuffix dest))))))
(defalias 'sh/rs 'sh/rsync)

(defun sh/get-shebang (path)
  (sh-notty (concat "get-shebang " (q path) " | s chomp 2>/dev/null")))
(defalias 'get-shebang 'sh/get-shebang)

(defun sh/repeat-string (times string)
  (sh-notty (concat "s rs " (q (str times))) string))
(defalias 'sh/rps 'sh/repeat-string)

(defun sh/grep (pattern input &optional options)
  (sh-notty (concat "grep " options " " (q pattern) " 2>/dev/null") input))

(defun sh/glob-grep (pattern input)
  (sh-notty (concat "glob-grep " (q pattern) " 2>/dev/null") input))

(defun curl (url)
  (sh-notty (concat "curl " (q url) " 2>/dev/null")))

(defun rb (command)
  (sh-notty (concat "rb " (q command) " 2>/dev/null")))

(defun glob (pattern &optional dir)
  (str2list (cl-sn (concat "glob -b " (q pattern) " 2>/dev/null") :stdin nil :dir (umn dir) :chomp t)))

(defmacro globm (&rest pattern)
  `(b glob -b ,@pattern 2>/dev/null))

(defun ca (pattern &optional dir)
  (sh-notty (concat "ca " (q pattern) " 2>/dev/null") nil (umn dir)))

(defmacro bds (stdin &rest body)
  "Save to named file on disk. (ds value key)"
  `(bp ds ,@body ,stdin))
(defalias 'ds 'bds)

(defmacro jq (stdin &rest body)
  "Save to named file on disk."
  `(bp jq ,@body ,stdin))

(defun bgs (name)
  "Get value back from named file."
  (bl gs name))
(defalias 'gs 'bgs)

(defun s/awk1 (s)
  (sh-notty "awk 1" s))
(defun s/cat-awk1 (path &optional dir)
  (setq path (umn path))
  (sh-notty (concat "cat " (q path) " | awk 1" " 2>/dev/null") nil dir))
(defun e/cat (path)
  "Return the contents of FILENAME."
  (with-temp-buffer
    (insert-file-contents path)
    (buffer-string)))
(defun s/cat (path &optional dir)
  "cat out a file"
  (setq path (umn path))
  (sh-notty (concat "cat " (q path) " 2>/dev/null") nil dir))

(defun s/sort (path &optional dir)
  "sort out a file"
  (setq path (umn path))
  (sh-notty (consort "sort " (q path) " 2>/dev/null") nil dir))
(defalias 'sh/cat 's/cat)
(defalias 'sh/cat-file 's/cat)
(defalias 'sh/cat-awk1 's/cat-awk1)
(defalias 'sh/awk1 's/awk1)
(defalias 'cat-file 's/cat)
(defalias 'cat-awk1 's/cat-awk1)
(defalias 'awk1 's/awk1)
(defalias 'cat 's/cat)

(defun /bn (path &optional dir)
  (sh-notty (concat "basename " (q path) " 2>/dev/null | s chomp") nil dir))
(defalias 's/bn '/bn)

     ;; This is for eshell/basename
(require 'eshell)
(defalias 'basename 'eshell/basename)

(defun /dn (path &optional dir)
  (sh-notty (concat "dirname " (q path) " 2>/dev/null | s chomp") nil dir))

(defun udn (paths &optional dir)
  (sh-notty (concat "u dn | s chomp") paths dir))

(defun e/dn (paths &optional dir)
  ;; use mapconcat
  ;; for each line in the string, perform some emacs operation on it
  ;; First split by line

  ;; (split-string paths "\n")
  ;; (cl-loop for i in (split-string paths "\n") collect i)
  (mapcar (lambda (path) (file-name-directory path)) (split-string paths "\n"))
  ;; (e/chomp (sh-notty (concat "u dn") paths dir))
  )
(defalias 'dn 'e/dn)
     ;; example
     ;; (e/dn (glob "/*"))

     ;; (split-string (glob "/*") "\n")

(defun /rp (path &optional dir)
  (sh-notty (concat "realpath " (q path) " 2>/dev/null | s chomp") nil dir))
(defalias 's/rp '/rp)

(defun /ext (path)
  (sh-notty (concat "ext " (q path) " 2>/dev/null | s chomp")))

(defun /mant (path)
  (sh-notty (concat "mant " (q path) " 2>/dev/null | s chomp")))

(defun /mkdir-p (path)
  (sh-notty (concat "mkdir -p " (q path))))
(defalias 's/mkdir-p '/mkdir-p)
(defalias 'mkdir-p '/mkdir-p)

(defun sh/git-hash (stdin)
  (sh-notty "git hash-object -w --stdin | s chomp" stdin))
(defalias 'git-hash 'sh/git-hash)

(defun sh/format-json (stdin)
  "Formats the json."
  (sh-notty "python -m json.tool" stdin))

(defun string-head (s)
  (car (split-string s "\n")))

;; (b) doesnt work with this. is there an 'sh' version of 'b'?
(defun clipboard-to-string ()
  "docstring"
  (interactive)
  (b-tty clipboard-to-string))
(defalias 'clip2str 'clipboard-to-string)

(defun clipboard-to-file ()
  "docstring"
  (interactive)
  (b-tty clipboard-to-file))
(defalias 'clip2file 'clipboard-to-file)

(defun open-in-vscode ()
  "Opens vscode in current window for buffer contents"
  (interactive)
  ;; (sh-notty (concat "vo " (q (buffer-file-path))) nil (cwd) nil t)
  (tmux-edit "vsc" "nw"))

(defun nsfa (cmd &optional dir)
  (sh-notty (concat "export TTY=; "
                    (if dir (concat " CWD=" (q dir) " ")
                      "")
                    " nsfa -E " (q cmd)) nil (or dir (cwd))))

(defun term-nsfa (cmd &optional input modename closeframe buffer-name dir)
  "Like term but can run a shell command."
  (interactive (list (read-string "cmd:")))
  (if input
      (let ((tf (make-temp-file "term-nsfa" nil nil input)))
        (my/term (message (nsfa (message (concat "( " cmd " ) < " (q tf))) dir)) closeframe modename buffer-name))
    (my/term (nsfa cmd dir) closeframe modename buffer-name)))

;; The 't alias broke things
;; (defalias 't 'term-nsfa)

(defun tmuxify-cmd (cmd)
  (concat "t new " (q (concat "TTY= " cmd))))

(defun term-nsfa-tm (cmd &optional input)
  "Like term but can run a shell command."
  (if input
      (let ((tf (make-temp-file "term-nsfa" nil nil input)))
        (term (message (nsfa (message (concat "( " cmd " ) < " (q tf)))))))
    (term (nsfa (tmuxify-cmd cmd)))))

;; (term-nsfa "v" "hi")
;; (term-nsfa "v")

(defun open-in-vim-in-term ()
  "Opens v in current window for buffer contents"
  (interactive)
  ;; (tmux-edit) is able to pipe a region into a tmux split pane
  ;; term-mode can't do that. I haven't implemented that ability yet.
  ;; (save-buffer) does not do what I want.
  ;; I should implement that ability though.
  (let ((line-and-col (cc "+" (line-number-at-pos) ":" (current-column))))
    (if (and buffer-file-name (not (string-match "\\[*Org Src" (buffer-name))))
        (term-nsfa (concat "vs -c \"set ls=0\" " line-and-col " " (q (buffer-file-path))))
      (term-nsfa (concat "vs -c \"set ls=0\" " line-and-col) (buffer-contents)))))
(defalias 'e/open-in-vim 'open-in-vim-in-term)

(defun new-project-dir (name)
  (interactive (list (read-string-hist "Project name: ")))
  (cl-sn (concat "new-project " (q name)) :chomp t))

(defun new-project (name ext)
  "Create a new project in my git directory"
  (interactive (let* ((project-name (read-string-hist "Project name: "))
                      (ext (if (not (f-directory-p (concat "/home/shane/source/git/mullikine/" (slugify project-name))))
                               (read-string-hist "Project ext: "))))
                 (list project-name ext)))
  ;; (find-file (chomp (eval `(b new-project ,(slugify name)))))
  (find-file (cl-sn (concat "new-project "
                            (q name)
                            " "
                            (q ext)) :chomp t)))

(defun show-extensions-below ()
  (interactive)
  (term-nsfa "show-extensions-below | xsv table | vs"))

(defun recent-project ()
  (interactive)
  (term-nsfa "hsqf new-project"))

(defun recent-playground ()
  (interactive)
  ;; (term-nsfa "hsqf pg")
  (nw "hsqf pg"))

(defun recent-git ()
  (interactive)
  ;; (nw "hsqf git")
  (eshell-run-command (fz (mnm (sh-notty "hsqc git")))))

(defun recent-hsq ()
  (interactive)
  ;; (nw "hsqf git")
  (eshell-run-command (fz (mnm (sh-notty "hsqc hsqc")))))


(defun fun (path)
  (interactive (list (read-string "path:")))
  "docstring"

  (if (string-empty-p path) (setq path "defaultval"))

  (let ((result (e/chomp (sh-notty (concat "ci yt-list-playlist-urls " (e/q path))))))
    (if (called-interactively-p 'any)
        ;; (message result)
        (new-buffer-from-string result)
      result)))


(defun eww-fz-history ()
  (interactive)
  (if (>= (prefix-numeric-value current-prefix-arg) 4)
      (he "eww-display-html")
    (let ((url (fz
                (bp uniqnosort (sed "s/^.*cache://" 
                                    (cl-sn "uq -l | tac" :stdin (lines2str (hg "eww-display-html"))
                                           ;; (sed "s/^.*cache://" (lines2str (hg "eww-display-html")))
                                           :chomp t)))
                nil
                nil
                "eww history: ")))
      (if url
          (my/eww url)))))


(provide 'my-nix)
