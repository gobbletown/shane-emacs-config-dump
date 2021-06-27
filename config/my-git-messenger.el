(require 'my-mode)
(require 'pretty-hydra)
(require 'major-mode-hydra)

;; Pop up last commit information of current line
;; This requires stuff taken from centaur emacs
;; Rather than include it, consider using centaur emacs
;; $MYGIT/seagle0128/.emacs.d/lisp/init-hydra.el
;; (use-package git-messenger
;;   :bind (:map vc-prefix-map
;;               ("p" . git-messenger:popup-message)
;;               :map git-messenger-map
;;               ("m" . git-messenger:copy-message))
;;   :pretty-hydra
;;   ((
;;     ;; :title (pretty-hydra-title "Git Messenger" 'alltheicon "git")
;;     :color blue :quit-key "q")
;;    ("Actions"
;;     (("s" git-messenger:popup-show "Show")
;;      ;; ("S" git-messenger:popup-show-verbose "Show verbose")
;;      ("c" git-messenger:copy-commit-id "Copy hash")
;;      ;; ("d" git-messenger:popup-diff "Diff")
;;      ("m" git-messenger:copy-message "Copy message")
;;      ("," (catch 'git-messenger-loop (git-messenger:show-parent)) "Go Parent"))))
;;   :init
;;   (setq git-messenger:show-detail t
;;         git-messenger:use-magit-popup t)

;;   (with-no-warnings
;;     (defun my-git-messenger:popup-message ()
;;       "Popup message with `posframe', `pos-tip', `lv' or `message', and dispatch actions with `hydra'."
;;       (interactive)
;;       (let* ((vcs (git-messenger:find-vcs))
;;              (file (buffer-file-name (buffer-base-buffer)))
;;              (line (line-number-at-pos))
;;              (commit-info (git-messenger:commit-info-at-line vcs file line))
;;              (commit-id (car commit-info))
;;              (author (cdr commit-info))
;;              (msg (git-messenger:commit-message vcs commit-id))
;;              (popuped-message (if (git-messenger:show-detail-p commit-id)
;;                                   (git-messenger:format-detail vcs commit-id author msg)
;;                                 (cl-case vcs
;;                                   (git msg)
;;                                   (svn (if (string= commit-id "-")
;;                                            msg
;;                                          (git-messenger:svn-message msg)))
;;                                   (hg msg)))))
;;         (setq git-messenger:vcs vcs
;;               git-messenger:last-message popuped-message
;;               git-messenger:last-commit-id commit-id)
;;         (run-hook-with-args 'git-messenger:before-popup-hook popuped-message)
;;         (git-messenger-hydra/body)
;;         (cond ((posframe-workable-p)
;;                (let ((buffer-name "*git-messenger*"))
;;                  (with-current-buffer (get-buffer-create buffer-name)
;;                    (let ((inhibit-read-only t)
;;                          (markdown-enable-math nil))
;;                      (erase-buffer)
;;                      (markdown-mode)
;;                      (flycheck-mode -1)
;;                      (insert popuped-message)))
;;                  (posframe-show buffer-name
;;                                 :internal-border-width 8
;;                                 :font centaur-childframe-font)
;;                  (unwind-protect
;;                      (push (read-event) unread-command-events)
;;                    (posframe-delete buffer-name))))
;;               ((fboundp 'pos-tip-show) (pos-tip-show popuped-message))
;;               ((fboundp 'lv-message)
;;                (lv-message popuped-message)
;;                (unwind-protect
;;                    (push (read-event) unread-command-events)
;;                  (lv-delete-window)))
;;               (t (message "%s" popuped-message)))
;;         (run-hook-with-args 'git-messenger:after-popup-hook popuped-message)))
;;     (advice-add #'git-messenger:popup-close :override #'ignore)
;;     (advice-add #'git-messenger:popup-message :override #'my-git-messenger:popup-message)))

(define-key my-mode-map (kbd "M-m g M") #'git-messenger:popup-message)

(provide 'my-git-messenger)