;; Put all helm-dash stuff inside my-helm-dash.el

;; (defun go-doc ()
;;   (interactive)
;;   (setq-local helm-dash-docsets '("Go")))

;; (add-hook 'go-mode-hook 'go-doc)


(require 'go-autocomplete)
(require 'auto-complete-config)

;; No need to modify this. I can modify my go wrapper
;; /home/shane/scripts/go

;; (defun go-packages-go-list ()
;;   "Return a list of all Go packages, using `go list'."
;;   (process-lines go-command "list" "-e" "all"))


;; TODO
;; (define-key ac-mode-map (kbd "M-TAB") 'auto-complete)

;; This makes it update using
;; go list -e all
(setq go-packages-function 'go-packages-go-list)



(_ns metalinter_stuff
     (use-package flycheck-gometalinter
       :ensure t
       :config
       (progn
         (flycheck-gometalinter-setup)))

     ;; skips 'vendor' directories and sets GO15VENDOREXPERIMENT=1
     (setq flycheck-gometalinter-vendor t)
     ;; only show errors
     (setq flycheck-gometalinter-errors-only t)
     ;; only run fast linters
     (setq flycheck-gometalinter-fast t)
     ;; use in tests files
     (setq flycheck-gometalinter-test t)
     ;; disable linters
     (setq flycheck-gometalinter-disable-linters '("gotype" "gocyclo"))
     ;; Only enable selected linters
     (setq flycheck-gometalinter-disable-all t)
     (setq flycheck-gometalinter-enable-linters '("golint"))
     ;; Set different deadline (default: 5s)
     (setq flycheck-gometalinter-deadline "10s")
     ;; Use a gometalinter configuration file (default: nil)
     (setq flycheck-gometalinter-config "/path/to/gometalinter-config.json"))


(define-key go-mode-map (kbd "M-e") #'er/expand-region)

(defun my/go-mode-hook-body ()
    ;; (define-key ggtags-mode-map (kbd "M-.") nil)
    (define-key go-mode-map (kbd "M-.") #'spacemacs/jump-to-definition))

;; :'( I don't know how to override the other mode's binding
;; I could unbind it maybe. Would that unbind for every buffer?
(if (cl-search "SPACEMACS" my-daemon-name)
    ;; this should probably be in auto-mode-load.el
    (add-hook 'go-mode-map #'my/go-mode-hook-body))

;; go get https://github.com/zmb3/gogetdoc
(setq godoc-at-point-function 'godoc-gogetdoc)

(provide 'my-go)