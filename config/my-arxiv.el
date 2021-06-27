(require 'biblio-arxiv)

(define-key biblio-selection-mode-map (kbd "M-p") #'handle-prevdef)
(define-key biblio-selection-mode-map (kbd "p") #'handle-prevdef)
(define-key biblio-selection-mode-map (kbd "M-n") #'handle-nextdef)
(define-key biblio-selection-mode-map (kbd "n") #'handle-nextdef)

(define-key biblio-selection-mode-map (kbd "C-k") #'biblio--selection-browse-direct)
(define-key biblio-selection-mode-map (kbd "C-j") #'biblio--selection-browse)
(define-key biblio-selection-mode-map (kbd "C-m") #'get-arxiv-summary)
(define-key biblio-selection-mode-map (kbd "C-h") #'get-arxiv-summary-vs)

(defun get-arxiv-summary-vs (&optional url)
  "Scan downwards for the first arxiv url and use that"
  (interactive)
  ;; Plan: use awk

  (save-excursion
    (search-forward "http://")
    (setq url (thing-at-point 'url)))
  ;; (if (not url)
  ;;     (setq url (thing-at-point 'url)))
  ;; (if (not url)
  ;;     (error "no url under cursor"))

  ;; (new-buffer-from-string (eval `(ci (sh-notty "q | xa arxiv-summary; a beep" ,url t))))
  ;; (new-buffer-from-string (sh-notty (concat "ci arxiv-summary " (e/q url))))
  (spv (concat "arxiv-summary " (e/q url))))

(defun get-arxiv-summary (&optional url)
  "Scan downwards for the first arxiv url and use that"
  (interactive)
  ;; Plan: use awk

  (save-excursion
    (search-forward "http://")
    (setq url (thing-at-point 'url)))
  ;; (if (not url)
  ;;     (setq url (thing-at-point 'url)))
  ;; (if (not url)
  ;;     (error "no url under cursor"))

  ;; (new-buffer-from-string (eval `(ci (sh-notty "q | xa arxiv-summary; a beep" ,url t))))
  ;; (new-buffer-from-string (sh-notty (concat "ci arxiv-summary " (e/q url))))
  (new-buffer-from-string (eval `(ci (sh-notty (concat "arxiv-summary " ,(e/q url)))))))

(defun get-arxiv-summary-line (&optional line)
  (interactive)

  (if (not line)
      (setq line (str (thing-at-point 'line))))
  (if (not line)
      (error "no line under cursor"))

  (new-buffer-from-string (bp sed -u -n "s=.*: \\(\\([a-z-]\\+/\\)\\?[0-9.v]\\+\\).*=\\1=p" | xa arxiv-summary line)))

(provide 'my-arxiv)