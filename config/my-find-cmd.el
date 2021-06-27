(require 'find-cmd)

(provide 'my-find-cmd)

;; Here I can list out all sorts of find commands for searching for
;; various things. I can use them in my shells.

;; TODO -- use find in shell commands, in emacs lisp
;; (sh-notty (find-cmd '(prune (name ".svn" ".git" ".CVS"))
;;                     '(and (or (name "*.pl" "*.pm" "*.t")
;;                               (mtime "+1"))
;;                           (fstype "nfs" "ufs"))))


;; (find-cmd '(prune (name ".svn" ".git" ".CVS"))
;;           '(or (name "*.pl" "*.pm" "*.t")
;;                (mtime "+1")))