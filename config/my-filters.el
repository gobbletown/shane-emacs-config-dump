(require 'my-utils)

;; cfilter is not a nice function. I should be using something a little purer
(_ns cfilters
     (defun lingo-extract-clql-from-yaml ()
       "Gets everything that's between a pair of backticks."
       (interactive)
       (cfilter "extract-yaml-from-clql")))

;; (_ns string-filters)
(defalias 'my/url-unhex-string 'url-unhex-string)

;; '(less (sh (concat "hls -i -f " (q "blue") " -b " (q "black") " " (q "clojure") " 2>/dev/null") "clojure" t))
;; (less (s/hls "clojure" "clojure"))
(defun s/hls (string stdin &optional fg bg)
  (if (not fg)
      (setq fg "orange"))

  (if (not bg)
      (setq bg "dgrey"))

  (sh (concat "hls -i -f " (q fg) " -b " (q bg) " " (q string) " 2>/dev/null") stdin t)
  ;; (sh-notty (concat "hls -i -f " (q fg) " -b " (q bg) " " (q string) " 2>/dev/null") stdin)
  )

(defun e/string-reverse (str)
  "Reverse the str where str is a string"
  (apply #'string
         (reverse
          (string-to-list str))))

;; This is like (q)
;; I use apply concat so that I don't have to place concat inside of q
(defun e/escape-string (&rest strings)
  (let ((print-escape-newlines t))
    (s-join " " (mapcar 'prin1-to-string strings))))
(defalias 'e/q 'e/escape-string)
(defalias 'q 'e/escape-string)     ; This is now the default
;; consider s/q

(defun e/qne (string)
  "Like e/q but without the end quotes"
  (pcre-replace-string "\"(.*)\"" "\\1" (e/q string)))
(defalias 'qne 'e/qne)

(defun s/bin2ascii (stdin)
  "Summarizes the given text."
  ;; (mapcar 'insert (car kill-ring))
  (interactive)
  (sh-notty "uuencode -" stdin))

;; TODO write this function in both pure emacs lisp and shell-emacs-lisp
;; (defun preserve-trailing-whitespace (sin sout)
;;   "Ensures that the same number of line endings appear at the end of the string as what went in. aka. unchomp"
;;   (sh-notty (concat "ptw <(p " (e/q s) ")") s)
;;   )

;; emacs lisp should provide threading
;; using a macro to create this syntax is nice in a way -- rackety perhaps -- but it's-old not very lispy
;; (defmacro preserve-trailing-whitespace (&rest body)
;;   "Run a string command, but preserve the amount of trailing whitespace. (ptw (awk1 \"hi\"))"
;;   )
(defun s-preserve-trailing-whitespace (s-new s-old)
  "Return s-new but with the same amount of trailing whitespace as s-old."
  (let* ((trailing_ws_pat "[ \t\n]*\\'")
         (original_whitespace (regex-match-string trailing_ws_pat s-old))
         (new_result (concat (replace-regexp-in-string trailing_ws_pat "" s-new) original_whitespace)))
    new_result))

(defun preserve-trailing-whitespace (fun s)
  "Run a string filter command, but preserve the amount of trailing whitespace. (ptw 'awk1 \"hi\")"

  (s-preserve-trailing-whitespace (apply fun (list s)) s)
  ;; (setq trailing_ws_pat "[ \t\n]*\\'")

  ;; (let* ((original_whitespace (regex-match-string trailing_ws_pat s))
  ;;        (result (apply fun (list s)))
  ;;        (new_result (concat (replace-regexp-in-string trailing_ws_pat "" result) original_whitespace)))
  ;;   new_result)
  )
(defalias 'ptw 'preserve-trailing-whitespace)

(defun filter-selected-region-through-macrostring (macrostring)
  "(filter-selected-region-through-macrostring \"bp xurls\")"
  ;; (filter-selected-region-through-function (lambda (s) (my-eval-string (concat "(" macrostring " s)"))))
  (eval `(filter-selected-region-through-function (hsr "filter-selected-region-through-macrostring" (lambda (s) (my-eval-string (concat "(" ,macrostring " s)")))))))

(defun filter-selected-region-through-function (fun)
  ;; (if (selected))
  (let* ((start (if (selected) (region-beginning) (point-min)))
         (end (if (selected) (region-end) (point-max)))
         (doreverse (and (selected) (< (point) (mark))))
         (removed (delete-and-extract-region start end))
         ;; (replacement (str (funcall fun (str removed))))
         (replacement (str (ptw fun (str removed))))
         (replacement-len (length (str replacement))))
    (if buffer-read-only (new-buffer-from-string replacement)
      (progn
        (insert replacement)
        (let ((end-point (point))
              (start-point (- (point) replacement-len)))
          (push-mark start-point)
          (goto-char end-point)
          (setq deactivate-mark nil)
          (activate-mark)
          (if doreverse
              (call-interactively 'cua-exchange-point-and-mark)))))
  ;; (error "select something first!")
    ))
(defalias 'filter-selection 'filter-selected-region-through-function)

;; filter-buffer-substring was the wrong way to go about filtering the marked region. It doesn't replace anything
;; (let ((filter-buffer-substring-function (lambda (beg end &optional delete)
;;                                           (q (buffer-substring beg end)))))
;;   (filter-buffer-substring (region-beginning) (region-end) t))

;; (defun cua--filter-buffer-noprops (start end)
;;   (let ((str (filter-buffer-substring start end)))
;;     (set-text-properties 0 (length str) nil str)
;;     str))

(defun f-irc (string)
  "Filters string through irc."
  (sh-notty "f-irc" string))

(defun s/chomp (string)
  "Chomps a string."
  (sh-notty "s chomp" string))
(defalias 'my/chomp 's/chomp)

(defun e/chomp-end (str)
  "Chomp tailing whitespace from STR."
  (replace-regexp-in-string (rx (* (any " \t\n")) eos)
                            ""
                            str))

(defun rx/chomp (str)
  "Chomp leading and tailing whitespace from STR."
  (replace-regexp-in-string (rx (or (: bos (* (any " \t\n")))
                                    (: (* (any " \t\n")) eos)))
                            ""
                            str))

;; (tvipe (fzf (scriptnames-list)))
;; (tvipe (fzf (scriptnames-list) "input"))
;; (tvipe (fzf (s-lines (mnm (scriptnames-string)))))
;; (fz '(a b c d) nil t "yo:")
(defun fz (list &optional input b_full-frame prompt must-match select-only-match add-props)
  ;; (helm-build-sync-source "test"
  ;;   :candidates (scriptnames-list))
  ;; Sources is a list of lists?
  ;; '((scriptnames-list))

  ;; select-only-match appears to not work if there is a newline
  ;; this is because 'empty' is also a selectable option

  ;; (helm :sources (helm-build-sync-source "-"
  ;;                  :candidates list)
  ;;       :input input
  ;;       :prompt prompt
  ;;       :full-frame b_full-frame
  ;;       :candidate-number-limit nil
  ;;       ;; :candidate-number-limit 500
  ;;       :buffer "*fzf*")
  (cl-fz list :initial-input input :full-frame b_full-frame :prompt prompt :must-match must-match :select-only-match select-only-match :add-props add-props))
;; (fz '(a b c d) "" t "yo:")
(defalias 'fzh 'fz)

(defun fzsh (c &optional cacheit)
  "fz a shell function, keeping track of history"
  (interactive (list (read-string-hist "fzsh cmd: ")
                     t))

  (let* ((slug (slugify c))
         (sel (fz (str2list (snc (if cacheit
                                     (concat "oci " c)
                                   c)))
                  nil nil (concat slug ": "))))
    (if (interactive-p)
        (xc sel)
      sel)))

;; (defun fz-must-match (list &optional prompt)
;;   (setq prompt (or prompt ":"))
;;   (completing-read prompt list nil t))

;; (defun fz-default-return-query (list &optional prompt)
;;   (setq prompt (or prompt ":"))
;;   (completing-read prompt list nil 'confirm))

(defun fz-completion-second-of-tuple-annotation-function (s)
  (let ((item (assoc s minibuffer-completion-table)))
    (when item
      ;; (concat " # " (second item))
      (cond
       ((listp item) (concat " # " (second item)))
       ((stringp item) "")
       (t "")))))

;; This is very useful
(cl-defun cl-fz (list &key prompt &key full-frame &key initial-input &key must-match &key select-only-match &key hist-var &key add-props)
          (if (and (not hist-var)
                   (sor prompt))
              (setq hist-var (str2sym (concat "histvar-fz-" (slugify prompt))))
              ;; It may already exist, so don't use defset
              ;; (eval
              ;;  (expand-macro
              ;;   `(defvar ,(str2sym (concat "histvar-fz-" (slugify prompt))) nil)))
              )

          (setq prompt (sor prompt ":"))

          (if (not (re-match-p " $" prompt))
              (setq prompt (concat prompt " ")))

          (if (eq (type list) 'symbol)
              (cond
                ((variable-p 'clojure-mode-funcs) (setq list (eval list)))
                ((function-p 'clojure-mode-funcs) (setq list (funcall list)))))

          (if (stringp list)
              (setq list (string2list list)))

          (if (and select-only-match (eq (length list) 1))
              (car list)
              (progn
                (setq prompt (or prompt ":"))
                (let ((helm-full-frame full-frame)
                      (completion-extra-properties nil))

                  (if add-props
                      (setq completion-extra-properties
                            (append
                             completion-extra-properties
                             add-props)))

                  (if (and (listp (car list)))
                      (setq completion-extra-properties
                            (append
                             '(:annotation-function fz-completion-second-of-tuple-annotation-function)
                             completion-extra-properties)))

                  ;; (etv completion-extra-properties)
                  (completing-read prompt list nil must-match initial-input hist-var)
                  ;; (helm-comp-read prompt list :must-match must-match :initial-input initial-input)
                  ))))
(defalias 'fz-new 'cl-fz)


;; (fz '(("a" "description of a") ("b" "b's description")))


;;
;; (defvar my-completions '(("a" "description of a") ("b" "b's description")))

;; ;; TODO Figure out how to fuzzy find through the annotations
;; (let ((completion-extra-properties '(:annotation-function fz-completion-second-of-tuple-annotation-function)))
;;   (completing-read "Prompt: " my-completions))



;; (fz-new '(a b c d) :must-match t :prompt "yo:" :full-frame t)

(cl-defun fz-default-return-query (list &key prompt &key full-frame &key initial-input)
  (fz-new list :prompt prompt :full-frame full-frame :initial-input initial-input))

(defun fz-default-return-query (list &optional prompt full-frame)
  (setq prompt (or prompt ":"))
  (let ((helm-full-frame full-frame))
    (helm-comp-read prompt list :must-match nil)))

;; Not sure what fzh was supposed to be
;; (defun fzh (list &optional input)
;;   ;; (helm-build-sync-source "test"
;;   ;;   :candidates (scriptnames-list))
;;   ;; Sources is a list of lists?
;;   ;; '((scriptnames-list))
;;   (if (stringp list) (setq list (split-string list "\n")))

;;   (helm :sources (helm-build-sync-source "-"
;;                    :candidates list)
;;         :input input
;;         ;; :candidate-number-limit 500
;;         :candidate-number-limit nil
;;         :buffer "*fzf*"))

;; (defun test-helm ()
;;   (interactive)
;;   (helm :sources (append helm-source-dictionary (list helm-source-dictionary-online))
;;         :full-frame t
;;         :candidate-number-limit 500
;;         :buffer "*helm dictionary*"))

(defun s/summarize (stdin)
  "Summarizes the given text."
  (interactive (list (my/selected-text)))
  (if (interactive-p)
      (etv (sh-notty "s summarize" stdin))
    (sh-notty "s summarize" stdin)))

(defun s/q (input)
  "Only quotes if it needs to"
  (interactive)
  (sh-notty "q" (str input)))
(defalias 'sh/q 's/q)

(defun q-eval (input)
  (interactive)
  (sh-notty "q-eval" (str input)))

(defun s/qf (input)
  "Always quote"
  (interactive)
  (sh-notty "q -f" (str input)))
(defalias 'sh/qf 's/qf)
(defalias 'qf 's/qf)


(defun sh/qne (input)
  "Quotes but removes the ends"
  (interactive)
  (sh-notty "qne" input))


(defun s-replace-regexp-thread (s1 s2 s3)
  (s-replace-regexp s1 s2 s3 t))

;; (->> "abc" (s-replace-regexp "\\(.\\)" "\\1 "))
(defmacro do-substitutions (str &rest tups)
  ""
  (let* (;; (srr ;; (lambda (s1 s2 s3) (s-replace-regexp s1 s3 s3 t))
         ;;      s-replace-regexp-thread)
         (newtups (mapcar (lambda (tup) (cons 's-replace-regexp-thread tup)) tups)))
    `(progn (->>
             ,str
             ,@newtups))))
(defalias 'seds 'do-substitutions)


(defun mnm (input)
  "Minimise string."
  ;; (sh-notty "mnm" input)
  (if input
      (seds (umn input)
            ("~/" "$HOME/")
            ("/home/shane/dump" "$DUMP")
            ("/home/shane/notes" "$NOTES")
            ("/home/shane/source/git/opensemanticsearch/open-semantic-search" "$OPENSEMS")
            ("/export/bulk/local-home/smulliga" "$BULK")
            ("/home/shane/var/smulliga/source/git/semiosis/prompts/prompts" "$PROMPTS")
            ("/home/shane/source/git/config/emacs" "$EMACSD")
            ("/home/shane/source/git/config/vim" "$VIMCONFIG")
            ("/home/shane" "$HOME")
            ("/home/shane/notes/programs/note/archive" "$FSNOTES")
            ("/home/shane/source/git" "$MYGIT")
            ("/home/shane/scripts" "$SCRIPTS")
            ("/home/shane/var/smulliga/source" "$BUILD")
            ("/home/shane/dump/logs" "$LOGDIR")

            ;; (xc (pps (mapcar
            ;;           (lambda (ts) (list (second ts) (car ts)))
            ;;           '(
            ;;             ("$DUMP" "/home/shane/dump")
            ;;             ("$NOTES" "/home/shane/notes")
            ;;             ("$OPENSEMS" "/home/shane/source/git/opensemanticsearch/open-semantic-search")
            ;;             ("$BULK" "/export/bulk/local-home/smulliga")
            ;;             ("$EMACSD" "/home/shane/source/git/config/emacs")
            ;;             ("$VIMCONFIG" "/home/shane/source/git/config/vim")
            ;;             ("$HOME" "/home/shane")
            ;;             ("$FSNOTES" "/home/shane/notes/programs/note/archive")
            ;;             ("$MYGIT" "/home/shane/source/git")
            ;;             ("$SCRIPTS" "/home/shane/scripts")
            ;;             ("$BUILD" "/home/shane/var/smulliga/source")
            ;;             ("$LOGDIR" "/home/shane/dump/logs")))))
            )))


;; (seds
;;  "abc"
;;  ("a" "A")
;;  ("c" "C"))


(defun umn (input)
  "Unminimise string."
  ;; (sh-notty "umn" input nil nil nil t)
  (if input
  (seds input
        ;; This breaks things like cfilter from using ~, such as surround '~' '~'
        ;; ("~" "/home/shane")
        ("~/" "/home/shane/")
        ("$DUMP" "/home/shane/dump")
        ("$NOTES" "/home/shane/notes")
        ("$OPENSEMS" "/home/shane/source/git/opensemanticsearch/open-semantic-search")
        ("$BULK" "/export/bulk/local-home/smulliga")
        ("$PROMPTS" "/home/shane/var/smulliga/source/git/semiosis/prompts/prompts")
        ("$EMACSD" "/home/shane/source/git/config/emacs")
        ("$VIMCONFIG" "/home/shane/source/git/config/vim")
        ("$HOME" "/home/shane")
        ("$FSNOTES" "/home/shane/notes/programs/note/archive")
        ("$MYGIT" "/home/shane/source/git")
        ("$SCRIPTS" "/home/shane/scripts")
        ("$BUILD" "/home/shane/var/smulliga/source")
        ("$LOGDIR" "/home/shane/dump/logs")))
  ;; b_umn must be t
  )
(defun uqftln (input)
  "Unquotes each line"
  (interactive)
  (sh-notty "uq -ftln" input))


(defun qftln (input)
  "Quotes each line"
  (interactive)
  (sh-notty "q -ftln" (str input)))

(defun uq (input)
  "Unquotes"
  (interactive)
  (cl-sn "uq" :stdin input :chomp t))

(defun strip-unicode (input)
  "Unquotes"
  (interactive)
  (sh-notty "c strip-unicode" input))
(defalias 's-u 'strip-unicode)

(defun erase-starting-whitespace (input)
  (sed "s/^\\s\\+//" input)
  ;; (sh-notty "sed 's/^\\s\\+//'" input)
  )

(defun single-space-whitespace (input)
  (sed "s/\\s\\+/ /g" input))

(defun erase-surrounding-whitespace (input)
  (erase-starting-whitespace (erase-end-whitespace input)))

(defun erase-end-whitespace (input)
  (sed "s/\\s\\+$//" input)
  ;; (sh-notty "sed 's/\\s\\+$//'" input)
  )
(defalias 'erase-free-whitespace 'erase-end-whitespace)


(defun fi-join (arg)
  "Indent by prefix arg"
  (interactive "P")
  ;; (message (str arg))
  ;; (ns (str arg))
  (progn (if (not arg) (setq arg ""))
         (cfilter (concat "s join " (str arg)))))


;; This breaks org-mode. So make a workaround
;; if (org-enabled)
(defun fi-indent (arg)
  "Indent by prefix arg"
  (interactive "P")
  ;; (ns (str arg))
  (progn (if (not arg) (setq arg 4))
         (cfilter (concat "indent " (str arg)))))

(defun fi-unindent (arg)
  "Indent by prefix arg"
  (interactive "P")
  ;; (ns (str arg))

  (progn
    (if (not arg) (setq arg 4))
    (cfilter (concat "indent -" (str arg)))))

(defun fi-org-indent (arg)
  "Indent by prefix arg"
  (interactive "P")
  ;; (ns (str arg))
  (cond
   ((and (equal major-mode 'org-mode)
         (string-match-p "^\*"
                         (if (selectionp)
                             (selection)
                           (thing-at-point 'line))))
    (cfilter "orgindent"))
   ((and (equal major-mode 'org-mode)
         (string-match-p "^ *-"
                         (if (selectionp)
                             (selection)
                           (thing-at-point 'line))))
    (cfilter (cmd "indent" "2")))
   (t (progn (if (not arg) (setq arg 4))
             (cfilter (concat "indent " (str arg)))))))

(defun fi-org-unindent (arg)
  "Indent by prefix arg"
  (interactive "P")
  ;; (ns (str arg))

  (cond
   ((and (equal major-mode 'org-mode)
         (not arg)
         (string-match-p "^\*"
                        (if (selectionp)
                            (selection)
                          (thing-at-point 'line))))
    (cfilter "orgindent -1"))
   ((and (equal major-mode 'org-mode)
         (not arg))
    (if (string-match-p "^ *-"
                        (if (selectionp)
                            (selection)
                          (thing-at-point 'line)))
        (cfilter "indent -2")
      (call-interactively #'org-run-babel-template-hydra)))
   (t (progn
        (if (not arg) (setq arg 4))
        (cfilter (concat "indent -" (str arg)))))))

(defun slugify (input &optional joinlines length)
  "Slugify input"
  (interactive)
  (let ((slug
         (if joinlines
             (sh-notty "tr '\n' - | slugify" input)
           (sh-notty "slugify" input))))
    (if length
        (substring slug 0 (- length 1))
      slug)))

(defun unslugify (input)
  (snc "unslugify" input))

(defmacro dsh (cmdstart)
  "Create elisp wrappers around shell commands"
  (let ((slug (str2sym (concat "sh/" (slugify cmdstart)))))
    `(defun ,slug (first &optional stdin)
       (sn (concat "sh -c " (q (concat ,cmdstart " " (if first (cmd first) "") " 2>/dev/null | cat"))) stdin
           ))))
(defalias 'dsn 'dsh)

;; Create some utilities
(loop for c in '("pb") do (eval `(dsh ,c)))

;; (dsh "echo -n hi")
;; (sh/echo-n-hi "yo")
;; (dsh "pb")
;; (xc (sh/pb "/home/shane/dump/tmp/scratchhZblwL.txt"))

(provide 'my-filters)