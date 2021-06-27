(require 'my-mode)

(defun google-scrape-after-loaded ()
  ;; (new-buffer-from-string (sh/ptw/uniqnosort (sh/ptw/xurls (format "%S" (buffer-string)))) "*google-results*")
  (let ((results (sh/ptw/uniqnosort (sh/ptw/xurls (format "%S" (buffer-string))))))
    (write-string-to-file results "/tmp/eww-scrape-output.txt")
    (new-buffer-from-string results)))

(defun eww-browse-url-then (url thenproc)
  (setq eww-after-render-hook (list
                               thenproc
                               (lm
                                (setq eww-after-render-hook '())
                                ;; This doesn't work for some reason
                                ;; (setq eww-after-render-hook ,oldhook)
                                ;; Unfortunately, this still runs
                                (add-hook 'eww-after-render-hook 'finished-loading-page))))
  (eww-browse-url url))

(defun google-scrape-results (query &rest runafter)
  (interactive (list (read-string "query:")))

  (if (not (string-empty-p query))
      (let* ((encodedquery (sh/ptw/urlencode query))
             (url (concat "http://www.google.com/search?ie=utf-8&oe=utf-8&q=" encodedquery))
             ;; (oldhook eww-after-render-hook)
             )

        (eval `(eww-browse-url-then url (lm (google-scrape-after-loaded) ,@runafter))))))

;; helm-google-suggest (C-x c C-c g)

(defun google-mode-language-and-selected-text ()
  (interactive)
  (let ((sel (or (selection)
                 (str (sexp-at-point)))))
    (nw (concat "egr " (current-lang) " " (bp tr "\\n" " " sel)))))

(define-key my-mode-map (kbd "C-c g") 'helm-google-suggest)
(define-key my-mode-map (kbd "M-q M-g M-s") 'helm-google-suggest)
(define-key my-mode-map (kbd "M-q M-g M-g") 'google-mode-language-and-selected-text)

(provide 'my-google)