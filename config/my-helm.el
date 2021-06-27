(require 'helm)
(require 'my-utils)
(require 'helm-net)

;; I think this was breaking
(setq helm-mode-handle-completion-in-region nil)
;; Perhaps it was a new helm package I installed
;; * The problem is these have different arguments
;; j:helm--completion-in-region
;; j:completion-in-region


;; global fuzzy
(setq helm-mode-fuzzy-match t)
(setq helm-mode-fuzzy-match nil)
(setq helm-completion-in-region-fuzzy-match t)

;; individual fuzzy
(setq helm-recentf-fuzzy-match t)
(setq helm-buffers-fuzzy-matching t)
(setq helm-locate-fuzzy-match t)
(setq helm-M-x-fuzzy-match t)
(setq helm-semantic-fuzzy-match t)
(setq helm-imenu-fuzzy-match t)
(setq helm-apropos-fuzzy-match t)
(setq helm-lisp-fuzzy-completion t)

;; I don't think it's possible to exit helm with the minibuffer instead of the candidate
;; must-match is built into helm but how to get it to do what I want all the time?
;; Answer: you can't, nor want to.
;; v +/"(minibuffer-message \" \[No match\]\"))" "$EMACSD/packages27/helm-core-20190410.1357/helm.el"
;; Unfortunately, must-match can't be toggled from within helm, which means C-j can't be made to use the current minibuffer
;; How then, in helm, do I insist on using the empty string when there is a selection?
;; Or how do I ask helm to accept empty string on enter without erroring when there are no candidates?

(setq helm-use-frame-when-more-than-two-windows nil)

;; There is also this other keymap
(defvar helm-comp-read-map
  (let ((map (make-sparse-keymap)))
    (set-keymap-parent map helm-map)
    (define-key map (kbd "<C-return>") 'helm-cr-empty-string)
    (define-key map (kbd "<M-RET>") 'helm-cr-empty-string)
    (define-key map (kbd "M-k") 'ace-jump-helm-line)
    ;; (define-key map (kbd "C-c o")      'helm-copy-to-tvipe)
    map)
  "Keymap for `helm-comp-read'.")


;; this broke helm on exordium. Why did I put it here in the first?
;; place?
;; (defun helm-update (&optional preselect source candidates)
;;   "Update candidates list in `helm-buffer' based on `helm-pattern'.
;; Argument PRESELECT is a string or regexp used to move selection
;; to a particular place after finishing update.
;; When SOURCE is provided update mode-line for this source, otherwise
;; the current source will be used.
;; Argument CANDIDATES when provided is used to redisplay these candidates
;; without recomputing them, it should be a list of lists."
;;   (helm-log "Start updating")
;;   (helm-kill-async-processes)
;;   ;; When persistent action have been called
;;   ;; we have two windows even with `helm-full-frame'.
;;   ;; So go back to one window when updating if `helm-full-frame'
;;   ;; is non-`nil'.
;;   (when (with-helm-buffer
;;           (and helm-onewindow-p
;;                ;; We are not displaying helm-buffer in a frame and
;;                ;; helm-window is already displayed.
;;                (not helm--buffer-in-new-frame-p)
;;                (helm-window)
;;                (not (helm-action-window))))
;;     (with-helm-window (delete-other-windows)))
;;   (with-current-buffer (helm-buffer-get)
;;     (set (make-local-variable 'helm-input-local) helm-pattern)
;;     (unwind-protect
;;         (let (sources matches)
;;           ;; Collect sources ready to be updated.
;;           (setq sources
;;                 (cl-loop for src in (helm-get-sources)
;;                          when (helm-update-source-p src)
;;                          collect src))
;;           ;; When no sources to update erase buffer
;;           ;; to avoid duplication of header and candidates
;;           ;; when next chunk of update will arrive,
;;           ;; otherwise the buffer is erased AFTER [1] the results
;;           ;; are computed.
;;           (unless sources (erase-buffer))
;;           ;; Compute matches without rendering the sources.
;;           ;; This prevent the helm-buffer flickering when constantly
;;           ;; updating.
;;           (helm-log "Matches: %S"
;;                     (setq matches (or candidates (helm--collect-matches sources))))
;;           ;; If computing matches finished and is not interrupted
;;           ;; erase the helm-buffer and render results (Fix #1157).
;;           (when matches    ;; nil only when interrupted by helm-while-no-input.
;;             (erase-buffer) ; [1]
;;             (cl-loop for src in sources
;;                      for mtc in matches
;;                      do (helm-render-source src mtc))
;;             ;; Move to first line only when there is matches
;;             ;; to avoid cursor moving upside down (issue #1703).
;;             (helm--update-move-first-line)
;;             (helm--reset-update-flag)))
;;       ;; When there is only one async source, update mode-line and run
;;       ;; `helm-after-update-hook' in `helm-output-filter--post-process',
;;       ;; when there is more than one source, update mode-line and run
;;       ;; `helm-after-update-hook' now even if an async source is
;;       ;; present and running in BG.
;;       (let ((src (or source (helm-get-current-source))))
;;         (unless (assq 'candidates-process src)
;;           (and src (helm-display-mode-line src 'force))
;;           (helm-log-run-hook 'helm-after-update-hook)))
;;       (when preselect
;;         (helm-log "Update preselect candidate %s" preselect)
;;         (if (helm-window)
;;             (with-helm-window (helm-preselect preselect source))
;;           (helm-preselect preselect source)))
;;       (setq helm--force-updating-p nil))
;;     (helm-log "end update")))

;; Is there a better way of overriding the keybindings than redefining this?
;; Does this even work?

;; Unfortunately, helm doesn't appear to keep everything in memory
;; The most I've been able to get out of a helm and into tvipe is 500 lines
(defun helm-copy-to-tvipe ()
  "Copy selection or marked candidates to `helm-current-buffer'.
Note that the real values of candidates are copied and not the
display values."
  (interactive)

  ;; How do I get all helm candidates?

  ;; (tvipe (helm-candidates-in-buffer))
  ;; (tvipe (helm-get-candidates))
  ;; (tvipe (helm-marked-candidates :all-sources t))

  ;; (helm-mark-all t)
  ;; (helm-mark-all t)

  ;; Why does this not get everything?
  ;; (helm-mark-all-1 t)

  (tvd (list2str (helm-get-candidates (helm-get-current-source))))  

  ;; ;; This worked, for fz at least
  ;; (helm-mark-all t)
  ;; (tvipe (helm-marked-candidates-strings :all-sources t) :b-nowait t :b-quiet t)
  ;; ;; (tvipe (helm-marked-candidates))
  )

(defun helm-copy-to-fzf ()
  "Copy selection or marked candidates to `helm-current-buffer'.
Note that the real values of candidates are copied and not the
display values."
  (interactive)

  (fzf (list2str (helm-get-candidates (helm-get-current-source)))))

(defun helm-copy-to-tvipe-bak ()
  "Copy selection or marked candidates to `helm-current-buffer'.
Note that the real values of candidates are copied and not the
display values."
  (interactive)
  (with-helm-alive-p
    (helm-run-after-exit
     (lambda (cands)
       (tvipe (mapconcat (lambda (c)
                              (format "%s" c))
                            cands "\n")))
     (helm-marked-candidates))))

;; Use this to test helm
;; (fz (globm /*))

(defmacro helm-marked-candidates-strings (&rest body)
  ""
  ;;`(my/join (mapcar 'str (helm-marked-candidates ,@body)) , "\n")
  `(my/join (helm-marked-candidates ,@body) "\n")
  ;;`(mapcar 'str (helm-marked-candidates ,@body))
  )

;; (defun helm-marked-candidates-strings ()
;;   ;; it's a list of pairs
;;   (if (not delim) (setq delim "\n"))
;;   (mapconcat 'identity list-of-strings delim))


(defun helm-copy-selection-to-clipboard ()
  "Copy selection or marked candidates to `helm-current-buffer'.
Note that the real values of candidates are copied and not the
display values."
  (interactive)
  ;; (xc (my/join (helm-marked-candidates) "\n"))
  ;; the marked candidates might be "buffer names", not strings.
  ;; strange, but true.

  (my/copy (helm-marked-candidates-strings)))


;; M-s
(defun helm-fz-directory ()
  (interactive)
  (let ((sel (string-head (helm-marked-candidates-strings))))))


;; (define-key my/lisp-mode-map (kbd "F")
;;   (lm (ekm "f M-? f")))


;; Make bindings when I need them
;; It's like a demotion, form parent to child.
;; (define-key my/lisp-mode-map (kbd "M-N") 'my/lispy-unconvolute)
;; (define-key my/lisp-mode-map (kbd "M-N") nil)

;; It's like a promotion, from child to parent.
;; (define-key my/lisp-mode-map (kbd "M-P") 'paredit-convolute-sexp)
;; (define-key my/lisp-mode-map (kbd "M-P") nil)

(defun helm-copy-input ()
  (interactive)

  ;; (helm-mark-all-1 t)
  (xc (minibuffer-contents) t)
  ;; (my-copy (minibuffer-contents))
  )

(defun helm-copy-selections ()
  (interactive)

  ;; (helm-mark-all-1 t)
  (xc (chomp (sh/cut "-d ' ' -f 2" (tvipe (helm-marked-candidates :all-sources t))))))

;; The bindings are found here
;; vim +/"(defvar helm-map" $HOME$MYGIT/spacemacs/packages27/helm-core-20180314.947/helm.el

(define-key helm-comp-read-map (kbd "<M-RET>")      'helm-copy-to-tvipe)

(with-eval-after-load 'helm
  ;; This works for most helms
  ;; But does not appear to work when selecting buffer
  ;; There must be helm modes which this doesnt bind

  (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action)
  (define-key helm-map (kbd "C-z") 'helm-select-action)
  (define-key helm-map (kbd "M-c") #'helm-copy-selection-to-clipboard)
  ;; (define-key helm-map (kbd "M-s") #'helm-fz-directory)
  ;; (define-key helm-map (kbd "C-h") nil)
  ;; (define-key helm-map (kbd "M-e") (df helm-open-in-emacs (spv (concat "e " (umn (bp head -n 1 (helm-marked-candidates-strings)))))))
  (define-key helm-map (kbd "M-e") (df helm-open ;; (helm-keyboard-quit)
                                       (find-file (umn (bp head -n 1 (helm-marked-candidates-strings)))) ;; (helm-keyboard-quit) ;This works to quit helm, but when it quits, the buffer quits too; This is desirable behaviour
                                       ))
  (define-key helm-map (kbd "M-v") (df helm-open-in-vim (spv (concat "v " (umn (bp head -n 1 (helm-marked-candidates-strings)))))))
  (define-key helm-map (kbd "M-o") (df helm-open-in-sps (sps (concat "zrepl o " (umn (bp head -n 1 (helm-marked-candidates-strings)))))))
  (define-key helm-map (kbd "M-F") (df helm-open-in-fzf (sph (concat "ca " (umn (bp head -n 1 (helm-marked-candidates-strings))) " | fzf -P"))))

  ;; helm-help to do the same thing as helm documentation
  (define-key helm-map (kbd "C-c ?")    'helm-documentation)

  ;; This does not appear to work
  (define-key helm-map (kbd "C-c o")      'helm-copy-to-tvipe)
  (define-key helm-map (kbd "M-Y")      'helm-copy-input)
  (define-key helm-map (kbd "C-c f")      'helm-copy-to-fzf)
  (define-key helm-map (kbd "C-c z")      'helm-copy-to-tvipe)

  (define-key helm-map (kbd "M-y")      'helm-copy-selections))

;; (define-key map (kbd "C-c C-h f")    'describe-function)
;; (define-key map (kbd "C-c C-h b")    'describe-bindings)
;; (define-key map (kbd "C-c C-h m")    'describe-mode)


(defun send-m-del ()
  (interactive)
  (ekm "M-DEL"))

(define-key helm-map (kbd "M-D") #'send-m-del)
(define-key helm-find-files-map (kbd "M-D") #'send-m-del)

(define-key helm-map (kbd "C-h") nil)


;; (defun some-action (arg)
;;   (message-box "%s\n%s"
;;                (helm-get-selection)
;;                (helm-marked-candidates)))
;;
;; (defun default-action (candidate)
;;   (browse-url
;;    (format
;;     "http://www.google.com/search?q=%s" (url-hexify-string helm-pattern))))
;;
;; (defvar source1 '((name . "HELM")
;;                   (candidates . (1 2 3 4))
;;                   (action . (("open" . some-action)))))
;;
;; (defvar fallback-source '((name . "fallback")
;;                           (dummy)
;;                           (action . (("Google" . default-action)))))
;;
;; (helm :sources '(source1 fallback-source))

(defun my-helm-find-files ()
  "Like helm-find-files, but it ignores the thing at point"
  (interactive)

  (cd (get-dir))
  (let ((helm-find-files-ignore-thing-at-point t))
    (call-interactively 'helm-find-files)))

(require 'my-mode)
(define-key my-mode-map (kbd "M-m f r") 'helm-mini) ; recent
(define-key my-mode-map (kbd "M-m f R") 'sps-ranger)

;; (define-key my-mode-map (kbd "M-\"") 'my-helm-fzf)
;; This is reserved by prog-mode-map handle-debug
(define-key my-mode-map (kbd "M-\"") nil)
(define-key my-mode-map (kbd "M-m f z") 'my-helm-fzf)
(define-key my-mode-map (kbd "M-m f Z") 'my-helm-fzf-top)
(define-key my-mode-map (kbd "M-m f f") 'my-helm-find-files) ; It's a little different from spacemacs' one. Spacemacs uses C-h for up dir where this uses C-l.

;; I need to find out how to use (describe-mode 'helm) and
;; (describe-minor-mode 'helm).



(defun helm-exhaust-candidates (&optional source)
  (let ((buf (new-buffer-from-string "new buf"))
        (src (or source (helm-get-current-source))))
    (helm-candidates-in-buffer-1
     buf
     ""
     (or (assoc-default 'get-line src)
         #'buffer-substring-no-properties)
     (or (assoc-default 'search src)
         '(helm-candidates-in-buffer-search-default-fn))
     ;; (helm-candidate-number-limit src)
     10000000
     (helm-attr 'match-part)
     src)))


(defun helm-test-code ()
  (interactive)
  (if nil (progn
            ;; a list of alists.
            helm-sources
            ))

  ;; This is a closure sometimes
  ;; (assoc 'candidates (helm-get-current-source))

  ;; (my/copy (pp-to-string (helm-get-current-source)))
  ;; (tvipe (pp-to-string (get-text-property (point) 'helm-cur-source))
  ;; ;; (tvipe (pp-to-string helm-sources))
  ;; ;; (tvipe (pp-to-string helm-current-source))
  ;; ;; (tvipe (pp-to-string helm-sources))
  ;; ;; (tvipe (list2str helm-sources))
  ;; )
  ;; (tvipe (str (get-text-property (point) 'helm-cur-source))
  ;; (tvipe (pp-to-string (helm-get-current-source)))
  ;; (tvipe (pp-to-string (type (helm-get-current-source))))
  (tvd (list2str (helm-get-candidates (helm-get-current-source))))
  ;; (let ((cand (assoc 'candidates (helm-get-current-source))))
  ;;   ;; (tvd (pp-to-string (cl-loop for src in helm-sources collect (helm-get-candidates src))))
  ;;   (tvd (pp-to-string helm-sources))
  ;;   ;; (if (eq (second cand) 'closure)
  ;;   ;;     (tvd (pp-to-string (third cand))))
  ;;   )
  ;; (helm-exhaust-candidates (helm-get-current-source))
  ;; (helm-exhaust-candidates)
  ;; (tvipe (buffer2string (helm-candidate-buffer)))
  ;; (tvipe (str (helm-candidate-number-limit (helm-get-current-source))))
  ;; (helm-display-mode-line (helm-get-current-source))
  ;; (tvipe (pp-to-string helm-sources))
  ;; (tvipe (pp-to-string helm-current-source))
  ;; (tvipe (pp-to-string helm-sources))
  ;; (tvipe (list2str helm-sources))
  )


;; (cl-defun helm-comp-read (prompt collection
;;                           &key
;;                             test
;;                             initial-input
;;                             default
;;                             preselect
;;                             (buffer "*Helm Completions*")
;;                             must-match
;;                             fuzzy
;;                             reverse-history
;;                             (requires-pattern 0)
;;                             history
;;                             input-history
;;                             (case-fold helm-comp-read-case-fold-search)
;;                             (del-input t)
;;                             (persistent-action nil)
;;                             (persistent-help "DoNothing")
;;                             (mode-line helm-comp-read-mode-line)
;;                             help-message
;;                             (keymap helm-comp-read-map)
;;                             (name "Helm Completions")
;;                             header-name
;;                             candidates-in-buffer
;;                             match-part
;;                             exec-when-only-one
;;                             quit-when-no-cand
;;                             (volatile t)
;;                             sort
;;                             fc-transformer
;;                             hist-fc-transformer
;;                             marked-candidates
;;                             nomark
;;                             (alistp t)
;;                             (candidate-number-limit helm-candidate-number-limit)
;;                             multiline
;;                             allow-nest)
;;   "Read a string in the minibuffer, with helm completion.

;; It is helm `completing-read' equivalent.

;; - PROMPT is the prompt name to use.

;; - COLLECTION can be a list, vector, obarray or hash-table.
;;   It can be also a function that receives three arguments:
;;   the values string, predicate and t. See `all-completions' for more details.

;; Keys description:

;; - TEST: A predicate called with one arg i.e candidate.

;; - INITIAL-INPUT: Same as input arg in `helm'.

;; - PRESELECT: See preselect arg of `helm'.

;; - DEFAULT: This option is used only for compatibility with regular
;;   Emacs `completing-read' (Same as DEFAULT arg of `completing-read').

;; - BUFFER: Name of helm-buffer.

;; - MUST-MATCH: Candidate selected must be one of COLLECTION.

;; - FUZZY: Enable fuzzy matching.

;; - REVERSE-HISTORY: When non--nil display history source after current
;;   source completion.

;; - REQUIRES-PATTERN: Same as helm attribute, default is 0.

;; - HISTORY: A list containing specific history, default is nil.
;;   When it is non--nil, all elements of HISTORY are displayed in
;;   a special source before COLLECTION.

;; - INPUT-HISTORY: A symbol. the minibuffer input history will be
;;   stored there, if nil or not provided, `minibuffer-history'
;;   will be used instead.

;; - CASE-FOLD: Same as `helm-case-fold-search'.

;; - DEL-INPUT: Boolean, when non--nil (default) remove the partial
;;   minibuffer input from HISTORY is present.

;; - PERSISTENT-ACTION: A function called with one arg i.e candidate.

;; - PERSISTENT-HELP: A string to document PERSISTENT-ACTION.

;; - MODE-LINE: A string or list to display in mode line.
;;   Default is `helm-comp-read-mode-line'.

;; - KEYMAP: A keymap to use in this `helm-comp-read'.
;;   (the keymap will be shared with history source)

;; - NAME: The name related to this local source.

;; - HEADER-NAME: A function to alter NAME, see `helm'.

;; - EXEC-WHEN-ONLY-ONE: Bound `helm-execute-action-at-once-if-one'
;;   to non--nil. (possibles values are t or nil).

;; - VOLATILE: Use volatile attribute.

;; - SORT: A predicate to give to `sort' e.g `string-lessp'
;;   Use this only on small data as it is ineficient.
;;   If you want to sort faster add a sort function to
;;   FC-TRANSFORMER.
;;   Note that FUZZY when enabled is already providing a sort function.

;; - FC-TRANSFORMER: A `filtered-candidate-transformer' function
;;   or a list of functions.

;; - HIST-FC-TRANSFORMER: A `filtered-candidate-transformer'
;;   function for the history source.

;; - MARKED-CANDIDATES: If non--nil return candidate or marked candidates as a list.

;; - NOMARK: When non--nil don't allow marking candidates.

;; - ALISTP: \(default is non--nil\) See `helm-comp-read-get-candidates'.

;; - CANDIDATES-IN-BUFFER: when non--nil use a source build with
;;   `helm-source-in-buffer' which is much faster.
;;   Argument VOLATILE have no effect when CANDIDATES-IN-BUFFER is non--nil.

;; - MATCH-PART: Allow matching only one part of candidate.
;;   See match-part documentation in `helm-source'.

;; - ALLOW-NEST: Allow nesting this `helm-comp-read' in a helm session.
;;   See `helm'.

;; - MULTILINE: See multiline in `helm-source'.

;; Any prefix args passed during `helm-comp-read' invocation will be recorded
;; in `helm-current-prefix-arg', otherwise if prefix args were given before
;; `helm-comp-read' invocation, the value of `current-prefix-arg' will be used.
;; That's mean you can pass prefix args before or after calling a command
;; that use `helm-comp-read' See `helm-M-x' for example."

;;   (when (get-buffer helm-action-buffer)
;;     (kill-buffer helm-action-buffer))
;;   (let ((action-fn `(("Sole action (Identity)"
;;                       . (lambda (candidate)
;;                           (if ,marked-candidates
;;                               (helm-marked-candidates)
;;                               (identity candidate)))))))
;;     ;; Assume completion have been already required,
;;     ;; so always use 'confirm.
;;     (when (eq must-match 'confirm-after-completion)
;;       (setq must-match 'confirm))
;;     (let* ((minibuffer-completion-confirm must-match)
;;            (must-match-map (when must-match
;;                              (let ((map (make-sparse-keymap)))
;;                                (define-key map (kbd "RET")
;;                                  'helm-confirm-and-exit-minibuffer)
;;                                map)))
;;            (loc-map (if must-match-map
;;                         (make-composed-keymap
;;                          must-match-map (or keymap helm-map))
;;                       (or keymap helm-map)))
;;            (minibuffer-completion-predicate test)
;;            (minibuffer-completion-table collection)
;;            (helm-read-file-name-mode-line-string
;;             (replace-regexp-in-string "helm-maybe-exit-minibuffer"
;;                                       "helm-confirm-and-exit-minibuffer"
;;                                       helm-read-file-name-mode-line-string))
;;            (get-candidates
;;             (lambda ()
;;               (let ((cands (helm-comp-read-get-candidates
;;                             ;; If `helm-pattern' is passed as INPUT
;;                             ;; and :alistp is nil INPUT is passed to
;;                             ;; `all-completions' which defeat helm
;;                             ;; matching functions (multi match, fuzzy
;;                             ;; etc...) issue #2134.
;;                             collection test sort alistp "")))
;;                 (helm-cr-default default cands))))
;;            (history-get-candidates
;;             (lambda ()
;;               (let ((cands (helm-comp-read-get-candidates
;;                             history test nil alistp)))
;;                 ;; (when cands
;;                 ;;   (delete "" (helm-cr-default default cands)))
;;                 ;; (cons "_" (helm-cr-default default cands))
;;                 (cons "" (helm-cr-default default cands)))))
;;            (src-hist (helm-build-sync-source (format "%s History" name)
;;                        :candidates history-get-candidates
;;                        :fuzzy-match fuzzy
;;                        :multiline multiline
;;                        :match-part match-part
;;                        :filtered-candidate-transformer
;;                        (append '((lambda (candidates sources)
;;                                    (cl-loop for i in candidates
;;                                             ;; Input is added to history in completing-read's
;;                                             ;; and may be regexp-quoted, so unquote it
;;                                             ;; but check if cand is a string (it may be at this stage
;;                                             ;; a symbol or nil) Issue #1553.
;;                                             when (stringp i)
;;                                             collect (replace-regexp-in-string "\\s\\" "" i))))
;;                                (and hist-fc-transformer (helm-mklist hist-fc-transformer)))
;;                        :persistent-action persistent-action
;;                        :persistent-help persistent-help
;;                        :keymap loc-map
;;                        :mode-line mode-line
;;                        :help-message help-message
;;                        :action action-fn))
;;            (src (helm-build-sync-source name
;;                   :candidates get-candidates
;;                   :match-part match-part
;;                   :multiline multiline
;;                   :header-name header-name
;;                   :filtered-candidate-transformer
;;                   (append (helm-mklist fc-transformer)
;;                           '(helm-cr-default-transformer))
;;                   :requires-pattern requires-pattern
;;                   :persistent-action persistent-action
;;                   :persistent-help persistent-help
;;                   :fuzzy-match fuzzy
;;                   :keymap loc-map
;;                   :mode-line mode-line
;;                   :help-message help-message
;;                   :action action-fn
;;                   :volatile volatile))
;;            (src-1 (helm-build-in-buffer-source name
;;                     :data get-candidates
;;                     :match-part match-part
;;                     :multiline multiline
;;                     :header-name header-name
;;                     :filtered-candidate-transformer
;;                     (append (helm-mklist fc-transformer)
;;                             '(helm-cr-default-transformer))
;;                     :requires-pattern requires-pattern
;;                     :persistent-action persistent-action
;;                     :fuzzy-match fuzzy
;;                     :keymap loc-map
;;                     :persistent-help persistent-help
;;                     :mode-line mode-line
;;                     :help-message help-message
;;                     :action action-fn))
;;            (src-list (list src-hist
;;                            (cons (cons 'must-match must-match)
;;                                  (if candidates-in-buffer
;;                                      src-1 src))))
;;            (helm-execute-action-at-once-if-one exec-when-only-one)
;;            (helm-quit-if-no-candidate quit-when-no-cand)
;;            result)
;;       (when nomark
;;         (setq src-list (cl-loop for src in src-list
;;                              collect (cons '(nomark) src))))
;;       (when reverse-history (setq src-list (nreverse src-list)))
;;       (add-hook 'helm-after-update-hook 'helm-comp-read--move-to-first-real-candidate)
;;       (unwind-protect
;;            (setq result (helm
;;                          :sources src-list
;;                          :input initial-input
;;                          :default default
;;                          :preselect preselect
;;                          :prompt prompt
;;                          :resume 'noresume
;;                          :keymap loc-map ;; Needed with empty collection.
;;                          :allow-nest allow-nest
;;                          :candidate-number-limit candidate-number-limit
;;                          :case-fold-search case-fold
;;                          :history (and (symbolp input-history) input-history)
;;                          :buffer buffer))
;;         (remove-hook 'helm-after-update-hook 'helm-comp-read--move-to-first-real-candidate))
;;       ;; Avoid adding an incomplete input to history.
;;       (when (and result history del-input)
;;         (cond ((and (symbolp history) ; History is a symbol.
;;                     (not (symbolp (symbol-value history)))) ; Fix Issue #324.
;;                ;; Be sure history is not a symbol with a nil value.
;;                (helm-aif (symbol-value history) (setcar it result)))
;;               ((consp history) ; A list with a non--nil value.
;;                (setcar history result))
;;               (t ; Possibly a symbol with a nil value.
;;                (set history (list result)))))
;;       (or result (helm-mode--keyboard-quit)))))



;; This should make helm less noisy and hopefully more responsive
(defun helm-maybe-exit-minibuffer ()
  (interactive)
  (with-helm-alive-p
    (if (and (helm--updating-p)
             (null helm--reading-passwd-or-string))
        (progn
          ;; (message "[Display not ready]")
          (sit-for 0.3) (message nil)
          (helm-update))
      (helm-exit-minibuffer))))



(define-key helm-map (kbd "<help> p") #'helm-test-code)



;; https://emacs.stackexchange.com/questions/33267/accept-unmatched-input-in-completing-read-when-using-helm
;; (defvar accepted-minibuffer-contents nil
;;   "Minibuffer contents saved in `force-exit-minibuffer-now'.")

;; (defun force-exit-minibuffer-now ()
;;   "Exit minibuffer (successfully) with whatever contents are in it.
;; Exiting helm sessions via this function doesn't attempt to match
;; the minibuffer contents with candidates supplied to `completing-read'."
;;   (interactive)
;;   (if minibuffer-completion-confirm
;;       (minibuffer-complete-and-exit)
;;     (setq accepted-minibuffer-contents (minibuffer-contents))
;;     (exit-minibuffer)))

;; (define-key helm-map (kbd "M-#") 'force-exit-minibuffer-now)

;; (defun my-completing-read (orig-fn &rest args)
;;   (interactive)
;;   (let* ((accepted-minibuffer-contents nil)
;;      (result (apply orig-fn args)))
;;     (or accepted-minibuffer-contents result)))

;; (advice-add 'completing-read :around 'my-completing-read)
;; (advice-remove 'completing-read  'my-completing-read)


;; Ensure ivy is the completing read we use, not helm.
;; We want to be able to enter empty string and enter what we have typed, not always the selection
(setq completing-read-function 'ivy-completing-read)

;; I don't want helm to take over everything'
;; I can still use helm
;; (helm-mode -1)
;; Unfortunately, turning off helm-mode breaks helm
;; modifying helm-mode, i could delete the thing that overtakes ivy
;; Removing the add-function advice made it work
(define-minor-mode helm-mode
  "Toggle generic helm completion.

All functions in Emacs that use `completing-read'
or `read-file-name' and friends will use helm interface
when this mode is turned on.

However you can modify this behavior for functions of your choice
with `helm-completing-read-handlers-alist'.

Also commands using `completion-in-region' will be helmized when
`helm-mode-handle-completion-in-region' is non nil, you can modify
this behavior with `helm-mode-no-completion-in-region-in-modes'.

Called with a positive arg, turn on unconditionally, with a
negative arg turn off.
You can turn it on with `helm-mode'.

Some crap emacs functions may not be supported,
e.g `ffap-alternate-file' and maybe others
You can add such functions to `helm-completing-read-handlers-alist'
with a nil value.

About `ido-mode':
When you are using `helm-mode', DO NOT use `ido-mode', instead if you
want some commands use `ido', add these commands to
`helm-completing-read-handlers-alist' with `ido' as value.

Note: This mode is incompatible with Emacs23."
  :group 'helm-mode
  :global t
  :lighter helm-completion-mode-string
  (cl-assert (boundp 'completing-read-function) nil
             "`helm-mode' not available, upgrade to Emacs-24")
  (if helm-mode
      (if (fboundp 'add-function)
          (progn
            ;; (add-function :override completing-read-function
            ;;               #'helm--completing-read-default)
            ;; (add-function :override read-file-name-function
            ;;               #'helm--generic-read-file-name)
            ;; (add-function :override read-buffer-function
            ;;               #'helm--generic-read-buffer)
            (when helm-mode-handle-completion-in-region
              (add-function :override completion-in-region-function
                            #'helm--completion-in-region))
            ;; If user have enabled ido-everywhere BEFORE enabling
            ;; helm-mode disable it and warn user about its
            ;; incompatibility with helm-mode (issue #2085).
            (helm-mode--disable-ido-maybe)
            ;; If ido-everywhere is not enabled yet anticipate and
            ;; disable it if user attempt to enable it while helm-mode
            ;; is running (issue #2085).
            (add-hook 'ido-everywhere-hook #'helm-mode--ido-everywhere-hook))

        ;; Disable this. It's breaking ivy
        ;; (setq completing-read-function 'helm--completing-read-default
        ;;       read-file-name-function  'helm--generic-read-file-name
        ;;       read-buffer-function     'helm--generic-read-buffer)

        (when (and (boundp 'completion-in-region-function)
                   helm-mode-handle-completion-in-region)
          (setq completion-in-region-function #'helm--completion-in-region))
        (message helm-completion-mode-start-message))
    (if (fboundp 'remove-function)
        (progn
          (remove-function completing-read-function #'helm--completing-read-default)
          (remove-function read-file-name-function #'helm--generic-read-file-name)
          (remove-function read-buffer-function #'helm--generic-read-buffer)
          (remove-function completion-in-region-function #'helm--completion-in-region)
          (remove-hook 'ido-everywhere-hook #'helm-mode--ido-everywhere-hook))
      (setq completing-read-function (and (fboundp 'completing-read-default)
                                          'completing-read-default)
            read-file-name-function  (and (fboundp 'read-file-name-default)
                                          'read-file-name-default)
            read-buffer-function     (and (fboundp 'read-buffer) 'read-buffer))
      (when (and (boundp 'completion-in-region-function)
                 (boundp 'helm--old-completion-in-region-function))
        (setq completion-in-region-function helm--old-completion-in-region-function))
      (message helm-completion-mode-quit-message))))


(defun restart-helm-fix ()
  (interactive)
  (helm-mode -1)
  (helm-mode 1)
  (helm)
  ;; (sleep 1)
  ;; (tsk "C-g")
  )




;; TODO Sort my-helm-fzf
;; https://github.com/jkitchin/jkitchin.github.com/blob/master/org/2016/01/24/Modern-use-of-helm---sortable-candidates.org
;; (defvar h-map
;;   (let ((map (make-sparse-keymap)))
;;     (set-keymap-parent map helm-map)
;;     (define-key map (kbd "M-<down>")   'h-sort)
;;     map)
;;   "keymap for a helm source.")
;; (defvar h-sort-fn nil)
;; (defun h-sort ()
;;   (interactive)
;;   (let ((action (read-char "#decreasing (d) | #increasing (i) | a-z (a) | z-a (z): ")))
;;     (cond
;;      ((eq action ?d)
;;       (setq h-sort-fn (lambda (c1 c2) (> (plist-get (cdr c1) :num) (plist-get (cdr c2) :num)))))
;;      ((eq action ?i)
;;       (setq h-sort-fn (lambda (c1 c2) (< (plist-get (cdr c1) :num) (plist-get (cdr c2) :num)))))
;;      ((eq action ?a)
;;       (setq h-sort-fn (lambda (c1 c2) (string< (plist-get (cdr c1) :key) (plist-get (cdr c2) :key)))))
;;      ((eq action ?z)
;;       (setq h-sort-fn (lambda (c1 c2) (string> (plist-get (cdr c1) :key) (plist-get (cdr c2) :key)))))
;;      (t (setq h-sort-fn nil)))
;;      (helm-refresh)
;;      (setq h-sort-fn nil)))


;; This works but then I don't know why it errors when it does
;; (advice-add 'helm--completion-in-region :around #'ignore-errors-around-advice)
;; (advice-remove 'helm--completion-in-region #'ignore-errors-around-advice)

(require 'ace-jump-helm-line)


(define-key helm-map (kbd "M-k") 'ace-jump-helm-line)


(defun completion-at-point ()
  "Perform completion on the text around point.
The completion method is determined by `completion-at-point-functions'."
  (interactive)
  (let ((res (run-hook-wrapped 'completion-at-point-functions
                               #'completion--capf-wrapper 'all)))

    ;; (remove-from-list 'completion-at-point-functions 'elisp-completion-at-point)
    ;; (etv (pps completion-at-point-functions))
    (pcase res
      (`(,_ . ,(and (pred functionp) f)) (funcall f))
      (`(,hookfun . (,start ,end ,collection . ,plist))
       (unless (markerp start) (setq start (copy-marker start)))
       (let* ((completion-extra-properties plist)
              (completion-in-region-mode-predicate
               (lambda ()
                 ;; We're still in the same completion field.
                 (let ((newstart (car-safe (funcall hookfun))))
                   (and newstart (= newstart start))))))
         ;; (etv (pps collection))
         ;; (etv (pps `(completion-in-region ,start ,end ,collection
         ;;                                  ,(plist-get plist :predicate))))
         (completion-in-region start end collection
                               (plist-get plist :predicate))))
      ;; Maybe completion already happened and the function returned t.
      (_
       (when (cdr res)
         (message "Warning: %S failed to return valid completion data!"
                  (car res)))
       (cdr res)))))

(advice-add 'helm-elisp--persistent-help :around #'ignore-errors-around-advice)

(defun helm-google-suggest-parser ()
  (cl-loop
   with result-alist = (xml-get-children
                        (car (xml-parse-region
                              (point-min) (point-max)))
                        'CompleteSuggestion)
   for i in result-alist collect
   (cdr (cl-caadr (assq 'suggestion i)))))

(defun helm-google-suggest-fetch (input)
  "Fetch suggestions for INPUT from XML buffer."
  (let ((request (format helm-google-suggest-url
                         (url-hexify-string input))))
    (helm-net--url-retrieve-sync
     request #'helm-google-suggest-parser)))


(setq helm-net-prefer-curl t)
(setq helm-net-prefer-curl nil)

;; (url-retrieve-synchronously "https://encrypted.google.com/complete/search?output=toolbar&q=haw")

(defun helm-net--url-retrieve-sync (request parser)
  (if helm-net-prefer-curl
      (with-temp-buffer
        (apply #'call-process "curl"
               nil `(t ,helm-net-curl-log-file) nil request helm-net-curl-switches)
        (funcall parser))
    ;; This makes it hang
    ;; (my-url-log "caling url-retrieve-synchronously")
    ;; (message "calling url-retrieve-synchronously")
    (let ((b (url-retrieve-synchronously request)))
      (my-url-log "Checking output from url-retrieve-synchronously")
      (my-url-log "a")
      (if (and
           b
           (not (eq 'input b))
           (bufferp b))
          (progn
            (my-url-log "b")
            (with-current-buffer b
              (let ((r (ignore-errors (funcall parser))))
                (my-url-log (pps r))
                (my-url-log "parsed")

                ;; redrawing doesn't tell helm to display the parsed results
                ;; relm is successfully retrieving the results but not always displaying them
                ;; why?
                ;; (redraw-display)
                r)))
        (progn
          (my-url-log "c")
          (my-url-log "nothing returned from url-retrieve-synchronously")
          nil)))))


;; inhibit-quit must be set to t to get around the fast typing problem when using emacs in the terminal
;; If this gets merged then I can remove the hack here
;; https://github.com/emacs-helm/helm/pull/2418
(defun helm-get-candidates (source)
  "Retrieve and return the list of candidates from SOURCE."
  (let* ((candidate-fn (assoc-default 'candidates source))
         (candidate-proc (assoc-default 'candidates-process source))
         ;; See comment in helm-get-cached-candidates (Bug#2113).
         ;; (inhibit-quit candidate-proc)
         (inhibit-quit (or candidate-proc
                           (not (display-graphic-p))))
         cfn-error
         (notify-error
          (lambda (&optional e)
            (error
             "In `%s' source: `%s' %s %s"
             (assoc-default 'name source)
             (or candidate-fn candidate-proc)
             (if e "\n" "must be a list, a symbol bound to a list, or a function returning a list")
             (if e (prin1-to-string e) ""))))
         (candidates (condition-case-unless-debug err
                         ;; Process candidates-(process) function
                         ;; It may return a process or a list of candidates.
                         (if candidate-proc
                             ;; Calling `helm-interpret-value' with no
                             ;; SOURCE arg force the use of `funcall'
                             ;; and not `helm-apply-functions-from-source'.
                             (helm-interpret-value candidate-proc)
                           (helm-interpret-value candidate-fn source))
                       (error (helm-log "Error: %S" (setq cfn-error err)) nil))))
    (cond ((and (processp candidates) (not candidate-proc))
           (warn "Candidates function `%s' should be called in a `candidates-process' attribute"
                 candidate-fn))
          ((and candidate-proc (not (processp candidates)))
           (error "Candidates function `%s' should run a process" candidate-proc)))
    (cond ((processp candidates)
           ;; Candidates will be filtered later in process filter.
           candidates)
          ;; An error occured in candidates function.
          (cfn-error (unless helm--ignore-errors
                       (funcall notify-error cfn-error)))
          ;; Candidates function returns no candidates.
          ((or (null candidates)
               ;; Can happen when the output of a process
               ;; is empty, and the candidates function call
               ;; something like (split-string (buffer-string) "\n")
               ;; which result in a list of one empty string (Bug#938).
               ;; e.g (completing-read "test: " '(""))
               (equal candidates '("")))
           nil)
          ((listp candidates)
           ;; Transform candidates with `candidate-transformer' functions or
           ;; `real-to-display' functions if those are found,
           ;; otherwise return candidates unmodified.
           ;; `filtered-candidate-transformer' is NOT called here.
           (helm-transform-candidates candidates source))
          (t (funcall notify-error)))))

;; helm-google-suggest is defined using this command
;; Making a default delay is probably a good thing
(defun helm-other-buffer (sources buffer &optional delay)
  "Simplified Helm interface with other `helm-buffer'.
Call `helm' only with SOURCES and BUFFER as args."
  (if (not delay)
      (setq delay 0.2))
  (helm :sources sources :buffer buffer
        :input-idle-delay delay
        :helm-full-frame t))

(require 'helm-google)
(defun helm-google (&optional engine search-term)
  "Web search interface for Emacs."
  (interactive)
  (let ((input (or search-term (when (use-region-p)
                                 (buffer-substring-no-properties
                                  (region-beginning)
                                  (region-end)))))
        (helm-google-default-engine (or engine helm-google-default-engine)))
    (helm :sources `((name . ,(helm-google-engine-string))
                     (action . helm-google-actions)
                     (candidates . helm-google-search)
                     (requires-pattern)
                     (nohighlight)
                     (multiline)
                     (match . identity)
                     (volatile))
          :prompt (concat (helm-google-engine-string) ": ")
          :input input
          :input-idle-delay helm-google-idle-delay
          :buffer "*helm google*"
          :history 'helm-google-input-history
          :helm-full-frame t)))

;; The delay prevents spamming google
(eval
 `(defun helm-google-suggest ()
    "Preconfigured `helm' for Google search with Google suggest."
    (interactive)
    ;; (helm-other-buffer 'helm-source-google-suggest "*helm google*" 0.1)
    (helm-other-buffer 'helm-source-google-suggest "*helm google*" ,(string-to-number (myrc-get "helm_async_delay")))))

(defun helm-google-suggest-set-candidates (&optional request-prefix)
  "Set candidates with result and number of Google results found."
  (let ((suggestions (helm-google-suggest-fetch
                      (or (and request-prefix
                               (concat request-prefix
                                       " " helm-pattern))
                          helm-pattern))))
    (if (member helm-pattern suggestions)
        suggestions
        ;; if there is no suggestion exactly matching the input then
        ;; prepend a Search on Google item to the list
        (append
         suggestions
         (list (cons (format "Search for '%s' on Google" helm-input)
                     helm-input))))))

;; emacs gp
(defun helm-google-suggest-set-candidates (&optional request-prefix)
  "Set candidates with result and number of Google results found."
  ;; (message "%s" (concat "request-prefix: '" request-prefix "'"))
  (let* ((suggestions (helm-google-suggest-fetch
                       (or (and request-prefix
                                (concat request-prefix
                                        " " helm-pattern))
                           helm-pattern)))
         (completions
          (if suggestions
              (if (member helm-pattern suggestions)
                  suggestions
                (cons helm-input suggestions))
            (append
             suggestions
             (list (cons (format "No completions. Search for '%s' on Google" helm-input)
                         helm-input))))))
    (mapcar (lambda (e) (if (stringp e)
                            (if (re-match-p (unregexify helm-input) e)
                                e
                              (concat helm-input " " e))
                          e))
            completions)))

(require 'helm-google)
(defun helm-google--parse-google (buf)
  "Parse the html response from Google."
  (helm-google--with-buffer buf
      (let (results result)
        (while (re-search-forward "class=\"kCrYT\"><a href=\"/url\\?q=\\(.*?\\)&amp;sa" nil t)
          (setq result (plist-put result :url (match-string-no-properties 1)))
          (re-search-forward "BNeawe vvjwJb AP7Wnd\">\\(.*?\\)</div>" nil t)
          (setq result (plist-put result :title (helm-google--process-html (match-string-no-properties 1))))
          ;; This check is necessary because of featured results
          (if (looking-at "</h3>")
              (progn
                (re-search-forward "BNeawe s3v9rd" nil t)
                (re-search-forward "BNeawe s3v9rd" nil t)
                (re-search-forward "\">\\(.*?\\)</div>" nil t)
                (setq result (plist-put result :content (helm-google--process-html (match-string-no-properties 1))))))
          (add-to-list 'results result t)
          (setq result nil))
        results)))


(defun helm-check-minibuffer-input ()
  "Check minibuffer content."
  (with-helm-quittable
    (with-selected-window (or (active-minibuffer-window)
                              (minibuffer-window))
      (helm-check-new-input (minibuffer-contents)))))

;; This is the fix
(defun helm-check-minibuffer-input ()
  "Check minibuffer content."
  (with-selected-window (or (active-minibuffer-window)
                            (minibuffer-window))
    (helm-check-new-input (minibuffer-contents))))

;;j:helm-source-google-suggest

(defset helm-source-google-suggest
  (helm-build-sync-source "Google Suggest"
    :candidates (lambda ()
                  ;; This doesn't actually enable it to render properly
                  ;; It still doesn't render
                  (funcall helm-google-suggest-default-function))
    ;; (let ((inhibit-quit t))
    ;;   (ignore-errors
    ;;     (funcall helm-google-suggest-default-function))))
    :action 'helm-google-suggest-actions
    :volatile t
    :keymap helm-map
    :requires-pattern 3))

(require 'helm-buffers)
(define-key helm-buffer-map (kbd "C-M-@") 'helm-toggle-visible-mark)
(define-key helm-buffer-map (kbd "M-SPC") 'helm-toggle-visible-mark)
;; (define-key helm-buffer-map (kbd "M-l") 'helm-toggle-visible-mark)
;; (define-key helm-buffer-map (kbd "M-l") nil)
(define-key helm-buffer-map (kbd "M-u") 'helm-unmark-all)

(provide 'my-helm)