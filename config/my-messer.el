(require 'inf-messer)

(defun social-dashboard ()
  (interactive)
  ;; TODO Show inf-messer-recent
  (nbfo (sed "s/^[^ ]* //" (inf-messer-recent))))

(define-key my-mode-map (kbd "H-1") 'inf-messer-history)
(define-key my-mode-map (kbd "H-2") 'inf-messer-send)

;; Show recent messages and select one to reply to
(define-key my-mode-map (kbd "H-3") 'inf-messer-reply)
(define-key my-mode-map (kbd "H-4") 'inf-messer-send-file)
(define-key my-mode-map (kbd "H-5") 'start-messer)
(define-key my-mode-map (kbd "H-6") 'inf-messer-reply)
(define-key my-mode-map (kbd "H-7") (lm (with-current-buffer (funcall-interactively 'inf-messer-history "Megan Goodwin"))))
(define-key my-mode-map (kbd "H-`") 'social-dashboard)

(df fb-megan-history (funcall-interactively 'inf-messer-history "Megan Goodwin"))
(df fb-skye-history (funcall-interactively 'inf-messer-history "Skye Budge"))
(df fb-scooter-history (funcall-interactively 'inf-messer-history "Good Old Scooter Club"))
(df fb-family-history (funcall-interactively 'inf-messer-history "family"))
(df fb-chen-history (funcall-interactively 'inf-messer-history "Chenrong Lü"))

;; Curry this
(defun inf-messer-send-megan (message)
  (interactive (list (read-string "m: ")))

  (let* ((contact "Megan Goodwin")
         (sentout
          (inf-messer-get-result-from-inf (concat "message " (q contact) " " message))))
    (nbfo sentout)))

(defun inf-messer-send-li (message)
  (interactive (list (read-string "m: ")))

  (let* ((contact "Leigham Fitzpatrick")
         (sentout
          (inf-messer-get-result-from-inf (concat "message " (q contact) " " message))))
    (nbfo sentout)))

(define-key-current inf-messer-mode-map "r" 'inf-messer-reply)
(define-key-current inf-messer-mode-map "s" 'inf-messer-send)
(define-key-current inf-messer-mode-map "M" 'inf-messer-send-megan)
(define-key-current inf-messer-mode-map "L" 'inf-messer-send-li)
(define-key-current inf-messer-mode-map "f" 'inf-messer-send-file)
(define-key-current inf-messer-mode-map "m" 'start-messer)
(define-key-current inf-messer-mode-map "h" 'inf-messer-history)
(define-key-current inf-messer-mode-map "m" 'fb-megan-history)
(define-key-current inf-messer-mode-map "y" 'fb-skye-history)
(define-key-current inf-messer-mode-map "c" 'inf-messer-recent)

(provide 'my-messer)