;; Disable message with never
(defun hi-lock-set-pattern (regexp face &optional subexp lighter case-fold spaces-regexp)
  "Highlight SUBEXP of REGEXP with face FACE.
If omitted or nil, SUBEXP defaults to zero, i.e. the entire
REGEXP is highlighted.  LIGHTER is a human-readable string to
display instead of a regexp.  Non-nil CASE-FOLD ignores case.
SPACES-REGEXP is a regexp to substitute spaces in font-lock search."
  ;; Hashcons the regexp, so it can be passed to remove-overlays later.
  (setq regexp (hi-lock--hashcons regexp))
  (setq subexp (or subexp 0))
  (let ((pattern (list (lambda (limit)
                         (let ((case-fold-search case-fold)
                               (search-spaces-regexp spaces-regexp))
                           (re-search-forward regexp limit t)))
                       (list subexp (list 'quote face) 'prepend)))
        (no-matches t))
    ;; Refuse to highlight a text that is already highlighted.
    (if (or (assoc regexp hi-lock-interactive-patterns)
            (assoc (or lighter regexp) hi-lock-interactive-lighters))
        (add-to-list 'hi-lock--unused-faces (face-name face))
      (push pattern hi-lock-interactive-patterns)
      (push (cons (or lighter regexp) pattern) hi-lock-interactive-lighters)
      (if (and font-lock-mode (font-lock-specified-p major-mode))
	        (progn
	          (font-lock-add-keywords nil (list pattern) t)
	          (font-lock-flush))
        (let* ((range-min (- (point) (/ hi-lock-highlight-range 2)))
               (range-max (+ (point) (/ hi-lock-highlight-range 2)))
               (search-start
                (max (point-min)
                     (- range-min (max 0 (- range-max (point-max))))))
               (search-end
                (min (point-max)
                     (+ range-max (max 0 (- (point-min) range-min)))))
               (case-fold-search case-fold)
               (search-spaces-regexp spaces-regexp))
          (save-excursion
            (goto-char search-start)
            (while (re-search-forward regexp search-end t)
              (when no-matches (setq no-matches nil))
              (let ((overlay (make-overlay (match-beginning subexp)
                                           (match-end subexp))))
                (overlay-put overlay 'hi-lock-overlay t)
                (overlay-put overlay 'hi-lock-overlay-regexp (or lighter regexp))
                (overlay-put overlay 'face face))
              (goto-char (match-end 0)))
            (when no-matches
              (add-to-list 'hi-lock--unused-faces (face-name face))
              (setq hi-lock-interactive-patterns
                    (cdr hi-lock-interactive-patterns)
                    hi-lock-interactive-lighters
                    (cdr hi-lock-interactive-lighters))))
          (never
           (when (or (> search-start (point-min)) (< search-end (point-max)))
             (message "Hi-lock added only in range %d-%d" search-start search-end))))))))

(provide 'my-hi-lock)