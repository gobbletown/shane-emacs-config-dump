(provide 'eldoc-eval)

;; I fixed it by making M-Y M-Y run the functions manually instead of using keyboard macros
;; This breaks M-Y M-Y. But only because it rebinds C-@
;; I should be able to work around that
(eldoc-in-minibuffer-mode 1)
;; (eldoc-in-minibuffer-mode -1)

;; pp+
;; This enables pp for the minibuffer
(setq eldoc-eval-preferred-function 'pp-eval-expression)

;; This disables it
(setq eldoc-eval-preferred-function 'eval-expression)

(provide 'my-eldoc-eval)