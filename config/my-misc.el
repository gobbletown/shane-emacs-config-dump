(provide 'my-misc)
(require 'my-aliases)

;; I don't actually like this

;; (use-package beacon
;;     :ensure t
;;     :config
;;     (beacon-mode 1)
;;     ;; (setq beacon-color "#666600")
;;     )

;; (setq go-packages-function 'go-packages-native)
(setq go-packages-function 'go-packages-go-list) ; comprehensive one

(require 'pcre2el)
(pcre-mode 1)


(up wttrin
  :ensure t
  :commands (wttrin)
  :init
  (setq wttrin-default-cities '("Dunedin"
                                "Auckland")))


;; purcell not starting. Needs this
;; No package for emacs 28?
(load "/var/smulliga/source/git/config/emacs/packages27/bitly-1.0/bitly.el")
(require 'bitly)                        ;url shortener

(setq bitly-access-token "1b1ca2de3b2d28e6fdba921171a8aefaad0354f0")

;1b1ca2de3b2d28e6fdba921171a8aefaad0354f0


;; This package rules
(require 'ample-regexps)

(require 'alert)
;; (alert "This is an alert" :severity 'high :style 'mode-line)


(require 'ansible-doc)

(require 'cff)

(with-eval-after-load 'ox (require 'ox-hugo))


;; this is like vimdiff for diffing regions
(use-package dumb-diff
  :bind (("C-c d" . dumb-diff)
         ("C-c 1" . dumb-diff-set-region-as-buffer1)
         ("C-c 2" . dumb-diff-set-region-as-buffer2)
         ("C-c q" . dumb-diff-quit))
  :ensure t)


;; This works for org-mode, definitely
;; Not working with lispy, though.
;; I don't currently have a use for it.
;; (use-package hungry-delete
;;   :ensure t
;;   :config
;;   (global-hungry-delete-mode))



(require 'sotlisp)
(speed-of-thought-mode 1)


(require 'recursive-narrow)

(require 'bm)


(defun goto-line-show ()
  "Show line numbers temporarily, while prompting for the line number input."
  (interactive)
  (unwind-protect
      (progn
        (linum-mode 1)
        (call-interactively #'goto-line))
    (linum-mode -1)))
;; (global-set-key (kbd "s-l") 'goto-line-show)
;; (global-set-key (kbd "s-l") nil)


(require 'pcase)
(require 'delsel)


(setq enwc-default-backend 'nm)


(require 'memoize)
;; (require 'ov-highlight)

;; (memoize 'my-function)
;; (memoize-restore 'my-function)

(require 'ox-ipynb)

(require 'pyvenv)

;; http://www.modernemacs.com/post/custom-eshell/
;; Don't actually load this. It's not that great.
;; (load "/home/shane/var/smulliga/source/git/config/emacs/config/esh-custom.el")


;; purcell not starting. Needs this
(load "/var/smulliga/source/git/config/emacs/packages27/lacarte-22.0/lacarte.el")
(require 'lacarte)
(require 'yaml-mode)


(require 'ob-elasticsearch)