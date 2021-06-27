;; How to get things under SPC

;; (spacemacs/declare-prefix "o" "own-menu")
;; (spacemacs/set-leader-keys "os" 'ispell-buffer)
;; ;; org-ids
;; (spacemacs/declare-prefix "od" "id")
;; (spacemacs/set-leader-keys "odc" 'org-id-copy)
;; (spacemacs/set-leader-keys "odu" 'org-id-update-id-locations)

(define-prefix-command 'my-prefix-m-4)
(global-set-key (kbd "M-4") 'my-prefix-m-4)

(define-prefix-command 'my-prefix-m-l)
(global-set-key (kbd "M-l") 'my-prefix-m-l)
(global-set-key (kbd "M-'") 'my-prefix-m-l)

(if (not (cl-search "SPACEMACS" my-daemon-name))
    (progn
      (define-prefix-command 'my-prefix-m-m)
      (global-set-key (kbd "M-m") 'my-prefix-m-m)))

;; Spacemacs appears to not mind here
(define-prefix-command 'my-prefix-m-g)
(global-set-key (kbd "M-g") 'my-prefix-m-g)

(define-prefix-command 'my-prefix-m-dash)
(global-set-key (kbd "M--") 'my-prefix-m-dash)

;; ;; These are also defined here
;; They have to be in my-mode-map (rather than global-map) because it simply doesnt work otherwise
;; vim +/"(define-prefix-command 'my-prefix-m)" "$EMACSD/config/shane-minor-mode.el"
;; vim +/"(define-prefix-command 'my-prefix-m-d)" "$EMACSD/config/shane-minor-mode.el"


;; I don't think this code allows the 'emacspeak-wizards-execute-asynchronously to bind. C-- isn't a key anyway.
;; (define-prefix-command 'my-prefix-c-dash)
;; (global-set-key (kbd "C--") 'my-prefix-c-dash)
;; (global-set-key (kbd "C-' a") 'emacspeak-wizards-execute-asynchronously)


;; But they work for everything (including spacemacs) as soon as they are defined.
;; BUT they do not work in emacs-lisp-mode in spacemacs
;; Not sure why. Maybe a binding starting with M-q is blocking it.

(define-prefix-command 'my-prefix-m-q)
(global-set-key (kbd "M-q") 'my-prefix-m-q)

(define-prefix-command 'my-prefix-m-q-m-r)
(global-set-key (kbd "M-q M-r") 'my-prefix-m-q-m-r)

(define-prefix-command 'my-prefix-m-l-m-tab)
(global-set-key (kbd "M-l M-TAB") 'my-prefix-m-l-m-tab)
(global-set-key (kbd "M-l C-M-i") 'my-prefix-m-l-m-tab)

;; (define-key-current inf-messer-mode-map "r" 'inf-messer-reply)
(defmacro define-key-current (map key func)
  `(define-key ,map (kbd ,(concat "M-l C-M-i " key)) ,func))
(defalias 'dkc 'define-key-current)

(defun tm-filter-facts ()
  (bp tm -f -i -fout spv fzf-remove-fact (buffer-contents)))

(provide 'my-prefixes)
