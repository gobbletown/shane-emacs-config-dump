(require 'plantuml-mode)

;; (setq plantuml-jar-path (chomp (sh-notty "alt -q plantuml")))
(setq plantuml-jar-path "/usr/share/plantuml/plantuml.jar")


(defun plantuml-init ()
  "Initialize the keywords or builtins from the cmdline language output."
  ;; (unless (or (eq system-type 'cygwin) (file-exists-p plantuml-jar-path))
  ;;   (error "Could not find plantuml.jar at %s" plantuml-jar-path))
  (with-temp-buffer
    (let ((cmd-args (plantuml-render-command "-language")))
      (apply 'call-process cmd-args)
      (goto-char (point-min)))
    (let ((found (search-forward ";" nil t))
          (word "")
          (count 0)
          (pos 0))
      (while found
        (forward-char)
        (setq word (current-word))
        (if (string= word "EOF") (setq found nil)
          ;; else
          (forward-line)
          (setq count (string-to-number (current-word)))
          (beginning-of-line 2)
          (setq pos (point))
          (forward-line count)
          (cond ((string= word "type")
                 (setq plantuml-types
                       (split-string
                        (buffer-substring-no-properties pos (point)))))
                ((string= word "keyword")
                 (setq plantuml-keywords
                       (split-string
                        (buffer-substring-no-properties pos (point)))))
                ((string= word "preprocessor")
                 (setq plantuml-preprocessors
                       (split-string
                        (buffer-substring-no-properties pos (point)))))
                (t (setq plantuml-builtins
                         (append
                          plantuml-builtins
                          (split-string
                           (buffer-substring-no-properties pos (point)))))))
          (setq found (search-forward ";" nil nil)))))))

(defun plantuml-render-command (&rest arguments)
  "Create a command line to execute PlantUML with arguments (as ARGUMENTS)."
  (let* ((cmd-list (append (list "plantuml") arguments))
         (cmd (mapconcat 'identity cmd-list "|")))
    (plantuml-debug (format "Command is [%s]" cmd))
    cmd-list))


(provide 'my-plantuml-mode)