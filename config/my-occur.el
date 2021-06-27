(require 'replace)                      ;builtin package

(define-key occur-mode-map (kbd "C-k") #'occur-mode-display-occurrence)



(defun occur-read-primary-args ()
  (let* ((perform-collect (consp current-prefix-arg))
         (regexp (read-regexp (if perform-collect
                                  "Collect strings matching regexp"
                                "List lines matching regexp")
                              ;; 'regexp-history-last
                              (let ((thing (unregexify (my/thing-at-point))))
                                (if (not (string-empty-p thing))
                                    ;; (if (yn (concat "Use word boundaries? " (concat "\\b" (my/thing-at-point) "\\b")))
                                    ;;     (list (concat "\\b" (my/thing-at-point) "\\b"))
                                    ;;   (list (my/thing-at-point)))
                                    (if (string-match-p "^[a-zA-Z0-9]+$" thing)
                                        (list (concat "\\b" thing "\\b"))
                                      (list thing))
                                  'regexp-history-last)))))
    (list regexp
	  (if perform-collect
	      ;; Perform collect operation
	      (if (zerop (regexp-opt-depth regexp))
		  ;; No subexpression so collect the entire match.
		  "\\&"
		;; Get the regexp for collection pattern.
		(let ((default (car occur-collect-regexp-history)))
		  (read-regexp
		   (format "Regexp to collect (default %s): " default)
		   default 'occur-collect-regexp-history)))
	    ;; Otherwise normal occur takes numerical prefix argument.
	    (when current-prefix-arg
	      (prefix-numeric-value current-prefix-arg))))))



;; This allows me to select text and use that for the basis of occur
;; Also, I want to be able to start iedit before starting occur -- so I can see the matches
(defun occur-around-advice (proc &rest args)
  (interactive
   (nconc (or (if (selection-p)
                  (let ((sel (selection)))
                    (deselect)
                    (list (concat "\\b" sel "\\b")))
                nil) (occur-read-primary-args))
          (and (use-region-p) (list (region-bounds)))))
  (call-interactively 'iedit-mode)
  (let ((res (if (use-region-p)
                 (apply proc (list (selection)))
               (apply proc args))))
    res))
(advice-add 'occur :around #'occur-around-advice)
;; (advice-remove 'occur #'occur-around-advice)

(defun my-grep-occur (dir regexp)
  (interactive (list (if (>= (prefix-numeric-value current-prefix-arg) 4)
                         (get-top-level)
                       (my/pwd)) (read-string "occur regexp: " (my/thing-at-point))))
  (moccur-grep-find dir (list regexp (file-name-extension (concat (unregexify (buffer-file-name)) "$")))))


(defun my-all-occur (rexp)
  "Search all buffers for REXP."
  (interactive (list (read-string "occur regexp: " (my/thing-at-point))))
  (multi-occur (buffer-list) rexp))


(define-key global-map (kbd "M-s a") 'my-all-occur)

;; TODO Make this find the files and open them as buffers then run occur
(define-key global-map (kbd "M-s g") 'my-grep-occur)

(require 'projectile)
(define-key global-map (kbd "M-s p") 'projectile-multi-occur)

(provide 'my-occur)