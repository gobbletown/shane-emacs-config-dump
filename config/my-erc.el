(require 'tls)
(require 'erc-services)
(require 'my-myrc)

;; Go to #systemcrafters

(require 'erc-join)
;; (erc-autojoin-mode 1)

;; (setq erc-default-server "irc.freenode.net")
(setq erc-default-server "irc.libera.chat")
(setq erc-nick "libertyprime")
(setq erc-user-full-name "Liberty J. Prime")
(setq erc-track-shorten-start 8)
(setq erc-autojoin-channels-alist '(("irc.libera.chat" "#emacs" "#erc" "#systemcrafters")))

;; when you part a channel, kill the buffer
(setq erc-kill-buffer-on-part t)
;; when someone sends you a message - you dont want it to pop up on you
(setq erc-auto-query 'bury)

;; 16.12.19
;; This is not currently working

;; This mode automates communication with services
(erc-services-mode 1)

(setq erc-prompt-for-nickserv-password nil)
(setq erc-prompt-for-password nil)

;; I will never put my dotfiles on github

(setq libera-password (myrc-get "libera_bot_pass"))
(setq libera-nick (myrc-get "libera_bot_nick"))
(setq libera-full-name (myrc-get "libera_bot_name"))

(setq freenode-password (myrc-get "freenode_bot_pass"))
(setq freenode-nick (myrc-get "freenode_bot_nick"))
(setq freenode-full-name (myrc-get "freenode_bot_name"))

; (myrc-get "gitlab_fmg_token")

(setq erc-nickserv-passwords '((freenode ((freenode-nick . freenode-password)))
                               (libera ((libera-nick . libera-password)))))

;(load "~/.ercpass")

;(erc-services-mode 1)



; circe doesn't have gpg issues
; $MYGIT/config/emacs/config/my-circe.el


;; This is needed to run erc on emacs other than spacemacs
;; For some reason erc doesn't show up in M-x
(defalias 'run-erc 'erc)


;; (cl-defun erc (&key (server (erc-compute-server))
;;                     (port   (erc-compute-port))
;;                     (nick   (erc-compute-nick))
;;                     password
;;                     (full-name (erc-compute-full-name)))
;;   "ERC is a powerful, modular, and extensible IRC client.
;; This function is the main entry point for ERC.

;; It permits you to select connection parameters, and then starts ERC.

;; Non-interactively, it takes the keyword arguments
;;    (server (erc-compute-server))
;;    (port   (erc-compute-port))
;;    (nick   (erc-compute-nick))
;;    password
;;    (full-name (erc-compute-full-name)))

;; That is, if called with

;;    (erc :server \"irc.freenode.net\" :full-name \"Harry S Truman\")

;; then the server and full-name will be set to those values, whereas
;; `erc-compute-port', `erc-compute-nick' and `erc-compute-full-name' will
;; be invoked for the values of the other parameters."
;;   (interactive (erc-select-read-args))
;;   (erc-open server port nick full-name t password))


;; I don't know if the password is actually being used
;; This is not identifying me on freenode
;; erc doesn't have SASL support. I added a manual plugin
;; $EMACSD/manual-packages/erc-sasl
(defun erc-libertyprime (tls)
  (interactive (list (yn "Use tls?")))
  (let* ((user "libertyprime")
         (pw (chomp (sh-notty (concat "grep -P '\\b" user "\\b' ~/.authinfo | awk '{print $NF}'")))))
    (setq erc-password pw)
    ;; (erc :server "irc.freenode.net" :port "6667" :nick user :password)
    (if tls
        (erc-tls :server "irc.libera.chat" :port "6667" :nick user :password)
      (erc :server "irc.libera.chat" :port "6667" :nick user :password))))

;; I think ~/.authinfo is not working
(never (auth-source-search :host "irc.freenode.net" :max 3 :user "libertyprime" :require '(:secret)))
(auth-source-search :host "irc.libera.chat" :max 3 :user "libertyprime" :require '(:secret))

(defun erc-libertyprimebot ()
  (interactive)
  (erc :server "irc.freenode.net" :port "6667" :nick "libertyprimebot" (chomp (sh-notty "grep -P '\\blibertyprimebot\\b' ~/.authinfo | awk '{print $NF}'"))))

;; erc-sasl
;; Need to update the submodule
;; cd ~/.emacs.d
;; git submodule update --init extensions/erc-sasl
;;; Code:
(use-package erc)
;; (if
;;     ;; Can't use this method because I would have to add symlinks to all emcas distros
;;     ;; (file-exists-p (concat user-emacs-directory "extensions/erc-sasl/erc-sasl.el"))
;;     (file-exists-p (concat emacsdir "/manual-packages/erc-sasl/erc-sasl.el"))
;;     (use-package erc-sasl
;;       ;; This still may not exist because it might be relative to user-emacs-directory
;;       ;; :load-path "extensions/erc-sasl/"
;;       :after erc
;;       :config
;;       (add-to-list 'erc-sasl-server-regexp-list "irc\\.freenode\\.net")
;;       (defun erc-login ()
;;         "Perform user authentication at the IRC server."
;;         (erc-log (format "login: nick: %s, user: %s %s %s :%s"
;;                          (erc-current-nick)
;;                          (user-login-name)
;;                          (or erc-system-name (system-name))
;;                          erc-session-server
;;                          erc-session-user-full-name))
;;         (if erc-session-password
;;             (erc-server-send (format "PASS %s" erc-session-password))
;;           (message "Logging in without password"))
;;         (when (and (featurep 'erc-sasl) (erc-sasl-use-sasl-p))
;;           (erc-server-send "CAP REQ :sasl"))
;;         (erc-server-send (format "NICK %s" (erc-current-nick)))
;;         (erc-server-send
;;          (format "USER %s %s %s :%s"
;;                  ;; hacked - S.B.
;;                  (if erc-anonymous-login erc-email-userid (user-login-name))
;;                  "0" "*"
;;                  erc-session-user-full-name))
;;         (erc-update-mode-line))))


(provide 'my-erc)