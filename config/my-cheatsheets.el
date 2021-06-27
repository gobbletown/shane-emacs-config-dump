(defun show-relevant-cheatsheats ()
  (interactive))

;; Perhaps I could use context functions and look for cheatsheet entries?
;; Nah.

;; I need to be able to select from and edit relevant cheatsheet files for the context
;; I really need something like a fork of context functions.

(defvar eww-patchup-url-alist nil)
;; (setq eww-patchup-url-alist nil)
(add-to-list 'plantuml-mode '(plantuml-mode . ()))

(define-key global-map (kbd "H-q") 'show-relevant-cheatsheats)

(provide 'my-cheatsheets)