(require 'my-lingo)

(defun next-dash ()
  (interactive)
  (search-forward "-"))

(defun previous-dash ()
  (interactive)
  (search-backward "-"))

(define-key yaml-mode-map (kbd "M--") 'next-dash)

(define-key yaml-mode-map (kbd "C-c '") 'emacs-lisp-edit-string)

;; nothing is working for me today...
;; (define-key yaml-mode-map (kbd "C-M--") 'previous-dash)
;; (define-key yaml-mode-map (kbd "M-[ M--") 'previous-dash)
;; (define-key yaml-mode-map (kbd "M-] M--") 'next-dash)


;; (define-key yaml-mode-map (kbd "C-c '") nil)

;; k8s mode also runs this function if it's hooked into yaml-mode
;; Therefore I have to check that it's not yaml mode
(defun check-if-k8s ()
  (if (and (not (derived-mode-p 'k8s-mode))
           (string-match-p "apiVersion:" (buffer-contents))
           (string-match-p "kind:" (buffer-contents))
           (string-match-p "metadata:" (buffer-contents)))
      (k8s-mode)))

(defun check-if-gitlab-ci ()
  (if (and (not (derived-mode-p 'gitlab-ci-mode))
           (or (string-match-p ".*\\.gitlab-ci\\.yml.*" (buffer-name))
               (string-match-p ".*gitlab-ci\\.yml.*" (buffer-name))))
      (gitlab-ci-mode)))

(add-hook 'yaml-mode-hook 'check-if-k8s t)
(add-hook 'yaml-mode-hook 'check-if-gitlab-ci t)
;; (remove-hook 'yaml-mode-hook 'check-if-k8s)

(defun sh/yaml-get-value-from-this-file ()
  (interactive)
  (if (and (major-mode-p 'yaml-mode)
           (f-file-p (buffer-file-name)))
      (sps
       (concat
        (cmd "yaml-get-value"
             (buffer-file-name))
        " | xc -i"))))

(defun yaml-get-value-from-this-file ()
  (interactive)
  (if (and (major-mode-p 'yaml-mode)
           (f-file-p (buffer-file-name)))
      (let ((key (fz (sn "yq . | jq-showschema-keys" (buffer-string)))))
        (if (sor key)
            (let ((s (snc (cmd "yq" "-r" key) (buffer-string))))
              (with-current-buffer
                  (esps (lm (nbfs s)))
                (ekm "C-x h"))
              ;; (my/copy s)
              )))))

(provide 'my-yaml)