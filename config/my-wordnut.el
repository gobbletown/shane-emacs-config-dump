(require 'wordnut)

;; Can't override because of lexical binding
;; (defun wordnut-lookup-current-word ()
;;   (interactive)
;;   (let (inline)
;;     (ignore-errors
;;       (wordnut--history-update-cur wordnut-hs))

;;     (setq inline (wordnut--lexi-link))
;;     (if inline
;; 	      (wordnut--lookup (car inline) (nth 1 inline) (nth 2 inline))
;;       (wordnut--lookup (current-word))
;;       ;; (call-interactively 'egr-thing-at-point-imediately)
;;       ;; (try (wordnut--lookup (current-word))
;;       ;;      (call-interactively 'egr-thing-at-point-imediately))
;;       )))

(provide 'my-wordnut)