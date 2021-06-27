(defun mode-line-progressbar-demo (&optional duration)
  "Displays a progressbar in the mode-line."
  (interactive (list 3))
  (let* ((mode-line-format mode-line-format)
         (max (window-width))
         (durationl duration)
         (delta (max 0 (/ (float durationl) max)))
         (message "Processing"))
    (unwind-protect
        (dotimes (i max)
          (let* ((text (format "%s %.2f%%%%" message (* 100 (/ (float i) max))))
                 (fill (ceiling (/ (max 0 (- max (length text))) (float 2))))
                 (msg (concat (make-string fill ?\s) text (make-string fill ?\s))))
            (put-text-property 0 i 'face '(:background "royalblue") msg)
            (setq mode-line-format msg)
            (force-mode-line-update)
            (sit-for delta)))
      (force-mode-line-update))))

(defun mode-line-progress-demo (&optional nsteps sleep)
  (interactive (list 500 0.01))
  (let ((progress-reporter
         (make-progress-reporter "Collecting mana for Emacs..."
                                 0  nsteps)))
    (dotimes (k nsteps)
      (sit-for sleep)
      (progress-reporter-update progress-reporter k))
    (progress-reporter-done progress-reporter)))

(provide 'my-mode-line-progressbar)