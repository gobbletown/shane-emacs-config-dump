(require 'company-tabnine

(setq company-idle-delay 0)
(setq company-show-numbers t))


;; TODO Fix
;; While browsing the completions list, if I press <space> then company aborts.


;; vim +/";; Trigger completion immediately." "$EMACSD/config/my-company.el"
;; Number the candidates (use M-1, M-2 etc to select completions).
(setq company-show-numbers t)


;; Use the tab-and-go frontend.
;; Allows TAB to select and complete at the same time.
;; Do not use tag-and-go. It breaks C-s
;; Plus, I am going to try to configure company from the basics, to get things like tabnine working nicely and to understand company.
;; (company-tng-configure-default)
;; (setq company-frontends
;;       '(company-tng-frontend
;;         company-pseudo-tooltip-frontend
;;         company-echo-metadata-frontend))

(setq company-tabnine-auto-fallback nil)
(setq company-tabnine-wait 1)


;; workaround for company-transformers
(setq company-tabnine--disable-next-transform nil)
(defun my-company--transform-candidates (func &rest args)
  (if (not company-tabnine--disable-next-transform)
      (apply func args)
    (setq company-tabnine--disable-next-transform nil)
    (car args)))

(defun my-company-tabnine (func &rest args)
  (when (eq (car args) 'candidates)
    (setq company-tabnine--disable-next-transform t))
  (apply func args))

(advice-add #'company--transform-candidates :around #'my-company--transform-candidates)
(advice-add #'company-tabnine :around #'my-company-tabnine)

;; Don't automatically use company-tabnine. Manually invoke it
;; (add-to-list 'company-backends #'company-tabnine)



;; workaround for company-transformers
;; Fix sorting
(setq company-tabnine--disable-next-transform nil)
(defun my-company--transform-candidates (func &rest args)
  (if (not company-tabnine--disable-next-transform)
      (apply func args)
    (setq company-tabnine--disable-next-transform nil)
    (car args)))
(defun my-company-tabnine (func &rest args)
  (when (eq (car args) 'candidates)
    (setq company-tabnine--disable-next-transform t))
  (apply func args))
(advice-add #'company--transform-candidates :around #'my-company--transform-candidates)
(advice-add #'company-tabnine :around #'my-company-tabnine)


(provide 'my-tabnine)