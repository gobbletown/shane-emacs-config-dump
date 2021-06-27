;; Make these bindings happen last so emacs fully loads before creating bindings

(if (cl-search "SPACEMACS" my-daemon-name)
  (progn
    (define-key spacemacs-default-map-root-map (kbd "M-m C-w d") nil)
    (define-key spacemacs-default-map-root-map (kbd "M-m a E") nil)))

(sslk "lg=" 'position-list-nav/body)

(sslk "lVc" 'toggle-chrome)
(sslk "lVr" 'toggle-read-only)
(sslk "lay" #'daemons)
; (eval `(sslk "laY" ,(make-etui-cmd "chkservice" nil)))
(sslk "laY" (make-etui-cmd "chkservice" nil))
(sslk "law" 'aws-instances)
(sslk "lap" #'list-processes)
(sslk "laS" #'list-clients)
(sslk "lal" #'bufler)
(sslk "laU" #'bluetooth-list-devices)
(sslk "lag" #'gist-list)
(sslk "laN" #'gnus)
(sslk "lat" #'helm-top)
(sslk "laT" #'list-timers)
(sslk "laP" #'proced)
(sslk "lab" #'dap-hydra/body)
(sslk "laa" #'dap-ui-breakpoints)
(sslk "lad" #'docker)
(sslk "lax" #'mitmproxy)
(sslk "laD" #'prodigy)
(sslk "lah" #'htop)
(sslk "laH" #'hackernews)
(sslk "lan" #'ibuffer)
(sslk "law" #'aws-instances)
(sslk "lak" #'kubernetes-overview)
(sslk "laf" #'deft)
(sslk "laB" #'calibredb)
(sslk "lae" #'deer)
(sslk "laio" #'iotop)
(sslk "laie" #'erc)
;; (sslk "laie" #'run-erc)
(sslk "laC" #'calc)
(sslk "lact" #'cryptop)
(sslk "laE" 'elfeed)
(sslk "la)" #'emoji-cheat-sheet-plus-buffer)

;; (define-key my-mode-map (kbd "M-m S f") #'flyspell-correct-at-point)
;; (define-key my-mode-map (kbd "M-m S p") #'flyspell-goto-previous-error)
;; (define-key my-mode-map (kbd "M-m S n") #'flyspell-goto-next-error)

;; Frustratingly, M-m w still interferes
(loop for d in
      (mapcar
       (lambda (l)
         `(define-key ,(third l) (kbd ,(concat "M-m " (second l) " " (car (car l)))) ,(second (car l))))
       (-cx '((";" 'ansi-zsh)
              ("'" 'eshell)
              ("\"" 'nw-term)
              ("s" 'eshell-sph)
              ("S" 'eshell-spv)
              ("g" 'split-window-below)
              ("G" 'split-window-right))
            '("w"
              "C-w")
            '(my-mode-map
              global-map)))
      do
      (ignore-errors
        (eval d)))

(ignore-errors
  (define-key my-mode-map (kbd "M-m w ;") #'ansi-zsh)
  (define-key my-mode-map (kbd "M-m w '") #'eshell)
  (define-key my-mode-map (kbd "M-m w \"") #'nw-term)

  (define-key my-mode-map (kbd "M-m w s") #'eshell-sph)
  (define-key my-mode-map (kbd "M-m w S") #'eshell-spv)

  (define-key my-mode-map (kbd "M-m w g") #'split-window-below)
  (define-key my-mode-map (kbd "M-m w G") #'split-window-right)

  ;; This overrides spacemacs bindings -- that's ok
  (define-key my-mode-map (kbd "M-m w v") #'e/sph-zsh)
  (define-key my-mode-map (kbd "M-m w V") #'e/spv-zsh)

  (define-key my-mode-map (kbd "M-m w N") #'spv-new-buffer)
  (define-key my-mode-map (kbd "M-m w n") #'sph-new-buffer)

  (define-key my-mode-map (kbd "M-m w O") #'win-swap)
  (define-key my-mode-map (kbd "M-m w o") #'win-swap)

  (define-key global-map (kbd "M-m w d") 'sph-next)
  (define-key global-map (kbd "M-m w D") 'spv-next)
  (define-key global-map (kbd "M-m w e") 'sps-next))


;; (sslk "ld" nil)
(sslk "ld?" #'ag-glossaries)
(sslk "ldo" 'fz-find-ws)
(sslk "ldO" 'ag-ws)
;; (sslk "lf" (df fz-find-file (e (fz (cat "$HOME/notes2018/files.txt")))))
(sslk "lT" 'fz-find-config)
(sslk "lO" 'fz-find-ws)

(define-key my-mode-map (kbd "M-l DEL") (df fz-find-dir (e (fz (cat "$NOTES/directories.org")))))

(progn
  ;; mu
  ;; Don't unminimise. e unminimises anyway 
  (ms "/M-m/{p;s/M-m/M-l/}" (define-key my-mode-map (kbd "M-m d DEL") 'fz-tm-shortcuts))
  (sslk "ldzw" 'fz-find-ws)
  (sslk "ldW" 'fz-find-ws)
  (sslk "ldG" 'ag-glossaries)
  (sslk "ldg l" 'swiper-glossaries)
  (sslk "ld6" (dff (e "$EMACSD/packages26")))
  (sslk "ld7" (dff (e "$EMACSD/packages27")))
  (sslk "ld8" (dff (e "$EMACSD/packages28")))
  (sslk "ldm" (dff (e "$NOTES/ws/music")))
  (sslk "lds" (dff (e "$SCRIPTS")))
  (sslk "ldq" (dff (e "$MYGIT/semiosis/pen.el")))
  (sslk "lda" (dff (e "$MYGIT/semiosis/prompts/prompts")))
  (sslk "ldx" (dff (e "$MYGIT/semiosis/examplary")))
  (sslk "ldd" (dff (e "$DUMP")))
  (sslk "ldD" (dff (e "$DUMP/downloads")))
  (sslk "ldn" (dff (e "$NOTES")))
  (sslk "ldM" (dff (e "$EMACSD/manual-packages")))
  (sslk "ldzG" (dff (sps "select-git-repo")))

  ;; unminimise for some of them
  (mu
   (sslk "ldzg" (df fz-select-git-repo
                    (let* ((sel (fz (chomp (sn "list-git-repos"))))
                           (dir (concat "$MYGIT/" sel)))
                      (if
                          (f-directory-p dir)
                          (e (concat "$MYGIT/" sel)))))))
  (sslk "ldzw" (dff (sps "select-ws-dir")))
  (sslk "ldzp" (dff (sps "select-python-package")))
  (sslk "lFw" (dff (e "$NOTES/ws/english/words.txt")))
  (sslk "lFR" (dff (e "$NOTES/read.org")))
  (sslk "lFH" (dff (e "$NOTES/watch.org")))
  (sslk "lFr" (dff (e "$NOTES/remember.org")))
  (sslk "lFg" (dff (e "$NOTES/glossary.txt")))
  (sslk "lFt" (dff (e "$NOTES/todo.org")))
  (sslk "lFn" (dff (e "$NOTES/need.org")))
  (sslk "lFf" (dff (e "$NOTES/files.txt")))
  (sslk "lFF" (dff (e "$HOME/filters/filters.sh")))
  (sslk "lFe" (dff (e "$NOTES/examples.txt")))
  (sslk "lFW" (dff (e "$NOTES/ws/french/words.txt")))
  (sslk "lFp" (dff (e "$NOTES/perspective.org")))
  (sslk "lFk" (dff (e "$NOTES/keep-in-mind.org")))
  (sslk "lFP" (dff (e "$NOTES/plan.org")))
  ;; (sslk "l3dw" (dff (my-open-dir "$MYGIT/takaheai/otagoai-website")))
  (sslk "ldgg" (dff (my-open-dir "$MYGIT")))
  (sslk "ldO" 'fz-find-ws)
  (sslk "ldE" (dff (my-open-dir "$EMACSD")))
  (sslk "ldJ" (dff (my-open-dir "$NOTES/ws/jobs")))
  (sslk "ldc" (dff (my-open-dir "$EMACSD/config")))
  (sslk "ldC" (dff (my-open-dir "$EMACSD/config")))
  (sslk "ldL" (dff (my-open-dir "$HOME/glossaries")))
  (sslk "ldb" (dff (my-open-dir "$DUMP$NOTES/ws/blog/blog")))
  (sslk "ldB" (dff (my-open-dir "$HOME/blog/posts")))
  (sslk "ldt" (dff (my-open-dir "$DUMP/torrents")))
  (sslk "ldh" (dff (my-open-dir "$HOME")))
  (sslk "ldw" (dff (my-open-dir "$NOTES/ws")))
  (sslk "ldo" (dff (my-open-dir "$NOTES/ws"))))

(sslk "lA" (df ansi-zsh (etansi zsh)))
(sslk "lrre" (df edit-emacs (e "$MYGIT/config/emacs/emacs")))
(sslk "lrrp" (df edit-python (e "$MYGIT/config/python/pythonrc.full.py")))
(sslk "lrrr" (df edit-racket (e "$HOME/.racketrc")))
(sslk "lrrs" (df edit-selected (e "$MYGIT/config/emacs/config/my-selected.el")))
(sslk "lrr." (df edit-my-spacemacs (e "$MYGIT/config/emacs/config/my-spacemacs.el")))
(sslk "lrrv" (df edit-my-spacemacs (e "$MYGIT/config/emacs/config/my-evil.el")))

;; (sslk "lrm" #'record-keyboard-macro-string)
;; (sslk "lrn" #'yank-function-from-binding)

;; (sslk "lpgr" (df go-reading (e "$HOME/.racketrc")))

;; (sslk "lghc/" #'github-search-user-clone-repo)
(sslk "lghc/" #'my-github-search-and-clone)

(sslk "lpJ" (df play-js (et playground js)))
(sslk "lpj" (df tm-play-js (etm playground js)))
(sslk "lpG" (df play-github (et playground github)))
;; (sslk "lpg" (df tm-play-github (etm playground github)))
;; (sslk "lp." (df edit-my-spacemacs (e "$MYGIT/config/emacs/config/my-spacemacs.el")))
(sslk "lp." (df edit-play-github (e (b which playground))))


;; This broke emacs startup
;; (sslk "lp." (eval `(df edit-play-github (e ,(b which playground)))))

;; (spacemacs/declare-prefix "lm" "sh-sh")

(sslk "lgde" #'end-of-defun)


;; (sslk "l7S" #'my/doc-thing-at-point-immediate-spv)
;; (sslk "l7s" #'my/doc-thing-at-point-immediate)

(sslk "l7" #'my-selection-note)
(sslk "l9" #'search-google-for-doc)
(sslk "l8" #'google-for-docs)
;; (sslk "l9" #'search-google-for-doc)


(sslk "lgf" 'find-file-at-point)


;; ;; Anything binding that starts with M-l or M-l should be a global map
;; %!sed "/\"M-[l']/{s/global-map/my-mode-map/g}"

;; (sslk "lm" (df sh-general (et sh-general)))
;; (define-key global-map (kbd "M-m M-m") 'magit-status)
;; (define-key global-map (kbd "M-m M-m") (df sh-general (et "sh-general")))
;; (define-key global-map (kbd "M-m M-m") 'magit-status)

(sslk "lN" 'magit-status)


;; Can't do this because it will overwrite the hydra
;; (sslk "le" 'my-revert)

;; why does the below sometimes not get loaded for non-spacemacs emacs?
;; Beacuse they must be defined after the prefix is defined.
;; Do not redefine the M-m prefix here.
;; Add prefixes to:
;; vim +/"define-prefix-command" "$EMACSD/config/shane-minor-mode.el"
(define-key my-mode-map (kbd "M-l C-s") #'my-swipe)
(define-key my-mode-map (kbd "M-' C-s") #'my-swipe)

(sslk "lD" 'my-swipe)

;; Because this is a global map it no longer works in spacemacs
;; This is because global maps are weaker

;; This is a little unnecessary now that I can open helm contents in vim
(define-key my-mode-map (kbd "M-l / C-i") #'tvipe-completions)

;; Keep it as diff
;;(define-key my-mode-map (kbd "M-l M-'") #'run-line-or-region-in-tmux)
;;(define-key my-mode-map (kbd "M-' M-'") #'run-line-or-region-in-tmux)

;; This broken magit-diff-unstaged-this
;; (sslk "l'" 'helm-M-x)

(sslk "lt" 'sh/git-add-all-below)
;; (sslk "lL" 'lispify-unlispify)
(sslk "lL" 'my-flycheck-list-errors)
(sslk "lkJ" 'compile-run-term)
(sslk "lk," 'compile-run-compile)
(sslk "lk<" 'compile-run-tm-ecompile)

;; (define-key my-mode-map (kbd "M-l M-L") #'flycheck-list-errors)
;; (define-key my-mode-map (kbd "M-' M-L") #'flycheck-list-error)


(sslk "ly" 'my-copy-link-at-point)
(sslk "ljh" 'cheat-sh)
(sslk "l." 'kill-buffer-immediately)
(sslk "lfP" 'fi-text-to-paras-nosegregate)

;; (define-key my-mode-map (kbd "M-l M-y") #'link-hint-copy-link-at-point)
;; (define-key my-mode-map (kbd "M-' M-y") #'link-hint-copy-link-at-point)

;; Overrides and things that sslk doesnt support
(define-key global-map (kbd "M-m C-s") #'my-swipe)



;; overrides
;; Global map so it works from term
(loop for (m k) in (-cartesian-product '(global-map my-mode-map)
                                       '("M-l" "M-'"))
      do (eval
          `(progn (define-key ,m (kbd ,(concat k " M-k m")) #'my-helm-imenu)
                  (define-key ,m (kbd ,(concat k " k")) #'bury-buffer)
                  (define-key ,m (kbd ,(concat k " s")) #'sph)
                  (define-key ,m (kbd ,(concat k " S")) #'spv)
                  (define-key ,m (kbd ,(concat k " y")) #'link-hint-copy-link)
                  (define-key ,m (kbd ,(concat k " M-e")) #'my-revert)
                  (define-key ,m (kbd ,(concat k " M-w")) #'my-save))))


;; (define-key global-map (kbd "M-l M-k m") #'helm-imenu)
;; (define-key global-map (kbd "M-' M-k m") #'helm-imenu)
;; (define-key my-mode-map (kbd "M-l M-k m") #'helm-imenu)
;; (define-key my-mode-map (kbd "M-' M-k m") #'helm-imenu)

;; (define-key global-map (kbd "M-m M-e") 'my-revert)
;; (define-key my-mode-map (kbd "M-m M-e") 'my-revert)


(define-key global-map (kbd "M-m M-m") 'magit-status)
(define-key my-mode-map (kbd "M-m M-m") 'magit-status)

;; (define-key global-map (kbd "M-l M-e") 'magit-status)
;; (define-key my-mode-map (kbd "M-l M-e") 'magit-status)


(provide 'my-post-bindings)
