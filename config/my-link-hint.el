(require 'link-hint)

(defun link-hint--apply (func args &optional parser action)
  "Try to call FUNC with ARGS.
If PARSER is specified, first change ARGS by passing PARSER ARGS and ACTION.
First try `apply'. If there is an error (ARGS is the wrong number of arguments
for FUNC), `funcall' FUNC with ARGS. Finally, call FUNC alone."
  (when parser
    (setq args (funcall parser args action)))
  ;; TODO is there a way to know how many arguments a function takes?
  (try
   (apply func args)
   (funcall func args)
   (funcall func)
   ;; (funcall func (fourth args))
   (if (major-mode-p 'markdown-mode)
       (let ((uri (string-or (fourth args)
                             (fifth args))))
         (if (string-empty-p uri)
             (error "uri empty"))
         (funcall func uri))
     (error "not markdown mode"))
   (let ((url (cl-sn "xurls" :stdin (str args) :chomp t)))
     (if (string-empty-p url)
         (error "url empty"))
     (funcall func url))
   ;; (funcall func (fourth args))
   )
  ;; (condition-case nil
  ;;     (apply func args)
  ;;   (error (condition-case nil
  ;;              (funcall func args)
  ;;            (error (condition-case nil
  ;;                       (funcall func)
  ;;                     (error (funcall func (fourth args))))))))
  )

;; (cl-sn "xurls" :stdin (str '(905 957 "(almost)" "http://http-kit.github.io/migration.html" nil nil nil)) :chomp t)

;; (cl-sn "xurls" :stdin (str '(905 957 "(almost)" "" nil nil nil)) :chomp t)

(provide 'my-link-hint)