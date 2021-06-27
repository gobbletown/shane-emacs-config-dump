(require 'mermaid-mode)

;; (defun mermaid-compile ()
;;   "Compile the current mermaid file using mmdc."
;;   (interactive)
;;   (let* ((input (f-filename (buffer-file-name)))
;;          (output (concat (file-name-sans-extension input) mermaid-output-format)))
;;     (call-process mermaid-mmdc-location nil "*mmdc*" nil "-i" input "-o" output)))

(defun mermaid-compile ()
  "Compile the current mermaid file using mmdc."
  (interactive)
  (if (selection-p)
      (sh-notty "mermaid-show" (selection))
    (sh-notty "mermaid-show" (buffer-contents))
    ;; (sh "mermaid-show" (selection))
    ;; (let* ((input (f-filename (buffer-file-name)))
    ;;        ;; (output (concat (file-name-sans-extension input) mermaid-output-format))
    ;;        )
    ;;   ;; (call-process mermaid-mmdc-location nil "*mmdc*" nil "-i" input "-o" output)
    ;;   (sh-notty (concat "mermaid-show " (q input)))
    ;;   ;; (sh (concat "mermaid-show " (q input)))
    ;;   )
    ))

(setq mermaid-mmdc-location "/home/shane/scripts/mmdc")
(setq ob-mermaid-cli-path "/home/shane/scripts/mmdc")

(provide 'my-mermaid)