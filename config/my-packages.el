(require 'package)
(require 'my-utils)
(setq package-archives nil)


(load "/home/shane/var/smulliga/source/git/config/emacs/ensure-packages.el")

                                        ; I didn't need to do this at all. I can install from the package
                                        ; manager. I had to sort out some badly installed packages using
                                        ; --debug-init though before
                                        ; this worked.
                                        ; This is very annoying to install
                                        ; (require 'parsebib)
                                        ; (require 'dash)
                                        ; ; ; For some reason I couldn't install this through m/elpa
                                        ; ; ; Even more annoyingly, I can't seem to use it
                                        ; (add-to-list 'load-path "/var/smulliga/source/git/jkitchin/org-ref")
                                        ; (require 'org-ref)


                                        ;(require 'package)
                                        ;(add-to-list 'package-archives
                                        ;'("melpa" . "https://melpa.org/packages/"))
                                        ;(when (< emacs-major-version 24)
                                        ;(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))

;; do M-x package-refresh-contents
(setq package-archives nil)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

;; I disabled marmalade because it was hanging
;; (add-to-list 'package-archives '("marmalade" . "https://marmalade-repo.org/packages/"))
;; (remove-from-list 'package-archives '("marmalade" . "https://marmalade-repo.org/packages/"))

;; Annoyingly, when http://elpa.gnu.org/ goes down, spacemacs can't ;; start
                                        ; ;; need this for let-alist
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))

;; I want to use the most up-to-date org mode
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)

;; (use-package org
;;   ;; :mode (("\\.org$" . org-mode))
;;   :ensure org-plus-contrib)

;; org-plus-contrib -- lots of packages in here
(require 'ob-ruby)

(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(add-to-list 'package-pinned-packages '(cider . "melpa-stable") t)


(package-initialize)

;; Auto install package are installed if they are missing
(setq package-list
      (append
       '(
         markdown-mode
          )
       (my/load-list-file
        "/home/shane/var/smulliga/source/git/config/emacs/packages.txt")))

;; This one requires emacs25
;; lsp-javascript-typescript

;; fetch the list of packages available
(unless package-archive-contents
  (package-refresh-contents))

; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (yes (ignore-errors (package-install package)))))


; Is this scimax check still needed?
(if (not this-is-scimax)
; (cond
  ; ((string= "scimax" my-daemon-name)
   ; (identity nil)
   ; )
  ; (t
    (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

    (add-to-list 'package-archives '("marmalade" . "https://marmalade-repo.org/packages/"))

    ;; Annoyingly, when http://elpa.gnu.org/ goes down, spacemacs can't ;; start
    ; ;; need this for let-alist
    (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))

    ;(when (< emacs-major-version 25)
    ;  ;; this is needed for xclip
    ;  ;; But I don't need to do this for emacs 25
    ;  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))

    (add-to-list 'package-archives '("gnu" . "http://elpa.zilongshanren.com/gnu/"))

    ;; need this for elpy
    (add-to-list 'package-archives
             '("melpa" . "http://elpa.zilongshanren.com/melpa/"))
    ;;(add-to-list 'package-archives
    ;;         '("melpa-stable" . "http://elpa.zilongshanren.com/melpa-stable/"))
    (add-to-list 'package-archives
                 '("SC" . "http://joseito.republika.pl/sunrise-commander/"))
    ;;(add-to-list 'package-archives
    ;;         '("marmalade" . "http://elpa.zilongshanren.com/marmalade/"))
    ;;(add-to-list 'package-archives
    ;;         '("org" . "http://elpa.zilongshanren.com/org/"))
    ; )
  )


(if (cl-search "SPACEMACS" my-daemon-name)
    (setq ein:completion-backend 'ein:use-ac-jedi-backend)
    (identity nil)
    )


(package-initialize)
;;(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
; (package-refresh-contents)

;; don't use https
;;(add-to-list 'package-archives
;;             '("MELPA" . "http://melpa.org/packages/" ))

; This should come after I change "package-archives". Can stack them
; up then refresh.
;((string= "general" my-daemon-name)
; (package-refresh-contents)
; )

;(require 'discover)
;(global-discover-mode 1)

;; To fix purcell
(load "/var/smulliga/source/git/config/emacs/packages27/aok-0.1/aok.el")

;(require 'shane-minor-mode)
(load "/var/smulliga/.emacs.d/config/shane-minor-mode.el")

;; (add-to-list 'load-path "/export/bulk/local-home/smulliga/source/git/rolandwalker/simpleclip/")
;; (require 'simpleclip)
;; (simpleclip-mode 1)

;; this is the other way to load el files
;; installed using package manager
;;(add-to-list 'load-path "/var/smulliga/home/.emacs.d/site-lisp/undo-tree/")
;(load "/var/smulliga/.emacs.d/site-lisp/undo-tree/undo-tree.el")

;; need this for other files
(add-to-list 'load-path "/export/bulk/local-home/smulliga/source/git/abo-abo/hydra/")
(load "hydra.el")

;; (add-to-list 'load-path "/home/shane/var/smulliga/source/git/config/emacs/my-packages/my-keywords-mode")
;; (require 'my-keywords-mode)

(add-to-list 'load-path "/export/bulk/local-home/smulliga/source/git/abo-abo/avy/")
(load "avy.el")
(global-set-key (kbd "M-k") 'avy-goto-char)

(add-to-list 'load-path "/export/bulk/local-home/smulliga/source/git/haskell/haskell-mode.git/")
(load "haskell.el")

;; The long-lost string manipulation library
;; /export/bulk/local-home/smulliga/source/git/magnars/s.el/README.md
(add-to-list 'load-path "/export/bulk/local-home/smulliga/source/git/magnars/s.el/")
(load "s.el")

(add-to-list 'load-path "/export/bulk/local-home/smulliga/source/git/bastibe/annotate.el/")
(load "annotate.el")

;; The minimap doesn't work in xterm and it's not good or useful
;; (add-to-list 'load-path "/export/bulk/local-home/smulliga/source/git/zk-phi/sublimity/")
;; (require 'sublimity)
;; (require 'sublimity-scroll)
;; (require 'sublimity-map) ;; experimental
;; ;; (require 'sublimity-attractive)
;; (sublimity-mode 1)



;(require 'w3m)
;(load "/home/shane/var/smulliga/source/git/config/emacs/w3m-settings.el")


;;(load "/var/smulliga/source/git/config/emacs/init-w3m.el")

; (cond
  ; ((string= "scimax" my-daemon-name)
   ; (identity nil)
   ; )
  ; (t
    (load "/var/smulliga/source/git/config/emacs/install-packages-if-not-installed.el")
    ; )
  ; )

;; (cond
;; ((string= "scimax" my-daemon-name)
;; (identity nil)
;; )
;; (t
;(if (not this-is-scimax)
;  (progn
;    (require 'pymacs)
;    (pymacs-load "ropemacs" "rope-")
;    )
;  )
;; )

;; (cond
;; ((string= "scimax" my-daemon-name)
;; (identity nil)
;; )
;; (t
;(if (not this-is-scimax)
;  (progn
;    ;; load all
;    ;; this stuff breaks python. i only want rope from this
;    ;;(load-file "/home/shane/source/git/gabrielelanaro/emacs-for-python/epy-init.el")
;
;    ;; load only some
;    (add-to-list 'load-path "/home/shane/source/git/gabrielelanaro/emacs-for-python") ;; tell where to load the various files
;    ; (require 'epy-setup)      ;; It will setup other loads, it is required!
;    ; (require 'epy-python)     ;; If you want the python facilities [optional]
;    ; (require 'epy-completion) ;; If you want the autocompletion settings [optional]
;    ; (require 'epy-editing)    ;; For configurations related to editing [optional]
;    ; this has the rope-auto-import binding
;    (require 'epy-bindings)   ;; For my suggested keybindings [optional]
;    ; (require 'epy-nose)       ;; For nose integration
;    ; )
;    )
;  )



(put 'scroll-left 'disabled nil)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(aw-leading-char-face ((t (:inherit ace-jump-face-foreground :height 3.0))))
 '(magit-popup-argument ((t (:inverse-video t)))))

; Don't do this. Try to extend org-mode without installing the package
; again.
; ;; Use a custom org-mode because I want to extend it
; (add-to-list 'load-path (expand-file-name "/var/smulliga/source/git/jwiegley/org-mode"))
; (require 'org-mode)


;; cpan mode
(add-to-list 'load-path (expand-file-name "/home/shane/var/smulliga/source/git/rmloveland/cpan-el/"))
(setf cpan-file-name "cpan")
(require 'cpan)


(defun my-delete-package (name)
  (-when-let (package (epl-find-installed-package (str2sym (if (stringp name) (str2sym name) name))))
        (epl-package-delete package)))


; This el file is too obsolete
; (load "/home/shane/notes2018/ws/anniversaries/anniversaries.el")
(put 'upcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'downcase-region 'disabled nil)

(defun package-list-convenience ()
  ()interactive
  (package-show-package-list t (list "convenience")))

(defun package-list-productivity ()
  (interactive)
  (package-show-package-list t (list "productivity")))


(defun package--get-description (desc)
  "Return a string containing the long description of the package DESC.
The description is read from the installed package files."
  ;; Installed packages have nil for kind, so we look for README
  ;; first, then fall back to the Commentary header.

  ;; We don’t include README.md here, because that is often the home
  ;; page on a site like github, and not suitable as the package long
  ;; description.
  (let ((files '("README-elpa" "README-elpa.md" "README" "README.rst" "README.org"))
        file
        (srcdir (package-desc-dir desc))
        result)
    (while (and files
                (not result))
      (setq file (pop files))
      (when (file-readable-p (expand-file-name file srcdir))
        ;; Found a README.
        (with-temp-buffer
          (insert-file-contents (expand-file-name file srcdir))
          (setq result (buffer-string)))))

    (or
     result

     (try
      (progn
        (message (expand-file-name
                  (format "%s.el" (package-desc-name desc)) srcdir))
        (lm-commentary (expand-file-name
                        (format "%s.el" (package-desc-name desc)) srcdir)))
      (progn
        (message (expand-file-name
                  (s-replace-regexp "-mode\\.el" ".el" (format "%s.el" (package-desc-name desc))) srcdir))
        (lm-commentary (expand-file-name
                        (s-replace-regexp "-mode\\.el" ".el" (format "%s.el" (package-desc-name desc))) srcdir)))
      (progn
        (message (expand-file-name
                  (s-replace-regexp "\\.el" "-mode.el" (format "%s.el" (package-desc-name desc))) srcdir))
        (lm-commentary (expand-file-name
                        (s-replace-regexp "\\.el" "-mode.el" (format "%s.el" (package-desc-name desc))) srcdir)))
      "")
     "")))

;; For. describe-package
;; (advice-add 'lm-commentary :around #'ignore-errors-around-advice)
;; (advice-remove 'lm-commentary  #'ignore-errors-around-advice)

(provide 'my-packages)