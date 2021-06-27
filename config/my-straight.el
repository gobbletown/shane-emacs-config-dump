(require 'straight)

(defvar bootstrap-version)

(let ((bootstrap-file
       (let ((fp (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory)))
         (snc (cmd "sed" "-i" "s=(load (expand-file-name (concat straight.el \"c\")=(load (expand-file-name (concat straight.el)=" fp))
         fp))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      ;; I needed to also enable emacs-lisp-mode because I have a failsafe advice thing
      (emacs-lisp-mode)
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; For some reason, 'make compile' is removing the .elc file

;; (defvar bootstrap-version)
;; (let ((bootstrap-file
;;        ;; (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory)
;;        (expand-file-name "manual-packages/straight.el/bootstrap.el" user-emacs-directory))
;;       (bootstrap-version 5))
;;   (unless (file-exists-p bootstrap-file)
;;     (with-current-buffer
;;         (url-retrieve-synchronously
;;          "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
;;          'silent 'inhibit-cookies)
;;       (goto-char (point-max))
;;       (eval-print-last-sexp)))
;;   (load bootstrap-file nil 'nomessage))
;; 
;; 
;; (straight-use-package 'el-patch)


(use-package shelldon
  :straight (shelldon :type git
			                :host github
			                :repo "Overdr0ne/shelldon"
			                :branch "master"))


(straight-use-package '(apheleia :host github :repo "raxod502/apheleia"))
(apheleia-global-mode +1)


;; Gumshoe: a spatial Point movement tracker
(use-package gumshoe
  :straight (gumshoe :type git
                     :host github
                     :repo "Overdr0ne/gumshoe"
                     :branch "master")
  :config
  ;; The minor mode must be enabled to begin tracking
  (global-gumshoe-mode 1))

(provide 'my-straight)