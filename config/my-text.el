(require 'wordnut)

(define-key text-mode-map (kbd "M-RET") 'new-line-and-indent)

;; v +/"(defun dict-word (word)" "$EMACSD/config/my-wordnet.el"
(define-key text-mode-map (kbd "M-9") #'dict-word)

(define-key text-mode-map (kbd "C-c C-o") 'org-open-at-point)

;; (define-key text-mode-map (kbd "M-8") #'engine/search-google)
;; (define-key text-mode-map (kbd "M-8") nil)


;; (remove-hook 'text-mode-hook 'flyspell-buffer)
(add-hook 'text-mode-hook 'my-flyspell-buffer)

(define-key text-mode-map (kbd "C-M-i") nil)

(provide 'my-org)