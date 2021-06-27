;; Use this instead
;; e:$EMACSD/config/my-file-parsers.el

;; (defun ufc-abstract ()
;;   (interactive)
;;   (cond ((and (major-mode-p 'clojure-mode)
;;               (string-equal "edn" (f-ext (get-path))))
;;          (nbfs (snc "ej | jq ." (buffer-string))
;;                nil
;;                'json-mode))))

;; (define-key my-mode-map (kbd "H-&") 'ufc-abstract)

(provide 'my-universal-file-conversion)