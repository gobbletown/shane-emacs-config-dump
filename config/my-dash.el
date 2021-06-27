;; To fix a bug in dash
(defalias 'backward-search 'search-backward)

;; This was removed from dash and dash-functional
;; But broke something in lsp, so I have copied from
;; sp +/"(defun -compose (&rest fns)" "$MYGIT/magnars/dash.el/dash-functional.el"s
;; -compose, etc

(load "/home/shane/var/smulliga/source/git/magnars/dash.el/dash-functional.el")

(provide 'my-dash)