(require 'eldoc)

(require 'eldoc-box)

(define-key global-map (kbd "C-x C-h") nil)

(advice-add 'eldoc-print-current-symbol-info :around #'ignore-errors-around-advice)
;; (advice-add 'lsp-eldoc-function :around #'ignore-errors-around-advice)
;; (advice-add 'lsp-ui-doc--disable-mouse-on-prefix :around #'ignore-errors-around-advice)
;; (advice-add 'lsp-hover :around #'ignore-errors-around-advice)
;; (advice-remove 'lsp-eldoc-hook #'ignore-errors-around-advice)
;; (advice-remove 'lsp-eldoc-function #'ignore-errors-around-advice)
;; (advice-remove 'eldoc-print-current-symbol-info #'ignore-errors-around-advice)


;; When eldoc-documentation-function doesn't exist, this gets super annoying
;; v +/"(add-function :before-until (local 'eldoc-documentation-function) #'lsp-eldoc-function)" "$EMACSD/packages27/lsp-mode-20201031.1501/lsp-mode.el"
(defun set-racket-dummy-eldoc-func ()
  "this fixes an annoying bug in lsp"
  (defset-local eldoc-documentation-function 'racket-dummy-eldoc-func))

(defun racket-dummy-eldoc-func ()
  "this fixes an annoying bug in lsp"
  nil)

(add-hook 'racket-mode-hook 'set-racket-dummy-eldoc-func)
(remove-hook 'racket-mode-hook 'set-racket-dummy-eldoc-func)

(advice-add 'lsp--on-idle :around #'ignore-errors-around-advice)

(provide 'my-eldoc)