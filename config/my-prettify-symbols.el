(provide 'my-prettify-symbols)


;; Currently, pretty mode has screwed up R editing in the terminal.
;; It's just ~global-prettify-symbols-mode~.
;; Ensure that is never enabled.
;; It's confusing and not worth it.

(global-prettify-symbols-mode 0)
;; (global-prettify-symbols-mode 1)




;; shorten function to f
;; Nah, no need
;; https://youtu.be/XPrRxhYJMkQ?t=92
;; the American people like their
;; bullshit out front where they can get a good
;; strong whiff of it that's why they reelected
;; Clinton
;; (add-hook 'js-mode-hook
;;           (lambda ()
;;             (push '("function" . ?ƒ) prettify-symbols-alist)
;;             (global-prettify-symbols-mode)))

;; (remove-hook 'js-mode-hook
;;           (lambda ()
;;             (push '("function" . ?ƒ) prettify-symbols-alist)
;;             (global-prettify-symbols-mode)))



;;;;It's sad that prettify symbols doesn't work for wide characters
;;(add-hook 'js-mode-hook
;;          (lambda ()
;;            (push '("function" . "信") prettify-symbols-alist)
;;            (global-prettify-symbols-mode)))
;;
;;(remove-hook 'js-mode-hook
;;          (lambda ()
;;            (push '("function" . ?ƒ) prettify-symbols-alist)
;;            (global-prettify-symbols-mode)))
;;
;;(remove-hook 'org-mode-hook
;;          (lambda ()
;;            (push '("information" . "信息") prettify-symbols-alist)
;;            (global-prettify-symbols-mode)))
;;(remove-hook 'org-mode-hook
;;          (lambda ()
;;            (push '("information" . "信") prettify-symbols-alist)
;;            (global-prettify-symbols-mode)))
;;(add-hook 'org-mode-hook
;;          (lambda ()
;;            (push '("information" . ?信) prettify-symbols-alist)
;;            (global-prettify-symbols-mode)))

;; this is just annoying and not helpful
;;(defun pretty-map-python ()
;;  (mapc (lambda (pair) (push pair prettify-symbols-alist))
;;        '(;; Syntax
;;
;;          ("in" . 8712)
;;          ("not in" . 8713)
;;          ;; ("yield" . 10235)
;;          ("for" . 8704)
;;          ;; Base Types
;;          ("int" . 8484)
;;          ("float" . 8477)
;;          ;; Mypy
;;          ;; ("Dict" . 120071)
;;          ;;("List" . 8466)
;;          ;;("Tuple" . 10754)
;;          ("Set" . 8486)
;;          ;;("Iterable" . 120074)
;;          ;;("Any" . 10068)
;;          ("Union" . 8899))))
;;
;;(add-hook 'python-mode-hook #'pretty-map-python t)



;; (remove-hook 'python-mode-hook #'pretty-map-python t)


;; These don't play nice in xterm with the current font
;; ("def" .      #x2131)
;; ("str" .      #x1d54a)
;; ("return" .   #x27fc)
;; ("not" .      #x2757)


;; THis is how to remove the hook if i make a mistake, although I should name to lambda to make it easier
;; (remove-hook
;;  'python-mode-hook
;;  (lambda ()
;;    (mapc (lambda (pair) (push pair prettify-symbols-alist))
;;          '(;; Syntax

;;            ("not" .      #x2757)
;;            ("in" .       #x2208)
;;            ("not in" .   #x2209)
;;            ("yield" .    #x27fb)
;;            ("for" .      #x2200)
;;            ;; Base Types
;;            ("int" .      #x2124)
;;            ("float" .    #x211d)

;;            ("True" .     #x1d54b)
;;            ("False" .    #x1d53d)
;;            ;; Mypy
;;            ("Dict" .     #x1d507)
;;            ("List" .     #x2112)
;;            ("Tuple" .    #x2a02)
;;            ("Set" .      #x2126)
;;            ("Iterable" . #x1d50a)
;;            ("Any" .      #x2754)
;;            ("Union" .    #x22c3)))))