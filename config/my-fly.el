;; (defvar flyspell-flycheck-enabled t)

(defun my-flyspell-buffer ()
  (interactive)
  ;; In honesty, this may be too slow
  (if (myrc-test "auto_flyspell_flycheck")
      (flyspell-buffer)
    ;; (user-error "flyspell-flycheck disabled")
    ))

;; Combine flyspell and flycheck
(defun fly-next-error ()
  (interactive)
  (let* ((pos (point))
         (fspos
          (save-excursion
            (ignore-errors
              (try
               (progn
                 (if (flyspell-overlay-here-p)
                     (setq flyspell-old-pos-error (point))
                   (setq flyspell-old-pos-error nil))
                 (call-interactively 'flyspell-goto-next-error)
                 (point))))))
         (fcpos
          (save-excursion
            (ignore-errors
              (try
               (progn
                 (call-interactively 'flycheck-next-error)
                 (point)))))))

    (if (and fspos
             (= pos fspos))
        (setq fspos nil))

    (if (and fcpos
             (= pos fcpos))
        (setq fcpos nil))

    (cond
     ((and fspos
           (or
            (not fcpos)
            (< fspos fcpos))
           (< (point) fspos))
      (progn
        ;; (message (concat "going from " (str (point)) " to " (str fspos) " oldpos: " (str flyspell-old-pos-error) " flyspell-old-pos-error: " (str flyspell-old-pos-error)))

        (goto-char fspos)

        ;; This isn't very reliable. Just go to the point
        ;; (call-interactively 'flyspell-goto-next-error)
        ;; (flyspell-goto-next-error)
        ;; (message (concat "gone from " (str (point)) " to " (str fspos) " oldpos: " (str flyspell-old-pos-error)))
        ))
     ((and fcpos
           (or
            (not fspos)
            (< fcpos fspos))
           (< (point) fcpos))
      (call-interactively 'flycheck-next-error)))))

(defun fly-prev-error ()
  (interactive)
  (let* ((pos (point))
         (fspos
          (save-excursion
            (ignore-errors
              (try
               (progn
                 (if (flyspell-overlay-here-p)
                     (setq flyspell-old-pos-error (point))
                   (setq flyspell-old-pos-error nil))
                 (call-interactively 'flyspell-goto-previous-error)
                 (point))))))
         (fcpos
          (save-excursion
            (ignore-errors
              (try
               (progn
                 (call-interactively 'flycheck-previous-error)
                 (point)))))))

    (if (and fspos
             (= pos fspos))
        (setq fspos nil))

    (if (and fcpos
             (= pos fcpos))
        (setq fcpos nil))

    (cond
     ((and fspos
           (or
            (not fcpos)
            (> fspos fcpos))
           (> (point) fspos))
      (progn
        (goto-char fspos)
        ;; (call-interactively 'flyspell-goto-previous-error)
        ))
     ((and fcpos
           (or
            (not fspos)
            (> fcpos fspos))
           (> (point) fcpos))
      (call-interactively 'flycheck-previous-error)))))

(provide 'my-fly)