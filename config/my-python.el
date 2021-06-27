(require 'python)
(require 'pydoc)

;; Disabled anaconda-mode. Just use jedi
;; (require 'anaconda-mode)

(setq flycheck-python-flake8-executable "flake8")

(define-key python-mode-map (kbd "M-C-i") nil)

;; 14.04.19
;; Debugging python completion
;; company-mode is what I currently use.
;; normal emacs uses company-jedi
;; I can type getopt. and then M-x company-jedi to see that it's working
;; I can run M-x company-diag to see which company back-end it's using
;; Spacemacs appears to use company-anaconda
;; This was not working when I tried it.
;; Both M-x anaconda-mode-complete and M-x company-anaconda should show completions


;; (eval-after-load 'python
;;   '(define-key python-mode-map (kbd "M-9") 'pydoc-at-point)
;;   )

;; (define-key python-mode-map (kbd "M-9") 'pydoc-at-point)


;; I should move to lsp
;; [[/home/shane/var/smulliga/source/git/config/emacs/config/my-lsp.el][my-lsp.el]]
;; Python is working OK without lsp at the moment. It's not perfect. Don't fix up the bugs. Simply move to lsp.


;; Create a hydra for context-sensitive options
;; For things like going to pydoc



;; Why did I remove anaconda completion again?
(defun my/python-mode-hook ()
  (interactive)
  ;; Force removal of anaconda from spacemacs pythons
  ;; This works but I don't want it
  ;; (add-to-list 'company-backends 'company-jedi)
  ;; (setq company-backends (delete 'company-anaconda company-backends))

  (add-to-list 'company-backends 'company-anaconda)

  (add-to-list 'flycheck-disabled-checkers 'python-pylint)
  )

;; It's not good enough to simply add the hook.
;; It must be the last hook to ensure that spacemcas hooks do not override it
;; t here appends it
;; Though, it appears to not work.
(add-hook 'python-mode-hook 'my/python-mode-hook t)

(require 'eldoc)
(require 'anaconda-mode) ;; provides anaconda-eldoc-mode

(add-hook 'python-mode-hook 'eldoc-mode)
;; (add-hook 'python-mode-hook 'anaconda-mode)
;; (remove-hook 'python-mode-hook 'anaconda-mode)

;; This is nice but may mess with LSP
;; (add-hook 'python-mode-hook 'anaconda-eldoc-mode)


;; (evil-forward-section-begin &optional COUNT)

;; (define-key anaconda-mode-map (kbd "M-r") nil)

;; This has not fixed anaconda/jedi/go to definition
(setq python-shell-interpreter "ipython3"
      python-shell-interpreter-args "--simple-prompt -i")

;; (setq python-shell-interpreter "conda-ipython"
;;       python-shell-interpreter-args "--simple-prompt -i")


(use-package importmagic
  :ensure t
  :config

  (defun make-import-magic-binding ()
    (interactive)
    (importmagic-mode t)
    (importmagic-fix-imports))
  (define-key python-mode-map (kbd "C-c C-l") #'make-import-magic-binding)
  (add-hook 'python-mode-hook 'importmagic-mode)
  (remove-hook 'python-mode-hook 'importmagic-mode))
;; (remove-hook 'python-mode-hook 'importmagic-mode)

(remove-hook 'python-mode-hook 'importmagic-mode)

;; (defun python-mode-hook-after ()
;;   (define-key python-mode-map (kbd "TAB") nil))

;; ;; (remove-hook 'python-mode-hook 'python-mode-hook-after)
;; (add-hook 'python-mode-hook 'python-mode-hook-after t)

(defun python-version ()
  (interactive)
  (let ((ver (sh-notty "vermin" (selection-or-buffer-string))))
    (if (called-interactively-p)
        (message ver)
      ver)))

(defun py-run-upto-get-type-of-thing (args)
  "Run the code up to the next line, then get the type of the thing under the cursor"
  (interactive "P"))

(setq realgud:pdb-command-name "mypdb")

(require 'epc)

(defun my-importmagic-fix-imports ()
  (interactive)
  (call-interactively 'importmagic-fix-imports))


;; Fixes a breakage that happens after loading a python notebook
(defvar ein:notebook-mode nil)


(defun python-mark-paragraph ()
  (interactive)
  (let ((startpos (point)))
    (if (looking-at "^[^[:space:]]")
        (progn
          (if (not (selection-p))
              (call-interactively 'er/expand-region))
          (call-interactively 'mark-paragraph))
      (progn
        (while (and (not (looking-at "^[^[:space:]]"))
                    (not (looking-at "^$")))
          (call-interactively 'er/expand-region))
        (if (looking-at "^[^[:space:]]")
            (call-interactively 'mark-paragraph))
        ;; (if (eq startpos (point))
        ;;     (call-interactively 'mark-paragraph))
        ))))

(define-key python-mode-map (kbd "M-h") 'python-mark-paragraph)

(defun sps-python-browse-package (&optional package)
  (interactive (list (sor (fz (sn "python-list-packages")))))
  (if package
      (sps "zsh" nil nil (concat "/usr/local/lib/python3.6/dist-packages/" package))))

(defun python-browse-package (&optional package)
  (interactive (list (sor (fz (sn "python-list-packages")))))
  (if package
      (e (concat "/usr/local/lib/python3.6/dist-packages/" package))))

(defun xpti-with-package (&optional package dir)
  (interactive (list (sor (fz (sn "python-list-packages")))))
  (if package
      (sps (concat "fz-xpti-package " (q package)) nil nil dir)
    (sps "fz-xpti-package" nil nil dir)))
(defalias 'fz-python-start-xpti-on-package 'xpti-with-package)


(defun py-detect-libraries (path)
  (interactive (list (if (re-match-p "\\.py$" (buffer-file-path))
                         (buffer-file-path)
                       (read-file-name "Path to .py file"))))

  (if (not (re-match-p "\\.py$" path))
      (setq path nil))

  (if path
      (etv (snc (concat "pip-missing-reqs " (q path))))
    (error "Invalid path")))


(require 'python-pytest)


(provide 'my-python)