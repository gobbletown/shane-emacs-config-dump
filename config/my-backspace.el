(require 'my-mode)
(require 'helm)

; This works but I've disabled it because socat doesn't like it
; Not the only reason. I want to be able to use the GUI version oof
; emacs and for that I need C-M-h

;; swapped C-h and DEL. Re-enabled.

;; (define-key key-translation-map [?\C-?] [?\C-h])
;; (define-key key-translation-map [?\C-h] [?\C-?])


;; C-h as a macro still points to DEL and it is affected
;; (define-key global-map (kbd "DEL") help-map)
;; (define-key lispy-mode-map (kbd "DEL") help-map)


;; I have decided that from now on, the combination C-M-o will not invoke help. This is the easiest way out. This means I need a new way to start help. Just use C-c h.
;; (global-set-key (kbd "C-M-o") help-map)
(global-set-key (kbd "C-M-o") (kbd "DEL"))



(define-key global-map (kbd "C-h") (kbd "DEL"))
(global-set-key (kbd "C-c h") help-map)

(define-key helm-map (kbd "C-h") nil)

;; I might have to do more things like this. If it gets too much, I should just do a translate. It is actually getting very frustrating.
(define-key helm-map (kbd "C-h c") nil)
(define-key helm-map (kbd "C-h C-d") nil)
(define-key helm-map (kbd "C-h") (kbd "DEL"))

;; This actually breaks M-DEL (In the terminal). It's to support the GUI version of emacs,
;; where tmux is not there to translate. It only breaks it because
;; M-Delete is being translated to C-M-h by emacs. It's just the DEL -> C-h map, I think. Use keyboard macro instead of translation map. I've disabled the translation. Just find a new way to invoke help.
(define-key my-mode-map (kbd "C-M-h") 'left-char)

;; There are going to be a lot more C-h bindings I need to make nil or
;; make "DEL"

;; (define-key isearch-mode-map (kbd "C-h") nil)
;; (define-key isearch-mode-map (kbd "C-h") (kbd "DEL")) ;; This works but there is more to remove
;; Annoyingly, I might have to do this for many other modes that use the minibuffer
(define-key isearch-mode-map (kbd "C-h") #'isearch-delete-char)
;; (define-key isearch-mode-map (kbd "DEL") #'isearch-delete-char)
;; (define-key search-map (kbd "C-h") nil)

(provide 'my-backspace)