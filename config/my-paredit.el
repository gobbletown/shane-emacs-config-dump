(require 'paredit)

(define-key paredit-mode-map (kbd "M-(") nil)
(define-key paredit-mode-map (kbd "M-)") nil)
(define-key paredit-mode-map (kbd "M-;") nil)
(define-key paredit-mode-map (kbd "M-s") nil)
(define-key paredit-mode-map (kbd "\"") nil)
(define-key paredit-mode-map (kbd "DEL") nil)
(define-key paredit-mode-map (kbd "M-DEL") nil)
(define-key paredit-mode-map (kbd "\\") nil)
(define-key paredit-mode-map (kbd "M-\"") nil)

;; Because I want counsel-ag to work
(define-key paredit-mode-map (kbd "M-?") nil)

;; This means I can use M-J to join lines in lisp
(defun paredit-join-sexps-around-advice (proc &rest args)
  (if (selected)
      (let ((res (apply proc args)))
        res)
    (call-interactively 'evil-join)))
(advice-add 'paredit-join-sexps :around #'paredit-join-sexps-around-advice)

(provide 'my-paredit)