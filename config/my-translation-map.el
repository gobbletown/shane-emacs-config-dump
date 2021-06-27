;; I made it so you can do <insert key> with C-M-i from tmux
;; But emacs translates it to C-M-i.
;; This is so I can make GUI like TUI in emacs. Don't use <insert key> bindings.

;; swapped <Insert> and C-M-i (reverses tmux's swap)
(define-key key-translation-map (kbd "<insertchar>") (kbd "C-M-i"))
;; (define-key key-translation-map (kbd "C-M-i") (kbd "<insertchar>"))
(define-key key-translation-map (kbd "C-M-i") nil)

;; swap M-` and M-~
;; So I can execute commands using M-` and bring up the menu bar ith M-~
(define-key key-translation-map (kbd "<ESC> `") (kbd "<ESC> ~"))
(define-key key-translation-map (kbd "<ESC> ~") (kbd "<ESC> `"))

;; Make it so C-M-x works like C-x
;; To make easier:
;; C-x left
;; C-x right
(define-key key-translation-map (kbd "C-M-x") (kbd "C-x"))

;; Make GUI emacs more like TUI emacs
(define-key key-translation-map (kbd "C-M-SPC") (kbd "C-M-@"))
(define-key key-translation-map (kbd "<insertchar>") (kbd "C-M-i")) ;M-TAB


;; Do this so that the bindings work everywhere, including helm etc.
(define-key key-translation-map (kbd "C-M-k") (kbd "<up>"))
(define-key key-translation-map (kbd "C-M-j") (kbd "<down>"))
(define-key key-translation-map (kbd "C-M-h") (kbd "<left>"))
(define-key key-translation-map (kbd "C-M-l") (kbd "<right>"))

;; (define-key key-translation-map (kbd "<C-M-up>") (kbd (s-repeat 5 "<up>")))
;; (define-key key-translation-map (kbd "<C-M-down>") (kbd (s-repeat 5 "<down>")))
;; (define-key key-translation-map (kbd "<C-M-left>") (kbd (s-repeat 5 "<left>")))
;; (define-key key-translation-map (kbd "<C-M-right>") (kbd (s-repeat 5 "<right>")))

;; (define-key key-translation-map (kbd "<C-M-up>") nil)
;; (define-key key-translation-map (kbd "<C-M-down>") nil)
;; (define-key key-translation-map (kbd "<C-M-left>") nil)
;; (define-key key-translation-map (kbd "<C-M-right>") nil)

(define-key global-map (kbd "<C-M-up>") (df up5 (ekm (s-repeat 5 "<up> "))))
(define-key global-map (kbd "<C-M-down>") (df down5 (ekm (s-repeat 5 "<down>"))))
(define-key global-map (kbd "<C-M-left>") (df left5 (ekm (s-repeat 5 "<left>"))))
(define-key global-map (kbd "<C-M-right>") (df right5 (ekm (s-repeat 5 "<right>"))))

;; this works for <esc> sleep1 <c-g>
;; This does not work if you try to do it all at once, or quickly.
;; Try a different binding C-M-g might be too difficult to get working.
;; (define-key key-translation-map (kbd "C-M-g") (kbd "<help>"))
;; Yes, use this from now on.
(define-key key-translation-map (kbd "C-M-]") (kbd "<help>"))


;; ;; ;; The super key cannot be translated because it is a modifier key
;; ;; ;; However, it might be possible to create 2 letter combinations
;; ;; (define-key key-translation-map (kbd "C-M-\\") [(s)])
;; (define-key key-translation-map (kbd "C-M-\\") nil)

;; (define-prefix-command 'my-prefix-super)
;; ;; (global-set-key (kbd "<supe>") 'my-prefix-super)
;; ;; (global-set-key (kbd "<super>") nil)

;; ;; (define-key global-map [(super ?\ )] 'identity)
;; ;; (define-key global-map [(super ?\ )] 'identity)
;; ;; (define-key global-map (kbd "<super> SPC") 'identity)
;; ;; (define-key global-map (kbd "<supe> SPC") nil)


(define-minor-mode disable-keys-mode
  "Disables all keys."
  :lighter " dk"
  :keymap (let ((map (make-sparse-keymap)))
            (define-key map (kbd "C-g") (lambda ()
                                          (interactive)
                                          (disable-keys-mode -1)))
            (define-key map [t] 'ignore)
            map))


;; (defun super-chord (sequence)
;;   "Copies the key binding after entering it"
;;   (interactive (list (setq sequence (format "%s" (key-description (read-key-sequence "Key: "))))))
;;   (let ((extra-keyboard-modifiers ?\s-a))
;;     (ekm sequence)))
;; (define-key global-map (kbd "C-M-\\") 'super-chord)
;; (define-key global-map (kbd "C-M-\\") nil)



(defun add-event-modifier (string e)
  (let ((symbol (if (symbolp e) e (car e))))
    (setq symbol (intern (concat string
                                 (symbol-name symbol))))
    (if (symbolp e)
        symbol
      (cons symbol (cdr e)))))

(defun superify (prompt)
  (let ((e (read-event)))
    (vector (if (numberp e)
                (logior (lsh 1 23) e)
              (if (memq 'super (event-modifiers e))
                  e
                (add-event-modifier "s-" e))))))

(defun hyperify (prompt)
  (let ((e (read-event)))
    (vector (if (numberp e)
                (logior (lsh 1 24) e)
              (if (memq 'hyper (event-modifiers e))
                  e
                (add-event-modifier "H-" e))))))

(define-key global-map (kbd "C-M-6") nil)             ;For GUI
(define-key function-key-map (kbd "C-M-6") 'superify) ;For GUI
(define-key function-key-map (kbd "C-M-^") 'superify)
(define-key function-key-map (kbd "C-^") 'superify)
(define-key global-map (kbd "C-M-\\") nil) ;Ensure that this bindings isnt taken
(define-key function-key-map (kbd "C-M-\\") 'hyperify)


;; (define-key local-function-key-map "\C-ch" 'hyperify)
;; (define-key local-function-key-map "\C-ch" nil)



;; (define-key global-map [(super ?\ )] 'identity)

(provide 'my-translation-map)