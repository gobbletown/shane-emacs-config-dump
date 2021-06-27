(require 'semantic)


;; I re-enabled semantic mode because it seems to be tightly integrated
;; into spacemacs

;; This is causing my lisp to go slow as hell, i think; https://github.com/company-mode/company-mode/issues/525
;; When writing comments, it will keep busting in and preventing me from typing
;;(semantic-mode -1)

;; disabling semantic makes imenu not work in spacemacs
;; enable semantic again

;; (type-of imenu-create-index-function)
;; symbol

;; Semantic is breaking imenu in python. So disable semantic. It's problematic and slow. Keep it disabled.




;; Variable: semantic-inhibit-functions List of functions to call with
;; no arguments before semantic sets up a buffer.
;; If any of these
;; functions returns non-nil, the current buffer is not setup to use
;; Semantic.
(setq semantic-inhibit-functions
      (list ;; (lambda () (not (and (featurep 'cc-defs)
       ;;                 c-buffer-is-cc-mode)))
       (lambda () (> (buffer-lines) 200))))


;; This will make C-c , work in org-mode again
(add-hook 'org-mode-hook '(lambda() (set
                                (make-local-variable 'semantic-mode) nil)))


;; This is enough to unbind all the semantic keys
(define-key semantic-mode-map (kbd "C-c ,") nil)

(provide 'my-semantic)