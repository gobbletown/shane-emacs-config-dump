(require 'my-browser)

;; If ~/.docsecs isn't available (my hard drive isn't plugged in) then
;; this will break emacs startup
;; helm-dash-docsets-path
(if (f-directory? "~/.docsets")
    (require 'helm-dash))


(defun go-doc ()
  (interactive)
  (setq-local helm-dash-docsets '("Go")))
(add-hook 'go-mode-hook 'go-doc)


(defun c++-doc ()
  (interactive)
  (setq-local helm-dash-docsets '("C++", "Boost", "CMake")))
(add-hook 'go-mode-hook 'c++-doc)


(defun c-doc ()
  (interactive)
  (setq-local helm-dash-docsets '("Arduino", "CMake", "C")))
(add-hook 'c-mode-hook 'c-doc)


(defun hs-doc ()
  (interactive)
  ;; But I still need this, so they dont start to double-up on emacs distros aside from purcelld
  (setq-local helm-dash-docsets '("Haskell"))
  ;; This works for purcell where above does not
  (helm-dash-activate-docset "Haskell"))
(add-hook 'haskell-mode-hook 'hs-doc)


(defun elisp-doc ()
  (interactive)
  ;; But I still need this, so they dont start to double-up on emacs distros aside from purcelld
  (setq-local helm-dash-docsets '("Emacs Lisp"))
  ;; This works for purcell where above does not
  (helm-dash-activate-docset "Emacs Lisp"))
(add-hook 'emacs-lisp-mode-hook 'elisp-doc)


(setq helm-dash-common-docsets '("Apache_HTTP_Server"))

;; (setq helm-dash-browser-func 'browse-url-generic)

(if (cl-search "PURCELL" my-daemon-name)
    (remove-hook 'haskell-mode-hook 'stack-exec-path-mode))



(setq helm-dash-browser-func 'eww)
;; (setq helm-dash-browser-func 'w3m-browse-url)


;; (define-key global-map (kbd "M-m d h") #'helm-dash-at-point)
(require 'my-prefixes)
(define-key my-mode-map (kbd "M-m d h") #'helm-dash-at-point)

(if (cl-search "PURCELL" my-daemon-name)
    (remove-hook 'haskell-mode-hook 'stack-exec-path-mode))


(provide 'my-helm-dash)