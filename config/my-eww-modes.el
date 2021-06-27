(require 'eww )

(defmacro defewwmode (url)
  (setq url (str url))
  (let* ((urlslug (slugify (str url)))
         (modestr (concat urlslug "-eww-mode"))
         (modesym (str2sym modestr))
         (mapsym (str2sym (concat modestr "-map"))))
    `(progn
       (defvar ,mapsym (make-sparse-keymap)
         ,(concat "Keymap for `" modestr "'."))
       (defvar-local ,modesym nil)

       (define-minor-mode ,modesym
         ,(concat "A minor mode for the '" url "' eww url.")
         :global nil
         :init-value nil
         :lighter ,(s-upcase urlslug)
         :keymap ,mapsym)
       (provide ',modesym))))

(cl-loop for eww in '(hn asciinema) do (eval `(defewwmode ,eww)))

(defalias 'hacker-news-eww-mode 'hn-eww-mode)

(defun get-eww-mode-string-from-url (url)
  (cond ((string-match-p "^https?://news\.ycombinator\.com/?$" url) "hn")
        ((string-match-p "^https?://asciinema.org/" url) "asciinema")
        (t "")))

(defun reevaluate-minor-mode ()
  (interactive)
  ;; Disable all currently enabled eww minor modes

  (let* ((modes (my-apropos-function "-eww-mode$"))
         (modestr (get-eww-mode-string-from-url (get-path)))
         (modesym (str2sym (concat modestr "-eww-mode"))))
    (cl-loop for m in modes do
             (if (function-p m)
                 (funcall m -1)))
    (if (function-p modesym)
        (funcall modesym 1))))

(add-hook 'eww-after-render-hook #'reevaluate-minor-mode)
(add-hook 'eww-browse-url-after-hook #'reevaluate-minor-mode)
(add-hook 'eww-follow-link-after-hook #'reevaluate-minor-mode)
(add-hook 'eww-reload-after-hook #'reevaluate-minor-mode)
(add-hook 'eww-restore-history-after-hook #'reevaluate-minor-mode)

(defun hn-next-page ()
  (interactive))

(defun hn-prev-page ()
  (interactive))

(defun hn-next-article-comments ()
  (interactive))

(defun hn-prev-article-comments ()
  (interactive))

;; (make-next-prev-def-for-mode hn-eww-mode)

(defun hn-eww-prev-article
    (&optional re)
  (interactive)
  (if
      (not re)
      (setq re "^ +[0-9]+\\. +"))
  (backward-to-indentation 0)
  (ignore-errors (search-backward-regexp re))
  (backward-to-indentation 0)
  (shr-next-link))
(defun hn-eww-next-article
    (&optional re)
  (interactive)
  (if
      (not re)
      (setq re "^ +[0-9]+\\. +"))
  (backward-to-indentation 0)
  (if
      (looking-at-p re)
      (progn
        (forward-char)))
  (try
   (search-forward-regexp re))
  (backward-to-indentation 0)
  (shr-next-link))

(defun current-line-string ()
  (thing-at-point 'line t))

(defun hn-eww-next-article-comments ()
  (interactive)
  (if (not (string-match-p "^ +[0-9]+\\. +" (current-line-string)))
      (hn-eww-next-article))
  (search-forward-regexp "\\([0-9]+ comments?\\|discuss\\)")
  (shr-previous-link))

(defun hn-eww-prev-article-comments ()
  (interactive)
  (hn-eww-prev-article)
  (hn-eww-prev-article)
  (search-forward-regexp "\\([0-9]+ comments?\\|discuss\\)")
  (shr-previous-link))


(define-key hn-eww-mode-map (kbd "M-n") #'hn-eww-next-article)
(define-key hn-eww-mode-map (kbd "M-p") #'hn-eww-prev-article)

(define-key hn-eww-mode-map (kbd "M-N") #'hn-eww-next-article-comments)
(define-key hn-eww-mode-map (kbd "M-P") #'hn-eww-prev-article-comments)

(define-key hn-eww-mode-map (kbd "]]") #'hn-next-page)
(define-key hn-eww-mode-map (kbd "[[") #'hn-prev-page)


(defun asciinema-eww-next-cast (&optional re)
  (interactive)
  (if
      (not re)
      (setq re " +[0-9][0-9]:[0-9][0-9][^0-9]"))
  (backward-to-indentation 0)
  (if (string-match-p re (current-line-string))
      (search-forward-regexp re))
  (ignore-errors (search-forward-regexp re))
  (backward-to-indentation 0))

(defun asciinema-eww-prev-cast (&optional re)
  (interactive)
  (if
      (not re)
      (setq re " +[0-9][0-9]:[0-9][0-9][^0-9]"))
  (backward-to-indentation 0)
  (ignore-errors (search-backward-regexp re))
  (backward-to-indentation 0))

(define-key asciinema-eww-mode-map (kbd "M-n") #'asciinema-eww-next-cast)
(define-key asciinema-eww-mode-map (kbd "M-p") #'asciinema-eww-prev-cast)

(provide 'my-eww-modes)