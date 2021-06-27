;;; .emacs --- let the user choose the emacs environment to use

;;; Commentary:
;;; This code mimics the behaviour of `startup.el' to let the
;;; usage of the custom init directory behave just like the
;;; one and only "~/.emacs.d".
;;;
;;; By setting the environment variable `EMACS_USER_DIRECTORY'
;;; the user-emacs-directory can be chosen and if there is an
;;; `init.el' the configuration from that directory will be used.
;;; If the environment variable is not set or there is no `init.el'
;;; the default configuration directory `~/.emacs.d/' will be used.
;;;
;;; The variable `server-name' will be set to the name of the directory
;;; chosen as start path.  So if the server will be started, it can be
;;; reached with 'emacsclient -s servername'.
;;;
;;; This now works with a current version of spacemacs but does not
;;; work with `async-start' in general, if the code executed with `async'
;;; uses `user-init-dir' or makes other assumptions about the emacs
;;; start-directory.


;; Something keeps installing drupal-mode and lsp-treemacs, which is broken
(load (concat emacsdir "/config/my-remove-bad-packages.el"))

;; This is a bit of a hack for ensuring that the requires are found
;; elisp files are always in the top folder of a plugin, apparently, so I can use maxdepth.
;; For some reasons adding snippets directories to 
(defun list-directories-recursively (dir)
  (string2list (e/chomp (sh-notty ;; (concat "find " (e/q dir) " -type d")
                         (concat "find -P " (e/q dir) " -maxdepth 2 \\( -name 'snippets' -o -name '*-snippets*' \\) -prune -o -type d") nil "/"))))

;; find -P /home/shane/.emacs.d/ -maxdepth 2 \( -name 'snippets' -o -name '*-snippets*' \) -prune -o -type d | v

;; Manually, recursively add every dir inside package-user-dir to the load path. this is to fix require issues
;; (add-to-list 'load-path package-user-dir)

;; TODO Do not load some packages explicitly, such as lsp-treemacs.
(setq load-path (cl-union load-path (list-directories-recursively "/home/shane/.emacs.d/packages28/")))

;; this must be here because this is where load-path is set
;; for emacs to start. No idea why
(progn
    (require 'tagedit)
    (require 'git-gutter+))

;; HERE down
;; (getenv "SERVER_NAME")

;; for scimax and prelude. But why does it not load? It hits it before
;; the init.el file, but doesnt load
(require 'org-macs)
;; This worked.
;; (load "/home/shane/var/smulliga/source/git/config/emacs/packages27/org-20190408/org-macs.el")
;; (load "/var/smulliga/source/git/config/emacs/packages27/org-20200316/org-macs.el")
(load "/home/shane/source/git/config/emacs/packages28/org-20210322/org-macs.el")

;; The packages directory is hardcoded
;; cd "$EMACSD"; ln -sf packages28 packages

;;; Code:
(let* ((user-init-dir-default (file-name-as-directory (concat "~" init-file-user "/.emacs.d")))
       (user-init-dir (file-name-as-directory (or (getenv "EMACS_USER_DIRECTORY") user-init-dir-default)))
       (user-init-file-1 (expand-file-name "init" user-init-dir)))
  (setq user-emacs-directory user-init-dir)
  (setq package-user-dir (file-name-as-directory (concat (or (getenv "EMACS_USER_DIRECTORY") user-init-dir-default) "/packages" (number-to-string emacs-major-version))))

  (with-eval-after-load "server"
    (setq server-name
          (let ((server--name (file-name-nondirectory
                               (directory-file-name user-emacs-directory))))
            (if (equal server--name ".emacs.d") (getenv "SERVER_NAME") server--name))))
  ;; This breaks doom
  ;; I needed to ensure init.el was the latest AND the example init was
                                        ; (load (expand-file-name "init" (file-name-as-directory (or (getenv "EMACS_USER_DIRECTORY") user-init-dir-default))) t)
  ;; not in there
  (setq user-init-file t)
  (load user-init-file-1 t t)
  (when (eq user-init-file t)
    (setq user-emacs-directory user-init-dir-default)
    (load (expand-file-name "init" user-init-dir-default) t t)))



;; HERE down broken somewhere
;; For some reason I need to run both here AND in the after-init-hook

(load (concat emacsdir "/config/my-faces.el"))
(load (concat emacsdir "/config/my-guide-key.el"))

;; This is for scimax
(load (concat emacsdir "/config/my-telephone-line.el"))

;; Run this again to ensure faces are set, even after loading
;; distribution code
;; After starting purcell, ensure guide key is off
;; Must be appended or exordium is still wrongly coloured
;; https://www.gnu.org/software/emacs/manual/html_node/elisp/Startup-Summary.html#Startup-Summary
;; Try emacs-startup-hook as it runs later -- did not work
;; Try window-setup-hook as it runs later -- did not work
(defun setup-faces ()
  (load (concat emacsdir "/config/my-themes.el"))
  (load (concat emacsdir "/config/my-faces.el"))
  (load (concat emacsdir "/config/my-guide-key.el"))
  (load (concat emacsdir "/config/my-telephone-line.el"))
  ;; Faces contains custom settings. Therefore I need to run my-lsp after it to enforce my settings.
  (load (concat emacsdir "/config/my-lsp.el")))

(add-hook 'window-setup-hook ;; 'emacs-startup-hook ;; 'after-init-hook
          'setup-faces t)

(defun after-window-setup-body ()
  ;; I had to load term config later for it to stick
  (ignore-errors
    (progn
      ;; something in my-custom may have been breaking lsp and making it not recognise changes to the buffer
      (load (concat emacsdir "/config/my-custom.el"))
      ;; I just want the lsp settings
      (load (concat emacsdir "/config/my-lsp.el"))))
  ;; Nothing before =my-term.el= is allowed to fail
  (load (concat emacsdir "/config/my-term.el")))

(add-hook 'window-setup-hook ;; 'emacs-startup-hook ;; 'after-init-hook
          'after-window-setup-body t)

(defun my-set-completing-read-to-ivy ()
  (interactive)
  (setq completing-read-function 'ivy-completing-read))

;; 'emacs-startup-hook ;; 'after-init-hook
(add-hook 'window-setup-hook 'my-set-completing-read-to-ivy t)

;; This is basically guaranteed to work.
;; Needed to place it here for exordium
;; vim +/"my-daemon-start-hook" "$HOME/scripts/e"
(defvar my-daemon-start-hook nil
  "Hook called after the daemon is started")
(add-hook 'my-daemon-start-hook
          'setup-faces t)

(if (cl-search "PURCELL" my-daemon-name)
    (progn
      (add-hook 'after-init-hook (lambda () (load (concat emacsdir "/config/my-telephone-line.el"))))
      (remove-hook 'after-init-hook 'dimmer-mode)
      (remove-hook 'prog-mode-hook 'display-line-numbers-mode)))

; (provide '.emacs)
(provide 'select-distribution)
;; .emacs ends here