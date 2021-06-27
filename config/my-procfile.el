;; a simple major mode, procfile-mode
;; For heroku Procfile

(setq procfile-highlights
      '(("^web:\\|^worker:\\|^release:\\|^urgentworker:" . font-lock-function-name-face))
      ;; '(("^web:\\|^worker:\\|^release:\\|^urgentworker:" . font-lock-function-name-face)
      ;;   ("Pi\\|Infinity" . font-lock-constant-face))
      )

(define-derived-mode procfile-mode fundamental-mode "procfile"
  "major mode for editing Procfile."
  (setq font-lock-defaults '(procfile-highlights)))

(defun foreman-find-procfile ()
  (let ((dir (f-traverse-upwards
              (lambda (path)
                (f-exists? (f-expand foreman-procfile-name path)))
              ".")))
    (if dir (f-expand foreman-procfile-name dir)
      (message "Procfile not found"))))

(provide 'my-procfile)