(require 'json)

;; This try is a better solution
(defun json-encode (object)
  "Return a JSON representation of OBJECT as a string."
  (cond ((memq object (list t json-null json-false))
         (json-encode-keyword object))
        ((stringp object)      (json-encode-string object))
        ((keywordp object)     (json-encode-string
                                (substring (symbol-name object) 1)))
        ((symbolp object)      (json-encode-string
                                (symbol-name object)))
        ((numberp object)      (json-encode-number object))
        ((arrayp object)       (json-encode-array object))
        ((hash-table-p object) (json-encode-hash-table object))
        ((listp object)        (try (json-encode-list object)
                                    (json-encode-string (str object))))
        ;; ((listp object)        (if nostringiffail (json-encode-list object)
        ;;                          (try (json-encode-list object)
        ;;                               (json-encode-string (str object)))))
        ;; ((listp object)        (json-encode-list object))
        (t                     (signal 'json-error (list object)))
        ;; (t                     (json-encode-string (str object)))
        ))

;; I added a try in here to make it more reliable
(defun json-encode-alist (alist)
  "Return a JSON representation of ALIST."
  (when json-encoding-object-sort-predicate
    (setq alist
          (sort alist (lambda (a b)
                        (funcall json-encoding-object-sort-predicate
                                 (car a) (car b))))))
  (format "{%s%s}"
          (json-join
           (json--with-indentation
            (mapcar (lambda (cons)
                      (format (if json-encoding-pretty-print
                                  "%s%s: %s"
                                "%s%s:%s")
                              json--encoding-current-indentation
                              (json-encode-key (car cons))
                              ;; (if stringiffail
                              ;;     (try
                              ;;      (json-encode (cdr cons))
                              ;;      (json-encode (str (cdr cons))))
                              ;;   (json-encode (cdr cons)))
                              (json-encode (cdr cons))))
                    alist))
           json-encoding-separator)
          (if (or (not json-encoding-pretty-print)
                  json-encoding-lisp-style-closings)
              ""
            json--encoding-current-indentation)))


;; Just dont run the json lsp server
(define-derived-mode jsonl-mode json-mode "JSONl"
  "jsonl mode")


(provide 'my-json)