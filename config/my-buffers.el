(defun list-buffers-matching (re)
  (-filter
   (lambda (x)
     (string-match-p re x))
   (mapcar 'str (buffer-list))))

(defun search-all-buffers (regexp)
  (interactive "sRegexp: ")
  (multi-occur-in-matching-buffers "." regexp t))
(define-key global-map (kbd "M-l M-k M-3") 'search-all-buffers)


;; This is actually kinda unreliable
(defun get-previous-buffer ()
  (save-window-excursion (previous-buffer) (current-buffer)))


(defun buffer-to-string (b)
  (str (buffer-string* b)))



(provide 'my-buffers)