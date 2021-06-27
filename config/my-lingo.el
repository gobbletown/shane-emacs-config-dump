(require 'my-prefixes)

(defun copy-fast (s)
  (interactive)
  (with-temp-buffer
    (insert s)
    (clipboard-kill-region (point-min) (point-max))))

(defun get-clql (&optional verbose)
  "Gets CLQL for the selection."
  (interactive)

  ;; Make it so this visibly puts the clql into the terminal, so I can tuck it away and return to it if I want
  ;; Any lingo tooling command should have results apear here
  ;; localhost_lingo-tooling:

  (if (not verbose)
      (defset opts " -noverbose ")
    (defset opts ""))

  (if (selected-p)
      (let ((clql (e/chomp
                   (sh-notty
                    (concat
                     "lingo -focus -clql " opts " tooling query-from-offset --final-fact-properties "
                     (full-path)
                     " "
                     (str (- (region-beginning) 1))
                     " "
                     (str (- (region-end) 1))
                     )))))
        ;; (copy-fast clql)
        ;; (message clql)
        ;; (ns clql)
        )))

(defun open-in-sublime ()
  (interactive)
  (sh-notty (concat "sublime " (e/q (str (buffer-file-name))))))

(defun lingo-insert-project-name ()
  (interactive)
  (insert (e/chomp (bp u dn | u bn (buffer-file-name)))))

(defun lingo-extract-backtick-test-cases ()
  "Gets everything that's between a pair of backticks."
  (interactive)
  (cfnb "extract-backtick-test-cases.sh"))

(defun lingo-extract-clql-from-yaml ()
  "Gets everything that's between a pair of backticks."
  (interactive)
  (cfnb "extract-clql-from-yaml"))

(defun lingo-strip-clql-from-yaml ()
  (interactive)
  (cfnb "strip-clql-from-yaml"))

(defun paste-clql-in-yaml ()
  (interactive)
  (cfnb "paste-clql-in-yaml"))

(defun indent-clql-for-yaml ()
  (interactive)
  (cfnb "indent-clql-for-yaml"))

(defun lingo-simplify-review-dump ()
  (interactive)
  (cfnb "lingo-simplify-review-dump.sh"))

(defun clql-annotate ()
  (interactive)
  (cfnb "clql-annotate"))

(defun clql-migrate ()
  (interactive)
  (cfnb "clql-migrate"))

(defun yaml-basic-conform ()
  (interactive)
  (cfnb "basic-conform-yaml"))

(defun yaml-migrate ()
  (interactive)
  (cfnb "migrate-codelingo-yaml"))

(defun migrate-tenet ()
  (interactive)
  (cfnb "migrate-tenet"))

(defun yaml-add-rewrite ()
  (interactive)
  (cfnb "add-rewrite-to-yaml"))

(defun clql-playgroundify ()
  (interactive)
  (cfnb "clql-playgroundify"))

(defun lingo-error-annotate ()
  (interactive)
  (cfnb "lingo-error-annotate"))

(defun clql-lint ()
  (interactive)
  (cfnb "clql-lint"))

(defun clql-remove-probable-extraneous-properties ()
  "Useful as I am refining some clql for the first time."
  (interactive)
  (cfnb "clql-remove-probable-extraneous-properties.sh"))

(defun lingo-extract-clql-from-yaml-to-file ()
  "Gets everything that's between a pair of backticks."
  (interactive)
  (find-file (sh-notty (concat "yaml2clql " (e/q (buffer-file-name))))))

(defun slack-last-error-link ()
  (interactive)
  (b slack-last-error-link))


(defun clpl-rewrite (lang bundletenet platform)
  "Run rewrites on the pipeline for a given bundle tenet and lang"
  (interactive (list
                (fzh '(go php py))
                (fz (b ci -t 3600 cl-list-rewrite-tenets | pyslice / -3:-1))
                (fzh '(staging paas dev-paas))))

  (if (not platform)
      (setq platform "staging"))

  (if (not lang)
      (setq lang "go"))

  (if (not bundletenet)
      (setq bundletenet "code-review-comments/declare-empty-slice"))

  (let ((repos-cmd (concat
                    "ci -t 3600 cl-list-repos-for-ext "
                    lang
                    " | git-dirs-to-urls ")))
    (eval
     `(b tm -te -d nw -nvt -args sshp -t p tmnp -u gen-pipelines -noforceclmaster -prefer-local-tenets -skipbasiccol -skipbundlescol -skipimpactbundlescol -ftl 1000 -hc -dsa -platform ,platform -rmr -c -real -f -fw -j 4 -cs -b -u -repos_cmd ,repos-cmd -DREWRITE_BUNDLETENET ,bundletenet))))


;; cl-defun has trouble with interactive
(defun clpl-get-rewrite-branches (since tenetname)
  "Get rewrite branches created since time for a tenet"
  (interactive (list
                (read-string "since:" "2 weeks ago")
                (fz (b ci -t 3600 cl-list-rewrite-tenets | pyslice / -2:-1))))

  (if (not since)
      (setq since "3 weeks ago"))

  (if (not tenetname)
      (setq tenetname "lower-case-constant-values"))

  (let ((inner-cmd (concat "osspipe rewrites json " tenetname " " since " | cl-rewrite-branch-from-json | v")))
    (eval (read (concat "(b tm -te -d nw -nvt " (q inner-cmd) ")")))))


(defun clpl-create-rewrite-branches (since)
  "Create rewrite branches for diffs created since time for a tenet"
  (interactive (list (read-string "since:" "2 weeks ago")))

  (if (not since)
      (setq since "3 weeks ago"))

  ;; sshp -t p tmnp -u automate-prs -c -bot -nn -rc -since "1 day ago"

  (let ((inner-cmd (concat "sshp -t p tmnp -u automate-prs -c -bot -nn -rc -since " (q since))))
    (eval (read (concat "(b tm -te -d nw -pak -nvt " (q inner-cmd) ")")))))



(defun fzf-remove-fact ()
  (interactive)
  (let ((result (tm-filter-facts)))
    ;; (if (y-or-n-p-with-timeout "replace current buffer contents?" 1 nil)
    ;;     (set-buffer-contents result)
    ;;   (new-buffer-from-string result))

    (if (not (empty-string-p result))
        (set-buffer-contents result))

    ;; (if (y-or-n-p "replace current buffer contents?")
    ;;     (set-buffer-contents result)
    ;;   (new-buffer-from-string result))
    ))

(global-set-key (kbd "M-q M-r M-f") 'fzf-remove-fact)


(define-derived-mode cltenet-mode yaml-mode "CodeLingo Tenet"
  "CodeLingo Tenet mode")


(provide 'my-lingo)