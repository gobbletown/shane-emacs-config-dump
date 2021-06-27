;; This package was the cause of slowness.
;; It's an apropos for Unicode -- to find emoji's. Simon showed me.


;; (require 'apu)

;; (defun apropos-char ()
;;   (interactive
;;    ;; (prog1 ()
;;    ;;   (setq apu-latest-pattern-set (list (list (apu-chars-read-pattern-arg)) nil))
;;    ;;   (let ((list-buf  (get-buffer-create
;;    ;;                     (apu-buf-name-for-matching (car apu-latest-pattern-set)
;;    ;;                                                (cdr apu-latest-pattern-set)))))
;;    ;;     (apu-add-to-pats+bufs (cons apu-latest-pattern-set list-buf))
;;    ;;     (with-current-buffer list-buf (setq apu--patterns (car apu-latest-pattern-set)))))
;;    (prog1 ()
;;      (setq apu-latest-pattern-set (list (list ;; (apu-chars-read-pattern-arg)
;;                                          (list ".*")) nil))
;;      (let ((list-buf  (get-buffer-create
;;                        (apu-buf-name-for-matching (car apu-latest-pattern-set)
;;                                                   (cdr apu-latest-pattern-set)))))
;;        (apu-add-to-pats+bufs (cons apu-latest-pattern-set list-buf))
;;        (with-current-buffer list-buf (setq apu--patterns (car apu-latest-pattern-set))))))
;;   (setq apu--orig-buffer  (current-buffer)
;;         apu--refresh-p    t)
;;   (when (called-interactively-p 'interactive)
;;     (setq apu--match-type  (if apu-match-two-or-more-words-flag
;;                                'MATCH-TWO-OR-MORE
;;                              (if apu-match-words-exactly-flag
;;                                  'MATCH-WORDS-EXACTLY
;;                                'MATCH-WORDS-AS-SUBSTRINGS))))
;;   (apu-print-apropos-matches)
;;   (apu-match-type-msg))

(provide 'my-apu)