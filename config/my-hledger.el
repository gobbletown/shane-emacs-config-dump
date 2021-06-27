(require 'hledger-mode)
(require 'auto-complete-config) ;; this is needed for the ac-modes variable

;; To open files with .journal extension in hledger-mode
(add-to-list 'auto-mode-alist '("\\.journal\\'" . hledger-mode))

;; Provide the path to you journal file.
;; The default location is too opinionated.
(setq hledger-jfile "/home/shane/notes2018/ws/finances/general.journal")


;;; Auto-completion for account names
;; For company-mode users,
(add-to-list 'company-backends 'hledger-company)

;; For auto-complete users,
(add-to-list 'ac-modes 'hledger-mode)
(add-hook 'hledger-mode-hook
    (lambda ()
        (setq-local ac-sources '(hledger-ac-source))))