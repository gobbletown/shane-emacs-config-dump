(require 'hackernews)

;; (define-key hackernews-mode-map (kbd "TAB") 'hackernews-next-item)
;; (define-key hackernews-mode-map (kbd "TAB") 'hackernews-next-comment)
;; hackernews-next-comment

(defun button-at-point ()
  (button-at (point)))

(defun hackernews-enter ()
  (interactive)
  (save-excursion
    (if (not (button-at-point))
        (hackernews-next-item))
    (ekm "RET")))

(define-key hackernews-mode-map (kbd "RET") 'hackernews-enter)

(defun hackernews-previous-line ()
  (interactive)
  (previous-line)
  (save-excursion
    (beginning-of-line)
    (hackernews-next-item)
    ;; (if (button-at-point)
    ;;     (message "%s" (button-get (button-at-point) 'help-echo)))
    ))

(define-key hackernews-mode-map (kbd "<up>") 'hackernews-previous-line)

(defun hackernews-next-line ()
  (interactive)
  (next-line)
  (save-excursion
    (beginning-of-line)
    (hackernews-next-item)
  ;; (if (button-at-point)
  ;;     (message "%s" (button-get (button-at-point) 'help-echo)))
    ))

(define-key hackernews-mode-map (kbd "<down>") 'hackernews-next-line)


(provide 'my-special)