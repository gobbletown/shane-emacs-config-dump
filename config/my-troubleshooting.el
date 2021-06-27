(provide 'my-troubleshooting)

;; semantic-mode makes it impossible to write emacs-lisp
;; It can take 10 minutes to generate suggestions after typing a single character

;; Lispy affects Imenu for Emacs Lisp?
;; It seems to be a bug in semantic-mode: when turned on, it sets
;; imenu-create-index-function to semantic-create-imenu-index, which
;; works only when semantic-mode is on. However, when semantic-mode is
;; turned off, it doesn't reset imenu-create-index-function to a sane
;; value.
(defun my/fix-imenu-function ()
  "Fixes the imenu function when imenu doesn't show any results. Semantic leaves the index function set. When semantic is not running, imenu doesn't work."
  (interactive)
  (if (not (minor-mode-enabled semantic-mode)) (setq-local imenu-create-index-function 'imenu-default-create-index-function)))