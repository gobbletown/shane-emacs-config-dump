(require 'my-term-modes)

;; This is mainly just some place to organise my TUIs

;; See also:
;; j:my-term-modes-commands

(defset my-list-of-tuis '(
                          ;; octotui needs a tmux wrapper
                          ("octotui" "github stats")
                          ("github-stats" "github stats")
                          ("ncdu" "ncurses du")
                          k9s
                          ("nmtui" "network manager")
                          ("alsamixer" "alsa volume control")
                          gpg-tui
                          tig))


;; (let ((completion-extra-properties '(:annotation-function fz-completion-second-of-tuple-annotation-function)))
;;   (fz my-list-of-tuis
;;       nil nil "run-tui: "))

(defun run-tui (tuicmd &optional pak)
  (interactive (list (fz my-list-of-tuis
                         nil nil "run-tui: ")))
  ;; (make-or-run-etui-cmd tuicmd)

  ;; Setting TERM is not sufficient for octotui. Need tmux
  ;; export TERM=xterm-256color;
  (term-nsfa (tmuxify-cmd (concat "eval `resize`; " tuicmd ";pak"))))

(define-key global-map (kbd "H-T") 'run-tui)


(provide 'my-tui-terminal-user-interfaces)