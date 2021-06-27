;; This is for all things replacement of existing =sh-= scripts


(defun hsqf (cmdname)
  "Run a command from history"
  (interactive (list (read-string-hist "hsqf command:")))
  ;; (nw "hsqf git")
  (let* ((selected-command (fz (mnm (sh-notty (concat "hsqc " cmdname))) nil nil "hsqf past cmd: "))
         (wd (uq (s-replace-regexp "^cd \"\\([^\"]+\\)\".*$" "\\1" selected-command)))
         (cmd (s-replace-regexp (concat "^[^;]*; \\([^ ]+\\).*") "\\1" selected-command)))

    (cond ((string-equal cmd "hsqf")
           (progn
             (setq cmd (s-replace-regexp (concat "^[^;]*; [^ ]+ \\([^ ]+\\).*") "\\1" selected-command))
             (hsqf cmd)))

          ;; TODO Make this work for the elisp gc
          ;; ((string-equal cmd "gc") x)

          (t (sps selected-command)))

    ;; (nw cmd)
    ))

;; (defun hsqf-hsqf ()
;;   (interactive)
;;   ;; (nw "hsqf git")
;;   (nw (fz (mnm (sh-notty "hsqc hsqf")))))

(mu
 (ms "/M-m/{p;s/M-m/M-l/}"
     (define-key my-mode-map (kbd "M-m H Z") (dff (find-file "$HOME/.zsh_history")))
     (define-key my-mode-map (kbd "M-m H B") (dff (find-file "$HOME/.bash_history")))
     ;; (define-key my-mode-map (kbd "M-m H G") (dff (hsqf "gh")))
     (define-key my-mode-map (kbd "M-m H c") (dff (hsqf "gc")))
     (define-key my-mode-map (kbd "M-m H b") (dff (hsqf "cr")))
     (define-key my-mode-map (kbd "M-m H H") (dff (hsqf "hsqf")))
     (define-key my-mode-map (kbd "M-m H r") (dff (hsqf "readsubs")))
     (define-key my-mode-map (kbd "M-m H A") (dff (hsqf "new-article")))
     ;; (define-key my-mode-map (kbd "M-m H N") (dff (hsqf "new-project")))
     (define-key my-mode-map (kbd "M-m H N") 'new-project)
     (define-key my-mode-map (kbd "M-m H K") (dff (hsqf "killall")))
     (define-key my-mode-map (kbd "M-m H X") (dff (hsqf "xrandr")))
     (define-key my-mode-map (kbd "M-m H F") (dff (hsqf "feh")))
     (define-key my-mode-map (kbd "M-m H P") (dff (hsqf "play-song")))
     (define-key my-mode-map (kbd "M-m H D") (dff (hsqf "docker")))
     (define-key my-mode-map (kbd "M-m H g") (dff (hsqf "git")))
     (define-key my-mode-map (kbd "M-m H O") (dff (hsqf "o")))
     (define-key my-mode-map (kbd "M-m H o") (dff (hsqf "o")))
     (define-key my-mode-map (kbd "M-m H y") (dff (hsqf "yt")))
     (define-key my-mode-map (kbd "M-m H C") (dff (hsqf "hcqf")))
     (define-key my-mode-map (kbd "M-m H h") #'hsqf)))


(define-key sh-mode-map (kbd "C-c C-o") 'org-open-at-point)

(provide 'my-sh)