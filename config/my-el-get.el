(require 'el-get)


(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    ;; I needed to also enable emacs-lisp-mode because I have a failsafe advice thing
    (emacs-lisp-mode)
    (eval-print-last-sexp)))

(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")

;; Sigh. Problems.
;; (el-get 'sync)


;; (setq calibre-db (concat calibre-root-dir "/metadata.db"))
;; (add-to-list 'el-get-sources
;;              `(:name calibre-query
;;                      :type git
;;                      :url "git://github.com/whacked/calibre-query.el.git"
;;                      :features "calibre-query"))

(provide 'my-el-get)