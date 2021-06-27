(require 'marginalia)

;; e ia ivy-prescient selectrum-prescient company-prescient prescient

(add-to-list 'load-path (concat emacsdir "/manual-packages/selectrum"))
(require 'selectrum)

;; (straight-use-package 'selectrum)

;; (selectrum-mode +1)

(define-key selectrum-minibuffer-map (kbd "<next>") 'selectrum-next-page)
(define-key selectrum-minibuffer-map (kbd "<prior>") 'selectrum-previous-page)


(never
 (use-package selectrum
   :init (selectrum-mode 1))
 (use-package selectrum-prescient
   :after selectrum
   :config
   (prescient-persist-mode t)
   (selectrum-prescient-mode t))
 (use-package marginalia
   :init (marginalia-mode))
 (use-package consult
   :straight (consult :type git :host github :repo "minad/consult")
   :bind (("C-c o" . consult-outline)
          ("C-x b" . consult-buffer)
          ("C-s" . consult-line) ;; "M-s l" is a good alternative
          ("M-y" . consult-yank-pop)
          ("<help> a" . consult-apropos))
   :general
   ('normal :prefix "SPC" "x b" 'consult-buffer)
   :config
   ;; Replace functions (consult-multi-occur is a drop-in replacement)
   (fset 'multi-occur #'consult-multi-occur)
   (consult-preview-mode) ;; Optionally enable previews
   ))


(provide 'my-selectrum)