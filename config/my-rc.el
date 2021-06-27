(require 'my-prog)

(defun my-goto-rc ()
  (interactive)
  (let ((rcsym (str2sym (concat (str major-mode) "-rc"))))
    (if (functionp rcsym)
        (funcall rcsym))))

(defun haskell-mode-rc ()
  (sps "vs -o $HOME/.ghci.hs $HOME/.ghci"))

(defun emacs-lisp-mode-rc ()
  (find-file (umn "$EMACSD/emacs")))

(defun common-lisp-mode-rc ()
  (find-file (umn "$HOME/.clisprc")))

(defun python-mode-rc ()
  (find-file (umn "$NOTES/ws/python/shanepy/shanepy.py")))

(defun prodigy-mode-rc ()
  (find-file (umn "$EMACSD/config/my-prodigy.el")))

(defun docker-container-mode-rc ()
  (find-file (umn "$EMACSD/config/my-docker.el")))

(defun docker-image-mode-rc ()
  (find-file (umn "$EMACSD/config/my-docker.el")))

(defun org-mode-rc ()
  (interactive)
  (find-file
   (umn (fz "$EMACSD/config/hydra-org.el
$EMACSD/config/my-org-brain.el
$EMACSD/config/my-org-templates.el
$EMACSD/config/my-org.el
$EMACSD/config/org-config.el
$EMACSD/config/org/org-google.el
$EMACSD/config/org/org-man.el
$EMACSD/config/org/org-rifle.el
$EMACSD/config/org/org-youtube.el"
            nil
            nil
            "org-mode-rc: "))))

(defun clojure-mode-rc ()
  (interactive)
  (find-file
   (umn (fz "$HOME/.clojurerc
$HOME/.clojure/deps.edn
$HOME/.clojure/rebel_readline.edn
$HOME/.lein/profiles.clj"
            nil
            nil
            "clojure-mode-rc: "))))

(defun kubernetes-overview-mode-rc ()
  (interactive)
  (find-file
   (umn (fz "$HOME/.kube/config
/etc/kubernetes/manifest/kube-apiserver.yaml
$EMACSD/config/my-kubernetes.el"
            nil
            nil
            "kubernetes-overview-mode-rc: "))))

(provide 'my-rc)