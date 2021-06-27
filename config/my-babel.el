(require 'ob-core)

;; org-babel-shell-names

;; I think this is just for setting up babel
(org-babel-do-load-languages
 'org-babel-load-languages
 '((shell . t)
   (python . t)
   (R . t)
   (js . t)
   (problog . t)
   (dot . t)
   (go . t)
   (show-dot . t)
   (tmux . t)
   (C . t)))

(defun inside-src-block ()
  "True if inside src block."
  (memq (org-element-type (org-element-context)) '(inline-src-block src-block)))

(defun org-babel-open-src-block-result-maybe ()
  (interactive)
  (if (inside-src-block)
      (progn
        (org-babel-open-src-block-result)
          )
    nil))

(setq org-src-window-setup 'current-window)

;; org-babel-map has a prefix, so all mappings will be prefixed with this. So I can't use org-babel-map. Just use org-mode map.
;; org-babel-key-prefix
(define-key org-mode-map (kbd "M-q M-r") #'org-babel-open-src-block-result-maybe)

(define-key org-src-mode-map (kbd "C-c C-c") #'org-edit-src-exit)

;; (defun org-babel-execute:powershell)



;; (defun org-babel-execute:javascript (body params)
;;   (let* ((coding-system-for-read 'utf-8) ;use utf-8 with sub-processes
;;          (coding-system-for-write 'utf-8)
;;          (in-file (org-babel-temp-file "js-")))
;;     (with-temp-file in-file
;;       (insert (org-babel-expand-body:generic body params)))
;;     (org-babel-eval (concat "node" " " (org-babel-process-file-name in-file)) "")
;;     nil))



;; Not sure why this is not collecting the output
(defun org-babel-execute:powershell (body params)
  (let* ((coding-system-for-read 'utf-8) ;use utf-8 with sub-processes
         l         (coding-system-for-write 'utf-8)
         (in-file (org-babel-temp-file "psh-")))
    (with-temp-file in-file
      (insert (org-babel-expand-body:generic body params)))
    (org-babel-eval (concat "pwsh" " -f " (org-babel-process-file-name in-file)) "")
    nil))

;; (defun org-babel-execute:powershell (body params)
;;   (let* ((cmd (concat (shell-quote-argument "pwsh"))))
;;     (org-babel-eval cmd body)
;;     nil))


(defun org-babel-get-named-block-contents (name)
  "Find a named source-code block.
Return the contents of the source block identified by source
NAME, or nil if no such block exists.  Set match data according
to `org-babel-named-src-block-regexp'."
  (save-excursion
    (goto-char (point-min))
    (goto-char (org-babel-find-named-block name))
    (org-get-src-block-here)
    ))

(defun org-babel-get-named-result-contents (name)
  "Find a named result block.
Return the contents of the source block identified by source
NAME, or nil if no such block exists.  Set match data according
to `org-babel-named-src-block-regexp'."
  (save-excursion
    (goto-char (point-min))
    (goto-char (org-babel-find-named-result name))
    (org-get-src-block-here)))


(defun org-babel-execute:generic (body params)
  ":interpreter executes body like 'interpreter file'
:interpreter filters the source like 'cat source | filter'"
  (let ((stdinblock (or (cdr (assoc :in params))
                        (cdr (assoc :inb params))
                        (cdr (assoc :ins params))
                        (cdr (assoc :insrc params))
                        ""))
        (stdinresult (or (cdr (assoc :inr params))
                         (cdr (assoc :inresult params))
                         ""))
        (stdincmd (or (cdr (assoc :input params))
                      (cdr (assoc :stdin params))
                      ))
        (interpreter (or (cdr (assoc :interpreter params))
                         (cdr (assoc :i params))
                         (cdr (assoc :sps params))
                         (cdr (assoc :sph params))
                         (cdr (assoc :spv params))
                         (cdr (assoc :comint params))
                         (cdr (assoc :nw params))
                         (cdr (assoc :esph params))
                         (cdr (assoc :espv params))
                         (cdr (assoc :enw params))))
        (tmp (or (cdr (assoc :t params))
                 (cdr (assoc :fp params))
                 (cdr (assoc :file params))
                 (org-babel-temp-file "generic-")))
        (args (or (cdr (assoc :args params))
                  (cdr (assoc :a params))))
        (filter (or (if (cdr (assq :spsf params))
                        (concat "sps -E " (q (cdr (assq :spsf params))))
                      nil)
                    (cdr (assoc :filter params))
                    (cdr (assoc :f params)))))

    (if (and (string-empty-p (or stdincmd ""))
             (not (string-empty-p (or stdinblock ""))))
        ;; Save the contents of stdinblock to a file
        ;; and overwrite stdincmd
        (let ((fp (org-babel-temp-file "stdin" "txt")))
          (write-string-to-file (org-babel-get-named-block-contents stdinblock) fp)
          (setq stdincmd (concat "cat " fp))))

    (if (and (string-empty-p (or stdincmd ""))
             (not (string-empty-p (or stdinresult ""))))
        (let ((fp (org-babel-temp-file "stdin" "txt")))
          (write-string-to-file (org-babel-get-named-result-contents stdinresult) fp)
          (setq stdincmd (concat "cat " fp))))


    (if (and (boundp 'stdincmd) stdincmd)
        (setq stdincmd (concat stdincmd " | "))
      (setq stdincmd ""))

    ;; (tvipe stdincmd)
    ;; (tvipe "hi")

    (if (not (and (boundp 'interpreter) interpreter))
        (setq interpreter "cat"))
    (write-string-to-file body tmp)
    (if (and (boundp 'args) args)
        (setq args (concat " " args))
      (setq args ""))
    (if (and (boundp 'filter) filter)
        (setq filter (concat "| " filter))
      (setq filter ""))

    ;; The str here are not superfluous. They check for nil
    (let* ((stdincmd (str stdincmd))
           (interpreter (str interpreter))
           (tmp (str tmp))
           (args (str args))
           (filter (str filter))
           (cmd (ds (format
                     ;; This tm-tty hack fixes the naive tty checking of many scripts and interpreters
                     ;; It's a bad hack, though and it's better to use this instead
                     ;; ! [ -t 0 ] && ! test "$(readlink /proc/$$/fd/0)" = /dev/null
                     ;; This still doesn't guarantee that it will work, unfortunately
                     ;; &2 is more reliable than tm-tty
                     ;; If stderr is being piped then this manes the script think it's a pipe'
                     ;; &2 is not reliable
                     "PATH=\"/home/shane/scripts:$PATH\"; %s %s%s%s %s"
                     ;; "PATH=\"/home/shane/scripts:$PATH\"; %s%s%s %s"
                     ;; If there is no stdin then it's probably a tty, so use &2 as a source of the pty
                     ;; Only try to add if it looks like a pty if it's not a pipe
                     "ls -la /proc/$$/fd/2 | grep -q pty && exec <&2;"
                     stdincmd
                     (if (string-match-p "{}" interpreter)
                         (s-replace "{}" tmp interpreter)
                       (concat
                        interpreter
                        " "
                        tmp))
                     args
                     filter) "babel")))
      (if (assoc :pak params)
          (setq cmd (concat cmd "; pak")))
      (cond ((assoc :comint params) (comint-quick cmd))
            ((assoc :nw params) (nw cmd))
            ((assoc :sps params) (sps cmd))
            ((assoc :sph params) (sph cmd))
            ((assoc :spv params) (spv cmd))
            ((assoc :esph params) (sph-term cmd))
            ((assoc :espv params) (spv-term cmd))
            ((assoc :enw params) (nw-term cmd))
            (t (shell-command-to-string cmd))))))

(defun org-babel-execute-src-block (&optional arg info params)
  "Execute the current source code block.
Insert the results of execution into the buffer.  Source code
execution and the collection and formatting of results can be
controlled through a variety of header arguments.

With prefix argument ARG, force re-execution even if an existing
result cached in the buffer would otherwise have been returned.

Optionally supply a value for INFO in the form returned by
`org-babel-get-src-block-info'.

Optionally supply a value for PARAMS which will be merged with
the header arguments specified at the front of the source code
block."
  (interactive)
  (let* ((org-babel-current-src-block-location
          (or org-babel-current-src-block-location
              (nth 5 info)
              (org-babel-where-is-src-block-head)))
         (info (if info (copy-tree info) (org-babel-get-src-block-info))))
    ;; Merge PARAMS with INFO before considering source block
    ;; evaluation since both could disagree.
    (cl-callf org-babel-merge-params (nth 2 info) params)
    (when (org-babel-check-evaluate info)
      (cl-callf org-babel-process-params (nth 2 info))
      (let* ((params (nth 2 info))
             (interpreter (or (cdr (assq :interpreter params))
                              (cdr (assq :i params))
                              (cdr (assq :sps params))
                              (cdr (assq :sph params))
                              (cdr (assq :spv params))
                              (cdr (assq :comint params))
                              (cdr (assq :nw params))
                              (cdr (assq :esph params))
                              (cdr (assq :espv params))
                              (cdr (assq :enw params))))
             (args (or (cdr (assq :args params))
                       (cdr (assq :a params))))
             (resultslang (or (cdr (assq :lang params))
                              (cdr (assq :l params))
                              ;; Not sure why these are both broken
                              ;; (s-replace-regexp "-mode$" "" (cdr (assq :mode params)))
                              ;; (s-replace-regexp "-mode$" "" (cdr (assq :m params)))
                              ))
             (stdincmd (or (cdr (assq :input params))
                           (cdr (assq :stdin params))
                           ))
             (filter (or (if (cdr (assq :spsf params))
                             (concat "sps -E " (q (cdr (assq :spsf params))))
                           nil)
                         (cdr (assq :filter params))
                         (cdr (assq :f params))))
             (cache (let ((c (cdr (assq :cache params))))
                      (and (not arg) c (string= "yes" c))))
             (new-hash (and cache (org-babel-sha1-hash info)))
             (old-hash (and cache (org-babel-current-result-hash)))
             (current-cache (and new-hash (equal new-hash old-hash))))
        (cond
         (current-cache
          (save-excursion               ;Return cached result.
            (goto-char (org-babel-where-is-src-block-result nil info))
            (forward-line)
            (skip-chars-forward " \t")
            (let ((result (org-babel-read-result)))
              (message (replace-regexp-in-string "%" "%%" (format "%S" result)))
              result)))
         ((org-babel-confirm-evaluate info)
          (let* ((lang (nth 0 info))
                 (result-params (cdr (assq :result-params params)))
                 ;; Expand noweb references in BODY and remove any
                 ;; coderef.
                 (body
                  (let ((coderef (nth 6 info))
                        (expand
                         (if (org-babel-noweb-p params :eval)
                             (org-babel-expand-noweb-references info)
                           (nth 1 info))))
                    (if (not coderef) expand
                      (replace-regexp-in-string
                       (org-src-coderef-regexp coderef) "" expand nil nil 1))))
                 (dir (cdr (assq :dir params)))
                 (default-directory
                   (or (and dir (file-name-as-directory (expand-file-name dir)))
                       default-directory))
                 (cmd (intern (concat "org-babel-execute:" lang)))
                 result)
            (if (and (not arg) (or interpreter filter))
                (setq cmd 'org-babel-execute:generic))
            (unless (fboundp cmd)
              (error "No org-babel-execute function for %s!" lang))
            (message "executing %s code block%s..."
                     (capitalize lang)
                     (let ((name (nth 4 info)))
                       (if name (format " (%s)" name) "")))
            (if (member "none" result-params)
                (progn (funcall cmd body params)
                       (message "result silenced"))
              (setq result
                    (let ((r (funcall cmd body params)))
                      (if (and (eq (cdr (assq :result-type params)) 'value)
                               (or (member "vector" result-params)
                                   (member "table" result-params))
                               (not (listp r)))
                          (list (list r))
                        r)))
              (let ((file (cdr (assq :file params))))
                ;; If non-empty result and :file then write to :file.
                (when file
                  (when result
                    (with-temp-file file
                      (insert (org-babel-format-result
                               result (cdr (assq :sep params))))))
                  (setq result file))
                ;; Possibly perform post process provided its
                ;; appropriate.  Dynamically bind "*this*" to the
                ;; actual results of the block.
                (let ((post (cdr (assq :post params))))
                  (when post
                    (let ((*this* (if (not file) result
                                    (org-babel-result-to-file
                                     file
                                     (let ((desc (assq :file-desc params)))
                                       (and desc (or (cdr desc) result)))))))
                      (setq result (org-babel-ref-resolve post))
                      (when file
                        (setq result-params (remove "file" result-params))))))
                (org-babel-insert-result
                 result result-params info new-hash (or resultslang lang))))
            (run-hooks 'org-babel-after-execute-hook)
            result)))))))

(defun test-mark-buffer ()
  (interactive)
  (progn (beginning-of-buffer) (activate-mark) (end-of-buffer)))

;; I've tried calling the functions directly instead of using keyboard macros
;; And discovered that activate-mark doesn't work
;; (defun org-babel-raise ()
;;   "Move the interior of a babel to the outside: remove the babel block chrome and keep only the source code."

;;   ;; https://stackoverflow.com/questions/9069514/emacs-problems-with-activating-mark-in-an-interactive-command

;;   (interactive)
;;   (let (deactivate-mark)
;;     (evil-with-single-undo
;;       (call-interactively 'org-mark-element)
;;       ;; (cua-set-mark)

;;       ;; (call-interactively 'cua-set-mark)
;;       ;; (next-line)
;;       ;; (activate-mark)
;;       ;; put a line after the block
;;       ;; (setq current-prefix-arg '(4))
;;       ;; (call-interactively 'cua-exchange-point-and-mark)

;;       (call-interactively 'cua-exchange-point-and-mark)
;;       ;; This appears to lose the mark
;;       (insert "\n")
;;       (call-interactively 'cua-exchange-point-and-mark)

;;       (call-interactively 'org-edit-special)
;;       ;; Can't get further with this method
;;       ;; (call-interactively 'mark-whole-buffer)
;;       ;; (call-interactively 'mark-whole-buffer)

;;       ;; (call-interactively 'kill-ring-save)
;;       ;; (call-interactively 'org-edit-src-exit)
;;       ;; (call-interactively 'org-babel-mark-block)
;;       ;; (previous-line)

;;       ;; (call-interactively 'cua-exchange-point-and-mark)
;;       ;; (next-line)
;;       ;; (yank)
;;       ;; (call-interactively 'cua-exchange-point-and-mark)
;;       )))

;; This function used to work
;; (defun org-babel-raise ()
;;   "Move the interior of a babel to the outside: remove the babel block chrome and keep only the source code."
;;   (interactive)
;;   (evil-with-single-undo
;;     ;; put a line after the block
;;     (call-interactively 'org-mark-element)
;;     (ekm "C-x C-x")
;;     (insert "\n")
;;     (ekm "<up>")
;;     (ekm "C-x C-x")

;;     (ekm "C-c '")
;;     (ekm "C-x h")
;;     (ekm "C-x h")
;;     (ekm "M-w")
;;     (ekm "C-c '")
;;     (call-interactively 'org-babel-mark-block)
;;     (ekm "<up>")
;;     (ekm "C-x C-x")
;;     (ekm "<down>")
;;     (ekm "C-y")
;;     (ekm "C-x C-x")))

;; I had high hopes here
;; Not sure why activate-mark doesn't work
(defun org-babel-raise ()
  "Move the interior of a babel to the outside: remove the babel block chrome and keep only the source code."
  (interactive)
  (let (deactivate-mark)
    (evil-with-single-undo

      ;; =org-mark-element= behaves slightly differently with a quote block
      (cond ((org-in-block-p '("quote"))
             (progn
               (call-interactively 'org-mark-element)
               (call-interactively 'previous-line)
               (call-interactively 'cua-exchange-point-and-mark)
               (call-interactively 'next-line)
               ;; (call-interactively 'next-line)
               (call-interactively 'cua-exchange-point-and-mark)))
            (t
             (call-interactively 'org-mark-element)))

      ;; cfilter breaks the mark
      (cfilter "sed -e /^#+/d -e 's/^  //'")

      (call-interactively 'cua-exchange-point-and-mark)
      (re-search-backward "[^[:space:]]")
      (call-interactively 'move-end-of-line)

      ;; Not sure why I can't activate mark after an edit. It was let...deactivate-mark that i needed
      ;; (tsk "C-x C-x")
      )))



(defun org-babel-change-block-type ()
  (interactive)
  (cond ((or (org-in-src-block-p)
             (org-in-block-p '("src" "example" "verbatim" "clocktable" "quote")))
         (progn
           (call-interactively 'org-babel-raise)
           (call-interactively 'hydra-org-template/body)))
        (t
         (self-insert-command 1))))

(define-key org-mode-map (kbd "M-.") 'org-babel-change-block-type)



;; (define-key org-mode-map (kbd ">") (lambda () (interactive) (call-interactively 'org-mark-element)))
;; (define-key org-mode-map (kbd ">") 'org-mark-element)
;; (define-key org-mode-map (kbd ">") 'org-babel-raise)

;; (define-key org-mode-map (kbd ">") 'test-mark-buffer)

(setq org-confirm-babel-evaluate nil)

;; (define-key org-mode-map (kbd ">") nil)
;; (define-key org-mode-map (kbd ">") 'org-babel-change-block-type)


(defun org-babel-execute-named-block ()
  (interactive)
  (save-excursion
    (goto-char
     (org-babel-find-named-block
      (completing-read "Code Block: " (org-babel-src-block-names))))
    (org-babel-execute-src-block-maybe)))


(defun org-edit-special-around-advice (proc &rest args)
  ;; (message "org-edit-special called with args %S" args)
  (let ((res (apply proc args)))
    (undo-tree-save-root ?')
    ;; (message "org-edit-special returned %S" res)
    res))
(advice-add 'org-edit-special :around #'org-edit-special-around-advice)


(defun org-babel-add-src-args ()
  (interactive)
  (if (org-in-src-block-p)
      (org-babel-insert-header-arg "args" (read-string "arguments:"))))

(define-key org-mode-map (kbd "M-@") 'org-babel-add-src-args)

(defun my-org-babel-goto-block-head (p)
  "Go to the beginning of the current block.
   If called with a prefix, go to the end of the block"
  (interactive "P")
  (let* ((element (org-element-at-point)))
    (when (or (eq (org-element-type element) 'example-block)
              (eq (org-element-type element) 'src-block) )
      (let ((begin (org-element-property :begin element))
            (end (org-element-property :end element)))
        ;; Ensure point is not on a blank line after the block.
        (beginning-of-line)
        (skip-chars-forward " \r\t\n" end)
        (when (< (point) end)
          (goto-char
           (if p
               (org-element-property :end element)
             (org-element-property :begin element))))))))

(defun org-babel-add-name ()
  (interactive)
  (call-interactively 'my-org-babel-goto-block-head)
  (if (looking-at-p "^#\\+NAME")
      (progn
        (re-search-forward ": ")
        (call-interactively 'cua-set-mark)
        (my-org-end-of-line))
      (progn
        (insert "\n")
        (previous-line)
        (insert "n")
        (call-interactively 'my/yas-complete))))
(define-key org-mode-map (kbd "C-c N") 'org-babel-add-name)


(defun org-babel-previous-src-name ()
  (save-excursion
    (org-babel-previous-src-block 1)
    (org-element-property :name (org-element-at-point))))

(defun org-babel-previous-results-name ()
  (save-excursion
    (org-babel-previous-src-block 1)
    (car (org-element-property :results (org-element-at-point)))))

;; (defun org-babel-previous-block-name ()
;;   (or (org-babel-previous-block-name)
;;       (org-babel-previous-results-name)))

(defun org-babel-add-stdin-arg-for-previous-block ()
  (interactive)
  (if (org-in-src-block-p)
      (let ((prevsrc (org-babel-previous-src-name))
            (prevres (org-babel-previous-results-name)))
        (if prevres
            (org-babel-insert-header-arg "inr" prevres)
          (if prevsrc
              (org-babel-insert-header-arg "inb" prevsrc))))))

(define-key org-mode-map (kbd "M-!") 'org-babel-add-stdin-arg-for-previous-block)

(defun org-get-src-block-language ()
  (interactive)
  (let* ((info (org-babel-get-src-block-info))
         (lang (if info
                   (car info))))
    (if (called-interactively-p)
        (my-copy lang)
      lang)))

(defun get-src-block-language ()
  (interactive)
  ;; (markdown-code-block-lang)

  (cond
   ((major-mode-p 'org-mode)
    (org-get-src-block-language))
   ((major-mode-p 'markdown-mode)
    (or
     (markdown-code-block-lang)
     "markdown"))
   ((major-mode-p 'eww-mode)
    (read-string-hist (concat "egr " query " lang: ")))
   (t (buffer-language))))


;; Use generic instead of this in templates
(defun org-babel-execute:awk (body params)
  (let* ((coding-system-for-read 'utf-8) ;use utf-8 with sub-processes
         l         (coding-system-for-write 'utf-8)
         (in-file (org-babel-temp-file "awk-")))
    (with-temp-file in-file
      (insert (org-babel-expand-body:generic body params)))
    (org-babel-eval (concat "awk -f " (org-babel-process-file-name in-file)) "")
    nil))


(provide 'my-babel)