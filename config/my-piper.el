(use-package piper
  :load-path "/home/shane/source/git/config/emacs/manual-packages/emacs-piper"
  :bind ("C-c C-\\" . piper))

(define-key global-map (kbd "C-c C-]") 'piper-user-interface)

;; This makes it less noisy
(defun piper-around-advice (proc &rest args)
  (let ((res (shut-up (apply proc args))))
    res))
(advice-add 'piper :around #'piper-around-advice)

;; (straight-use-package
;;  '(emacs-piper :type git :host gitlab :repo "howardabrams/emacs-piper"))

(if (cl-search "SPACEMACS" my-daemon-name)
    (use-package piper
      :load-path "/home/shane/source/git/config/emacs/manual-packages/emacs-piper"
      :config
      (spacemacs/declare-prefix "o |" "piper")
      (spacemacs/set-leader-keys
        "|"     '("piper-ui"        . piper-user-interface)
        "o | |" '("piper-locally"   . piper)
        "o | d" '("other-directory" . piper-other)
        "o | r" '("piper-remotely"  . piper-remote))))

(provide 'my-piper)