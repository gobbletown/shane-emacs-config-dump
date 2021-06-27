(require 'memoize)


;; (memoize 'myrc-test)
;; (memoize-restore 'myrc-test)

;; Why does the memoization not work?
;; It only memoizes when the result is truthy
;; So I can't memoize predicates



;; I need a toggle for updating memoized functions
;; Also, this method of memoizing, doesn't save to disk
;; (memoize 'cljr--get-artifacts-from-middleware)
;; (memoize-restore 'cljr--get-artifacts-from-middleware)

;; I think results are saved to a hash table
;; Is it possible to save and restore a hash table from disk?




(mu (defset my-ht-cache-dir "$NOTES/programs/my-ht-cache"))

(defun my-ht-cache-slug-fp (name)
  (concat my-ht-cache-dir "/" "persistent-hash-" (slugify name) ".elht"))

(defun my-ht-cache (name &optional ht)
  (let* ((n (my-ht-cache-slug-fp name))
         (nswap (concat n ".swap")))
    (if ht
        (progn (shut-up (write-to-file (prin1-to-string ht) nswap))
               (rename-file nswap n t))
      (if (f-exists-p n)
          (let ((r (find-file-noselect n)))
            (if r
                (let ((ret (read r)))
                  (kill-buffer r)
                  ret)))))))

;; (my-ht-cache "myht" (make-hash-table :test 'equal))
;; (my-ht-cache "myht")

(defun my-ht-cache-delete (name)
  (f-delete (my-ht-cache-slug-fp name) t))

;; (my-ht-cache-delete "myht")

;; (if (featurep 'hashtable-print-readable)
;;     (defmacro make-or-load-hash-table (name &rest body)
;;       `(progn
;;          (or (my-ht-cache ,name)
;;              (make-hash-table ,@body))))
;;   (defmacro make-or-load-hash-table (name &rest body)
;;     `(progn
;;        (make-hash-table ,@body))))

(defun make-or-load-hash-table (name args)
  (progn
    (or (my-ht-cache name)
        (apply 'make-hash-table args))))

;; ;; Make this work also for 'nil results
;; I have also made it more robust by letting it work outside of its lexical context (the memoize package)
(defun memoize--wrap (func timeout)
  "Return the memoized version of FUNC.
TIMEOUT specifies how long the values last from last access. A
nil timeout will cause the values to never expire, which will
cause a memory leak as memoize is use, so use the nil value with
care."
  (let* (;;This also works for lambdas
         (funcpps (pps func))
         (funcslugdata (if (< 150 (length funcpps))
                           (md5 funcpps)
                         funcpps))
         (funcslug (slugify (s-join "-" (str2list funcslugdata))))
         (tablename (concat "table-" funcslug))
         (timeoutsname (concat "timeouts-" funcslug))
         ;; (table (eval `(make-or-load-hash-table ,tablename :test 'equal)))
         ;; (timeouts (eval `(make-or-load-hash-table ,timeoutsname :test 'equal)))
         (table (make-or-load-hash-table tablename '(:test equal)))
         (timeouts (make-or-load-hash-table timeoutsname '(:test equal))))
    (eval
     `(lambda (&rest args)
        (let ((value (gethash args ,table)))
          (unwind-protect
              ;; (or value (puthash args (apply ,func args) ,table))
              (let ((ret (or (and
                              ;; (not (>= (prefix-numeric-value current-global-prefix-arg) 4))
                              value)
                             ;; Add to the hash table and save the hash table
                             (let ((newret (puthash args
                                                    (or (apply ,func args)
                                                        'MEMOIZE_NIL)
                                                    ,table)))
                               (if (featurep 'hashtable-print-readable)
                                   (my-ht-cache ,tablename ,table))
                               newret))))
                (if (equal ret 'MEMOIZE_NIL)
                    (setq ret nil))
                ret)
            (let ((existing-timer (gethash args ,timeouts))
                  (timeout-to-use (or
                                   ;; timeout comes from the calling 'memoize' function
                                   (and (variable-p 'timeout)
                                        timeout)
                                   memoize-default-timeout)))
              (when existing-timer
                (cancel-timer existing-timer))
              (when timeout-to-use
                (puthash args
                         (run-at-time timeout-to-use nil
                                      (lambda ()
                                        ;; It would probably be better to alert and ignore
                                        (try (remhash args ,table)
                                             (message ,(concat "timer for memoized " funcslug " failed"))))) ,timeouts)))))))))



(defun memoize--wrap-orig (func timeout)
  "Return the memoized version of FUNC.
TIMEOUT specifies how long the values last from last access. A
nil timeout will cause the values to never expire, which will
cause a memory leak as memoize is use, so use the nil value with
care."
  (let ((table (make-hash-table :test 'equal))
        (timeouts (make-hash-table :test 'equal)))
    (eval
     `(lambda (&rest args)
        (let ((value (gethash args ,table)))
          (unwind-protect
              (or value (puthash args (apply ,func args) ,table))
            (let ((existing-timer (gethash args ,timeouts))
                  (timeout-to-use (or ,timeout memoize-default-timeout)))
              (when existing-timer
                (cancel-timer existing-timer))
              (when timeout-to-use
                (puthash args
                         (run-at-time timeout-to-use nil
                                      (lambda ()
                                        (remhash args ,table))) ,timeouts)))))))))


(defun memoize-orig (func &optional timeout)
  "Memoize FUNC: a closure, lambda, or symbol.

If argument is a symbol then install the memoized function over
the original function. The TIMEOUT value, a timeout string as
used by `run-at-time' will determine when the value expires, and
will apply after the last access (unless another access
happens)."
  (cl-typecase func
    (symbol
     (when (get func :memoize-original-function)
       (user-error "%s is already memoized" func))
     (put func :memoize-original-documentation (documentation func))
     (put func 'function-documentation
          (concat (documentation func) " (memoized)"))
     (put func :memoize-original-function (symbol-function func))
     (fset func (memoize--wrap-orig (symbol-function func) timeout))
     func)
    (function (memoize--wrap-orig func timeout))))



;; Re-memoize these

(advice-add 'memoize-restore :around #'ignore-errors-around-advice)


(provide 'my-memoize)