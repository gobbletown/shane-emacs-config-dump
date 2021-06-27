(require 'prodigy)

(define-key prodigy-mode-map (kbd "v") #'prodigy-display-process)

(prodigy-define-service
  :name "blog@localhost"
  :command "python2"
  :args '("-m" "SimpleHTTPServer" "8000")
  :cwd "/home/shane/source/git/mullikine/mullikine.github.io/"
  :tags '(file-server)
  :stop-signal 'sigkill
  :kill-process-buffer-on-stop t)

(prodigy-define-service
  :name "start-background-processes"
  :command "start-background-processes"
  :args '()
  :cwd "~/"
  :tags '(bash init)
  :stop-signal 'sigint
  :kill-process-buffer-on-stop t)

(prodigy-define-service
  :name "datomic"
  :command "datomic-start-local-transactor"
  :args '()
  :cwd "~/"
  :port 4334
  :tags '(bash init)
  :stop-signal 'sigint
  :kill-process-buffer-on-stop t)

(prodigy-define-service
  :name "test prompts"
  :command "continually-test-prompts"
  :args ()
  ;; :command "git-repo-for-each-branch-do"
  ;; :args '("https://github.com/semiosis/prompts/"
  ;;         "/home/shane/source/git/semiosis/prompt-tests/run-tests")
  :cwd "~/"
  :tags '(pen)
  :stop-signal 'sigkill
  :kill-process-buffer-on-stop t)

;; Kick it off
;; TODO Don't kick it off automatically
;; (prodigy-restart-service
;;     '(:name "test prompts" :command "continually-test-prompts" :args nil :cwd "~/" :tags
;;             (pen)
;;             :stop-signal sigint
;;             :kill-process-buffer-on-stop t))

(prodigy-define-service
  :name "pydoc3.5"
  :command "pydoc3.5"
  :args '("-p" "7035")
  :cwd "~/"
  :tags '(python)
  :stop-signal 'sigkill
  :kill-process-buffer-on-stop t)

(prodigy-define-service
  :name "pydoc3.6"
  :command "pydoc3.6"
  :args '("-p" "7036")
  :cwd "~/"
  :tags '(python)
  :stop-signal 'sigkill
  :kill-process-buffer-on-stop t)

(prodigy-define-service
  :name "pydoc3.7"
  :command "pydoc3.7"
  :args '("-p" "7037")
  :cwd "~/"
  :tags '(python)
  :stop-signal 'sigkill
  :kill-process-buffer-on-stop t)

(prodigy-define-service
  :name "start hugo server"
  :command "start-hugo-server"
  :args '("-p" "8580")
  :cwd "/home/shane/dump/home/shane/notes/ws/blog/blog"
  :tags '(hugo)
  :stop-signal 'sigkill
  :kill-process-buffer-on-stop t)

(prodigy-define-service
  :name "start fortescue hugo server"
  :command "start-fmg-hugo-server"
  :args '("-p" "8680")
  :cwd "/home/shane/dump/home/shane/notes/ws/fmg-fortesque-metals-group/blog-hugo"
  :tags '(hugo)
  :stop-signal 'sigkill
  :kill-process-buffer-on-stop t)

(prodigy-define-service
  :name "port-forward to k8s elasticsearch"
  :command "k8s-es-port-forward"
  :args '()
  :cwd "/home/shane"
  :tags '(es k8s)
  :stop-signal 'sigint
  :kill-process-buffer-on-stop t)

;; prodigy isn't really appropriate for this
;; (prodigy-define-service
;;   :name "google for coffee"
;;   :command "gl"
;;   :args '("-notty" "-loop" "5" "coffee" "near" "me")
;;   :cwd "/home/shane"
;;   :tags '(coffee)
;;   :stop-signal 'sigint
;;   :kill-process-buffer-on-stop t)

;; How to add an elisp function?
;; clomacs-httpd-start


(defun org-link--prodigy (service-name)
  (save-window-excursion
    (prodigy)

    (prodigy-first)
    ;; (tv (pps service-name))
    (search-forward (concat "     " service-name "  "))
    (prodigy-start)
    (my-prodigy-copy 0)
    ;; (ekm "r")
    ))

(org-add-link-type "prodigy" 'org-link--prodigy)


(defun prodigy-copy-name ()
  (interactive)
  (xc (concat "[[prodigy:" (prodigy--imenu-extract-index-name) "]]")))

(defun my-prodigy-copy (arg)
  (interactive "P")

  (if (not arg)
      (setq arg 7))

  (cond
   ((= arg 0) (prodigy-copy-url))
   (t (prodigy-copy-name))))


(define-key prodigy-mode-map (kbd "w") 'my-prodigy-copy)


(provide 'my-prodigy)