;; v +/"github-search-clone-repo" "$EMACSD/packages27/github-search-20170824.323/github-search.el"
;; github-search-clone-repo

(require 'github-search)

(require 'license-templates)

;; This fixes an issue
(defset github-search-clone-repository-function 'magit-clone-regular)

(defun github-search-do-repo-clonef (repo)
  (let ((remote-url (funcall github-search-get-clone-url-function repo))
        (target-directory (github-search-get-target-directory-for-repo repo)))
    (funcall github-search-clone-repository-function remote-url target-directory "")))

(defun my-egr-guru99 (query)
  (interactive (list (read-string-hist "egr:" "guru99 ")))
  ;; (sps (concat "eww " (q (car (str2list (sn (concat "gl " (q query))))))))
  (eww (car (str2list (sn (concat "gl " (q query)))))))

(defun my-rat-dockerhub-search (query)
  (interactive (list (read-string-hist "dockerhub:")))
  (sps (concat "rat-dockerhub " (q query))))

(defun my-k8s-hub-search-eww (query)
  (interactive (list (read-string-hist "egr:" "kubernetes hub ")))
  (sps (concat "eww " (q (car (str2list (sn (concat "gl " (q query) " | grep helm.sh/charts/"))))))))

(defun my-k8s-hub-search (query)
  (interactive (list (read-string-hist "helm hub install:" "")))
  (fz (str2list (chomp (sn (concat "helm search hub -o json " (q query) " | jq -r '.[].url'"))))
      nil nil "k8s hub: "))

(defun sh/gc (url)
  (interactive (list (read-string-hist "GitHub url:")))
  (term-nsfa-tm (concat "gc " (q url))))

(defun my-github-docker-compose-search-and-clone (query)
  (interactive (list (read-string-hist "GitHub docker-compose:")))
  (gc (fz (annotate-github-urls-with-info (sn (concat "glh docker-compose " (q query))))
          nil nil "gc docker compose: ")))

(defun my-github-awesome-search-and-clone (query)
  (interactive (list (read-string-hist "GitHub awesome:")))
  (gc (fz (annotate-github-urls-with-info (sn (concat "glh awesome " (q query))))
          nil nil "gc awesome: ")))

(defun my-github-example-search-and-clone (query)
  (interactive (list (read-string-hist "GitHub example:")))
  (gc (fz (annotate-github-urls-with-info (sn (concat "glh example " (q query))))
          nil nil "gc example: ")))

(defun github-clone-dired (url)
  (interactive (list (read-string-hist "GitHub url:")))
  (let ((dir (cl-sn (concat "gc " (q url) " | cat") :chomp t)))
    (if (f-directory-p dir)
        (progn
          (dired dir)
          (dired-git-info-mode 1)
          (dired-hide-details-mode 0))
      (message "unsuccesful"))
    dir))
(defalias 'gc 'github-clone-dired)

(defun my-github-search-and-clone-cookiecutter (query)
  (interactive (list (read-string-hist "cookiecutter query:")))
  (let* ((url (fz (cl-sn (concat "upd glh cookiecutter " (q query) " | cat" ) :chomp t)))
         (dir (if url (gc url)))
         (name (if (and url dir) (read-string-hist "project name: " query))))
    (if (and dir name)
        (term-sps (tmuxify-cmd (concat "CWD= zrepl cookiecutter " (q dir))) (new-project-dir name)))))

(defun zip-shell-filter1 (filtercmd lors)

  ;; -zip-lists
  (let ((l1)
        (l2))
    (if (stringp lors)
        (setq lors (str2list lors)))

    (loop for u in lors collect
          (list u
                (if (re-match-p "github.com" u)
                    (concat
                     (snc "get-stars-for-repo" u) "★, " (snc "get-most-recent-commit-for-repo" u))
                  "")))))

(defun annotate-github-urls-with-info (urls)
  (if (stringp urls)
      (setq urls (str2list urls)))

  (loop for u in urls collect
        (list u
              (if (re-match-p "github.com" u)
                  (concat
                   (snc "get-stars-for-repo" u) "★, " (snc "get-most-recent-commit-for-repo" u))
                ""))))

(defun test-annotate-github-urls-with-info ()
  (interactive)
  ;; (etv
  ;;  (pps
  ;;   (annotate-github-urls-with-info
  ;;    (list
  ;;     "https://github.com/dinedal/textql"
  ;;     "https://gitlab.com/Oslandia/albion"))))
  (gc
   (fz
    (annotate-github-urls-with-info
     (list
      "https://github.com/dinedal/textql"
      "https://gitlab.com/Oslandia/albion"))
    nil nil "test-annotate-github-urls-with-info: ")))

(defun my-github-search-and-clone (query)
  (interactive (list (read-string-hist "GitHub query:")))
  (gc (fz (annotate-github-urls-with-info (sn (concat "upd glh " (q query) " | cat")))
          nil nil "gc: ")) :chomp t)

(defun sh/my-github-search-and-clone (query)
  (interactive (list (read-string-hist "GitHub query:")))
  (sh/gc (fz (annotate-github-urls-with-info (sn (concat "upd glh " (q query)))))))
(defalias 'sh/gc 'sh/my-github-search-and-clone)

(defun tpb (query)
  (interactive (list (read-string-hist "tpb: ")))
  (sps (concat "tpb " query)))

;; (defun my-github-search-and-clone-template (query)
;;   (interactive (list (read-string-hist "GitHub query:")))
;;   (term-nsfa-tm (concat "gc " (q (fz (sn (concat "glh " (q query) " template")))))))

(defun my-github-search-and-clone-template (query)
  (interactive (list (read-string-hist "GitHub query:" (concat (current-lang) " template "))))
  (term-nsfa-tm (concat "gc " (q (fz (sn (concat "glh " query)))))))

;; smth is used for the browse function handler
;; So if i want to add extra stuff I must place it later
(defun chrome (url &optional smth)
  (interactive (list (read-string-hist "chrome url: ")))
  (cl-sn (concat "chrome " (q url)) :detach t))


;; bug
;; It's because of changing buffers
;; (shut-up (substring (pwd) 10))

(defun github-url ()
  (let* ((git-url (string-or (cl-sn "vc url" :dir (my/pwd) :chomp t))))
    (if git-url
        (if (re-match-p "//github.com/" git-url)
            git-url))))

(defun vc-url ()
  (string-or (cl-sn "vc url" :dir (my/pwd) :chomp t)))

(defun chrome-github-actions ()
  "This opens github actions for this git repository in vscode in chrome"
  (interactive)
  (let ((git-url (string-or (cl-sn "vc url" :dir (my/pwd) :chomp t))))
    (if git-url
        (if (re-match-p "//github.com/" git-url)
            (progn
              (setq git-url (concat (snc "gh-base-url" git-url) "/actions/new"))
              (chrome git-url))))))

(defun github1s ()
  "This opens the readme of this git repository in vscode in chrome"
  (interactive)
  (let ((git-url (string-or (cl-sn "vc url" :dir (my/pwd) :chomp t))))
    (if git-url
        (if (re-match-p "//github.com/" git-url)
            (progn
              (setq git-url (s-replace-regexp "//github\\.com/" "//github1s.com/" git-url))
              (chrome git-url))))))

(defun github-surf ()
  "This opens the readme of this git repository in vscode in chrome"
  (interactive)
  (let ((git-url (string-or (cl-sn "vc url" :dir (my/pwd) :chomp t))))
    (if git-url
        (if (re-match-p "//github.com/" git-url)
            (progn
              (setq git-url (s-replace-regexp "//github\\.com/" "//github.surf/" git-url))
              (chrome git-url))))))


(defun chrome-git-url ()
  "This opens this git repository in chrome"
  (interactive)
  (let ((git-url (string-or (cl-sn "vc url" :dir (my/pwd) :chomp t))))
    (if git-url
        (chrome git-url))))

(provide 'my-github)