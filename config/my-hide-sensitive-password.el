(require 'password-mode)
(provide 'my-hide-sensitive-password)

;; This is disabled because it breaks things
;; Such as putting a text block around this
;; $HOME/notes2018/ws/emacs/troubleshooting/scratch/password-mode-broken.org

;; (_ns disabled
;;      ;; Password mode enables you to put arbitrary passwords into text
;;      ;; But it does not match the actual password
;;      (add-hook 'text-mode-hook 'password-mode)
;;      ;; There is a prefix regexp used to find the text before the password:
;;      (setq password-mode-password-prefix-regexs '("[Pp]assword:?[[:space:]]+" "[Pp]asswort:?[[:space:]]+"))
;;      ;; There is also a regexp used to find the actual password:
;;      ;; (defcustom password-mode-password-regex
;;      ;;   "\\([[:graph:]]*\\)")
;;      )

