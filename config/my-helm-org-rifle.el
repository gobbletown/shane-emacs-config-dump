(require 'helm-org-rifle)

(define-key helm-org-rifle-map (kbd "C-h") 'nil)
(define-key helm-org-rifle-map (kbd "C-s") 'helm-next-source)

;; (define-key helm-org-rifle-map (kbd "<up>") 'previous-history-element)
;; (define-key helm-org-rifle-map (kbd "M-p") 'helm-previous-line)
;; (define-key helm-org-rifle-map (kbd "<down>") 'next-history-element)
;; (define-key helm-org-rifle-map (kbd "M-n") 'helm-next-line)

(define-key helm-org-rifle-map (kbd "<up>") nil)
(define-key helm-org-rifle-map (kbd "M-p") nil)
(define-key helm-org-rifle-map (kbd "<down>") nil)
(define-key helm-org-rifle-map (kbd "M-n") nil)

(provide 'my-helm-org-rifle)