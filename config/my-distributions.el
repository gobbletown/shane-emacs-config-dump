(defun is-spacemacs ()
  (cl-search "SPACEMACS" my-daemon-name))

(defun is-magit ()
  (cl-search "magit" my-daemon-name))

(if (is-magit)
    (progn
      (rainbow-mode)                    ; this one's probably not necessary
      ;;(my/with 'rainbow-delimiters
      ;;         (global-rainbow-delimiters-mode -1)
      ;;         (global-rainbow-identifiers-always-mode -1))
      ;;
      ))

(provide 'my-distributions)
