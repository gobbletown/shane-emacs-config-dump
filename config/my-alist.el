(defun aget (key alist)
  (cdr (assoc key alist)))

(defun alist-set (alist-symbol key value)
  "Set KEY to VALUE in alist ALIST-SYMBOL."
  (set alist-symbol
       (cons (list key value) 
             (assq-delete-all key (eval alist-symbol)))))

(defun alist-setcdr (alist-symbol key value)
  "Set KEY to VALUE in alist ALIST-SYMBOL."
  (set alist-symbol
       (cons (cons key value)
             (assq-delete-all key (eval alist-symbol))))

  ;; (setcdr (assoc 'file org-link-frame-setup) 'find-file)
  )

;; (let ((foo '((a 1) (b 2))))
;;   (alist-set 'foo 'a 3)
;;   foo)
                                        ; => ((a 3) (b 2))

(provide 'my-alist)