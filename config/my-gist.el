(require 'gist)

;; This already copies. No need for advice
;; (gist-print-current-url)

(defun get-gist-url ()
  (interactive)
  (let ((url
         (concat
          "https://gist.github.com"
          "/"
          gist-list-buffer-user
          "/"
          (tabulated-list-get-id))))

    (if (called-interactively-p)
        (my/copy url))
    url))

(defun my-gist-open ()
  (interactive)
  (let ((url (get-gist-url)))
    (if (called-interactively-p)
        (nw (concat "o " (q url))))))

(defun my-gist-browse ()
  (interactive)
  (let ((url (get-gist-url)))
    (if (called-interactively-p)
        (progn
          (nw (concat "eww " (q url)))
          (my/copy url)))))

(defun my-gist-copy-url ()
  (interactive)
  (if (called-interactively-p)
      (my/copy (get-gist-url))))

(define-key gist-list-menu-mode-map (kbd "w") #'get-gist-url)
(define-key gist-list-menu-mode-map (kbd "r") #'my-gist-browse)
(define-key gist-list-menu-mode-map (kbd "c") #'my-gist-copy-url)
(define-key gist-list-menu-mode-map (kbd "o") #'my-gist-open)

(provide 'my-gist)
